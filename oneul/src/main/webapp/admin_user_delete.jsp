<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    request.setCharacterEncoding("UTF-8");
    String[] userNumbers = request.getParameterValues("user_number");

    if (userNumbers != null && userNumbers.length > 0) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/oneul?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul",
                    "root", "root")) {

                String sql = "DELETE FROM users WHERE user_number = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    for (String num : userNumbers) {
                        stmt.setInt(1, Integer.parseInt(num));
                        stmt.executeUpdate();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    response.sendRedirect("admin_users.jsp?message=" + java.net.URLEncoder.encode("삭제 완료", "UTF-8"));
%>
