<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, java.io.*" %>

<%
    request.setCharacterEncoding("UTF-8");
    String message = "";
    String mode = request.getMethod();
    String idParam = request.getParameter("id");
    int productId = 0;
    String name = ""; int price = 0; String image = ""; String category = ""; String description = "";
    try {
        productId = Integer.parseInt(idParam);
    } catch (Exception e) {
        response.sendRedirect("admin_products.jsp?message=잘못된 제품 번호입니다.");
        return;
    }
    Class.forName("com.mysql.cj.jdbc.Driver");
    try (Connection conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/oneul?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul",
            "root","root")) {

        if ("POST".equalsIgnoreCase(mode)) {
            name = request.getParameter("name");
            price = Integer.parseInt(request.getParameter("price"));
            image = request.getParameter("image");
            category = request.getParameter("category");
            description = request.getParameter("description");
            String updateSql = "UPDATE products SET name=?,price=?,image=?,category=?,description=? WHERE id=?";
            try (PreparedStatement stmt = conn.prepareStatement(updateSql)) {
                stmt.setString(1,name);
                stmt.setInt(2,price);
                stmt.setString(3,image);
                stmt.setString(4,category);
                stmt.setString(5,description);
                stmt.setInt(6,productId);
                int updated = stmt.executeUpdate();
                response.sendRedirect("admin_products.jsp?message="+java.net.URLEncoder.encode(
                    updated>0?"수정이 완료되었습니다.":"수정 실패","UTF-8"));
                return;
            }
        } else {
            String query = "SELECT * FROM products WHERE id=?";
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setInt(1,productId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        name = rs.getString("name");
                        price = rs.getInt("price");
                        image = rs.getString("image");
                        category = rs.getString("category");
                        description = rs.getString("description");
                    } else {
                        response.sendRedirect("admin_products.jsp?message=해당 제품을 찾을 수 없습니다.");
                        return;
                    }
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        message = "오류: "+e.getMessage();
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>제품 수정</title>
  <style>
    /* 페이지 전체 배경은 흰색으로 유지 */
    body {
      font-family: 'Noto Sans KR', sans-serif;
      background-color: #fff;
      margin: 0;
      padding: 0;
    }
    /* 헤더(include) 아래 본문 영역만 약한 회색 배경 */
    .container {
      width: 500px;
      margin: 50px auto;
      background: #f4f4f4; /* 본문 배경 */
      padding: 30px;
      border-radius: 12px;
      box-shadow: 0 4px 16px rgba(0,0,0,0.1);
    }
    h2 { text-align: center; color: #333; }
    label { display: block; margin: 15px 0 5px; font-weight: bold; }
    input, select, textarea {
      width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 6px; box-sizing: border-box;
      background: #fff; /* 입력 필드는 흰색 */
    }
    textarea { resize: vertical; }
    .btn-wrap { display: flex; justify-content: space-between; margin-top: 20px; }
    button {
      background-color: #007bff; color: #fff; border: none; padding: 10px 20px; border-radius: 6px;
      cursor: pointer;
    }
    button:hover { background-color: #0056b3; }
    ad { text-decoration: none; padding: 10px 20px; background: #6c757d; color: #fff; border-radius: 6px; }
    .message { text-align: center; color: red; margin-bottom: 15px; }
  </style>
</head>
<body>

<%@ include file="admin_header.jsp" %>

<div class="container">
  <h2>제품 수정</h2>
  <% if (!message.isEmpty()) { %><p class="message"><%= message %></p><% } %>
  <form method="post" action="admin_product_edit.jsp?id=<%=productId%>">
    <label>제품명:</label>
    <input type="text" name="name" value="<%=name%>" required>
    <label>가격:</label>
    <input type="number" name="price" value="<%=price%>" required>
    <label>이미지 경로:</label>
    <input type="text" name="image" value="<%=image%>" required>
    <label>카테고리:</label>
    <select name="category" required>
      <option value="hangwa" <%=category.equals("hangwa")?"selected":""%>>한과</option>
      <option value="nuts" <%=category.equals("nuts")?"selected":""%>>넛츠</option>
    </select>
    <label>설명:</label>
    <textarea name="description" rows="4"><%=description%></textarea>
    <div class="btn-wrap">
      <button type="submit">수정</button>
      <ad href="admin_products.jsp">취소</ad>
    </div>
  </form>
</div>

</body>
</html>
