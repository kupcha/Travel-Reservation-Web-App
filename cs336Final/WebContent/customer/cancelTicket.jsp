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
	
	<div id="divTableTrip" class="after-box">
			
			<table id= "tableTrip" style="width:85%" border="1em" cellpadding="5px 0px 5px 0px">

			<tr>
			<td><b>Select</b></td>
			<td><b>Airline</b></td>
			<td><b>Flight Number</b></td>
			<td><b>Ticket Number</b></td>
			<td><b>Class</b></td>
			<td><b>Seat Number</b></td>
			<td><b>Departure Airport</b></td>
			<td><b>Destination Airport</b></td>
			<td><b>Departure Date</b></td>
			<td><b>Departure Time</b></td>
			<td><b>Arrival Time</b></td>
			<td><b>Flight Type</b></td>
			<td><b>Cancellation Fee</b></td>
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
			String sql = "SELECT f.ALID, f.flight_number,tk.class, tk.ticket_number, tk.seat_number, f.departure_airport,"+
						"f.destination_airport,f.date,f.departure_time,f.arrival_time, "+
						"f.domestic, tk.class, cb.change_fee "+
						"FROM group13_db.flight f, group13_db.flightTicket t, group13_db.ticket tk, group13_db.customerBuys cb "+
						"WHERE tk.username = ? and f.flight_number = t.flight_number"+
						" and tk.ticket_number = t.ticket_number and cb.username = tk.username and cb.ticket_number = tk.ticket_number";
			PreparedStatement st = connection.prepareStatement(sql);
			st.setString(1, username);
			resultSet = st.executeQuery();
			//resultSet = statement.executeQuery(sql);
			while(resultSet.next()){
		%>
		<tr>
		<% 
		String cancelFee = resultSet.getString("change_fee");
			if(cancelFee.equals("0")){
				cancelFee = "N/A";
			}
			if(resultSet.getString("domestic").equals("1")){
				tempType = "Domestic";
			}
			else{
				tempType = "International";
			}
			%>
		<td><input type="radio" name="cancelSelection"></td>
		<td><%=resultSet.getString("ALID") %></td>
		<td><%=resultSet.getString("flight_number") %></td>
		<td><%=resultSet.getString("ticket_number") %></td>
		<td><%=resultSet.getString("class") %></td>
		<td><%=resultSet.getString("seat_number") %></td>
		<td><%=resultSet.getString("departure_airport") %></td>
		<td><%=resultSet.getString("destination_airport") %></td>
		<td><%=resultSet.getString("date") %></td>
		<td><%=resultSet.getString("departure_time") %></td>
		<td><%=resultSet.getString("arrival_time") %></td>
		<td><%=tempType%></td>
		<td><%=cancelFee%></td>
		
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
		var table = document.getElementById("tableTrip"),rIndex;
		for(var i = 0; i<table.rows.length;i++){
			table.rows[i].onclick=function(){
				rIndex = this.rowIndex;
				document.getElementById("alid").value = this.cells[1].innerHTML;
				document.getElementById("flightNumb").value = this.cells[2].innerHTML;
				document.getElementById("ticket").value = this.cells[3].innerHTML;
				document.getElementById("class").value = this.cells[4].innerHTML;

			}
		}
	</script>
	<form method="GET" action="submitCancelation.jsp" onsubmit="return validateLogin()">
			<br><input type="submit" value="Cancel Selected Ticket">
			
			<input type="text" name = "alid" id="alid" style='visibility:hidden'>
			<input type="text" name = "flightNumb" id="flightNumb" style='visibility:hidden'>
			<input type="text" name = "ticket" id="ticket" style='visibility:hidden'>
			<input type="text" name = "depart" id="depart" style='visibility:hidden'>
			<input type="text" name = "class" id="class" style='visibility:hidden'>
			<input type="text" name = "flightType" id="flightType" style='visibility:hidden'>
	</form>
	<form method="GET" action="customer.jsp" onsubmit="return validateLogin()">
		<br><input type="submit" value="Cancel">	
	</form>
</body>
</html>
