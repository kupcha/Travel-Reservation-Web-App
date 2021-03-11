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
		String ticket = request.getParameter("ticket");
		String fNumb = request.getParameter("flightNumb");
		String fClass = request.getParameter("class");
		try{
			if(!fClass.equalsIgnoreCase("economy")){
				System.out.println(alid+" | "+fNumb+" | "+ticket+" | "+fClass);
				
				ApplicationDB ap = new ApplicationDB();
				Connection connection = ap.getConnection();
				Statement statement = connection.createStatement();
				String sql = "DELETE FROM group13_db.flightTicket "+
				"WHERE ticket_number = ?";
				PreparedStatement st = connection.prepareStatement(sql);
				
				
				st.setString(1,ticket);
				
				st.executeUpdate();
				
				sql = "DELETE FROM group13_db.ticket "+
				"WHERE ticket_number = ?";
				st = connection.prepareStatement(sql);
						
				st.setString(1,ticket);
				
				st.executeUpdate();
				
				sql = "DELETE FROM group13_db.customerBuys "+
				"WHERE ticket_number = ?";
				
				st = connection.prepareStatement(sql);
								
				st.setString(1,ticket);
						
				st.executeUpdate();
				

			}	
			else{
				//System.out.println("no removal");
				out.print("<p class=\"margin-bottom red-font\">Cannot cancel an economy ticket.</p>");
				out.print("<p class=\"margin-bottom red-font\">You are being redirected. Please wait.</p>");
				
				
				//TimeUnit.SECONDS.sleep(3);
				
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		response.sendRedirect(request.getContextPath() + "/customer/customer.jsp");
			
	%>
	
</body>
</html>
