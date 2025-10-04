<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    String title = request.getParameter("title");
    String content = request.getParameter("content");

    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/oneul?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul",
            "root", "root"
        );

        String sql = "INSERT INTO notice (title, content) VALUES (?, ?)";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, title);
        stmt.setString(2, content);

        int result = stmt.executeUpdate();
        if (result > 0) {
            response.sendRedirect("admin_notice.jsp");
        } else {
            out.println("등록 실패");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
