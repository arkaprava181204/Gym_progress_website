<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Adminmst.Master" AutoEventWireup="true" CodeBehind="loginmodal.aspx.cs" Inherits="URprogress.Content.loginmodal" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server
    <link href="..\content\Stylelogin.css" rel="stylesheet" />
     <!-- LOGIN MODAL -->

    <div class="modal">

        <div class="modal-box">

            <span class="close">&times;</span>

            <h2>Sign In / Sign Up</h2>

            <input type="email" placeholder="Enter Email">
            <input type="password" placeholder="Enter Password">

            <button id="loginBtn">Continue</button>

        </div>

    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
</asp:Content>
