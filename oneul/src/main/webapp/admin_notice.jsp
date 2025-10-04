<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, java.util.*" %>

<%
    // DB 연결
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    List<Map<String, String>> noticeList = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/oneul?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul",
            "root", "root"
        );

        String sql = "SELECT * FROM notice ORDER BY id DESC";
        stmt = conn.prepareStatement(sql);
        rs = stmt.executeQuery();

        while (rs.next()) {
            Map<String, String> notice = new HashMap<>();
            notice.put("id", rs.getString("id"));
            notice.put("title", rs.getString("title"));
            notice.put("created_at", rs.getString("created_at"));
            noticeList.add(notice);
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
    <title>공지사항 관리</title>
    <link rel="stylesheet" href="./css/index.css"> <!-- adminMain과 일관성 유지 -->
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

        .admin-table {
            width: 90%;
            margin: 0 auto 30px auto;
            border-collapse: collapse;
            font-size: 16px;
        }

        .admin-table th,
        .admin-table td {
            border: 1px solid #ccc;
            padding: 10px 15px;
        }

        .admin-table th {
            background-color: #f0f0f0;
        }

        .edit-btn,
        .delete-btn {
            text-decoration: none;
            color: #0066cc;
        }

        .edit-btn:hover,
        .delete-btn:hover {
            text-decoration: underline;
        }

        .admin-add-button {
            text-align: center;
            margin-top: 20px;
        }

        .admin-add-button button {
            padding: 10px 20px;
            font-size: 16px;
            border: none;
            background-color: black;
            color: white;
            border-radius: 5px;
            cursor: pointer;
        }

        .admin-add-button button:hover {
            background-color: #444;
        }
    </style>
</head>
<body>

    <%@ include file="admin_header.jsp" %>
	<h2 style="text-align:center;">관리자 모드(공지사항)</h2>
    <div class="admin-content">
        <h2 class="admin-title">공지사항 관리</h2>
        <table class="admin-table">
            <tr>
                <th>번호</th>
                <th>제목</th>
                <th>작성일</th>
                <th>수정</th>
                <th>삭제</th>
            </tr>
            <%
                for (Map<String, String> notice : noticeList) {
            %>
            <tr>
                <td><%= notice.get("id") %></td>
                <td><%= notice.get("title") %></td>
                <td><%= notice.get("created_at") %></td>
                <td><a href="notice_edit.jsp?id=<%= notice.get("id") %>" class="edit-btn">수정</a></td>
                <td><a href="notice_delete.jsp?id=<%= notice.get("id") %>" class="delete-btn" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a></td>
            </tr>
            <%
                }
            %>
        </table>
        <div class="admin-add-button">
            <a href="notice_add.jsp"><button>등록</button></a>
        </div>
    </div>

</body>
</html>
