<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, java.util.*" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원관리</title>
    <link rel="stylesheet" href="css/index.css">
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
        }

        h2 {
            text-align: center;
            margin: 40px 0 20px;
            color: #333;
        }

        table {
            width: 90%;
            margin: 0 auto 30px;
            border-collapse: collapse;
            background-color: #fff;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            border-radius: 10px;
            overflow: hidden;
        }

        th, td {
            padding: 14px;
            text-align: center;
            border-bottom: 1px solid #e0e0e0;
        }

        th {
            background-color: #f5f5f5;
            color: #333;
            font-weight: bold;
        }

        tr:hover {
            background-color: #f0f8ff;
        }

        input[type="checkbox"] {
            width: 18px;
            height: 18px;
        }

        .btn {
            padding: 10px 25px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            background-color: #ef5350;
            color: white;
            transition: background-color 0.3s ease;
            margin-right: 5%;
        }

        .btn:hover {
            background-color: #d32f2f;
        }

        .action-buttons {
            text-align: right;
            margin-bottom: 40px;
            margin-right: 5%;
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

<h2>관리자 모드 - 회원관리</h2>

<form method="post" action="admin_user_delete.jsp">
    <table>
        <thead>
            <tr>
                <th><input type="checkbox" onclick="toggleAll(this)"></th>
                <th>번호</th>
                <th>아이디</th>
                <th>이름</th>
                <th>휴대전화</th>
            </tr>
        </thead>
        <tbody>
        <%
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/oneul?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul",
                    "root", "root");
                 PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users WHERE role = 'user'");
                 ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {
        %>
            <tr>
                <td><input type="checkbox" name="user_number" value="<%= rs.getInt("user_number") %>"></td>
                <td><%= rs.getInt("user_number") %></td>
                <td><%= rs.getString("user_id") %></td>
                <td><%= rs.getString("user_name") %></td>
                <td><%= rs.getString("user_phonenumber") %></td>
            </tr>
        <%
                }
            } catch (Exception e) {
                out.println("<tr><td colspan='5' style='color:red;'>오류 발생: " + e.getMessage() + "</td></tr>");
            }
        %>
        </tbody>
    </table>

    <div class="action-buttons">
        <button type="submit" class="btn">선택 삭제</button>
    </div>
</form>

<script>
    function toggleAll(source) {
        const checkboxes = document.querySelectorAll('input[type="checkbox"][name="user_number"]');
        checkboxes.forEach(cb => cb.checked = source.checked);
    }
</script>

</body>
</html>
