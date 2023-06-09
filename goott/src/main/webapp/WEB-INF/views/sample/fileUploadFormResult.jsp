<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>File Upload Form : Result Page</title>
</head>
<body>

<c:choose>
	<c:when test="${msg eq '에러'}">
		<h2>${ename }님,  업로드를 실패했습니다.</h2>
	</c:when>
	<c:otherwise>
			<h2>${ename }님, 업로드에 성공했습니다.</h2>
	
	</c:otherwise>

</c:choose>

		
		
</body>
</html>