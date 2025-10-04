<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    // 1) 제품 정보 조회
    String productId = request.getParameter("id");
    String name = "", description = "", image = "";
    int price = 0;
    try (Connection conn = DriverManager.getConnection(
             "jdbc:mysql://localhost:3306/oneul?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul",
             "root", "root");
         PreparedStatement stmt = conn.prepareStatement(
             "SELECT * FROM products WHERE id = ?")
    ) {
        Class.forName("com.mysql.cj.jdbc.Driver");
        stmt.setInt(1, Integer.parseInt(productId));
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                name = rs.getString("name");
                description = rs.getString("description");
                image = rs.getString("image");
                price = rs.getInt("price");
            }
        }
    } catch (Exception e) {
        // 화면에 예외 메시지를 바로 찍어줍니다.
        out.println("<h3>오류 발생: " + e.getMessage() + "</h3>");
        return;
    }

    // 2) 로그인 여부 확인
    String userId = (String) session.getAttribute("user_id");

    // 3) 이미지 경로 보정
    String imagePath = image.startsWith("/") ? image : "/" + image;
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title><%= name %> - 상세정보</title>
    <link rel="stylesheet" href="./css/index.css">
    <style>
        /* (기존 스타일 그대로) */
        body { background: #fff; font-family: 'Noto Sans KR', sans-serif; }
        .product-detail-container { width:80%; margin:50px auto; border:2px solid #000; border-radius:15px;
            padding:30px; display:flex; gap:40px; }
        .product-image-box img { width:300px; border:1px solid #ddd; }
        .product-info { flex:1; }
        .product-info h2 { font-size:24px; margin-bottom:20px; }
        .product-info p { margin-bottom:15px; font-size:16px; }
        .quantity-input { width:60px; padding:5px; font-size:16px; text-align:center; margin-bottom:20px; }
        .buttons { display:flex; gap:20px; margin-top:20px; }
        .buttons button { padding:10px 25px; font-size:16px; border:1px solid #000; background:#fff; cursor:pointer; }
        .buttons button:hover { background:#eee; }
    </style>
</head>
<body>

    <%@ include file="header.jsp" %>

    <div class="product-detail-container">
        <div class="product-image-box">
            <img src="<%= request.getContextPath() + imagePath %>" alt="<%= name %>">
        </div>
        <div class="product-info">
            <h2><%= name %></h2>
            <p><strong>가격:</strong> <%= price %>원</p>
            <p><strong>상세정보:</strong><br>
               <%= (description != null && !description.isEmpty())
                    ? description
                    : "상세 설명이 없습니다." %>
            </p>

            <label for="quantity">수량:</label>
            <input type="number" id="quantity" name="quantity"
                   class="quantity-input" value="1" min="1" required>

            <div class="buttons">
                <!-- 구매하기 버튼 -->
<form action="checkout.jsp" method="post" style="display:inline;">
    <input type="hidden" name="product_id" value="<%= productId %>">
    <input type="hidden" name="quantity" value="1" id="buy-qty">
    <% if (userId != null) { %>
        <button type="submit"
            onclick="document.getElementById('buy-qty').value = document.getElementById('quantity').value;">
            구매하기
        </button>
    <% } else { %>
        <button type="button"
            onclick="alert('로그인이 필요합니다.'); location.href='login.jsp';">
            구매하기
        </button>
    <% } %>
</form>


                <!-- 장바구니 버튼 -->
                <form action="cart_add.jsp" method="post" style="display:inline;">
                    <input type="hidden" name="product_id" value="<%= productId %>">
                    <input type="hidden" name="quantity" value="1" id="cart-qty">
                    <% if (userId != null) { %>
                        <button type="submit"
                            onclick="document.getElementById('cart-qty').value = document.getElementById('quantity').value;">
                            장바구니
                        </button>
                    <% } else { %>
                        <button type="button"
                            onclick="alert('로그인이 필요합니다.'); location.href='login.jsp';">
                            장바구니
                        </button>
                    <% } %>
                </form>
            </div>
        </div>
    </div>

</body>
</html>
