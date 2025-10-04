<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    String user_id = request.getParameter("user_id");
    String password = request.getParameter("password");
    String username = request.getParameter("username");
    String phone = request.getParameter("phone");
    String address = request.getParameter("address");  // 주소 입력 추가

    if (user_id == null || user_id.isEmpty() || password == null || password.isEmpty() ||
        username == null || username.isEmpty() || phone == null || phone.isEmpty() ||
        address == null || address.isEmpty()) {
        out.println("모든 필드를 작성해주세요.");
        return;
    }

    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/oneul", "root", "root");

        // 중복 확인
        String checkSql = "SELECT COUNT(*) FROM users WHERE user_id = ?";
        stmt = conn.prepareStatement(checkSql);
        stmt.setString(1, user_id);
        ResultSet rs = stmt.executeQuery();

        if (rs.next() && rs.getInt(1) > 0) {
            out.println("<script>");
            out.println("alert('아이디가 이미 존재합니다. 다른 아이디를 사용해 주세요.');");
            out.println("history.back();");
            out.println("</script>");
        } else {
            // 주소 포함한 INSERT 쿼리
            String sql = "INSERT INTO users (user_id, user_password, user_name, user_phonenumber, address) VALUES (?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, user_id);
            stmt.setString(2, password);
            stmt.setString(3, username);
            stmt.setString(4, phone);
            stmt.setString(5, address);

            int result = stmt.executeUpdate();

            if (result > 0) {
                out.println("<script>");
                out.println("alert('회원가입 성공. 축하드립니다!');");
                out.println("window.location.href='index.jsp';");
                out.println("</script>");
            } else {
                out.println("<script>");
                out.println("alert('회원가입 실패. 다시 시도해주세요.');");
                out.println("history.back();");
                out.println("</script>");
            }
            stmt.close();
        }
    } catch (SQLException e) {
        out.println("SQL 오류: " + e.getMessage());
        e.printStackTrace();
    } catch (Exception e) {
        out.println("일반 오류: " + e.getMessage());
        e.printStackTrace();
    } finally {
        try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
