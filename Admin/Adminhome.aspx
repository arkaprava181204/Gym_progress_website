<%@ Page Title=""
Language="C#"
MasterPageFile="~/Admin/Adminmst.Master"
AutoEventWireup="true"
CodeBehind="Adminhome.aspx.cs"
Inherits="URprogress.Admin.Adminhome" %>

<asp:Content ID="Content1"
ContentPlaceHolderID="head"
runat="server">

<link href="../content/Styleactual.css?v=20"
rel="stylesheet" />

<script src="https://kit.fontawesome.com/b99e675b6e.js"></script>

<script src="../scripts/jquery-3.0.0.min.js"></script>

<script src="../scripts/popper.min.js"></script>

<script src="../scripts/bootstrap.min.js"></script>

</asp:Content>

<asp:Content ID="Content2"
ContentPlaceHolderID="ContentPlaceHolder1"
runat="server">

<script>

$(document).ready(function () {

    let exercises = [

        "Bench Press",
        "Incline Bench Press",
        "Squat",
        "Deadlift",
        "Shoulder Press",
        "Lateral Raise",
        "Lat Pulldown",
        "Pull Ups",
        "Push Ups",
        "Bicep Curl",
        "Hammer Curl",
        "Tricep Pushdown",
        "Leg Press",
        "Leg Extension",
        "Leg Curl"

    ];

    // SEARCH

    $("#exerciseSearch").keyup(function () {

        let value =
            $(this).val().toLowerCase();

        $("#suggestions").empty();

        if (value == "") {

            $("#suggestions").hide();
            return;
        }

        let matched =
            exercises.filter(exercise =>
                exercise.toLowerCase().includes(value));

        matched.forEach(function (exercise) {

            $("#suggestions").append(`

                <div class="suggestion-item">

                    ${exercise}

                </div>

            `);

        });

        $("#suggestions").show();

    });

    // SELECT EXERCISE

    $(document).on(
        "click",
        ".suggestion-item",
        function () {

            $("#exerciseSearch")
                .val($(this).text());

            $("#suggestions").hide();

        });

    // ADD EXERCISE

    $("#addExerciseBtn").click(function () {

        let exerciseName =
            $("#exerciseSearch").val();

        if (exerciseName == "") {

            alert("Enter Exercise");
            return;
        }

        $("#exerciseTable").append(`

            <tr>

                <td class="exname">

                    ${exerciseName}

                </td>

                <td>0</td>

                <td>

                    <input class="reps"
                    type="number"
                    value="0">

                </td>

                <td>

                    <input class="sets"
                    type="number"
                    value="0">

                </td>

            </tr>

        `);

        $.ajax({

            type: "POST",

            url:
                "Adminhome.aspx/SaveExercise",

            data: JSON.stringify({

                exname: exerciseName

            }),

            contentType:
                "application/json; charset=utf-8",

            dataType: "json"

        });

        $("#exerciseSearch").val("");

        $("#exerciseSearch").focus();

    });

    // CLEAR PANEL

    $("#clearExercisesBtn").click(function () {

        $("#exerciseTable").html(`

            <tr>

                <th>Exercise Name</th>
                <th>Prev</th>
                <th>Reps</th>
                <th>Sets</th>

            </tr>

        `);

    });

    // UPDATE REPS/SETS

    $(document).on(
        "keydown",
        ".reps, .sets",
        function (e) {

            if (e.key === "Enter") {

                e.preventDefault();

                let row =
                    $(this).closest("tr");

                let exname =
                    row.find(".exname").text().trim();

                let reps =
                    row.find(".reps").val();

                let sets =
                    row.find(".sets").val();

                $.ajax({

                    type: "POST",

                    url:
                        "Adminhome.aspx/UpdateExercise",

                    data: JSON.stringify({

                        exname: exname,
                        reps: reps,
                        sets: sets

                    }),

                    contentType:
                        "application/json; charset=utf-8",

                    dataType: "json"

                });

                return false;
            }

        });

    // CALCULATOR

    $("#weightInput, #heightInput")
        .keypress(function (e) {

            if (e.which == 13) {

                e.preventDefault();

                let weight =
                    parseFloat(
                        $("#weightInput").val());

                let height =
                    parseFloat(
                        $("#heightInput").val());

                if (!weight || !height) {

                    alert(
                        "Enter Weight and Height");

                    return;
                }

                let calories =
                    weight * 33;

                let protein =
                    weight * 2;

                let fats =
                    weight * 0.8;

                let carbs =

                    (calories -

                        ((protein * 4) +

                            (fats * 9))) / 4;

                $("#calorieResult")
                    .text(Math.round(calories));

                $("#proteinResult")
                    .text(Math.round(protein));

                $("#fatResult")
                    .text(Math.round(fats));

                $("#carbResult")
                    .text(Math.round(carbs));

            }

        });

    // SAVE WORKOUT

    $("#saveWorkoutBtn").click(function () {

        let workoutName =
            $("#workoutName").val();

        let workoutDay =
            $("#workoutDay").val();

        if (workoutName == "") {

            alert("Enter Workout Name");
            return;
        }

        $.ajax({

            type: "POST",

            url:
                "Adminhome.aspx/SaveWorkout",

            data: JSON.stringify({

                workoutName: workoutName,
                workoutDay: workoutDay

            }),

            contentType:
                "application/json; charset=utf-8",

            dataType: "json",

            success: function (response) {

                let workoutID =
                    response.d;

                $(".workout-list").append(`

                    <div class="workout-item"
                    data-id="${workoutID}">

                        <b>${workoutDay}</b>
                        -
                        ${workoutName}

                    </div>

                `);

                alert("Workout Saved");

            }

        });

    });

    // CLICK WORKOUT

    $(document).on(
        "click",
        ".workout-item",
        function () {

            let workoutID =
                $(this).data("id");

            $.ajax({

                type: "POST",

                url:
                    "Adminhome.aspx/GetExercises",

                data: JSON.stringify({

                    workoutID: workoutID

                }),

                contentType:
                    "application/json; charset=utf-8",

                dataType: "json",

                success: function (response) {

                    let exercises =
                        response.d;

                    $("#exerciseTable").html(`

                    <tr>

                        <th>Exercise Name</th>
                        <th>Prev</th>
                        <th>Reps</th>
                        <th>Sets</th>

                    </tr>

                `);

                    exercises.forEach(function (ex) {

                        $("#exerciseTable").append(`

                        <tr>

                            <td class="exname">

                                ${ex.ExerciseName}

                            </td>

                            <td>

                                ${ex.Lastreps}

                            </td>

                            <td>

                                <input class="reps"
                                type="number"
                                value="${ex.Reps}">

                            </td>

                            <td>

                                <input class="sets"
                                type="number"
                                value="${ex.SetsCounts}">

                            </td>

                        </tr>

                    `);

                    });

                }

            });

        });

});

</script>

<!-- MAIN -->

<div class="main">

    <!-- LEFT -->

    <div class="exercise-section">

        <div class="exercise-controls">

            <input type="text"
                   id="exerciseSearch"
                   placeholder="Search Exercise">

            <div id="suggestions"></div>

            <button type="button"
                    id="addExerciseBtn">

                +

            </button>

            <button type="button"
                    id="clearExercisesBtn">

                Clear

            </button>

        </div>

        <table class="exercise-table"
               id="exerciseTable">

            <tr>

                <th>Exercise Name</th>
                <th>Prev</th>
                <th>Reps</th>
                <th>Sets</th>

            </tr>

        </table>

    </div>

    <!-- RIGHT -->

    <div class="right">

        <!-- DIET -->

        <div class="diet">

            <div class="diet-top">

                <input type="number"
                       id="weightInput"
                       placeholder="Add Weight (kg)">

                <input type="number"
                       id="heightInput"
                       placeholder="Add Height (cm)">

            </div>

            <div class="diet-data">

                <h2>
                    Protein:
                    <span id="proteinResult">0</span> g
                </h2>

                <h2>
                    Calories:
                    <span id="calorieResult">0</span>
                </h2>

                <h2>
                    Carbs:
                    <span id="carbResult">0</span> g
                </h2>

                <h2>
                    Fats:
                    <span id="fatResult">0</span> g
                </h2>

            </div>

        </div>

        <!-- BOTTOM -->

        <div class="bottom">

            <!-- WORKOUT -->

            <div class="workout">

                <h2>Workout List</h2>

                <div class="workout-list">

                </div>

                <div class="save-workout-box">

                    <input type="text"
                           id="workoutName"
                           placeholder="Workout Name">

                    <select id="workoutDay">

                        <option>Mon</option>
                        <option>Tue</option>
                        <option>Wed</option>
                        <option>Thu</option>
                        <option>Fri</option>
                        <option>Sat</option>
                        <option>Sun</option>

                    </select>

                    <button type="button"
                            id="saveWorkoutBtn">

                        Save Workout

                    </button>

                </div>

            </div>

            <!-- NOTES -->

            <div class="notes">

                <h2>Notes</h2>

                <textarea id="notesBox"></textarea>

            </div>

        </div>

    </div>

</div>

</asp:Content>