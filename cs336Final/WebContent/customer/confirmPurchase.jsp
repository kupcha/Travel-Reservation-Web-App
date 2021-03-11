<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../common/head.jsp" %>
	<style type="text/css">
		.box {
		  float: left;
		  width: 200px;
		  height: 100px;
		  margin: 1em;
		}
		.after-box {
		  clear: left;
		}
		.main_container aside{
		    width: 300px;
		    position: absolute;
		    border: 1px solid blue;
		    height: 400px;
		    visibility: hidden;
		}
		.main_container div{
		    margin-left: 300px;
		    border: 1px solid green;
		    height: 400px;
		    visibility: hidden;
		}
	
	</style>
</head>
<body>

	<% request.setAttribute("expectedType", "customer");%>
	<%@ include file="../common/mainheader.jsp" %>
	
	<%@page import="java.sql.DriverManager"%>
	<%@page import="java.sql.ResultSet"%>
	<%@page import="java.sql.Statement"%>
	<%@page import="java.sql.Connection"%>

	
	<div id="divTableTrip">
		<h4>Confirm Details</h4>
		<table id= "tableTrip" style="width:75%" border="1em" cellpadding="5px 0px 5px 0px">

			<tr>
				<td><b>Airline</b></td>
				<td><b>Flight Number</b></td>
				<td><b>Departure Airport</b></td>
				<td><b>Destination Airport</b></td>
				<td><b>Departure Date</b></td>
				<td><b>Departure Time</b></td>
				<td><b>Arrival Time</b></td>
				<td><b>Starting At</b></td>
				<td><b>Trip type</b></td>
			</tr>
		<%
		
		String tempType;
		
		Connection connection = null;
		Statement statement = null;
		ResultSet resultSet = null;
		Driver dr = null;
		try{ 
			String alid = request.getParameter("alid");
			String flightNumb = request.getParameter("flightNumb");
			String date = request.getParameter("date");
			String depart = request.getParameter("depart");
			String returnDate = request.getParameter("returnDate");
			System.out.println(alid+" "+flightNumb+" "+date+" "+depart+" | "+returnDate);
			
			ApplicationDB ap = new ApplicationDB();
			connection = ap.getConnection();
			statement = connection.createStatement();
			String sql = "SELECT f.ALID, f.flight_number, f.departure_airport,"+
					"f.destination_airport,f.date,f.departure_time,f.arrival_time, "+
					"f.domestic, f.Base_price "+
					"FROM group13_db.flight f "+
					"WHERE f.alid = ? and f.flight_number = ? and f.date = ? and f.departure_time = ?";
			PreparedStatement st = connection.prepareStatement(sql);
			st.setString(1, alid);
			st.setString(2, flightNumb);
			st.setString(3, date);
			st.setString(4, depart);
			resultSet = st.executeQuery();
			String temp;
			while(resultSet.next()){
		%>
		<tr>
		<% 
			if(resultSet.getString("domestic").equals("1")){
				tempType = "Domestic";
			}
			else{
				tempType = "International";
			}
		%>
		<td><%=resultSet.getString("ALID") %></td>
		<td><%=resultSet.getString("flight_number") %></td>
		<td><%=resultSet.getString("departure_airport") %></td>
		<td><%=resultSet.getString("destination_airport") %></td>
		<td><%=resultSet.getString("date") %></td>
		<td><%=resultSet.getString("departure_time") %></td>
		<td><%=resultSet.getString("arrival_time") %></td>
		<td><%="$"+resultSet.getString("Base_price") %></td>
		<td><%=request.getParameter("tripT")%></td>
		
		</tr>
		
		<% 
			temp = resultSet.getString("Base_price");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		%>
		</table>

	</div>
	<div id="meal">
		<h4>Choose Meal Plan</h4>
		<table id= "tableMeal" style="width:50%" border="1em" cellpadding="5px 0px 5px 0px">
			
			<tr>
				<td><b>Choice</b></td>
				<td><b>Meal Plans</b></td>
				<td><b>Price (UsD)</b></td>
			</tr>
			<tr>
				<td><input type="radio" name="radioMeal"></td>
				<td>No Meal Plan</td>
				<td>0.0</td>
			</tr>
			<tr>
				<td><input type="radio" name="radioMeal"></td>
				<td>Plan 1</td>
				<td>19.99</td>
			</tr>
			<tr>
				<td><input type="radio" name="radioMeal"></td>
				<td>Plan 2</td>
				<td>49.99</td>
			</tr>
			<tr>
				<td><input type="radio" name="radioMeal"></td>
				<td>Plan 3</td>
				<td>99.99</td>
			</tr>
	
		</table>
	</div>
	<div id="ticketClass">
		<h4>Choose Class</h4>
		<table id= "tableClass" style="width:30%" border="1em" cellpadding="5px 0px 5px 0px">
			
			<tr>
				<td><b>Choice</b></td>
				<td><b>Class</b></td>
				<td><b>Extra</b></td>
			</tr>
			<tr>
				<td><input type="radio" name="classType"></td>
				<td>Economy</td>
				<td>0.00</td>
			</tr>
			<tr>
				<td><input type="radio" name="classType"></td>
				<td>Bus/1st</td>
				<td>10000.00</td>
			</tr>
			
	
		</table>
	</div>
	<form method="POST" action="submitPurchase.jsp" onsubmit = "return validateLogin()">
		<input type="submit" value="Submit" >	
		<input type="text" name="mealVal" id="mealVal" style='visibility:hidden'>
		<input type="text" name="classVal" id="classVal" style='visibility:hidden'>
		<input type="text" name="classType" id="classType" style='visibility:hidden'>
		<input type="text" name="newalid" id="newalid" value=<%=request.getParameter("alid")%> style='visibility:hidden'>
		<input type="text" name="newflightNumb" id="newflightNumb" value=<%=request.getParameter("flightNumb")%> style='visibility:hidden'>
		<input type="text" name="newdate" id="newdate" value=<%=request.getParameter("date")%> style='visibility:hidden'>
		<input type="text" name="newprice" id="newprice" value=<%=request.getParameter("price")%> style='visibility:hidden'>
		<input type="text" name="newtrip" id="newtrip" value=<%=request.getParameter("tripT")%> style='visibility:hidden'>
			<input type="text" name = "flex" id="flex" value=<%=request.getParameter("flex")%> style='visibility:hidden'>
		<input type="text" name="newreturnDate" id="newreturnDate" value=<%=request.getParameter("returnDate")%> style='visibility:hidden'>
			
	</form>
	
	<script> 
	
		
		var meal = "none", class_type = "none",class_price = "none";
		var table = document.getElementById("tableMeal"),rIndex;
		for(var i = 0; i<table.rows.length;i++){
			table.rows[i].onclick=function(){
				rIndex = this.rowIndex;
				document.getElementById("mealVal").value = this.cells[2].innerHTML;
				meal = this.cells[2].innerHTML;
			}
		}
		
		var table2 = document.getElementById("tableClass"),rIndex2;
		for(var i = 0; i<table2.rows.length;i++){
			table2.rows[i].onclick=function(){
				rIndex2 = this.rowIndex;
				document.getElementById("classType").value = this.cells[1].innerHTML;
				document.getElementById("classVal").value = this.cells[2].innerHTML;
				class_type = this.cells[1].innerHTML;
				class_price = this.cells[2].innerHTML;
			}
		}
		
		
	</script>
	<script>
		function checkAvailability(){
			
		}
	
	</script>
</body>
</html>
