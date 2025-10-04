<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page session="true" %>

<style>
    body {
        background-color: white;
        color: black;
        margin: 0;
        font-family: 'Pretendard', sans-serif;
    }

    .admin-navbar {
        background-color: white;
        padding: 20px 60px;
        border-bottom: 1px solid #ddd;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .admin-navbar .logo img {
        height: 40px;
    }

    .admin-navbar .nav-menu a {
        color: #333;
        text-decoration: none;
        margin: 0 15px;
        font-weight: bold;
        font-size: 16px;
    }

    .admin-navbar .nav-menu a:hover {
        color: #f39c12;
    }

    .admin-navbar .login-info {
        font-size: 14px;
    }

    .admin-content {
        margin: 50px auto;
        width: 70%;
        text-align: center;
        border: 2px solid black;
        border-radius: 20px;
        padding: 80px 0;
        font-size: 28px;
        font-weight: bold;
    }
</style>

<div class="admin-navbar">
    <div class="logo">
        <a href="adminMain.jsp">
            <img src="./images/logo.png" alt="오늘, 한과">
        </a>
    </div>

    <div class="nav-menu">
        <a href="admin_products.jsp">제품관리</a>
        <a href="admin_users.jsp">회원관리</a>
        <a href="admin_experience.jsp">체험관리</a>
        <a href="admin_orders.jsp">주문현황</a>
        <a href="admin_notice.jsp">공지사항</a>
    </div>

    <div class="login-info">
        <!-- userName은 부모 페이지에서 받아옴 -->
        <%= session.getAttribute("user_name") %>님 | <a href="logout.jsp">로그아웃</a>
    </div>
</div>
