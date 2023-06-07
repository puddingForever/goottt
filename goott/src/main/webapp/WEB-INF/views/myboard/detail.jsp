<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:set var="contextPath" value="${pageContext.request.contextPath }" />

<%@ include file="../myinclude/myheader.jsp"%>
<div id="page-wrapper">
	<div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">Board - Detail</h1>
		</div>
		<%-- /.col-lg-12 --%>
	</div>
	<%-- /.row --%>
	<div class="row">
		<div class="col-lg-12">
		<h3 class="page-header"
 			style="white-space: nowrap;" >Board - Detail: <c:out value="${board.bno}"/>번 게시물</h3>
			<div class="panel panel-default">
				<div class="panel-heading">
					<div class="row">
						 <div class="col-md-3" style="white-space: nowrap; height: 45px; padding-top:11px;">
						 <strong style="font-size:18px;">${board.bwriter}님 작성</strong>
						 </div>
						<div class="col-md-3" style="white-space: nowrap; height: 45px; padding-top:16px;">
							 <span class="text-primary" style="font-size: smaller; height: 45px; padding-top: 19px;">
							 <span>
							 <span>등록일:&nbsp;</span>
							<strong><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" 
							 value="${board.bregDate}"/></strong>
							 <span>&nbsp;&nbsp;</span>
							 </span>
							<span>조회수:&nbsp;<strong><c:out value="${board.bviewsCnt}"/></strong></span>
							 </span>
						 </div>
						<div class="col-md-6" style="height: 45px; padding-top:6px;"><%-- vertical-align: middle; --%>
							 <div class="button-group pull-right">
							 <button type="button" id="btnToModify" data-oper="modify" class="btn btn-primary"><span>수정</span></button>
							 <button type="button" id="btnToList" data-oper="list" class="btn btn-info"><span>목록</span></button>
							 </div>
						 </div>
						 </div>
				</div>
				<%-- /.panel-heading --%>
				<div class="panel-body form-horizontal">
						 <div class="form-group">
						 	<label class="col-sm-2 control-label" style="white-space: nowrap;">글제목</label>
						 <div class="col-sm-10">
							 <input class="form-control" name="btitle" value='<c:out value="${board.btitle}"/>'
						 readonly="readonly"/>
						 </div>
					 </div>
					 <div class="form-group">
						 <label class="col-sm-2 control-label" style="white-space: nowrap;">글내용</label>
						 <%-- <textarea>와 </textarea>는 한 줄에 작성되어야 필요없는 공백이 포함되지 않음 --%>
						 <div class="col-sm-10">
						 <textarea class="form-control" rows="3" name="bcontent" style="resize: none;"
							 readonly="readonly"><c:out value="${board.bcontent}"/></textarea>
						 </div>
					 </div>
					 <div class="form-group">
						 <label class="col-sm-2 control-label" style="white-space: nowrap;">최종수정일</label>
						 <div class="col-sm-10">
							 <input class="form-control" name="bmodDate"
							 value='<fmt:formatDate pattern="yyyy/MM/dd HH:mm:ss" value="${board.bmodDate}"/>'
							 readonly="readonly" />
						 </div>
					 </div>
					 </div><%-- /.panel-body --%>
				 </div><%-- /.panel --%>
				 </div><%-- /.col-lg-12 --%>
				 <form id="frmSendValue"><!-- 폼을 추가(list.jsp와 동일한 아이디의 form) -->
					 <input type='hidden' name='bno' id="bno" value='<c:out value="${board.bno}"/>'>
					 <input type='hidden' name='pageNum' value='${myBoardPagingDTO.pageNum}'>
					 <input type='hidden' name='rowAmountPerPage' value='${myBoardPagingDTO.rowAmountPerPage}'>
				 	<input type='hidden' name='scope' value='${myBoardPagingDTO.scope}'>
				 	<input type='hidden' name='keyword' value='${myBoardPagingDTO.keyword}'>
				</form>
				
				
				<%-- 댓글 화면 표시 시작, 붙여넣기 후, 아래의 style 태그 내용은 <div id="page-wrapper"> 태그 위에 옮겨놓을 것 --%>
			<style>
			.txtBoxCmt, .txtBoxComment {
			 overflow: hidden; resize: vertical; min-height: 100px; color: black;
			}
			</style>
				<div class="row">
					 <div class="col-lg-12">
						 <div class="panel panel-default" >
							 <div class="panel-heading">
								 <p style="margin-bottom: 0px; font-size: 16px;">
								 <strong style="padding-top: 2px;">
								 <span>댓글&nbsp;<c:out value="${board.breplyCnt}"/>개</span> 
								 <span>&nbsp;</span>
								<button type="button" id="btnChgCmtReg" class="btn btn-info btn-sm">댓글 작성</button>
								 <button type="button" id="btnRegCmt" class="btn btn-warning btn-sm"
								 style="display:none">댓글 등록</button>
								 <button type="button" id="btnCancelRegCmt" class="btn btn-warning btn-sm"
								style="display:none">취소</button>
								 </strong>
								 </p>
							 </div> <%-- /.panel-heading --%>
							 <div class="panel-body">
								<%-- 댓글 입력창 div 시작 --%>
								 <div class="form-group" style="margin-bottom: 5px;">
								 <textarea class="form-control txtBoxCmt" name="rcontent"
								 placeholder="댓글작성을 원하시면,&#10;댓글 작성 버튼을 클릭해주세요."
								 readonly="readonly"
								 ></textarea>
								 </div>
								 <hr style="margin-top: 10px; margin-bottom: 10px;">
								<%-- 댓글 입력창 div 끝 --%>
								 <ul class="chat">
								 <%-- 댓글 목록 표시 영역 - JavaScript 로 내용이 생성되어 표시됩니다.--%>
								 <li class="left clearfix commentLi" data-bno="123456" data-rno="12">
									 <div>
										 <div>
											 <span class="header info-rwriter">
											 <strong class="primary-font">user00</strong>
											 <span>&nbsp;</span>
											 <small class="text-muted">2018-01-01 13:13</small>
											 </span>
											 <p>앞으로 사용할 댓글 표시 기본 템플릿입니다.</p>
										 </div>
										 <div class="btnsComment" style="margin-bottom:10px">
											 <button type="button" style="display:in-block"
											 class="btn btn-primary btn-xs btnChgReg">답글 작성</button>
											 <button type="button" style="display:none" 
											 class="btn btn-warning btn-xs btnRegCmt">답글 등록</button>
											 <hr class="txtBoxCmtHr" style="margin-top:10px; margin-bottom:10px">
											 <textarea class="form-control txtBoxCmtMod" name="rcontent" style="margin-bottom:10px"
											 placeholder="답글작성을 원하시면,&#10;답글 작성 버튼을 클릭해주세요."
											 ></textarea>
										 </div>
									 </div>
								 </li>
								 </ul><%-- /.chat --%>
							 </div><%-- /.panel-body --%>
							 <div class="panel-footer text-center" id="showCmtPagingNums">
							 <%-- 댓글 목록의 페이징 번호 표시 영역 - JavaScript 로 내용이 생성되어 표시됩니다.--%>
							 </div>
						 </div><%-- /.panel --%>
					 </div><%-- .col-lg-12 --%>
					</div><%-- .row : 댓글 화면 표시 끝 --%>
					<%-- 댓글 페이징 데이터 저장 form --%>
					<form id="frmCmtPagingValue">
					 <input type='hidden' name='pageNum' value='' />
					 <input type='hidden' name='rowAmountPerPage' value='' />
					</form>				
				
 			</div><%-- /.row --%>

<%-- /#page-wrapper --%>

<script>
//게시물 수정 페이지로 이동 

var frmSendValue = $("#frmSendValue");

$("#btnToModify").on("click",function(){
	frmSendValue.attr("action","${contextPath}/myboard/modify");
	frmSendValue.attr("method","get");
	frmSendValue.submit();

})

//게시물 목록 페이지로 이동
$("#btnToList").on("click",function(){
	
	frmSendValue.find("#bno").remove();
	frmSendValue.attr("action","${contextPath}/myboard/list");
	frmSendValue.attr("method","get");
	frmSendValue.submit();

})

var result='<c:out value="${result}"/>'; //컨트롤러로부터 전달받음

function checkModifyOperation(result){
	if(result == '' || history.state){
		return ;
	}	else if(result == 'successModify'){
		var myMsg="글이 수정되었습니다.";
	}
	
	alert(myMsg);
	myMsg='';
	
}

//페이지 로딩되자마자 바로 확인 
$(document).ready(function(){
	checkModifyOperation(result);
})
</script>


<script type="text/javascript" src="${contextPath }/resources/js/mycomment.js"></script>
<script>

	var bnoValue = '<c:out value="${board.bno}"/>';

	var commentUL = $(".chat"); // 댓글 표시영역
	var frmCmtPagingValue = $("#frmCmtPagingValue"); // 페이징값 전달 form 
	
	
	
	/* myCommentClsr.getCmtList(
		{bno:bnoValue, page:1},
		function(replyPagingCreator){
			for(var i=0, len=replyPagingCreator.replyList.length || 0; i<len; i++){
				console.log(replyPagingCreator.replyList[i]);
			}
		}
	); */
	
	/* //댓글 등록 테스트
	myCommentClsr.registerCmt(
		{bno:bnoValue, rcontent:"JS-클로저-댓글입력테스트",rwriter:"user7"},
		function(result){
			alert("처리결과" + result);
		}
	);
	
	//답글 등록 테스트 
	myCommentClsr.registerReply(
		{bno:bnoValue, prno:1, rcontent : "JS-클로저 댓글의 답글 입력테스트",rwriter:"user10"},
		function(result){
			alert("myReplyClsr : " + result);
		}
	
	); */
	

/* 	//댓글-답글 조회 테스트 
	myCommentClsr.getCmtReply(
			{bno:bnoValue, rno:1},
			function(data){
				console.log(data);
			}
	);
	
	//댓글-답글 수정 테스트 
	myCommentClsr.modifyCmtReply(
		{bno:bnoValue, rno: 1, rcontent:"JS 클로저에 의한 댓글 수정===="},
		function(modifyResult){
			alert(modifyResult + "-ajax 처리 완료")	
		}
	); */
	/* myCommentClsr.removeCmtReply(
		{bno:bnoValue, rno: 1,rwriter:'user10'},
		function(deleteResult){
			if(deleteResult == "댓글 삭제 성공"){
				alert(deleteResult + "댓글이 삭제되었습니다.")
			}	
			
		},
		function(err){
			alert("오류로 인한 댓글 취소");
		}
	);  */
	
	
	
</script>
<%@ include file="../myinclude/myfooter.jsp"%>
