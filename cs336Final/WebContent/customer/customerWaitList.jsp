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
	<%@ include file="../common/mainheader.jsp"%>
	
	
	<h2>The flight you requested is currently full. Do you wish to be placed in the wait list?</h2>

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
			String alid = String.valueOf(session.getAttribute("alid"));
			String flightNumb = String.valueOf(session.getAttribute("flightNumber"));
			
			//System.out.println("customerWaitList "+alid+" "+flightNumb);
			
			ApplicationDB ap = new ApplicationDB();
			connection = ap.getConnection();
			statement = connection.createStatement();
			String sql = "SELECT f.ALID, f.flight_number, f.departure_airport,"+
					"f.destination_airport,f.date,f.departure_time,f.arrival_time, "+
					"f.domestic, f.Base_price "+
					"FROM group13_db.flight f "+
					"WHERE f.alid = ? and f.flight_number = ?";
			PreparedStatement st = connection.prepareStatement(sql);
			st.setString(1, alid);
			st.setString(2, flightNumb);
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
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		%>
		</table>
	</div>
	<br>
	<form action="customer.jsp">
		<input type="submit" value="Cancel">
	</form>
	<br>
	<form method="POST" action="submitWaitList.jsp">
		<input type="submit" value="Confirm" >
		<input type="text" name="alid" id="alid" value=<%=String.valueOf(session.getAttribute("alid"))%> style='visibility:hidden'>
		<input type="text" name="fNumb" id="fNumb" value=<%=String.valueOf(session.getAttribute("flightNumber"))%> style='visibility:hidden'>
	</form>

</body>
</html>
