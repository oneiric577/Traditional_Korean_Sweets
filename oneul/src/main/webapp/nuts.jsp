<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>넛츠</title>
    <link rel="stylesheet" href="./css/index.css">
    <link rel="stylesheet" href="./css/product.css">
    <style>
        .product-container {
            max-width: 1200px;
            margin: 50px auto;
            padding: 20px;
        }

        .product-list {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 30px;
        }

        .product-item {
            cursor: pointer;
            text-align: center;
            width: 220px;
            margin: 10px;
            display: inline-block;
            vertical-align: top;
        }

        .product-item img {
            width: 200px;
            height: 200px;
            object-fit: cover;
            border: 1px solid #ccc;
            border-radius: 10px;
            transition: transform 0.2s;
        }

        .product-item img:hover {
            transform: scale(1.05);
        }

        .name, .price {
            margin: 10px 0;
        }
    </style>
</head>
<body>

    <%@ include file="header.jsp" %>

    <div class="product-container">
        <h2>넛츠 상품 목록</h2>
        <div class="product-list">
        <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/oneul", "root", "root");

                String sql = "SELECT * FROM products WHERE category = 'nuts'";
                pstmt = conn.prepareStatement(sql);
                rs = pstmt.executeQuery();

                while (rs.next()) {
                    String name = rs.getString("name");
                    int price = rs.getInt("price");
                    String image = rs.getString("image");
                    int id = rs.getInt("id");
        %>
            <div class="product-item" onclick="location.href='product_detail.jsp?id=<%= id %>';">
                <img src="<%= request.getContextPath() + "/" + image %>" alt="<%= name %>" class="product-image">
                <p class="name"><%= name %></p>
                <p class="price"><%= price %>원</p>
            </div>
        <%
                }
            } catch (Exception e) {
                out.println("DB 오류: " + e.getMessage());
            } finally {
                if (rs != null) try { rs.close(); } catch (Exception e) {}
                if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
                if (conn != null) try { conn.close(); } catch (Exception e) {}
            }
        %>
        </div>
    </div>

</body>
</html>
