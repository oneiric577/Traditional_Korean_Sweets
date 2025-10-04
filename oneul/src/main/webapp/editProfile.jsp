<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*" %>

<%
    request.setCharacterEncoding("UTF-8");

    String userId = (String) session.getAttribute("user_id");
    String newName = request.getParameter("newName");
    String newPhone = request.getParameter("newPhone");
    String newPassword = request.getParameter("newPassword");
    String newAddress = request.getParameter("newAddress");

    if (userId == null || newName == null || newPhone == null || newPassword == null || newAddress == null) {
        out.println("<script>alert('모든 정보를 입력해주세요.'); history.back();</script>");
        return;
    }

    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/oneul?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
        conn = DriverManager.getConnection(url, "root", "root");

        String sql = "UPDATE users SET user_password = ?, user_name = ?, user_phonenumber = ?, address = ? WHERE user_id = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, newPassword);
        stmt.setString(2, newName);
        stmt.setString(3, newPhone);
        stmt.setString(4, newAddress);
        stmt.setString(5, userId);

        int result = stmt.executeUpdate();

        if (result > 0) {
            out.println("<script>");
            out.println("alert('회원 정보가 수정되었습니다.');");
            out.println("location.href='index.jsp';");
            out.println("</script>");
        } else {
            out.println("<script>alert('수정 실패. 다시 시도해주세요.'); history.back();</script>");
        }

    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('오류 발생: " + e.getMessage() + "'); history.back();</script>");
    } finally {
        try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
