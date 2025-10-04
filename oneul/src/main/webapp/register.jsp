<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
    <link rel="stylesheet" href="./css/index.css">
    <link rel="stylesheet" href="./css/login-register.css">
    <script>
        function checkDuplicateUsername() {
            var username = document.getElementById("user_id").value;
            if (username != "") {
                var xhr = new XMLHttpRequest();
                xhr.open("GET", "checkUsername.jsp?user_id=" + username, true);
                xhr.onreadystatechange = function () {
                    if (xhr.readyState == 4 && xhr.status == 200) {
                        var response = xhr.responseText.trim();
                        var resultMessage = document.getElementById("usernameMessage");
                        if (response == "exists") {
                            resultMessage.textContent = "이미 사용 중인 아이디입니다.";
                            resultMessage.style.color = "red";
                        } else if (response == "available") {
                            resultMessage.textContent = "사용 가능한 아이디입니다.";
                            resultMessage.style.color = "green";
                        }
                    }
                };
                xhr.send();
            }
        }
    </script>
</head>
<body>
<%@ include file="header.jsp" %>
<div class="form-page">
    <div class="form-container">
        <h2>회원가입</h2>
        <form action="registerAction.jsp" method="post">
            <div class="input-group">
                <label for="user_id">아이디</label>
                <div style="display: flex; gap: 10px;">
                    <input type="text" id="user_id" name="user_id" required>
                    <button type="button" class="btn small" onclick="checkDuplicateUsername()">중복확인</button>
                </div>
                <div id="usernameMessage" class="message"></div>
            </div>

            <div class="input-group">
                <label for="password">비밀번호</label>
                <input type="password" id="password" name="password" required>
            </div>

            <div class="input-group">
                <label for="username">이름</label>
                <input type="text" id="username" name="username" required>
            </div>

            <div class="input-group">
                <label for="phone">전화번호</label>
                <input type="text" id="phone" name="phone" required>
            </div>

            <!-- 주소 입력 필드 추가 -->
            <div class="input-group">
                <label for="address">주소</label>
                <input type="text" id="address" name="address" required>
            </div>

            <div class="button-group">
                <button type="submit" class="btn login-btn">회원가입</button>
                <a href="login.jsp" class="btn cancel-btn">로그인</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>
