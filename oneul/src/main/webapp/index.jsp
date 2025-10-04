<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    List<Map<String, String>> products = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/oneul?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul",
            "root", "root"
        );

        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM products ORDER BY RAND() LIMIT 3");

        while (rs.next()) {
            Map<String, String> product = new HashMap<>();
            product.put("name", rs.getString("name"));
            product.put("image", rs.getString("image"));
            product.put("price", rs.getString("price"));
            products.add(product);
        }

        rs.close();
        stmt.close();
        conn.close();
    } catch (Exception e) {
        out.println("<p style='color:red;'>DB 오류: " + e.getMessage() + "</p>");
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>오늘, 한과</title>
    <link rel="stylesheet" href="./css/index.css">
    <style>
        .best-product {
            text-align: center;
            margin-bottom: 60px;
        }

        .product-list {
            display: flex;
            justify-content: center;
            gap: 20px;
            flex-wrap: wrap;
        }

        .product-item {
            width: 220px;
            height: 320px;
            text-align: center;
            background-color: #f9f9f9;
            border-radius: 8px;
            padding: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
        }

        .product-item img {
            width: 100%;
            height: 180px;
            object-fit: cover;
            border-radius: 6px;
        }

        .product-item p {
            margin-top: 10px;
            font-size: 14px;
            color: #333;
        }
    </style>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            let current = 0;
            const slides = document.querySelectorAll(".slides img");

            function showSlide(index) {
                slides.forEach((slide, i) => {
                    slide.classList.remove("active");
                    if (i === index) slide.classList.add("active");
                });
            }

            function nextSlide() {
                current = (current + 1) % slides.length;
                showSlide(current);
            }

            showSlide(current);
            setInterval(nextSlide, 3000);
        });
    </script>
</head>
<body>
    <%@ include file="header.jsp" %>

    <!-- 슬라이드는 그대로 유지 -->
    <div class="slider">
        <div class="slides">
            <img src="./images/slide1.jpg" alt="Slide 1">
            <img src="./images/slide2.jpg" alt="Slide 2">
            <img src="./images/slide3.jpg" alt="Slide 3">
        </div>
    </div>

    <!-- BEST PRODUCT 영역 -->
    <section class="best-product">
        <h2>BEST PRODUCT</h2>
        <div class="product-list">
            <% for (Map<String, String> product : products) { %>
                <div class="product-item">
                    <img src="<%= product.get("image") %>" alt="<%= product.get("name") %>">
                    <p><strong><%= product.get("name") %></strong></p>
                    <p><%= product.get("price") %>원</p>
                </div>
            <% } %>
        </div>
    </section>
</body>
</html>
