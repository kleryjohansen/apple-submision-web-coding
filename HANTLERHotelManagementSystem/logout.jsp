<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Menghapus semua session
    session.invalidate();

    // Redirect ke index.jsp
    response.sendRedirect("index.jsp");
%>