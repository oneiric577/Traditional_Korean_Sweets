<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    String id = request.getParameter("id");
    String title = "", content = "";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/oneul?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul",
            "root", "root"
        );

        String sql = "SELECT * FROM notice WHERE id = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, id);
        rs = stmt.executeQuery();

        if (rs.next()) {
            title = rs.getString("title");
            content = rs.getString("content");
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
    <title>공지사항 수정</title>
    <link rel="stylesheet" href="./css/index.css">
    <style>
        body {
            background-color: white;
            color: #333;
        }

        .admin-content {
            margin: 50px auto;
            width: 70%;
            padding: 40px;
            border: 2px solid black;
            border-radius: 20px;
            text-align: center;
            background-color: white;
        }

        .admin-title {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 30px;
        }

        .notice-form {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .notice-form input[type="text"],
        .notice-form textarea {
            width: 80%;
            padding: 10px;
            margin-bottom: 20px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        .notice-form input[type="submit"] {
            padding: 10px 20px;
            font-size: 16px;
            border: none;
            background-color: black;
            color: white;
            border-radius: 5px;
            cursor: pointer;
        }

        .notice-form input[type="submit"]:hover {
            background-color: #444;
        }
    </style>
</head>
<body>

    <%@ include file="admin_header.jsp" %>

    <div class="admin-content">
        <h2 class="admin-title">공지사항 수정</h2>
        <form class="notice-form" action="notice_edit_action.jsp" method="post">
            <input type="hidden" name="id" value="<%= id %>">
            <input type="text" name="title" value="<%= title %>" required>

            <textarea name="content" rows="10" required><%= content %></textarea>

            <input type="submit" value="수정">
        </form>
    </div>

</body>
</html>
