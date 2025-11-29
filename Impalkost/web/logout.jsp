<%-- 
    Document   : logout
    Created on : 14 Okt 2025, 15.51.31
    Author     : Ghaisani
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Invalidate sesi
    session.invalidate();
    
    // Redirect ke login page dengan success message
    response.sendRedirect("login.jsp?logout=success");
%> 