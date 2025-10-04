<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
    <link rel="stylesheet" href="./css/index.css">
    <link rel="stylesheet" href="./css/login-register.css">
</head>
<body>
    <%@ include file="header.jsp" %>

    <div class="form-page">
        <div class="form-container">
            <h2>로그인</h2>

            <%
                // 로그인 필요 알림 메시지 출력
                String message = request.getParameter("message");
                if (message != null) {
                    out.println("<p style='color: red;'>" + message + "</p>");
                }
            %>

            <form action="loginAction.jsp" method="post">
                <div class="input-group">
                    <label for="user_id">아이디</label>
                    <input type="text" id="user_id" name="user_id" required>
                </div>
                <div class="input-group">
                    <label for="user_password">비밀번호</label>
                    <input type="password" id="user_password" name="user_password" required>
                </div>
                <div class="button-group">
                    <button type="submit" class="btn login-btn">로그인</button>
                    <a href="register.jsp" class="btn cancel-btn">회원가입</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
