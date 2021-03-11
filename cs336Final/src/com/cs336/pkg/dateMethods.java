package com.cs336.pkg;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class SubmitPurchase
 */
@WebServlet("/SubmitPurchase")
public class dateMethods extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public dateMethods() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
		
	}
	public static String dateFormat(String date) {
		String year = date.substring(0,4);
		String month = date.substring(5,7);
		String day = date.substring(8);
		return year+"-"+month+"-"+day;
	}
	public static String dateFlexibleLower(String date) {
		String year = date.substring(0,4);
		String month = date.substring(5,7);
		String day = date.substring(8);
		
		if(Integer.parseInt(day)>=8) {
			day = String.valueOf(Integer.parseInt(day)-7);
		}
		else {
			if(Integer.parseInt(month)==1) {
				month = "12";
				year = String.valueOf(Integer.parseInt(year)-1);
			}
			else {
				month =  String.valueOf(Integer.parseInt(month)-1);
			}
			day = String.valueOf(Integer.parseInt(day)-7 + 30);
		}
		return year+"-"+month+"-"+day;
	}
	public static String dateFlexibleUpper(String date) {
		String year = date.substring(0,4);
		String month = date.substring(5,7);
		String day = date.substring(8);
		
		if(Integer.parseInt(day)<=23) {
			day = String.valueOf(Integer.parseInt(day)+7);
		}
		else {
			if(Integer.parseInt(month)<12) {
				month =  String.valueOf(Integer.parseInt(month)+1);
			}
			else {
				month =  "01";
				year = String.valueOf(Integer.parseInt(year)+1);
			}
			day = String.valueOf(Integer.parseInt(day)+7 - 30);
		}
		return year+"-"+month+"-"+day;
	}

}
