<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*" %>
<%
    // 아이디 값 가져오기
    String user_id = request.getParameter("user_id");

    // 데이터베이스 연결 변수
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        // MySQL JDBC 드라이버 로드
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/oneul", "root", "root");

        // 중복된 아이디가 있는지 확인
        String checkSql = "SELECT COUNT(*) FROM users WHERE user_id = ?";
        stmt = conn.prepareStatement(checkSql);
        stmt.setString(1, user_id);
        rs = stmt.executeQuery();

        if (rs.next() && rs.getInt(1) > 0) {
            // 아이디가 중복된 경우
            out.print("exists");
        } else {
            // 아이디가 사용 가능할 경우
            out.print("available");
        }

    } catch (SQLException e) {
        e.printStackTrace();
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        // 자원 해제
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
