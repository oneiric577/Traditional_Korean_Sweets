<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, java.io.*" %>

<%
    String message = "";

    try {
        if (session.getAttribute("user_id") == null) {
            message = "로그인이 필요합니다.";
            response.sendRedirect("login.jsp?message=" + java.net.URLEncoder.encode(message, "UTF-8"));
            return;
        }

        Integer userNumber = (Integer) session.getAttribute("user_number");
        if (userNumber == null) {
            message = "유효하지 않은 사용자입니다.";
            response.sendRedirect("login.jsp?message=" + java.net.URLEncoder.encode(message, "UTF-8"));
            return;
        }

        String productIdParam = request.getParameter("product_id");
        int productId;
        try {
            productId = Integer.parseInt(productIdParam);
        } catch (Exception e) {
            message = "잘못된 요청입니다.";
            response.sendRedirect("cart.jsp?message=" + java.net.URLEncoder.encode(message, "UTF-8"));
            return;
        }

        Class.forName("com.mysql.cj.jdbc.Driver");
        try (Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/oneul?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul",
                "root", "root");
             PreparedStatement stmt = conn.prepareStatement(
                     "DELETE FROM cart WHERE user_number = ? AND product_id = ?")) {

            stmt.setInt(1, userNumber);
            stmt.setInt(2, productId);
            int deleted = stmt.executeUpdate();

            if (deleted > 0) {
                message = "삭제가 완료되었습니다.";
            } else {
                message = "삭제할 항목이 없습니다.";
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        message = "오류가 발생했습니다.";
    }

    // 🔥 이 아래에는 아무 코드도 두지 말고, 끝내야 해!
    response.sendRedirect("cart.jsp?message=" + java.net.URLEncoder.encode(message, "UTF-8"));
%>
