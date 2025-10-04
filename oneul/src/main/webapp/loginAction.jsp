<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*" %>

<%
    request.setCharacterEncoding("UTF-8");

    String userId = request.getParameter("user_id");
    String userPassword = request.getParameter("user_password");

    if (userId == null || userPassword == null || userId.trim().isEmpty() || userPassword.trim().isEmpty()) {
        out.println("<script>alert('아이디와 비밀번호를 입력해주세요.'); location.href='login.jsp';</script>");
        return;
    }

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/oneul?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
        conn = DriverManager.getConnection(url, "root", "root");

        String sql = "SELECT user_name, role FROM users WHERE user_id = ? AND user_password = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, userId);
        stmt.setString(2, userPassword);
        rs = stmt.executeQuery();

        if (rs.next()) {
            String userName = rs.getString("user_name");
            String userRole = rs.getString("role");

            session.setAttribute("user_id", userId);
            session.setAttribute("user_name", userName);
            session.setAttribute("user_role", userRole); // 중요!!

            // 관리자일 경우 adminMain.jsp로 리다이렉트
            if ("admin".equals(userRole)) {
%>
                <script>
                    alert('관리자 로그인 성공!');
                    location.href = 'adminMain.jsp';
                </script>
<%
            } else {
%>
                <script>
                    alert('로그인 성공!');
                    location.href = 'index.jsp';
                </script>
<%
            }
        } else {
%>
            <script>
                alert('아이디 또는 비밀번호가 일치하지 않습니다.');
                location.href = 'login.jsp';
            </script>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('로그인 중 오류 발생'); location.href='login.jsp';</script>");
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (stmt != null) try { stmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>
