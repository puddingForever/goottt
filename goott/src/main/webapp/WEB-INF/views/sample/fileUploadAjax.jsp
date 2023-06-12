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
<div class="fileUploadResult">
 <ul>
 <%-- 업로드 후 처리결과가 표시될 영역 --%>
 </ul>
</div>


<div class='bigImageWrapper'>
	<div class='bigImage'>
	<!-- 이미지파일이 표시되는 DIV -->
	</div>
</div>


<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<script type="text/javascript">





function checkUploadFile(fileName,fileSize){
	
	var maxAllowedSize = 10485760;
	var regExpFileExtension = /(.*)\.(exe|sh|zip|alz|dll|c)$/i ;
	
	//최대 허용 크기 제한 검사 
	if(fileSize > maxAllowedSize){
		alert("업로드 파일의 크기는 1MB를 넘을 수 없습니다. ");
		return false;
	}
	
	//업로드파일의 확장자 검사
	if(regExpFileExtension.test(fileName)){
		alert("해당 종류(exe, sh, zip, alz, dll, c)에 파일은 업로드 할 수 없습니다.")
		return false;
	}
	
	return true;
}


//input 초기화를 위해 div 요소의 비어있는 input 요소를 복사해서 저장함 
var cloneFileInput = $(".uploadDiv").clone(); //uploadDiv의 자식을 복사함 
//console.log("cloneFileInput: \n" +  cloneFileInput.html());

//업로드 결과 표시 함수 
function showUploadResult(uploadResult){
	
	//객체가 없으면 (업로드할 파일이 없으면)
	if(!uploadResult || uploadResult.length == 0){
		return ;
	}
	
	
	var fileUploadResult = $(".fileUploadResult ul");
	var str = "";
	
	$(uploadResult).each(function(i,obj){ //index, 자바스크립트 객체 
	
		var fullFileName = encodeURI(obj.repoPath + "/" + obj.uploadPath
				           +"/" + obj.uuid + "_" + obj.fileName);
		
		if(obj.fileType == "F"){
			
													
			str  += "<li>"
				 +  "  <a href='${contextPath}/filedownloadAjax?fileName="+fullFileName+"'>"  
				 + "        <img src='${contextPath}/resources/img/attach.png'"
				 + " 		alt='No Icon' style='height: 18px; width: 18px;'>" + obj.fileName
				 + "   </a>"
				 + " </li>";	 
		}else if(obj.fileType == "I"){ // 이미지파일일떄 
			
			var thumbnailFileName = encodeURI(obj.repoPath + "/" + obj.uploadPath
									+"/s_" + obj.uuid + "_" + obj.fileName);
		
	     // console.log("thumbnailFileName" + thumbnailFileName);
			
			str += "<li>"
	//			 +  "  <a href='${contextPath}/filedownloadAjax?fileName="+fullFileName+"'>"  
				 +  "  <a href=\"javascript:showImage('"+fullFileName+"')\">"  
     //                     <a href=\"javascript:showImage('파일이름변수')">
				 + "     <img src='${contextPath}/displayThumbnail?fileName="+thumbnailFileName + "'"
				 + "        alt='No Icon' style='height:18px;width:18px;'>"
				 + obj.fileName
				 +"   </a>"
				 + "</li>";
		}			
	});	
	fileUploadResult.append(str);
}


//함수: 이미지를 다운로드 받아서 웹 브라우저에 표시 
function showImage(fullFileName){
	
	$(".bigImageWrapper").css("display","flex").show();
	$(".bigImage").html("<img src='${contextPath}/filedownloadAjax?fileName="
			 						+fullFileName+"'>")
				//  .animate({width:'100%', height:'100%'}, 1000);    //1초안에 이미지가 나옴		
	       		    .animate({height:'100%'}, 1000);  
}

//이미지 제거 
$(".bigImageWrapper").on("click",function(){
	
	$(".bigImage").animate({width:'0%', height: '0%'},3000); //3초 안에 없앰 
	
	setTimeout(function(){
		$(".bigImageWrapper").hide();
	},2500); // 2.5초동안 hide 실행 할 것임 !! 
	
   // $(".bigImageWrapper").hide();
})

//업로드 요청
$("#btnFileUpload").on("click",function(){
	
	//ajax로 파일 전송시에 사용되는 WEB api 클래스의 생성자(브라우저에 있는거) 
	var formData = new FormData();
	
	// input 요소 두개가 저장됨 
	var inputFiles = $("input[name='uploadFiles']");
/*	
	var myFiles = inputFiles[0].files; // files 타입의 input 요소			
	for(var i = 0; i < myFiles.length; i++){
		
		formData.append("uploadFiles", myFiles[i]);
		
	}
	
*/		 
	
	//input이 하나인 경우에는 다음처럼 한 줄을 적으면 됨
    //var myFiles = inputFiles[0].files; 하나가 입력되도 name 속성이라서 배열 형태로 들어감 
	
    
	//input에서 파일 추출
	var myFiles = [];
	
	for(var i=0; i<inputFiles.length; i++){
		myFiles = inputFiles[i].files;

		for(var j = 0 ; j < myFiles.length; j++ ) {			
			if(!checkUploadFile(myFiles[j].name,myFiles[j].size)){
				return ;
			}				
			formData.append("uploadFiles",myFiles[j])			
		}		
	}
	
	
	
	
	//formData 보내주기 
	$.ajax({
			type:"post",
			url:"${contextPath}/fileUploadAjaxAction",
			data: formData,
			processData: false, //서버가 contenttype 알아서 지정함 
			contentType: false, // contentType에 설정된 형식으로 data를 처리하지 않음 
			dataType:"json",
			success: function(uploadResult){		
				
				console.log(uploadResult);		
				$(".uploadDiv").html(cloneFileInput.html()); // 비어있는 input요소로 됨(위에서 비어있는 요소를 복사했기 때문!)
				//$(".uploadDiv .inputFile").each(function(i,e){
				//	$(e).val("");
				//})
				
				showUploadResult(uploadResult);
				
			}
		});
	
})



</script>
</body>
</html>

