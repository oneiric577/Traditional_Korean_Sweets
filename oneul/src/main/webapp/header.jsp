<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="javax.servlet.http.*" %>

<!-- ✅ 넓고 여유 있게 조정된 헤더 스타일 -->
<style>
    .site-header {
        background-color: #8B5A2B;
        color: white;
        padding: 20px 60px;
        font-family: '맑은 고딕', sans-serif;
    }
    .header-container {
        max-width: 1200px;
        margin: 0 auto;
    }
    .user-menu {
        display: flex;
        justify-content: flex-end;
        margin-bottom: 15px;
        font-size: 15px;
    }
    .user-menu a {
        color: white;
        margin-left: 20px;
        text-decoration: none;
    }
    .user-menu span {
        font-weight: bold;
    }
    .navbar-menu {
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 60px;
        padding: 10px 0;
    }
    .navbar-menu a {
        color: white;
        text-decoration: none;
        font-weight: bold;
        font-size: 17px;
        transition: color 0.3s;
    }
    .navbar-menu a:hover {
        color: #ffdd99;
    }
    .navbar-menu img {
        background-color: white;
        padding: 5px 10px;
        border-radius: 5px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.2);
    }
</style>

<header class="site-header">
    <div class="header-container">

        <!-- 로그인 사용자 메뉴 -->
        <div class="user-menu">
            <% if (session.getAttribute("user_id") != null) { %>
                <a href="profile.jsp">
                    <span><%= session.getAttribute("user_name") %>님</span>
                </a>
                <a href="logout.jsp">로그아웃</a>
                <a href="cart.jsp">장바구니</a>
            <% } else { %>
                <a href="login.jsp">로그인</a>
                <a href="register.jsp">회원가입</a>
            <% } %>
        </div>

        <!-- 중앙 내비게이션 -->
        <nav class="navbar-menu">
            <a href="hangwa.jsp">한과</a>
            <a href="nuts.jsp">넛츠</a>
            <a href="index.jsp">
                <img src="./images/logo.png" alt="오늘, 한과" width="150" height="40">
            </a>
            <a href="experience.jsp">체험신청</a>
            <a href="notice.jsp">공지사항</a>
        </nav>

    </div>
</header>
