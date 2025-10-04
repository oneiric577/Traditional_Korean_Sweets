<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, java.net.URLEncoder" %>
<%
    // 1) 로그인 체크
    String userId = (String) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect("login.jsp?message="
            + URLEncoder.encode("로그인이 필요합니다.", "UTF-8"));
        return;
    }

    // 2) users 테이블에서 user_number, user_name, user_phonenumber 조회
    Integer userNum = null;
    String  userName = null;
    String  userPhone = null;
    Class.forName("com.mysql.cj.jdbc.Driver");
    try (Connection c0 = DriverManager.getConnection(
             "jdbc:mysql://localhost:3306/oneul?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul",
             "root","root");
         PreparedStatement p0 = c0.prepareStatement(
             "SELECT user_number, user_name, user_phonenumber FROM users WHERE user_id = ?"
         )
    ) {
        p0.setString(1, userId);
        try (ResultSet r0 = p0.executeQuery()) {
            if (r0.next()) {
                userNum   = r0.getInt("user_number");
                userName  = r0.getString("user_name");
                userPhone = r0.getString("user_phonenumber");
                // 세션에 번호만 저장해 두면 충분합니다
                session.setAttribute("user_number", userNum);
            } else {
                response.sendRedirect("login.jsp?message="
                    + URLEncoder.encode("유효하지 않은 사용자입니다.", "UTF-8"));
                return;
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
        response.sendRedirect("experience.jsp?message="
            + URLEncoder.encode("사용자 조회 중 오류가 발생했습니다.", "UTF-8"));
        return;
    }

    // 3) 폼에서 넘어온 날짜들
    String[] dates = request.getParameterValues("dates");
    if (dates == null || dates.length == 0) {
        response.sendRedirect("experience.jsp?message="
            + URLEncoder.encode("날짜를 선택해주세요.", "UTF-8"));
        return;
    }

    // 4) 배치 삽입 (experience_requests 테이블에 phone_number 컬럼이 있어야 합니다)
    try (Connection conn = DriverManager.getConnection(
             "jdbc:mysql://localhost:3306/oneul?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul",
             "root","root");
         PreparedStatement pst = conn.prepareStatement(
             "INSERT INTO experience_requests "
           + "(user_number, user_name, phone_number, experience_date) "
           + "VALUES (?, ?, ?, ?)"
         )
    ) {
        for (String d : dates) {
            pst.setInt(1, userNum);      // user_number
            pst.setString(2, userName);  // user_name
            pst.setString(3, userPhone); // phone_number (테이블 컬럼명)
            pst.setString(4, d);         // experience_date
            pst.addBatch();
        }
        int[] results = pst.executeBatch();

        if (results.length > 0) {
            response.sendRedirect("experience.jsp?message="
                + URLEncoder.encode("신청이 완료되었습니다.", "UTF-8"));
        } else {
            response.sendRedirect("experience.jsp?message="
                + URLEncoder.encode("신청에 실패했습니다. 다시 시도해주세요.", "UTF-8"));
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("experience.jsp?message="
            + URLEncoder.encode("오류가 발생했습니다: " + e.getMessage(), "UTF-8"));
    }
%>
