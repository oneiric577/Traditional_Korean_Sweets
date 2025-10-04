<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항 등록</title>
    <link rel="stylesheet" href="./css/index.css"> <!-- adminMain 스타일 유지 -->
    <style>
        body {
            background-color: white;
            color: #333;
        }

        .admin-content {
            margin: 50px auto;
            width: 70%;
            padding: 40px;
            border: 2px solid black;
            border-radius: 20px;
            text-align: center;
            background-color: white;
        }

        .admin-title {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 30px;
        }

        .notice-form {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .notice-form input[type="text"],
        .notice-form textarea {
            width: 80%;
            padding: 10px;
            margin-bottom: 20px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        .notice-form input[type="submit"] {
            padding: 10px 20px;
            font-size: 16px;
            border: none;
            background-color: black;
            color: white;
            border-radius: 5px;
            cursor: pointer;
        }

        .notice-form input[type="submit"]:hover {
            background-color: #444;
        }
    </style>
</head>
<body>

    <%@ include file="admin_header.jsp" %>

    <div class="admin-content">
        <h2 class="admin-title">공지사항 등록</h2>
        <form class="notice-form" action="notice_add_action.jsp" method="post">
            <input type="text" name="title" placeholder="제목을 입력하세요" required>

            <textarea name="content" rows="10" placeholder="내용을 입력하세요" required></textarea>

            <input type="submit" value="등록">
        </form>
    </div>

</body>
</html>
