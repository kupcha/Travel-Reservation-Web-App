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
<%@ page import= "java.util.concurrent.TimeUnit"%>

<!DOCTYPE html>
<html>
<head>
	<%@ include file="../common/head.jsp" %>
</head>
<body>
	<% request.setAttribute("expectedType", "customer");%>
	<%@ include file="../common/mainheader.jsp" %>
	
	<%
		
		
		String alid = request.getParameter("alid");
		String fNumb = request.getParameter("flightNumb");
		try{
			System.out.println(alid+" | "+fNumb);
				
			ApplicationDB ap = new ApplicationDB();
			Connection connection = ap.getConnection();
			Statement statement = connection.createStatement();
			String sql = "DELETE FROM group13_db.waitList "+
			"WHERE username = ? and ALID = ? and flight_number = ?";
			PreparedStatement st = connection.prepareStatement(sql);
				
				
			st.setString(1,username);
			st.setString(2,alid);
			st.setString(3,fNumb);
				
			st.executeUpdate();
				
				
		}catch (Exception e) {
			e.printStackTrace();
		}
		response.sendRedirect(request.getContextPath() + "/customer/customer.jsp");
			
	%>
	
</body>
</html>
