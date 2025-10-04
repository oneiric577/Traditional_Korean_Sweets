<!-- cart.jsp -->
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*, javax.servlet.http.*" %>
<%@ include file="header.jsp" %>
<%
    String msg = request.getParameter("message");
    if (msg != null) {
%>
    <p style="text-align:center; color:green;"><%= java.net.URLDecoder.decode(msg, "UTF-8") %></p>
<%
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>장바구니</title>
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; background-color: white; padding: 40px 20px; }
        table { width: 80%; margin: 0 auto; border-collapse: collapse; background: white; box-shadow: 0 0 10px rgba(139,90,43,0.3); }
        th, td { padding: 15px; text-align: center; border-bottom: 1px solid #d8bfa3; }
        th { background: #8B5A2B; color: #fff; }
        tr:hover { background-color: #fff0e0; }
        .total-price { width: 80%; margin: 20px auto 10px; text-align: right; font-size: 20px; font-weight: bold; color: #5a3916; }
        .checkout-btn { display: block; width: 80%; margin: 10px auto 30px; text-align: right; }
        .checkout-btn button { background-color: #b87333; border: none; color: white; padding: 10px 20px; font-size: 16px; border-radius: 5px; cursor: pointer; }
        .checkout-btn button:hover { background-color: #a0522d; }
        .select-all { margin: 20px auto; width: 80%; text-align: left; font-size: 14px; color: #5a3916; }
        input[type="checkbox"] { transform: scale(1.2); }
    </style>
</head>
<body>
<%
    String userId = (String) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect("login.jsp?message=로그인이 필요합니다.");
        return;
    }
    Integer userNumber = (Integer) session.getAttribute("user_number");
    if (userNumber == null) {
        Connection c0=null; PreparedStatement p0=null; ResultSet r0=null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            c0 = DriverManager.getConnection("jdbc:mysql://localhost:3306/oneul?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul","root","root");
            p0=c0.prepareStatement("SELECT user_number FROM users WHERE user_id=?");
            p0.setString(1,userId); r0=p0.executeQuery();
            if(r0.next()){ userNumber=r0.getInt("user_number"); session.setAttribute("user_number",userNumber);}
            else { response.sendRedirect("login.jsp?message=유효하지 않은 사용자입니다."); return; }
        } finally {
            if(r0!=null) try{r0.close();}catch(Exception ign){}
            if(p0!=null) try{p0.close();}catch(Exception ign){}
            if(c0!=null) try{c0.close();}catch(Exception ign){}
        }
    }
    Connection conn=null; PreparedStatement stmt=null; ResultSet rs=null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/oneul?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul","root","root");
        stmt=conn.prepareStatement(
            "SELECT p.name,p.price,c.quantity,c.product_id FROM cart c JOIN products p ON c.product_id=p.id WHERE c.user_number=?"
        );
        stmt.setInt(1,userNumber); rs=stmt.executeQuery();
%>
    <div class="select-all">
        <input type="checkbox" id="selectAll" onchange="toggleAll(this)"> 전체 선택
    </div>
    <form id="cartForm">
        <table>
            <thead>
                <tr>
                    <th>선택</th><th>상품명</th><th>가격</th><th>수량</th><th>합계</th><th>삭제</th>
                </tr>
            </thead>
            <tbody>
<%
        while(rs.next()){
            String name=rs.getString("name");
            int price=rs.getInt("price"), qty=rs.getInt("quantity"), pid=rs.getInt("product_id");
            int sub=price*qty;
%>
                <tr>
                    <td><input type="checkbox" class="product-checkbox" data-product-id="<%=pid%>" data-quantity="<%=qty%>" data-subtotal="<%=sub%>"></td>
                    <td><%=name%></td>
                    <td><%=price%>원</td>
                    <td><%=qty%></td>
                    <td><%=sub%>원</td>
                    <td>
                        <form action="cart_delete.jsp" method="post" style="margin:0;">
                            <input type="hidden" name="product_id" value="<%=pid%>">
                            <button type="submit">삭제</button>
                        </form>
                    </td>
                </tr>
<%
        }
%>
            </tbody>
        </table>
    </form>
    <div class="total-price">총 합계: <span id="totalPrice">0</span> 원</div>
    <div class="checkout-btn"><button type="button" onclick="submitCheckout()">구매하기</button></div>
<%
    } finally {
        if(rs!=null)try{rs.close();}catch(Exception ign){}
        if(stmt!=null)try{stmt.close();}catch(Exception ign){}
        if(conn!=null)try{conn.close();}catch(Exception ign){}
    }
%>
<script>
    function updateTotal(){
        let t=0;
        document.querySelectorAll('.product-checkbox').forEach(cb=>{ if(cb.checked) t+=parseInt(cb.dataset.subtotal); });
        document.getElementById('totalPrice').innerText=t.toLocaleString();
    }
    function toggleAll(src){
        document.querySelectorAll('.product-checkbox').forEach(cb=>cb.checked=src.checked);
        updateTotal();
    }
    document.querySelectorAll('.product-checkbox').forEach(cb=>cb.addEventListener('change',updateTotal));
    function submitCheckout(){
        const sel=document.querySelectorAll('.product-checkbox:checked');
        if(sel.length===0){ alert("구매할 상품을 선택해주세요."); return; }
        const f=document.createElement('form'); f.method='POST'; f.action='checkout.jsp';
        sel.forEach(cb=>{
            let i1=document.createElement('input'); i1.type='hidden'; i1.name='product_id'; i1.value=cb.dataset.productId; f.appendChild(i1);
            let i2=document.createElement('input'); i2.type='hidden'; i2.name='quantity'; i2.value=cb.dataset.quantity; f.appendChild(i2);
        });
        document.body.appendChild(f); f.submit();
    }
    window.onload=updateTotal;
</script>
</body>
</html>
