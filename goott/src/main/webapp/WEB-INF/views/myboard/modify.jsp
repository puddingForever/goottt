<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:set var="contextPath" value="${pageContext.request.contextPath }" />

<%@ include file="../myinclude/myheader.jsp"%>
<div id="page-wrapper">
	<div class="row">
		<div class="col-lg-12">
			<h3 class="page-header">Board - Modify</h3>
		</div>
		<%-- /.col-lg-12 --%>
	</div>
	<%-- /.row --%>
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">
					<h4>게시글 수정-삭제</h4>
				</div>
				<%-- /.panel-heading --%>
				
				<div class="panel-body">
					<form role="form" id="frmModify" method="post" name="frmBoard">
						 
						<div class="form-group">
							<label>글번호</label> <input class="form-control" name="bno" value='<c:out value="${board.bno}"/>' readonly="readonly" />
						</div>
						<div class="form-group">
							<label>글제목</label>  
							<input class="form-control" name="btitle" value='<c:out value="${board.btitle}"/>' />
						</div>
						<div class="form-group">
							<label>글내용</label>		
							<textarea class="form-control" rows="3" name="bcontent"><c:out value="${board.bcontent}" /></textarea>
						</div>
						<div class="form-group">
							<label>작성자</label> <input class="form-control" name="bwriter" value='<c:out value="${board.bwriter}"/>' readonly="readonly" />
						</div>

						<div class="form-group">
							<label>최종수정일</label> [등록일시:
							<fmt:formatDate pattern="yyyy/MM/dd HH:mm:ss" value="${board.bregDate}" /> ] 
							<input class="form-control" name="bmodDate" value='<fmt:formatDate pattern="yyyy/MM/dd HH:mm:ss" value="${board.bmodDate}"/>'
								disabled="disabled" /> 
						</div>
						<button type="button" class="btn btn-default" id="btnModify" data-oper="modify">수정</button>
						<button type="button" class="btn btn-danger" id="btnRemove" data-oper="remove">삭제</button>
						<button type="button" class="btn btn-info" id="btnList" data-oper="list">취소</button>
					</form>
				</div>
				<%-- /.panel-body --%>
			</div>
			<%-- /.panel --%>
		</div>
		<%-- /.col-lg-12 --%>
	</div>
	<%-- /.row --%>
</div>
<%-- /#page-wrapper --%>
<script>
//form 수정/삭제/목록보기 버튼 클릭 이벤트 처리
	var frmModify = $("#frmModify");
	$('button').on("click",function(e){
		var operation = $(this).data("oper");
		alert("operation: " + operation);
		
		if(operation=="modify"){
		   frmModify.attr("action","${contextPath}/myboard/modify");	
		}
		else if(operation=="remove"){
			frmModify.attr("action","${contextPath}/myboard/delete");
		}
		else if(operation=="list"){
			frmModify.attr("action","${contextPath}/myboard/list").attr("method","get");
			frmModify.empty();
		}
		
		frmModify.submit();
	})


</script>



<%@ include file="../myinclude/myfooter.jsp"%>