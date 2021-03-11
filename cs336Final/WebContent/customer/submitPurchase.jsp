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
	<form method="POST" action="customerWaitList.jsp">
		<input type="text" name="newalid2" id="newalid2" value=<%=request.getParameter("newalid")%> style='visibility:hidden'>
		<input type="text" name="newflightNumb2" id="newflightNumb2" value=<%=request.getParameter("newflightNumb")%> style='visibility:hidden'>
	</form>
	<%
	try{
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		Date date = new Date(System.currentTimeMillis());
		//System.out.println(dateFormat.format(date));
		
		String today = String.valueOf(dateFormat.format(date));
		String alid = request.getParameter("newalid");
		String fDate = request.getParameter("newdate");
		String fNumb = request.getParameter("newflightNumb");
		String meal = request.getParameter("mealVal");
		String classType = request.getParameter("classType");
		String classVal = request.getParameter("classVal");
		String round = request.getParameter("newtrip");
		String returnDate = request.getParameter("newreturnDate");
		String price = String.valueOf(request.getParameter("newprice")).substring(1);
		
		price = String.valueOf(Double.parseDouble(price)+Double.parseDouble(classVal)+Double.parseDouble(meal));
		
		String changeFee;
		
		if(!classType.equals("Economy")){
			changeFee = "500.00";
		}
		else{
			changeFee = "0.0";
		}
		
		System.out.println(alid+" | "+fNumb+" | "+fDate+" | "+today+" | "+meal+" | "+classType+" | "+classVal+" | "+price+" | "+round+" | "+returnDate+" |");
		
		ApplicationDB ap = new ApplicationDB();
		Connection connection = ap.getConnection();
		Statement statement = connection.createStatement();
		
		String sql = "SELECT max(ticket_number)+1 nextTicket "+
				"FROM group13_db.ticket t";
		PreparedStatement st = connection.prepareStatement(sql);
		ResultSet resultSet = st.executeQuery();
		resultSet.next();
		String ticket = String.valueOf(resultSet.getString("nextTicket"));
		
		if(ticket == null || ticket.equals("null")) {
			ticket = "1";
		}
		//System.out.println("ticket " +ticket);
		
		sql = "SELECT number_seats AS maxSeat "+
			"FROM group13_db.aircraft ac, group13_db.flight f "+
			"WHERE f.flight_number = ? and f.ACID = ac.ACID";
		
		st = connection.prepareStatement(sql);
		st.setString(1,fNumb);
		resultSet = st.executeQuery();
		resultSet.next();
		int maxSeat = Integer.parseInt(resultSet.getString("maxSeat"));
		
		sql = "SELECT count(*) + 1 AS nextSeat "+
			"FROM group13_db.flightTicket t "+
			"WHERE t.flight_number = ?";
		
		st = connection.prepareStatement(sql);
		
		st.setString(1,fNumb);
		
		resultSet = st.executeQuery();
		resultSet.next();
		
		String seat = resultSet.getString("nextSeat");
		if(maxSeat>=Integer.parseInt(seat)){
			sql = "INSERT INTO group13_db.ticket (`ticket_number`, `username`, `seat_number`, `class`, `one_way`, `round_trip`, `meal_ordered`, `total_fare`) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
			
			st = connection.prepareStatement(sql);
			
			st.setString(1,ticket);
			st.setString(2,username);
			st.setString(3,seat);
			st.setString(4,classType);
			if(round.equals("One-way")){
				st.setString(5,"1");
				st.setString(6,"0");	
			}
			else{
				st.setString(5,"0");
				st.setString(6,"1");
				
			}
			st.setString(7,meal);
			st.setString(8,price);
			
			st.executeUpdate();
			
			sql = "INSERT INTO group13_db.customerBuys (`username`, `ticket_number`, `date_time_purchased`, `flight_date`, `booking_fee`, `change_fee`) VALUES (?, ?, ?, ?, ?, ?)";
			
			st = connection.prepareStatement(sql);
				
			st.setString(1,username);
			st.setString(2,ticket);
			st.setString(3,today);
			st.setString(4,fDate);
			st.setString(5,price);
			st.setString(6,changeFee);
			
			st.executeUpdate();
			
			
			sql = "INSERT INTO group13_db.flightTicket (`flight_number`, `ticket_number`, `ALID`) VALUES (?, ?, ?)";
			
			st = connection.prepareStatement(sql);
			
			st.setString(1,fNumb);
			st.setString(2,ticket);
			st.setString(3,alid);
			
			st.executeUpdate();
			
			
			if(round.equals("Round-trip")){
				if(returnDate.equals("2019")){
					out.print("<p class=\"margin-bottom red-font\">Invalid return date.</p>");
					response.sendRedirect(request.getContextPath() + "/customer/customer.jsp");
					
				}
		%>
		<div id="resultTable">
			<h2>Search Results - Return trip</h2>
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

				 ap = new ApplicationDB();
				 connection = ap.getConnection();
				 statement = connection.createStatement();
				
				
				System.out.println(alid+" "+fNumb+" "+returnDate);
				
				sql = "SELECT f.departure_airport, f.destination_airport "+
							"FROM group13_db.flight f "+
							"WHERE f.alid = ? and f.flight_number = ?";
			
				
				
				st = connection.prepareStatement(sql);
				st.setString(1,alid);
				st.setString(2,fNumb);

				resultSet = st.executeQuery();
				
				resultSet.next();
				
				String departLoc = resultSet.getString("destination_airport");
				String destination = resultSet.getString("departure_airport");
				
				System.out.println(returnDate+" "+departLoc+" "+destination);
				
				
				String tempType;
				String flex = request.getParameter("flex");

				if(flex != null && flex.equals("flexDates")){
					if(flex.equals("flexDates")){
						String dateLow = dateMethods.dateFlexibleLower(fDate);
						String dateUp = dateMethods.dateFlexibleUpper(fDate);
						System.out.println(dateLow+" "+dateUp);
						sql = "SELECT f.ALID, f.flight_number, f.departure_airport,"+
								"f.destination_airport,f.date,f.departure_time,f.arrival_time, "+
								"f.domestic, f.Base_price "+
								"FROM group13_db.flight f "+
								"WHERE (f.date between ? and ?) and f.departure_airport = ? and f.destination_airport = ?";
	
						st = connection.prepareStatement(sql);
						st.setString(1,dateLow);
						st.setString(2,dateUp);
						st.setString(3,departLoc);
						st.setString(4,destination);
					}
				}
				else{
					sql = "SELECT f.ALID, f.flight_number, f.departure_airport,"+
							"f.destination_airport,f.date,f.departure_time,f.arrival_time, "+
							"f.domestic, f.Base_price "+
							"FROM group13_db.flight f "+
							"WHERE f.date = ? and f.departure_airport = ? and f.destination_airport = ?";

					st = connection.prepareStatement(sql);
					st.setString(1,fDate);
					st.setString(2,departLoc);
					st.setString(3,destination);
				
				}
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
				<input type="text" name = "flex" id="flex" value=<%=request.getParameter("flex")%> style='visibility:hidden'>
				<input type="text" name = "price" id="price" style='visibility:hidden'><br/>
		</form>
		<form method="POST" action="customer.jsp" onsubmit="return validateLogin()">
			<input type="submit" value="Cancel">
		</form>
		</div>
		<%
			}
			else{
				response.sendRedirect(request.getContextPath() + "/customer/customer.jsp");
			}
		}
		else{
			
			session.setAttribute("alid", alid);
			session.setAttribute("flightNumber", fNumb);
			session.setAttribute("returnDate", returnDate);
			response.sendRedirect(request.getContextPath() + "/customer/customerWaitList.jsp");
			
		}
	}
	catch (Exception e) {
		e.printStackTrace();
	}	
		
	
	%>
	<form>
		<input type="text" id="newalid" name="newalid" value=<%=request.getParameter("newalid")%> style='visibility:hidden'>
		<input type="text" id="fNumber" name="fNumber" value=<%=request.getParameter("newflightNumb")%> style='visibility:hidden'>
		<input type="text" id="rDate" name="rDate" value=<%=request.getParameter("newreturnDate")%> style='visibility:hidden'>
	</form>

	
</body>
</html>
