<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>

<script type ="text/javascript">
function JoinForm__submit(form) {
	let loginid = form.loginId.value.trim();
	let loginPw = form.loginPw.value.trim();
	let loginPwConfirm = form.loginPwConfirm.value.trim();
	let name = form.name.value.trim();
	
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

    if (form.loginPw.value !== form.loginPwConfirm.value) {
        alert('비밀번호가 일치하지 않습니다.');
        form.loginPwConfirm.focus();
        return false;
    }
    
    form.name.value = form.name.value.trim();
    if (form.name.value.length == 0) {
        alert('이름을 입력해주세요.');
        form.name.focus();
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
	<h1>회원가입</h1>

	<form action="doJoin" method="POST" onsubmit="return JoinForm__submit(this);">
	<div>
        <input name="loginId" type="text" placeholder="아이디 입력" autocomplete="off" />
    </div>
    <div>
        <input name="loginPw" type="password" placeholder="비밀번호 입력" />
    </div>
    <div>
        <input name="loginPwConfirm" type="password" placeholder="비밀번호 확인" />
    </div>
    <div>	
        <input name="name" type="text" placeholder="이름 입력" autocomplete="off" />
    </div>
    <div>
        <input type="submit" value="회원가입" />
    </div>
	</form>
	
</body>
</html>

