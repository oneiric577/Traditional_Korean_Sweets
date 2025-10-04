<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%
    String noticeId = request.getParameter("id");

    String title = "", content = "", date = "";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    String userId = (String) session.getAttribute("user_id");
    String userName = (String) session.getAttribute("user_name");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/oneul?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul",
            "root", "root"
        );

        String sql = "SELECT * FROM notice WHERE id = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, noticeId);
        rs = stmt.executeQuery();

        if (rs.next()) {
            title = rs.getString("title");
            content = rs.getString("content");
            date = rs.getString("created_at");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항 상세보기</title>
    <link rel="stylesheet" href="./css/index.css">
    <style>
        .notice-container {
            width: 70%;
            margin: 50px auto;
            padding: 30px;
            border: 1px solid #ccc;
            border-radius: 10px;
            background-color: #fdfdfd;
            font-family: '맑은 고딕', sans-serif;
        }
        .notice-title {
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 20px;
            border-bottom: 2px solid #555;
            padding-bottom: 10px;
        }
        .notice-date {
            color: #888;
            font-size: 14px;
            margin-bottom: 20px;
            text-align: right;
        }
        .notice-content {
            font-size: 18px;
            line-height: 1.8;
            white-space: pre-wrap;
        }
        .back-btn {
            display: inline-block;
            margin-top: 30px;
            padding: 10px 25px;
            background-color: #333;
            color: white;
            border: none;
            border-radius: 5px;
            text-decoration: none;
        }
        .back-btn:hover {
            background-color: #555;
        }
    </style>
</head>
<body>

    <!-- ✅ 공통 헤더 영역만 include -->
    <jsp:include page="header.jsp" />

    <!-- ✅ 본문 영역 -->
    <div class="notice-container">
        <div class="notice-title"><%= title %></div>
        <div class="notice-date"><%= date %></div>
        <div class="notice-content"><%= content %></div>
        <a href="notice.jsp" class="back-btn">목록으로</a>
    </div>

</body>
</html>
