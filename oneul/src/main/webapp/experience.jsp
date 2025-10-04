<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>

<%
    String message = request.getParameter("message");

    Calendar cal = Calendar.getInstance();
    int year  = request.getParameter("year") != null
                ? Integer.parseInt(request.getParameter("year"))
                : cal.get(Calendar.YEAR);
    int month = request.getParameter("month") != null
                ? Integer.parseInt(request.getParameter("month")) - 1
                : cal.get(Calendar.MONTH);

    cal.set(year, month, 1);
    int startDay = cal.get(Calendar.DAY_OF_WEEK);
    int endDate  = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
    String[] days = {"일", "월", "화", "수", "목", "금", "토"};
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>체험신청</title>
  <link rel="stylesheet" href="./css/index.css">
  <style>
    .calendar-container {
      width: 90%;
      margin: 40px auto;
      text-align: center;
    }

    h2 {
      font-size: 28px;
      margin-bottom: 15px;
    }

    .message {
      text-align: center;
      color: #27ae60;
      margin-bottom: 20px;
      font-weight: bold;
    }

    .month-nav {
      display: flex;
      justify-content: center;
      align-items: center;
      font-size: 20px;
      margin-bottom: 20px;
    }

    .month-nav a {
      text-decoration: none;
      font-weight: bold;
      color: #333;
      margin: 0 20px;
    }

    .month-nav a:hover {
      color: #2980b9;
    }

    table.calendar {
      width: 100%;
      border-collapse: collapse;
      background-color: #fafafa;
    }

    table.calendar th,
    table.calendar td {
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

    table.calendar td.gray {
      background-color: #f0f0f0;
    }

    .date-number {
      font-weight: bold;
      display: block;
      margin-bottom: 5px;
    }

    table.calendar input[type=checkbox] {
      position: absolute;
      bottom: 6px;
      right: 6px;
      transform: scale(1.2);
    }

    .today {
      background-color: #ffeaa7 !important;
    }

    .submit-wrap {
      text-align: right;
      margin-top: 20px;
    }

    .submit-wrap button {
      padding: 10px 20px;
      font-size: 16px;
      background: #8B5A2B;
      color: #fff;
      border: none;
      border-radius: 4px;
      cursor: pointer;
    }

    .submit-wrap button:hover {
      background: #a16f3a;
    }
  </style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="calendar-container">
  <h2>체험신청</h2>
  <% if (message != null) { %>
    <div class="message"><%= message %></div>
  <% } %>

  <form method="post" action="experience_submit.jsp">
    <div class="month-nav">
      <a href="?year=<%= month == 0 ? year - 1 : year %>&month=<%= month == 0 ? 12 : month %>">&lt; 이전</a>
      <span><%= year %>년 <%= month + 1 %>월</span>
      <a href="?year=<%= month == 11 ? year + 1 : year %>&month=<%= month == 11 ? 1 : month + 2 %>">다음 &gt;</a>
    </div>

    <table class="calendar">
      <tr>
        <% for (String d : days) { %>
          <th><%= d %></th>
        <% } %>
      </tr>

      <%
        int day = 1, cell = 1;
        Calendar today = Calendar.getInstance();

        while (day <= endDate) {
      %>
        <tr>
        <% for (int i = 1; i <= 7; i++) {
             if (cell < startDay || day > endDate) {
        %>
          <td class="gray"></td>
        <%
             } else {
               cal.set(Calendar.DAY_OF_MONTH, day);
               String val = String.format("%04d-%02d-%02d", year, month + 1, day);
               boolean isToday =
                   cal.get(Calendar.YEAR) == today.get(Calendar.YEAR) &&
                   cal.get(Calendar.MONTH) == today.get(Calendar.MONTH) &&
                   cal.get(Calendar.DAY_OF_MONTH) == today.get(Calendar.DAY_OF_MONTH);
        %>
          <td <%= isToday ? "class='today'" : "" %>>
            <label>
              <span class="date-number"><%= day %></span>
              <input type="checkbox" name="dates" value="<%= val %>">
            </label>
          </td>
        <%
               day++;
             }
             cell++;
           }
        %>
        </tr>
      <% } %>
    </table>

    <div class="submit-wrap">
      <button type="submit">신청하기</button>
    </div>
  </form>
</div>

</body>
</html>
