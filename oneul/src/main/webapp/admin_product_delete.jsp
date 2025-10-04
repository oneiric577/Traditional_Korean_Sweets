<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, java.util.*" %>

<%
    String[] productIds = request.getParameterValues("product_ids");

    if (productIds == null || productIds.length == 0) {
        response.sendRedirect("admin_products.jsp?message=" + java.net.URLEncoder.encode("삭제할 제품을 선택해주세요.", "UTF-8"));
        return;
    }

    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/oneul?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul",
            "root", "root"
        );

        // IN 절에 필요한 만큼 ? 를 동적으로 생성
        String placeholders = String.join(",", Collections.nCopies(productIds.length, "?"));
        String sql = "DELETE FROM products WHERE id IN (" + placeholders + ")";
        stmt = conn.prepareStatement(sql);

        // 각 제품 ID를 PreparedStatement에 설정
        for (int i = 0; i < productIds.length; i++) {
            stmt.setInt(i + 1, Integer.parseInt(productIds[i]));
        }

        int deleted = stmt.executeUpdate();

        String msg = deleted + "개의 제품이 삭제되었습니다.";
        response.sendRedirect("admin_products.jsp?message=" + java.net.URLEncoder.encode(msg, "UTF-8"));

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("admin_products.jsp?message=" + java.net.URLEncoder.encode("오류 발생: " + e.getMessage(), "UTF-8"));
    } finally {
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
