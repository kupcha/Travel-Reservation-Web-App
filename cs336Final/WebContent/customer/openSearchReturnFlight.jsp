<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../common/head.jsp" %>
</head>
<body>
	<% request.setAttribute("expectedType", "customer");%>
	<%@ include file="../common/mainheader.jsp" %>
	
	<div id="resultTable">
		<h2>Search Results</h2>
		<table id= "tableTrip" style="width:75%" border="1em" cellpadding="5px 0px 5px 0px">
			<tr>
				<td><b>Select</b></td>
				<td><b>Airline</b></td>
				<td><b>Flight Number</b></td>
				<td><b>Departure Airport</b></td>
				<td><b>Destination Airport</b></td>
				<td><b>Departure Date</b></td>
				<td><b>Departure Time</b></td>
				<td><b>Arrival Time</b></td>
				<td><b>Starting At</b></td>
			</tr>
		<%

			ApplicationDB ap = new ApplicationDB();
			Connection connection = ap.getConnection();
			Statement statement = connection.createStatement();
			
			String returnDate = String.valueOf(request.getAttribute("returnDate"));
			String alid = String.valueOf(request.getAttribute("alid"));
			String fNumb = String.valueOf(request.getAttribute("fNumb"));
			if(returnDate.equals("null")) returnDate = request.getParameter("rDate");
			if(alid.equals("null")) alid = request.getParameter("newalid");
			if(fNumb.equals("null")) fNumb = request.getParameter("fNumber");
			System.out.println(alid+" "+fNumb+" "+returnDate);
			
			String sql = "SELECT f.departure_airport, f.destination_airport "+
						"FROM group13_db.flight f "+
						"WHERE f.alid = ? and f.flight_number = ? and f.date = ?";
		
			
			
			PreparedStatement st = connection.prepareStatement(sql);
			st.setString(1,alid);
			st.setString(2,fNumb);
			st.setString(3,returnDate);

			ResultSet resultSet = st.executeQuery();
			
			resultSet.next();
			
			String departLoc = resultSet.getString("destination_airport");
			String destination = resultSet.getString("departure_airport");
			
			System.out.println(returnDate+" "+departLoc+" "+destination);
			
			
			String tempType;
			sql = "SELECT f.ALID, f.flight_number, f.departure_airport,"+
					"f.destination_airport,f.date,f.departure_time,f.arrival_time, "+
					"f.domestic, f.Base_price "+
					"FROM group13_db.flight f "+
					"WHERE f.date = ? and f.departure_airport = ? and f.destination_airport = ?";

			st = connection.prepareStatement(sql);
			st.setString(1,returnDate);
			st.setString(2,destination);
			st.setString(3,departLoc);
			resultSet = st.executeQuery();
			while(resultSet.next()){
		%>
		<tr>
		<td><input type="radio" name="flightSelection"></td>
		<td><%=resultSet.getString("ALID") %></td>
		<td><%=resultSet.getString("flight_number") %></td>
		<td><%=resultSet.getString("destination_airport") %></td>
		<td><%=resultSet.getString("departure_airport") %></td>
		<td><%=resultSet.getString("date") %></td>
		<td><%=resultSet.getString("departure_time") %></td>
		<td><%=resultSet.getString("arrival_time") %></td>
		<td><%="$"+resultSet.getString("Base_price") %></td>
		
		
		</tr>
		<%
			}
		%>
		</table>
	
	<script>
		var alid = "none",flightNum = "none";
		var table = document.getElementById("tableTrip"),rIndex;
		for(var i = 0; i<table.rows.length;i++){
			table.rows[i].onclick=function(){
				rIndex = this.rowIndex;
				document.getElementById("alid").value = this.cells[1].innerHTML;
				document.getElementById("flightNumb").value = this.cells[2].innerHTML;
				document.getElementById("date").value = this.cells[5].innerHTML;
				document.getElementById("depart").value = this.cells[6].innerHTML;
				document.getElementById("price").value = this.cells[8].innerHTML;
				
				alid = this.cells[1].innerHTML;
				flightNumb = this.cells[2].innerHTML;
			}
		}
	</script>
	<form method="GET" action="confirmPurchase.jsp" onsubmit="return validateLogin()">
			<br><input type="submit" value="Make Purchase">
			
			<input type="text" name = "alid" id="alid" style='visibility:hidden'>
			<input type="text" name = "flightNumb" id="flightNumb" style='visibility:hidden'>
			<input type="text" name = "date" id="date" style='visibility:hidden'>
			<input type="text" name = "depart" id="depart" style='visibility:hidden'>
			<input type="text" name = "price" id="price" style='visibility:hidden'>
			<input type="text" name = "tripT" id="tripT" value=<%=request.getParameter("tripType")%> style='visibility:hidden'><br/>
	</form>
	
	</div>
</body>
</html>
