<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*, java.util.*" %>
<%
    String[] productIds = request.getParameterValues("product_id");
    String[] quantities = request.getParameterValues("quantity");
    if(productIds==null||quantities==null){
        response.sendRedirect("cart.jsp?message=상품을 선택하세요");
        return;
    }
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/oneul?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul",
        "root","root"
    );
    List<String> names = new ArrayList<>();
    List<String> images = new ArrayList<>();
    List<Integer> prices = new ArrayList<>();
    List<Integer> qtys = new ArrayList<>();
    int total = 0;
    for (int i = 0; i < productIds.length; i++) {
        int pid = Integer.parseInt(productIds[i]), qty = Integer.parseInt(quantities[i]);
        PreparedStatement ps = conn.prepareStatement("SELECT name,image,price FROM products WHERE id=?");
        ps.setInt(1, pid);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            names.add(rs.getString("name"));
            images.add(rs.getString("image"));
            prices.add(rs.getInt("price"));
            qtys.add(qty);
            total += rs.getInt("price") * qty;
        }
        rs.close();
        ps.close();
    }
    conn.close();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"><title>결제하기</title>
    <link rel="stylesheet" href="./css/index.css">
    <style>
        body {
            background-color: #f9f9f9;
            font-family: 'Noto Sans KR', sans-serif;
            margin: 0; padding: 0;
        }
        .container {
            width: 80%; margin: 50px auto; padding: 20px;
            background: #fff; border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        h2 { color: #8B5A2B; font-size: 24px; margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
        th, td { padding: 12px; text-align: left; border: 1px solid #8B5A2B; }
        th { background: #8B5A2B; color: #fff; }
        td img { width: 80px; height: 80px; object-fit: cover; border: 1px solid #ccc; }
        .total { font-size: 20px; font-weight: bold; text-align: right; color: #8B5A2B; margin-bottom: 20px; }
        form { background: #f7f7f7; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .shipping-info input, .buy-button {
            width: 100%; box-sizing: border-box;
            padding: 10px; margin: 10px 0;
            border: 1px solid #8B5A2B; border-radius: 5px;
            font-size: 16px;
        }
        .buy-button {
            background: #8B5A2B; color: #fff; border: none;
            cursor: pointer; margin-top: 20px;
        }
        .buy-button:hover { background: #70451e; }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="container">
    <h2>주문 확인</h2>
    <table>
        <thead>
            <tr><th>이미지</th><th>상품명</th><th>가격</th><th>수량</th><th>소계</th></tr>
        </thead>
        <tbody>
        <%
            for (int i = 0; i < names.size(); i++) {
                String img = images.get(i).startsWith("/") ? images.get(i) : "/" + images.get(i);
        %>
            <tr>
                <td><img src="<%= request.getContextPath() + img %>" alt=""></td>
                <td><%= names.get(i) %></td>
                <td><%= prices.get(i) %>원</td>
                <td><%= qtys.get(i) %>개</td>
                <td><%= prices.get(i) * qtys.get(i) %>원</td>
            </tr>
        <%
            }
        %>
        </tbody>
    </table>

    <div class="total">총 합계: <%= total %>원</div>

    <form action="payment_process.jsp" method="post">
        <%
            for (int i = 0; i < productIds.length; i++) {
        %>
            <input type="hidden" name="product_id" value="<%= productIds[i] %>">
            <input type="hidden" name="quantity" value="<%= quantities[i] %>">
        <%
            }
        %>
        <input type="hidden" name="total_price" value="<%= total %>">

        <div class="shipping-info">
            <input type="text" name="customer_name" placeholder="이름" required>
            <input type="text" name="address" placeholder="주소" required>
            <input type="text" name="phone" placeholder="전화번호" required>
        </div>

        <button type="submit" class="buy-button">구매하기</button>
    </form>
</div>

</body>
</html>
