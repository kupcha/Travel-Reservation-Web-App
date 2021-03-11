<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>G13 Travel Agency</title>
	<style>
		.margin-bottom {
			margin-bottom: 10px;
		}
		.red-font {
			color: red;
		}
		.green-font {
			color: green;
		}
	</style>
</head>
<body>
	<h1>Welcome to G13 Travel Agency</h1>
	<br/><br/><br/>
	<%
		String created = (String)session.getAttribute("account-created");
		if (created != null) {
			out.print("<p class=\"margin-bottom green-font\">Account created successfully!</p>");
			session.removeAttribute("account-created");
		}
	%>
	<h3>Login to continue:</h3>
	<% 
		String username = (String)session.getAttribute("db_username");
		String type = (String)session.getAttribute("db_type");
		if (username != null) {
			if (type.equals("customer")) {
				response.sendRedirect(request.getContextPath() + "/customer/customer.jsp");
			}
			else if (type.equals("admin")) {
				response.sendRedirect(request.getContextPath() + "/admin/admin.jsp");
			}
			else if (type.equals("representative")) {
				response.sendRedirect(request.getContextPath() + "/representative/representative.jsp");
			}
		}

		Boolean b = (Boolean)session.getAttribute("loginError");
		if (b != null) {
			if (b.booleanValue()) {
				out.print("<p class=\"margin-bottom red-font\">Error: wrong username or password</p>");
				session.removeAttribute("loginError");
			}
		}
	%>
	<form method="POST" action="login" onsubmit="return validateLogin()">
		<div class="margin-bottom">
			<label>Username:</label>
			<input id="login-username" type="text" name="username"/>
		</div>
		<div class="margin-bottom">
			<label>Password:</label>
			<input id="login-password" type="password" name="password"/>
		</div>
		<input type="submit" value="Login"/>
	</form>
	<br/><br/>

	<h3>Do not have an account? Create one!</h3>
	<form method="POST" action="create-account" onsubmit="return validateCreateAccount()">
		<div class="margin-bottom">
			<label>Username:</label>
			<input id="username-input" type="text" name="username"/>
		</div>
		<div class="margin-bottom">
			<label>Password:</label>
			<input id="password-input" type="password" name="password"/>
		</div>
		<div class="margin-bottom">
			<label>Confirm Password:</label>
			<input id="password-confirm-input" type="password" name="password-confirm"/>
		</div>
		<input type="submit" value="Create Account"/>
	</form>
	
	<!-- -----------------------------------  -->
	<!-- ----------  JavaScript ------------- -->
	<!-- -----------------------------------  -->
	<script>
		function validateLogin() {
			var username = document.getElementById('login-username').value.trim();
			var password = document.getElementById('login-password').value.trim();

			// Check if some field is empty
			if (!username || !password) {
				alert('Username and password are required!');
				return false;
			}
			return true;
		}

		function validateCreateAccount() {
			var username = document.getElementById('username-input').value.trim();
			var password = document.getElementById('password-input').value.trim();
			var passwordConfirm = document.getElementById('password-confirm-input').value.trim();
			
			// Check if some field is empty
			if (!username || !password || !passwordConfirm) {
				alert('All fields are required!');
				return false;
			}
			
			// Check if length is at least 4
			if (
				username.length < 4 || username.length > 8 || 
				password.length < 4 || password.length > 8 || 
				passwordConfirm.length < 4 || passwordConfirm.length > 8
			) {
				alert('All fields must be between 4 and 8 characters!');
				return false;
			}
			
			// Check if passwords match
			if (password !== passwordConfirm) {
				alert('Passwords do not match!')
				return false;
			}
			
			return true;
		}
	</script>
</body>
</html>
