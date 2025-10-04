<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상품 목록</title>
    <link rel="stylesheet" href="./css/product.css">
</head>
<body>
    <div class="navbar">
        <p class="user-menu">
            <a href="login.jsp">로그인</a> |
            <a href="register.jsp">회원가입</a>
        </p>
    </div>
    <div class="product-list">
        <% 
            String category = request.getParameter("category");
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                String dbUrl = "jdbc:mysql://localhost:3306/oneul";
                String dbUser = "root";
                String dbPassword = "password";
                conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                
                String sql = "SELECT * FROM products WHERE category = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, category);
                rs = stmt.executeQuery();
                
                while (rs.next()) {
        %>
        <div class="product-item">
            <img src="<%= rs.getString("image") %>" alt="<%= rs.getString("name") %>">
            <p><%= rs.getString("name") %></p>
            <p><%= rs.getString("price") %>원</p>
        </div>
        <% 
            }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        %>
    </div>
</body>
</html>
