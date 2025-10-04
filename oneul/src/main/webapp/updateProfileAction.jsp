<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*" %>

<%
    // 세션에서 user_id 가져오기
    String userId = (String) session.getAttribute("user_id");
    
    if (userId == null) {
        // 로그인되지 않은 사용자라면 로그인 페이지로 리다이렉트
        response.sendRedirect("login.jsp");
        return;
    }

    // 요청 파라미터에서 수정된 정보 가져오기
    String newUsername = request.getParameter("username");
    String newPhone = request.getParameter("phone");
    String newPassword = request.getParameter("password");

    Connection conn = null;
    PreparedStatement stmt = null;
    int result = 0;

    try {
        // MySQL JDBC 드라이버 로드
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/oneul", "root", "root");

        // 비밀번호가 비어있지 않다면 비밀번호도 함께 업데이트
        String sql;
        if (newPassword != null && !newPassword.trim().isEmpty()) {
            // 비밀번호가 입력되었다면 비밀번호를 업데이트하는 SQL 쿼리
            sql = "UPDATE users SET user_name = ?, user_phonenumber = ?, user_password = ? WHERE user_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, newUsername);
            stmt.setString(2, newPhone);
            stmt.setString(3, newPassword);
            stmt.setString(4, userId);
        } else {
            // 비밀번호 변경이 없다면 비밀번호를 제외한 정보만 업데이트
            sql = "UPDATE users SET user_name = ?, user_phonenumber = ? WHERE user_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, newUsername);
            stmt.setString(2, newPhone);
            stmt.setString(3, userId);
        }

        result = stmt.executeUpdate();  // 쿼리 실행

        if (result > 0) {
            // 변경 완료 후 알림 메시지와 함께 index.jsp로 리다이렉트
            out.println("<script>alert('변경이 완료되었습니다!'); window.location='index.jsp';</script>");
        } else {
            // 수정이 실패하면 다시 프로필 수정 페이지로 돌아가도록 리다이렉트
            out.println("<script>alert('정보 수정에 실패했습니다.'); window.location='profile.jsp';</script>");
        }

    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('오류가 발생했습니다.'); window.location='profile.jsp';</script>");
    } finally {
        // 자원 해제
        try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
