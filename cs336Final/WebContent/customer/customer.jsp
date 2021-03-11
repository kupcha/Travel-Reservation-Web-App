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
	
	
	<div>
		<button onClick="tripFunct()" style = margin-right:16px><h4>Open Search</h4></button>
		<button onClick="searchAndFilter()" style = margin-right:16px><h4>Open Ticket History</h4></button>
		<button onClick="waitList()" style = margin-right:16px><h4>Open Wait List</h4></button>
	</div>
	
	<div id="tripInfo" class="box" style="visibility:hidden">
	    <form method="GET" action="openSearch.jsp" onsubmit="return validateLogin()">
			<h2>Trip Planner</h2>
				<div class="margin-bottom">
					<label>Departure Date:</label>
					<input id="depart-date" type="date" name="departDate"/>
				</div>
				<div class="margin-bottom">
					<label><br>Return Date (if applicable):</label>
					<input id="return-date" type="date" name="returnDate"/>
				</div>
				<div class="margin-bottom">
					<label><br>From:</label>
					<input id="depart-location" type="text" name="from"/>
				</div>
				<div class="margin-bottom">
					<label><br>To:</label>
					<input id="destination" type="text" name="destination"/>
				</div>
		  
				<p>Please select:</p>
				<input type="radio" checked = "checked" name="tripType" value="One-way"> One-way<br>
				<input type="radio" name="tripType" value="Round-trip"> Round-trip<br> 
				<input type="checkbox" name="flex" value="flexDates"> Flexible dates<br>
		
		 		<br><input type="submit" value="Search"/><br/>
		 		
			</form>
	</div>
	<div id="divTableSearch" class="box" style='visibility:hidden'>
		<h2>Sort Flight History</h2>
		<table id="sortTable" style="width:15%" border="1em" cellpadding="5px 0px 5px 0px">
			<tr>
				<td>Select</td>
				<td>Category</td>
			</tr>
			<tr>
				<td align="center"><input type="radio" name="sortSelection"></td>
				<td>Airline</td>
			</tr>
			<tr>
				<td align="center"><input type="radio" name="sortSelection"></td>
				<td>Date</td>
			</tr>
			<tr>
				<td align="center"><input type="radio" name="sortSelection"></td>
				<td>Departure Time</td>
			</tr>
			<tr>
				<td align="center"><input type="radio" name="sortSelection"></td>
				<td>Arrival Time</td>
			</tr>
			<tr>
				<td align="center"><input type="radio" name="sortSelection"></td>
				<td>Price</td>
			</tr>
		</table>
		<form method="POST" action="customerSortedHistory.jsp" onsubmit="return validateLogin()">
			<br><input type="submit" value="Sort Results">
			<input type="text" name = "sortOption" id="sortOption" value=" " style='visibility:hidden'>
		</form>
	</div>
	<br><br><br><div class="after-box"></div>
	
	<br><br><br><br><br><br><br><br><br><br><br><br><br>
	<div id="divTableTrip" class="after-box" style='visibility:hidden'>
		<h2><br>Flight History</h2>
		<table id= "tableTrip" style="width:90%" border="1em" cellpadding="5px 0px 5px 0px">
			<tr>
				<td><b>Airline</b></td>
				<td><b>Flight Number</b></td>
				<td><b>Ticket Number</b></td>
				<td><b>Seat Number</b></td>
				<td><b>Class</b></td>
				<td><b>Departure Airport</b></td>
				<td><b>Destination Airport</b></td>
				<td><b>Departure Date</b></td>
				<td><b>Departure Time</b></td>
				<td><b>Arrival Time</b></td>
				<td><b>Flight Type</b></td>
				<td><b>Class</b></td>
				<td><b>Price Paid</b></td>
			</tr>
		<%
		try{ 
			String tempType;
			Connection connection = null;
			Statement statement = null;
			ResultSet resultSet = null;
			Driver dr = null;
			ApplicationDB ap = new ApplicationDB();
			connection = ap.getConnection();
			statement = connection.createStatement();
			String sql = "SELECT f.ALID, f.flight_number,tk.class, tk.ticket_number, tk.seat_number, f.departure_airport,"+
						"f.destination_airport,f.date,f.departure_time,f.arrival_time, "+
						"f.domestic, tk.class, cb.booking_fee "+
						"FROM group13_db.flight f, group13_db.flightTicket t, group13_db.ticket tk, group13_db.customerBuys cb "+
						"WHERE tk.username = ? and f.flight_number = t.flight_number"+
						" and tk.ticket_number = t.ticket_number and cb.ticket_number = tk.ticket_number and tk.username = cb.username";
			PreparedStatement st = connection.prepareStatement(sql);
			st.setString(1, username);
			resultSet = st.executeQuery();
			//resultSet = statement.executeQuery(sql);
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
			<td><%=resultSet.getString("ticket_number") %></td>
			<td><%=resultSet.getString("seat_number") %></td>
			<td><%=resultSet.getString("class") %></td>
			<td><%=resultSet.getString("departure_airport") %></td>
			<td><%=resultSet.getString("destination_airport") %></td>
			<td><%=resultSet.getString("date") %></td>
			<td><%=resultSet.getString("departure_time") %></td>
			<td><%=resultSet.getString("arrival_time") %></td>
			<td><%=tempType%></td>
			<td><%=resultSet.getString("class") %></td>
			<td><%="$"+resultSet.getString("booking_fee") %></td>
			
		</tr>
		
		<% 
		}
		
		} catch (Exception e) {
			e.printStackTrace();
		}
		%>
		</table>
		<form action="cancelTicket.jsp" class="btn-group" onsubmit="return validateLogin()">
			<br><input type="submit" value="Cancel Ticket" style = margin-right:16px>
		</form><br>
	</div>
	<div id="divWaitList" style='visibility:hidden'>
		<h2><br>My Wait List</h2>
		<table id= "waitListTable" style="width:20%" border="1em" cellpadding="5px 0px 5px 0px">
			<tr>
				<td><b>Airline</b></td>
				<td><b>Flight Number</b></td>
			</tr>
		<%
		try{ 
			String tempType;
			Connection connection = null;
			Statement statement = null;
			ResultSet resultSet = null;
			Driver dr = null;
			ApplicationDB ap = new ApplicationDB();
			connection = ap.getConnection();
			statement = connection.createStatement();
			String sql = "SELECT ALID, flight_number FROM group13_db.waitList WHERE username = ?";
			PreparedStatement st = connection.prepareStatement(sql);
			st.setString(1, username);
			resultSet = st.executeQuery();
			//resultSet = statement.executeQuery(sql);
			while(resultSet.next()){
		%>
		<tr>
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
		<form action="cancelWait.jsp" class="btn-group" onsubmit="return validateLogin()">
			<br><input type="submit" value="Cancel Wait List" style = margin-right:16px>
		</form><br>
	</div>
	<script>
		
		function tripFunct(){
			var button = document.getElementById("trip");
			var myDiv = document.getElementById("tripInfo");
		
			function toggle() {
			    myDiv.style.visibility = myDiv.style.visibility === "hidden" ? "visible" :  "hidden";
			}
		
			toggle();
		
			//button.addEventListener("click", toggle, false);
		}
		function searchAndFilter(){
			tableFunct();
			searchFunct();
		}
		function tableFunct(){
			//var button = document.getElementById("pastFlight");
			var myDiv = document.getElementById("divTableTrip");
		
			function toggle() {
			    myDiv.style.visibility = myDiv.style.visibility === "hidden" ? "visible" :  "hidden";
			}
		
			toggle();
		
			
		}
		function searchFunct(){
			//var button = document.getElementById("pastFlight");
			var myDiv2 = document.getElementById("divTableSearch");
		
			function toggle() {
			    myDiv2.style.visibility = myDiv2.style.visibility === "hidden" ? "visible" :  "hidden";
			}
		
			toggle();

			//button.addEventListener("click", toggle, false);
		}
		function waitList(){
			//var button = document.getElementById("pastFlight");
			var myDiv3 = document.getElementById("divWaitList");
		
			function toggle() {
			    myDiv3.style.visibility = myDiv3.style.visibility === "hidden" ? "visible" :  "hidden";
			}
		
			toggle();

			//button.addEventListener("click", toggle, false);
		}
		var table2 = document.getElementById("sortTable"),rIndex2;
		for(var i = 0; i<table2.rows.length;i++){
			table2.rows[i].onclick=function(){
				rIndex2 = this.rowIndex;
				document.getElementById("sortOption").value = this.cells[1].innerHTML;
			}
		}
	</script>

	
</body>
</html>
