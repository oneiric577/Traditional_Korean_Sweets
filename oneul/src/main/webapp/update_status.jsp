<%@ page contentType="text/plain;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%-- update_status.jsp --%>
<%
    request.setCharacterEncoding("UTF-8");
    String id  = request.getParameter("id");
    String st  = request.getParameter("status");
    if (id == null || st == null) {
        out.print("ERR: missing");
        return;
    }
    int status;
    try {
        status = Integer.parseInt(st);
        if (status < 0 || status > 2) { out.print("ERR: invalid"); return; }
    } catch (Exception e) {
        out.print("ERR: parse");
        return;
    }
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        try (Connection c = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/oneul?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul",
                "root","root");
             PreparedStatement p = c.prepareStatement(
                 "UPDATE orders SET delivery_status=? WHERE id=?"
             )) {
            p.setInt(1, status);
            p.setInt(2, Integer.parseInt(id));
            int cnt = p.executeUpdate();
            out.print(cnt > 0 ? "OK" : "ERR:cnt" + cnt);
        }
    } catch (Exception e) {
        out.print("ERR:" + e.getMessage());
    }
%>
