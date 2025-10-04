<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*" %>

<%
    // 로그인 여부 체크
    if (session.getAttribute("user_id") == null) {
        // 로그인되지 않은 경우, 알림을 띄우고 로그인 페이지로 리다이렉트
        response.sendRedirect("login.jsp?message=로그인이 필요합니다.");
        return;
    }

    String productId = request.getParameter("product_id");
    String quantity = request.getParameter("quantity");

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/oneul", "root", "root");

        String sql = "SELECT * FROM products WHERE id = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, Integer.parseInt(productId));
        rs = stmt.executeQuery();

        if (rs.next()) {
            // 장바구니에 추가하는 로직
            int userNumber = (int) session.getAttribute("user_number");
            int quantityInt = Integer.parseInt(quantity);

            String checkSql = "SELECT quantity FROM cart WHERE user_number = ? AND product_id = ?";
            stmt = conn.prepareStatement(checkSql);
            stmt.setInt(1, userNumber);
            stmt.setInt(2, Integer.parseInt(productId));
            rs = stmt.executeQuery();

            if (rs.next()) {
                // 이미 장바구니에 있으면 수량을 더함
                int existingQty = rs.getInt("quantity");
                String updateSql = "UPDATE cart SET quantity = ? WHERE user_number = ? AND product_id = ?";
                stmt = conn.prepareStatement(updateSql);
                stmt.setInt(1, existingQty + quantityInt);
                stmt.setInt(2, userNumber);
                stmt.setInt(3, Integer.parseInt(productId));
                stmt.executeUpdate();
            } else {
                // 장바구니에 없으면 새로 추가
                String insertSql = "INSERT INTO cart (user_number, product_id, quantity) VALUES (?, ?, ?)";
                stmt = conn.prepareStatement(insertSql);
                stmt.setInt(1, userNumber);
                stmt.setInt(2, Integer.parseInt(productId));
                stmt.setInt(3, quantityInt);
                stmt.executeUpdate();
            }

            // 장바구니 페이지로 리다이렉트
            response.sendRedirect("cart.jsp");

        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (stmt != null) try { stmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>
