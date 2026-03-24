<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>

<script type ="text/javascript">
function LoginForm__submit(form) {
	let loginid = form.loginId.value.trim();
	let loginPw = form.loginPw.value.trim();
	
    form.loginId.value = form.loginId.value.trim();
    if (form.loginId.value.length == 0) {
        alert('아이디를 입력해주세요.');
        form.loginId.focus();
        return false;
    }
    
    form.loginPw.value = form.loginPw.value.trim();
    if (form.loginPw.value.length == 0) {
        alert('비밀번호를 입력해주세요.');
        form.loginPw.focus();
        return false;
    }

    return true;
}
</script>

<style>
table>thead>tr>th, table>tbody>tr>td {
	padding: 10px;
}
</style>

</head>
<body>
	<a href="../home/main">메인으로 이동</a>
	<h1>로그인</h1>

	<form action="doLogin" method="POST" onsubmit="return LoginForm__submit(this);">
	<div>
        	아이디 : <input name="loginId" type="text" placeholder="아이디 입력" autocomplete="off" />
    </div>
    <div>
      		비밀번호 :   <input name="loginPw" type="password" placeholder="비밀번호 입력" autocomplete="off" />
    </div>

    <div>
        <input type="submit" value="로그인" />
    </div>
	</form>
	
</body>
</html>

