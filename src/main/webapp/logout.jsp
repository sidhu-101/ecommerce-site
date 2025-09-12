<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // Invalidate the current session to logout the user
    if (session != null) {
        session.invalidate();
    }
    // Redirect to login page or homepage after logout
    response.sendRedirect("index.jsp");
%>
