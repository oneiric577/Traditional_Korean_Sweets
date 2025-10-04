<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>관리자 주문현황</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/index.css">
  <style>
    body { font-family: 'Noto Sans KR', sans-serif; background:#fff; margin:0; padding:0; }
    .container { width:90%; margin:40px auto; }
    h2 { text-align:center; margin-bottom:30px; font-size:26px; color:#333; }
    table { width:100%; border-collapse:collapse; }
    th, td { border:1px solid #ccc; padding:10px; text-align:center; }
    th { background:#f0f0f0; }
    tr:nth-child(even) { background:#fafafa; }

    .btn-status {
      padding:6px 12px; border:none; border-radius:4px; color:#fff;
      cursor:pointer; transition:opacity .2s;
    }
    .status-0 { background-color:#e53935 !important; }   /* 재고확인 = 빨강 */
    .status-1 { background-color:#ff9800 !important; }   /* 배송중 = 주황 */
    .status-2 { background-color:#4caf50 !important; }   /* 배송완료 = 초록 */
    .btn-status:hover { opacity:.8; }
  </style>
</head>
<body>

<%@ include file="admin_header.jsp" %>

<h2>관리자 모드 (주문현황)</h2>
<div class="container">
  <table>
    <tr>
      <th>번호</th><th>아이디</th><th>이름</th><th>휴대전화</th>
      <th>주문상품</th><th>주소</th><th>수량</th><th>주문일시</th><th>배송 상태</th>
    </tr>
    <%
      Class.forName("com.mysql.cj.jdbc.Driver");
      try (
        Connection conn = DriverManager.getConnection(
          "jdbc:mysql://localhost:3306/oneul?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul",
          "root","root");
        PreparedStatement stmt = conn.prepareStatement(
          "SELECT o.id, o.user_id, o.user_name, o.user_phonenumber, o.address,"
        + " p.name AS product_name, o.quantity, o.order_date, o.delivery_status "
        + "FROM orders o JOIN products p ON o.product_id=p.id ORDER BY o.order_date DESC"
        );
        ResultSet rs = stmt.executeQuery();
      ) {
        while (rs.next()) {
          int id = rs.getInt("id");
          int status = rs.getInt("delivery_status");
          String label = (status==0 ? "재고확인" : status==1 ? "배송중" : "배송완료");
    %>
    <tr>
      <td><%=id%></td>
      <td><%=rs.getString("user_id")%></td>
      <td><%=rs.getString("user_name")%></td>
      <td><%=rs.getString("user_phonenumber")%></td>
      <td><%=rs.getString("product_name")%></td>
      <td><%=rs.getString("address")%></td>
      <td><%=rs.getInt("quantity")%></td>
      <td><%=rs.getTimestamp("order_date")%></td>
      <td>
        <button 
          id="btn-<%=id%>" 
          class="btn-status status-<%=status%>" 
          data-id="<%=id%>" 
          data-status="<%=status%>"
          onclick="updateStatus(<%=id%>)">
          <%=label%>
        </button>
      </td>
    </tr>
    <%  }
      } catch(Exception e) { %>
    <tr><td colspan="9" style="color:red;">오류: <%=e.getMessage()%></td></tr>
    <% } %>
  </table>
</div>

<script>
  const ctx = '<%=request.getContextPath()%>';
  const texts = ["재고확인","배송중","배송완료"];
  function updateStatus(id) {
    const btn = document.getElementById('btn-' + id);
    const old = parseInt(btn.dataset.status,10);
    const next = (old + 1) % 3;
    fetch(ctx + '/update_status.jsp', {
      method: 'POST',
      headers: {'Content-Type':'application/x-www-form-urlencoded'},
      body: 'id='+id+'&status='+next
    })
    .then(r=>r.text())
    .then(text=>{
      if(text.trim().startsWith('OK')){
        btn.dataset.status = next;
        btn.textContent = texts[next];
        btn.classList.remove('status-'+old);
        btn.classList.add('status-'+next);
      } else {
        alert('업데이트 실패: '+text);
      }
    })
    .catch(err=>{
      console.error(err);
      alert('서버 통신 오류');
    });
  }
</script>

</body>
</html>
