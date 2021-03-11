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
		  width: 100px;
		  height: 25px;
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
	<h2>Sort Results</h2>
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
	<form method="POST" action="sortedOpenSearch.jsp" onsubmit="return validateLogin()">
		<br><input type="submit" value="Sort Results">
		<input type="text" name = "sortOption" id="sortOption" value=" " style='visibility:hidden'>
		<input type="text" name=departDate id="departDate" value=<%=request.getParameter("departDate") %> style='visibility:hidden'>
		<input type="text" name="from" id="from" value=<%=request.getParameter("from") %> style='visibility:hidden'>
		<input type="text" name="destination" id="destination" value=<%=request.getParameter("destination") %> style='visibility:hidden'>
		<input type="text" name="tripType" id="tripType" value=<%=request.getParameter("tripType") %> style='visibility:hidden'>
		<input type="text" name="flex" id="flex" value=<%=request.getParameter("flex") %> style='visibility:hidden'>
		<%
		if(request.getParameter("returnDate") == null || request.getParameter("returnDate").equals("") || request.getParameter("returnDate").equals("null")){
			request.setAttribute("returnDate","2019");
		}
		else{
			request.setAttribute("returnDate",request.getParameter("returnDate"));
		}
		%>
	</form>
	
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
		
			String sort = request.getParameter("sortOption");
			String order = " ";
			if(sort.equals("Airline")){
				order = "ORDER BY f.ALID";
			}
			else if(sort.equals("Date")){
				order = "ORDER BY f.date";	
			}
			else if(sort.equals("Departure Time")){
				order = "ORDER BY f.departure_time";
			}
			else if(sort.equals("Arrival Time")){
				order = "ORDER BY f.arrival_time";				
			}else{
				order = "ORDER BY f.base_price";				
			}
			
			System.out.println("Sorte type: "+sort);
			String departDate = request.getParameter("departDate");
			String returnDate = String.valueOf(request.getAttribute("returnDate"));
			String departLoc = request.getParameter("from");
			String destination = request.getParameter("destination");
			String round = request.getParameter("tripType");
			String flex = request.getParameter("flex");
			//System.out.println(departDate+" "+round+" "+returnDate+" "+departLoc+" "+destination+" "+flex);
		
			String tempType;
			ApplicationDB ap = new ApplicationDB();
			Connection connection = ap.getConnection();
			Statement statement = connection.createStatement();
			PreparedStatement st;
			String sql;
			if(flex != null && flex.equals("flexDates")){
				String dateLow = dateMethods.dateFlexibleLower(departDate);
				String dateUp = dateMethods.dateFlexibleUpper(departDate);
				//System.out.println(dateLow+" "+dateUp);
				sql = "SELECT f.ALID, f.flight_number, f.departure_airport,"+
						"f.destination_airport,f.date,f.departure_time,f.arrival_time, "+
						"f.domestic, f.Base_price "+
						"FROM group13_db.flight f "+
						"WHERE (f.date between ? and ?) and f.departure_airport = ? and f.destination_airport = ? "+order;

				st = connection.prepareStatement(sql);
				st.setString(1,dateLow);
				st.setString(2,dateUp);
				st.setString(3,departLoc);
				st.setString(4,destination);
			}
			else{
				sql = "SELECT f.ALID, f.flight_number, f.departure_airport,"+
						"f.destination_airport,f.date,f.departure_time,f.arrival_time, "+
						"f.domestic, f.Base_price "+
						"FROM group13_db.flight f "+
						"WHERE f.date = ? and f.departure_airport = ? and f.destination_airport = ? "+order;

				st = connection.prepareStatement(sql);
				st.setString(1,departDate);
				st.setString(2,departLoc);
				st.setString(3,destination);
			
			}
			ResultSet resultSet = st.executeQuery();
			while(resultSet.next()){
		%>
		<tr>
		<td><input type="radio" name="flightSelection"></td>
		<td><%=resultSet.getString("ALID") %></td>
		<td><%=resultSet.getString("flight_number") %></td>
		<td><%=resultSet.getString("departure_airport") %></td>
		<td><%=resultSet.getString("destination_airport") %></td>
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
		var table2 = document.getElementById("sortTable"),rIndex2;
		for(var i = 0; i<table2.rows.length;i++){
			table2.rows[i].onclick=function(){
				rIndex2 = this.rowIndex;
				document.getElementById("sortOption").value = this.cells[1].innerHTML;
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
			<input type="text" name = "flex" id="flex" value=<%=request.getParameter("flex")%> style='visibility:hidden'>
			<input type="text" name = "tripT" id="tripT" value=<%=request.getParameter("tripType")%> style='visibility:hidden'>
			<%if(request.getParameter("returnDate") == null || request.getParameter("returnDate").equals("") || request.getParameter("returnDate").equals("null")){
				request.setAttribute("returnDate","2019");
			}
			else{
				request.setAttribute("returnDate",request.getParameter("returnDate"));
			}%>
				<input type="text" name = "returnDate" id="returnDate" value=<%=request.getAttribute("returnDate")%> style="visibility:hidden">
	</form>
	
	</div>
</body>
</html>
