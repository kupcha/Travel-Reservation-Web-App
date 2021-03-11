<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.io.IOException"%>
<%@ page import= "java.sql.Connection"%>
<%@ page import= "java.sql.PreparedStatement"%>
<%@ page import= "java.sql.ResultSet"%>
<%@ page import= "java.sql.Statement"%>
<%@ page import= "java.text.DateFormat"%>
<%@ page import= "java.text.SimpleDateFormat"%>
<%@ page import= "java.util.Date"%>

<!DOCTYPE html>
<html>
<head>
	<%@ include file="../common/head.jsp" %>
</head>
<body>
	<% request.setAttribute("expectedType", "customer");%>
	<%@ include file="../common/mainheader.jsp" %>
	
	<%
	try{
		
		String alid = String.valueOf(request.getParameter("alid"));
		String fNumb = String.valueOf(request.getParameter("fNumb"));
		
		//System.out.println("submitWaitList "+alid+" "+fNumb);
		
		ApplicationDB ap = new ApplicationDB();
		Connection connection = ap.getConnection();
		Statement statement = connection.createStatement();
		
		String sql = "SELECT max(ticket_number)+1 nextTicket "+
				"FROM group13_db.ticket t";
		PreparedStatement st = connection.prepareStatement(sql);
		ResultSet resultSet = st.executeQuery();
		resultSet.next();
		
		sql = "INSERT INTO group13_db.waitList (flight_number, username, ALID) VALUES (?, ?, ?)";
		st = connection.prepareStatement(sql);
		st.setString(1,fNumb);
		st.setString(2,username);
		st.setString(3,alid);
		
		st.executeUpdate();

		
	}
	catch (Exception e) {
		e.printStackTrace();
	}	
		
	
		response.sendRedirect(request.getContextPath() + "/customer/customer.jsp");
	%>
	
</body>
</html>
