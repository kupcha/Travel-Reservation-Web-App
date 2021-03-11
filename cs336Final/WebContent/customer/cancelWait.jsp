<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>

<!DOCTYPE html>
<html>
<head>
	<%@ include file="../common/head.jsp" %>
	
</head>
<body>

	<% request.setAttribute("expectedType", "customer");%>
	<%@ include file="../common/mainheader.jsp"%>
	
	<div id="divWaitList">
		<h2><br>My Wait List</h2>
		<table id= "waitListTable" style="width:20%" border="1em" cellpadding="5px 0px 5px 0px">
			<tr>
				<td><b>Select</b></td>
				<td><b>Airline</b></td>
				<td><b>Flight Number</b></td>
			</tr>
		<%
		try{ 
			String tempType;
			Connection connection = null;
			Statement statement = null;
			ResultSet resultSet = null;
			
			ApplicationDB ap = new ApplicationDB();
			connection = ap.getConnection();
			statement = connection.createStatement();
			String sql = "SELECT ALID, flight_number "+
						"FROM waitList "+
						"WHERE username = ?";
			PreparedStatement st = connection.prepareStatement(sql);
			st.setString(1, username);
			resultSet = st.executeQuery();
			//resultSet = statement.executeQuery(sql);
			while(resultSet.next()){
		%>
		<tr>
		<td><input type="radio" name="cancelSelection"></td>
		<td><%=resultSet.getString("ALID") %></td>
		<td><%=resultSet.getString("flight_number") %></td>
		
		</tr>
		
		<% 
		}
		
		} catch (Exception e) {
			e.printStackTrace();
		}
		%>
		</table>

	</div>
	<script>
		var alid = "none",flightNum = "none";
		var table = document.getElementById("waitListTable"),rIndex;
		for(var i = 0; i<table.rows.length;i++){
			table.rows[i].onclick=function(){
				rIndex = this.rowIndex;
				document.getElementById("alid").value = this.cells[1].innerHTML;
				document.getElementById("flightNumb").value = this.cells[2].innerHTML;

			}
		}
	</script>
	<form method="POST" action="submitWaitCancelation.jsp" onsubmit="return validateLogin()">
			<br><input type="submit" value="Cancel Selected Ticket">
			
			<input type="text" name = "alid" id="alid" style='visibility:hidden'>
			<input type="text" name = "flightNumb" id="flightNumb" style='visibility:hidden'>
	</form>
</body>
</html>
