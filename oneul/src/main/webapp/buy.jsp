<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
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
    String qtyParam = request.getParameter("quantity");
    int quantity = 1;
    try {
        quantity = Integer.parseInt(qtyParam);
    } catch (Exception e) {
        quantity = 1;
    }

    boolean success = false;

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/oneul?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul",
            "root", "root"
        );

        // 사용자 정보 조회
        String userName = "", phone = "", address = "";
        String userSql = "SELECT user_name, user_phonenumber, address FROM users WHERE user_id = ?";
        ps = conn.prepareStatement(userSql);
        ps.setString(1, userId);
        rs = ps.executeQuery();

        if (rs.next()) {
            userName = rs.getString("user_name");
            phone = rs.getString("user_phonenumber");
            address = rs.getString("address");
        }

        // 주문 정보 삽입
        String orderSql = "INSERT INTO orders (user_id, product_id, quantity, user_name, user_phonenumber, address) VALUES (?, ?, ?, ?, ?, ?)";
        ps = conn.prepareStatement(orderSql);
        ps.setString(1, userId);
        ps.setInt(2, Integer.parseInt(productId));
        ps.setInt(3, quantity);
        ps.setString(4, userName);
        ps.setString(5, phone);
        ps.setString(6, address);

        if (ps.executeUpdate() > 0) {
            success = true;
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
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
