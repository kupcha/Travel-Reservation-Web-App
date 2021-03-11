package com.cs336.pkg;

import java.io.IOException;
import java.sql.ResultSet;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.sql.Connection;
import java.sql.Statement;

/**
 * Servlet implementation class LoginServlet
 */
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
    /**
     * Default constructor. 
     */
    public LoginServlet() {
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

		try {
			ApplicationDB db = new ApplicationDB();
			Connection con = db.getConnection();

			Statement stmt = con.createStatement();
			String formUsername = request.getParameter("username");
			String formPassword = request.getParameter("password");
			String str = "SELECT username,type FROM user WHERE username='" + formUsername + "' AND password='" + formPassword + "'";
			ResultSet result = stmt.executeQuery(str);

			// If username or password do not exist in DB redirect back to index with error
			if (result == null || !result.next()) {
				session.setAttribute("loginError", true);
				response.sendRedirect(request.getContextPath() + "/index.jsp");
			} else {
				// Otherwise set username in session
				session.setAttribute("db_username", result.getString("username"));
				String type = result.getString("type");
				session.setAttribute("db_type", type);

				if (type.equals("customer")) {
					response.sendRedirect(request.getContextPath() + "/customer/customer.jsp");
				}
				else if (type.equals("admin")) {
					response.sendRedirect(request.getContextPath() + "/admin/admin.jsp");
				}
				else if (type.equals("representative")) {
					response.sendRedirect(request.getContextPath() + "/representative/representative.jsp");
				}
			}

			db.closeConnection(con);
		} catch (Exception e) {
			e.printStackTrace();
		}	
	}
}
