<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*" %>

<%
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/oneul?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
        conn = DriverManager.getConnection(url, "root", "root");

        String sql = "SELECT id, title, created_at FROM notice ORDER BY id DESC";
        stmt = conn.prepareStatement(sql);
        rs = stmt.executeQuery();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항</title>
    <link rel="stylesheet" href="./css/index.css">
    <style>
        table {
            width: 90%;
            margin: 50px auto;
            border-collapse: collapse;
            text-align: center;
        }
        th, td {
            border: 1px solid black;
            padding: 12px;
        }
        th {
            background-color: #f4f4f4;
        }
        .plus-btn {
            background-color: #eee;
            border: none;
            font-size: 20px;
            padding: 5px 10px;
            cursor: pointer;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
    </style>
</head>
<body>

<jsp:include page="header.jsp" /> <!-- 로고, 메뉴 포함 -->

<table>
    <tr>
        <th>번호</th>
        <th>제목</th>
        <th>작성일</th>
        <th></th>
    </tr>

<%
    while (rs.next()) {
%>
    <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getString("title") %></td>
        <td><%= rs.getDate("created_at") %></td>
        <td>
            <form action="noticeDetail.jsp" method="get">
                <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                <button type="submit" class="plus-btn">＋</button>
            </form>
        </td>
    </tr>
<%
    }
%>
</table>

</body>
</html>

<%
    } catch (Exception e) {
        out.println("공지사항을 불러오는 중 오류 발생: " + e.getMessage());
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (stmt != null) stmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>
