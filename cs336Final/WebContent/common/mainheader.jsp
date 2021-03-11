<%
	String username = (String)session.getAttribute("db_username");

	// If no username it means user did not login, send back to index
	if (username == null) {
		response.sendRedirect(request.getContextPath() + "/index.jsp");
	}

	// Get user type
	String type = (String)session.getAttribute("db_type");
	String expectedType = (String)request.getAttribute("expectedType");
	if (type != null && !type.equals(expectedType)) {
		response.sendRedirect(request.getContextPath() + "/403.jsp");
	}
%>

<div class="flex-container">
	<h1 class="">Hello, <%=username%>!</h1>
	<h3 class="">Type: <%=type%></h3>
	<form class="" method="POST" action=<%=request.getContextPath() + "/logout"%>>
		<input class="btn-large" type="submit" value="Logout"/>
	</form>
</div>
