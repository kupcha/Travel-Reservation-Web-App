package com.cs336.pkg;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import com.mysql.jdbc.Driver;

public class ApplicationDB {
	Connection connection = null;
	Driver driver = null;
	
	public ApplicationDB() {
		// Nothing to do here yet
	}

	public Connection getConnection() {
		//Create a connection string
		String connectionUrl = "jdbc:mysql://group13-db-instance.cbxyjrbkpo2b.us-east-2.rds.amazonaws.com:3306/group13_db";
		
		try {
			//Load JDBC driver - the interface standardizing the connection procedure. Look at WEB-INF\lib for a mysql connector jar file, otherwise it fails.
			driver = new com.mysql.jdbc.Driver();
			DriverManager.registerDriver(driver);
		} catch (Exception e) {
			e.printStackTrace();
		}

		try {
			//Create a connection to your DB
			connection = DriverManager.getConnection(connectionUrl,"group13", "13group13group");
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return connection;
	}
	
	public void closeConnection(Connection connection) {
		try {
			connection.close();
			DriverManager.deregisterDriver(driver);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
