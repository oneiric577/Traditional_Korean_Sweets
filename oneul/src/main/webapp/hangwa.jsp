<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>한과</title>
    <link rel="stylesheet" href="./css/index.css">
    <link rel="stylesheet" href="./css/product.css">
</head>
<body>

    <%@ include file="header.jsp" %>

    <div class="product-container">
        <h2>한과 상품 목록</h2>
        <div class="product-list">
        <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/oneul", "root", "root");

                String sql = "SELECT * FROM products WHERE category = 'hangwa'";
                pstmt = conn.prepareStatement(sql);
                rs = pstmt.executeQuery();

                while (rs.next()) {
                    int id = rs.getInt("id");
                    String name = rs.getString("name");
                    int price = rs.getInt("price");
                    String image = rs.getString("image");
        %>
            <div class="product-item">
                <!-- 이미지 클릭 시 상세 페이지로 이동 -->
                <a href="product_detail.jsp?id=<%= id %>">
                    <img src="<%= request.getContextPath() + "/" + image %>" alt="<%= name %>" class="product-image">
                </a>
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
