<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, java.util.*" %>
<%
    String userId = (String) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect("login.jsp?message=로그인이 필요합니다.");
        return;
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>제품 관리 - 관리자 모드</title>
    <link rel="stylesheet" href="css/index.css">
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
        }

        h2 {
            text-align: center;
            margin-top: 40px;
            color: #333;
        }

        table {
            width: 90%;
            margin: 30px auto;
            border-collapse: collapse;
            background-color: #fff;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        th, td {
            padding: 14px;
            text-align: center;
            border-bottom: 1px solid #e0e0e0;
        }

        th {
            background-color: #fafafa;
            color: #333;
            font-weight: bold;
        }

        tr:hover {
            background-color: #f0f8ff;
        }

        td a {
            text-decoration: none;
            color: #1565c0;
        }

        td a:hover {
            text-decoration: underline;
        }

        .action-buttons {
            display: flex;
            justify-content: center;
            margin-bottom: 40px;
            gap: 20px;
        }

        .btn {
            padding: 10px 25px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .btn-delete {
            background-color: #ef5350;
            color: white;
        }

        .btn-delete:hover {
            background-color: #d32f2f;
        }

        .btn-add {
            background-color: #66bb6a;
            color: white;
        }

        .btn-add:hover {
            background-color: #388e3c;
        }

        input[type="checkbox"] {
            width: 18px;
            height: 18px;
        }

        @media (max-width: 768px) {
            table {
                font-size: 13px;
            }
            .btn {
                padding: 8px 18px;
            }
        }
    </style>
</head>
<body>

<%@ include file="admin_header.jsp" %>

<h2>관리자 모드 - 제품 관리</h2>

<form action="admin_product_delete.jsp" method="post">
    <table>
        <thead>
            <tr>
                <th><input type="checkbox" onclick="toggleAll(this)"></th>
                <th>제품 번호</th>
                <th>제품명</th>
                <th>카테고리</th>
                <th>가격</th>
                <th>수정</th>
            </tr>
        </thead>
        <tbody>
        <%
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/oneul?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul",
                    "root", "root"
                );
                String sql = "SELECT * FROM products";
                stmt = conn.prepareStatement(sql);
                rs = stmt.executeQuery();

                while (rs.next()) {
                    int id = rs.getInt("id");
                    String name = rs.getString("name");
                    String category = rs.getString("category");
                    int price = rs.getInt("price");
        %>
            <tr>
                <td><input type="checkbox" name="product_ids" value="<%= id %>"></td>
                <td><%= id %></td>
                <td><%= name %></td>
                <td><%= category %></td>
                <td><%= String.format("%,d", price) %> 원</td>
                <td><a href="admin_product_edit.jsp?id=<%= id %>">수정</a></td>
            </tr>
        <%
                }
            } catch (Exception e) {
        %>
            <tr><td colspan="6" style="color:red;">오류 발생: <%= e.getMessage() %></td></tr>
        <%
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        %>
        </tbody>
    </table>

    <div class="action-buttons">
        <button type="submit" class="btn btn-delete">선택 삭제</button>
        <a href="admin_product_add.jsp" class="btn btn-add">제품 등록</a>
    </div>
</form>

<script>
    function toggleAll(source) {
        const checkboxes = document.getElementsByName('product_ids');
        for (let i = 0; i < checkboxes.length; i++) {
            checkboxes[i].checked = source.checked;
        }
    }
</script>

</body>
</html>
