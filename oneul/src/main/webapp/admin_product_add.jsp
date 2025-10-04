<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, java.io.*" %>

<%
    request.setCharacterEncoding("UTF-8");
    boolean isPost = "POST".equalsIgnoreCase(request.getMethod());

    String message = "";

    if (isPost) {
        String name = request.getParameter("name");
        String priceStr = request.getParameter("price");
        String image = request.getParameter("image");
        String category = request.getParameter("category");
        String description = request.getParameter("description");

        try {
            int price = Integer.parseInt(priceStr);

            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/oneul?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul",
                        "root", "root"
                    );
                 PreparedStatement stmt = conn.prepareStatement(
                        "INSERT INTO products (name, price, image, category, description) VALUES (?, ?, ?, ?, ?)"
                 )) {

                stmt.setString(1, name);
                stmt.setInt(2, price);
                stmt.setString(3, image);
                stmt.setString(4, category);
                stmt.setString(5, description);

                int inserted = stmt.executeUpdate();
                message = inserted > 0 ? "제품이 등록되었습니다." : "등록 실패";
                response.sendRedirect("admin_products.jsp?message=" + java.net.URLEncoder.encode(message, "UTF-8"));
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            message = "오류 발생: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>제품 등록</title>
    <link rel="stylesheet" href="css/index.css">
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 100%;
            max-width: 600px;
            margin: 60px auto;
            background: #fff;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }
        h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #333;
        }
        label {
            font-weight: 600;
            display: block;
            margin-bottom: 5px;
            color: #444;
        }
        input[type="text"],
        input[type="number"],
        select,
        textarea {
            width: 100%;
            padding: 10px 12px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
        }
        textarea {
            resize: vertical;
        }
        .btn-wrap {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        button {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            font-size: 15px;
            cursor: pointer;
            transition: background 0.3s;
        }
        button:hover {
            background-color: #45a049;
        }
        a.cancel {
            text-decoration: none;
            color: #999;
            font-size: 14px;
            transition: color 0.2s;
        }
        a.cancel:hover {
            color: #666;
        }
        .message {
            text-align: center;
            color: red;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
<%@ include file="admin_header.jsp" %>

<div class="container">
    <h2>제품 등록</h2>

    <% if (!message.isEmpty()) { %>
        <p class="message"><%= message %></p>
    <% } %>

    <form method="post" action="admin_product_add.jsp">
        <label for="name">제품명</label>
        <input type="text" id="name" name="name" required>

        <label for="price">가격</label>
        <input type="number" id="price" name="price" required>

        <label for="image">이미지 경로</label>
        <input type="text" id="image" name="image" required>

        <label for="category">카테고리</label>
        <select id="category" name="category" required>
            <option value="hangwa">한과</option>
            <option value="nuts">넛츠</option>
        </select>

        <label for="description">설명</label>
        <textarea id="description" name="description" rows="4"></textarea>

        <div class="btn-wrap">
            <button type="submit">등록</button>
            <a class="cancel" href="admin_products.jsp">취소</a>
        </div>
    </form>
</div>

</body>
</html>
