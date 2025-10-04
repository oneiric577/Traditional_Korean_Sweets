<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String id = request.getParameter("id");

    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/oneul?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul",
            "root", "root"
        );

        String sql = "DELETE FROM notice WHERE id = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, id);

        stmt.executeUpdate();
        response.sendRedirect("admin_notice.jsp");
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
