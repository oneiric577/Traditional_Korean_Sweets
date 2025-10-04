<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    String userId = (String) session.getAttribute("user_id");
    if (userId == null) {
%>
    <script>
        alert("로그인이 필요합니다.");
        location.href = "login.jsp";
    </script>
<%
        return;
    }

    String productId = request.getParameter("product_id");
    String quantityStr = request.getParameter("quantity");
    String totalPriceStr = request.getParameter("total_price");
    String customerName = request.getParameter("customer_name");
    String address = request.getParameter("address");
    String phone = request.getParameter("phone");

    int quantity = 1;
    int totalPrice = 0;
    try {
        quantity = Integer.parseInt(quantityStr);
        totalPrice = Integer.parseInt(totalPriceStr);
    } catch (Exception e) {
        e.printStackTrace();
    }

    boolean success = false;

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/oneul?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul",
            "root", "root"
        );

        String sql = "INSERT INTO orders (user_id, product_id, quantity, user_name, user_phonenumber, address) VALUES (?, ?, ?, ?, ?, ?)";
        ps = conn.prepareStatement(sql);
        ps.setString(1, userId);
        ps.setInt(2, Integer.parseInt(productId));
        ps.setInt(3, quantity);
        ps.setString(4, customerName);
        ps.setString(5, phone);
        ps.setString(6, address);

        if (ps.executeUpdate() > 0) {
            success = true;
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }

    if (success) {
%>
    <script>
        alert("구매가 완료되었습니다.");
        location.href = "index.jsp";
    </script>
<%
    } else {
%>
    <script>
        alert("구매에 실패했습니다. 다시 시도해 주세요.");
        history.back();
    </script>
<%
    }
%>
