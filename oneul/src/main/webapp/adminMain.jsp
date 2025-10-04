<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>

<%
    String userId = (String) session.getAttribute("user_id");
    String userName = (String) session.getAttribute("user_name");
    String userRole = (String) session.getAttribute("user_role");

    if (userId == null || !"admin".equals(userRole)) {
%>
    <script>
        alert("관리자만 접근 가능합니다.");
        window.location.href = "index.jsp";
    </script>
<%
        return;
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 모드 - 오늘, 한과</title>
    <link rel="stylesheet" href="./css/index.css">
</head>
<body>

    <!-- 헤더 인클루드 -->
    <%@ include file="admin_header.jsp" %>

    <!-- 본문 콘텐츠 -->
    <div class="admin-content">
        *현재 관리자 모드 입니다.*
    </div>

</body>
</html>
