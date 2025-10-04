<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page session="true" %> <!-- 세션 사용 선언 -->
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%
    // 세션을 만료시켜 로그아웃 처리
    session.invalidate();
    response.sendRedirect("index.jsp");  // 로그아웃 후 홈페이지로 리다이렉트
%>
