<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>File Upload Ajax Page</title>

<style>
/* a {text-decoration: none;} */

.bigImageWrapper {
	position: absolute;
	display: none;
	justify-content: center;
	align-items: center;
	top:0%;
	width: 100%;
	height: 100%;
	background-color: lightgray;
	z-index: 100;
}
.bigImage {
	position: relative;
	display:flex;
	justify-content: center;
	align-items: center;
}
.bigImage img { height: 100%; max-width: 100%; width: auto; overflow: hidden }
</style>

</head>
<body>
<h1>Ajax를 이용한 파일 업로드 페이지</h1>
<div class="uploadDiv">
	<input  class="inputFile" type="file" name="uploadFiles" multiple="multiple" /><br>
	<input  class="inputFile" type="file" name="uploadFiles"  /><br>
</div>
<button id="btnFileUpload" type="button">File Upload With Ajax</button>


<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<script type="text/javascript">


//파일 업로드 제한 
function checkUploadfile(filename,fileSize){
	
	var maxSizeAllowed = 1048576;
	var regExpFileExtension=/(.*)\.(exe|sh|zip|alz)$/i;
	
	if(fileSize>= maxSizeAllowed ){
		alert("업로드 파일 크기 초과");
		return false;
	}
	
	if(regExpFileExtension.test(filename)){
		alert("exe|sh|zip|alz 형식 업로드 불가 ")
		return false;
	}
	
	return true;
}

//파일 업로드 처리 
$("#btnFileUpload").on("click",function(e){
		
	
	var formData = new FormData();
	var inputFiles = $("input[name='uploadFiles']"); // 배열 두개로 들어감 
	
	var myFiles = [];
	
	for(var i=0; i<inputFiles.length; i++){
		
		myFiles = inputFiles[i].files; 

		for(var j=0; j<myFiles.length; j++){
			if(!checkUploadfile(myFiles[i].name,myFiles.size)){
				return false;
			}
			formData.append("uploadFiles",myFiles[j]);
		}
		
	}//end-for i
	
	//formData보내주기 : form요소는 url을 통해 처리 후 , jsp페이지 호출에 의한 페이지 전환이 발생 , 
	//FormData는 페이지 전환없이 폼 데이터만을 제출하고 싶을 떄 form대신 사용됨 ! 
	
	$.ajax({
		type:"post",
		url:"${contextPath}/fileUploadAjaxAction",
		data:formData, // 
		processData:false, // contenttype의 설정으로 data를 처리하지 않음 
		contentType:false, //contentType에 mime타입을 지정하지 않음 
		dataType:"text",
		success:function(uploadResult){
			alert("upload success\n");
		}		
		
	});//end-ajax
	
})




</script>
</body>
</html>

