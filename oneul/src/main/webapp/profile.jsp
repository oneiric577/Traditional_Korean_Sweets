<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*" %>

<%
    String userId = (String) session.getAttribute("user_id");

    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/oneul?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul";
        conn = DriverManager.getConnection(url, "root", "root");

        String sql = "SELECT user_name, user_phonenumber, address FROM users WHERE user_id = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, userId);
        rs = stmt.executeQuery();

        if (rs.next()) {
            // 현재 데이터를 가져오긴 하지만, value로 세팅하진 않음 (placeholder만 사용)
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원정보 수정</title>
    <link rel="stylesheet" href="./css/index.css">
    <link rel="stylesheet" href="./css/login-register.css">
</head>
<body>
    <div class="form-page">
        <div class="form-container">
            <h2>회원정보 수정</h2>
            <form action="editProfile.jsp" method="post" accept-charset="UTF-8">
                <div class="input-group">
                    <label for="newName">이름</label>
                    <input type="text" id="newName" name="newName" placeholder="이름 입력" required>
                </div>
                <div class="input-group">
                    <label for="newPhone">전화번호</label>
                    <input type="text" id="newPhone" name="newPhone" placeholder="전화번호 입력" required>
                </div>
                <div class="input-group">
                    <label for="newAddress">주소</label>
                    <input type="text" id="newAddress" name="newAddress" placeholder="주소 입력" required>
                </div>
                <div class="input-group">
                    <label for="newPassword">새 비밀번호</label>
                    <input type="password" id="newPassword" name="newPassword" placeholder="새 비밀번호 입력" required>
                </div>
                <div class="button-group">
                    <button type="submit" class="btn login-btn">변경하기</button>
                    <a href="index.jsp" class="btn cancel-btn">취소</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
