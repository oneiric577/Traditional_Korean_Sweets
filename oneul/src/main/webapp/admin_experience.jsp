<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat" %>
<%@ include file="admin_header.jsp" %>

<%
    // 현재 월 처리
    int currentYear = Calendar.getInstance().get(Calendar.YEAR);
    int currentMonth = Calendar.getInstance().get(Calendar.MONTH); // 0-based

    String yearParam = request.getParameter("year");
    String monthParam = request.getParameter("month");

    if (yearParam != null && monthParam != null) {
        try {
            currentYear = Integer.parseInt(yearParam);
            currentMonth = Integer.parseInt(monthParam);
        } catch (Exception e) { /* 무시 */ }
    }

    // DB에서 해당 월의 체험 기록 가져오기
    Map<String, List<String>> calendarData = new HashMap<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/oneul?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul",
            "root", "root"
        );

        PreparedStatement pst = conn.prepareStatement(
            "SELECT user_name, phone_number, experience_date FROM experience_requests WHERE YEAR(experience_date) = ? AND MONTH(experience_date) = ?"
        );
        pst.setInt(1, currentYear);
        pst.setInt(2, currentMonth + 1); // MONTH는 1-based

        ResultSet rs = pst.executeQuery();
        while (rs.next()) {
            String name = rs.getString("user_name");
            String phone = rs.getString("phone_number");
            java.sql.Date date = rs.getDate("experience_date");

            String key = new SimpleDateFormat("yyyy-MM-dd").format(date);
            String info = name + " (" + phone + ")";

            if (!calendarData.containsKey(key)) {
                calendarData.put(key, new ArrayList<>());
            }
            calendarData.get(key).add(info);
        }

        rs.close();
        pst.close();
        conn.close();
    } catch (Exception e) {
        out.println("<p style='color:red;'>DB 오류: " + e.getMessage() + "</p>");
    }

    // 달력 생성
    Calendar cal = Calendar.getInstance();
    cal.set(currentYear, currentMonth, 1);
    int startDayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
    int lastDate = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
%>

<style>
    .calendar-container {
        width: 90%;
        margin: 40px auto;
        text-align: center;
    }

    .calendar-header {
        display: flex;
        justify-content: center;
        align-items: center;
        font-size: 24px;
        margin-bottom: 20px;
    }

    .calendar-header a {
        margin: 0 20px;
        text-decoration: none;
        font-weight: bold;
        color: #333;
    }

    table.calendar {
        width: 100%;
        border-collapse: collapse;
        background-color: #fafafa;
    }

    table.calendar th, table.calendar td {
        border: 1px solid #ccc;
        width: 14.28%;
        height: 120px;
        vertical-align: top;
        padding: 8px;
        font-size: 14px;
        position: relative;
    }

    table.calendar th {
        background-color: #f9f9f9;
    }

    .date-number {
        font-weight: bold;
        margin-bottom: 4px;
        display: block;
    }

    .entry {
        font-size: 13px;
        margin-top: 4px;
        color: #333;
    }

    .today {
        background-color: #ffeaa7;
    }
</style>
<h2 style="text-align:center;">관리자 모드(체험현황)</h2>
<div class="calendar-container">
    <div class="calendar-header">
        <a href="admin_experience.jsp?year=<%= currentYear %>&month=<%= currentMonth - 1 %>">&#8592;</a>
        <span><%= currentYear %>년 <%= (currentMonth + 1) %>월 체험 현황</span>
        <a href="admin_experience.jsp?year=<%= currentYear %>&month=<%= currentMonth + 1 %>">&#8594;</a>
    </div>

    <table class="calendar">
        <tr>
            <th>일</th>
            <th>월</th>
            <th>화</th>
            <th>수</th>
            <th>목</th>
            <th>금</th>
            <th>토</th>
        </tr>
        <tr>
<%
    int dayOfWeekIndex = 1;
    for (int i = 1; i < startDayOfWeek; i++) {
        out.print("<td></td>");
        dayOfWeekIndex++;
    }

    for (int date = 1; date <= lastDate; date++) {
        cal.set(Calendar.DAY_OF_MONTH, date);
        String key = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());

        boolean isToday = (cal.get(Calendar.YEAR) == Calendar.getInstance().get(Calendar.YEAR))
                       && (cal.get(Calendar.MONTH) == Calendar.getInstance().get(Calendar.MONTH))
                       && (cal.get(Calendar.DAY_OF_MONTH) == Calendar.getInstance().get(Calendar.DAY_OF_MONTH));

        out.print("<td" + (isToday ? " class='today'" : "") + ">");
        out.print("<span class='date-number'>" + date + "</span>");

        if (calendarData.containsKey(key)) {
            for (String entry : calendarData.get(key)) {
                out.print("<div class='entry'>" + entry + "</div>");
            }
        }

        out.print("</td>");

        if (dayOfWeekIndex % 7 == 0) out.print("</tr><tr>");
        dayOfWeekIndex++;
    }

    while ((dayOfWeekIndex - 1) % 7 != 0) {
        out.print("<td></td>");
        dayOfWeekIndex++;
    }
%>
        </tr>
    </table>
</div>
