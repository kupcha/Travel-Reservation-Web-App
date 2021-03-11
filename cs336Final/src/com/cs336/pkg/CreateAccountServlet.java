package com.cs336.pkg;

import java.io.IOException;
import java.sql.ResultSet;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.sql.PreparedStatement;

import java.sql.Connection;
import java.sql.Statement;

/**
 * Servlet implementation class LoginServlet
 */
public class CreateAccountServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
    /**
     * Default constructor. 
     */
    public CreateAccountServlet() {
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO: nothing here yet
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();

		String formUsername = request.getParameter("username");
		String formPassword = request.getParameter("password");

		try {
			ApplicationDB db = new ApplicationDB();
			Connection con = db.getConnection();

			PreparedStatement insertUser = con.prepareStatement("INSERT INTO user (password, type, username) VALUES (?,?,?)");
			insertUser.setString(1, formPassword);
			insertUser.setString(2, "customer");
			insertUser.setString(3, formUsername);
			insertUser.executeUpdate();
		
			session.setAttribute("account-created", "account created");
			response.sendRedirect(request.getContextPath() + "/index.jsp");
			db.closeConnection(con);
		} catch (Exception e) {
			e.printStackTrace();
		}	

	}
}
