<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:set var="contextPath" value="${pageContext.request.contextPath }" />

<%@ include file="../myinclude/myheader.jsp"%>

<div id="page-wrapper">
	<div class="row">
		<div class="col-lg-12">
			<h3 class="page-header">Board -List</h3>
		</div>
		<!-- /.col-lg-12 -->
	</div>
	<!-- /.row -->
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">
				<div class="row">
					 <div class="col-md-6" style="font-size:20px; height: 45px; padding-top:10px;">게시글 목록</div>
					 <div class="col-md-6" style="padding-top:8px;">
					 <button type="button" id="btnMoveRegister" class="btn btn-primary btn-sm pull-right">새글 등록</button>
					 </div>
				 </div>
				</div>
				<div class="panel-body">
				
					<form class="form-inline" id="frmSendValue" action="${contextPath}/myboard/list" method="get" name="frmSendValue">
								 <div class="form-group">
									 <label class="sr-only">frmSendValues</label>
									 <select class="form-control" id="selectAmount" name="rowAmountPerPage"><!-- 표시 게시물 수 선택 -->
										 <option value="10" <c:out value="${pagingCreator.myBoardPagingDTO.rowAmountPerPage eq '10'
										 ? 'selected' : ''}" /> >10개</option>
										 <option value="20" <c:out value="${pagingCreator.myBoardPagingDTO.rowAmountPerPage eq '20'
										 ? 'selected' : ''}" /> >20개</option>
										 <option value="50" <c:out value="${pagingCreator.myBoardPagingDTO.rowAmountPerPage eq '50'
										 ? 'selected' : ''}" /> >50개</option>
										 <option value="100" <c:out value="${pagingCreator.myBoardPagingDTO.rowAmountPerPage eq '100'
										 ? 'selected' : ''}" /> >100개</option>
									</select>
									 
									 <select class="form-control" id="selectScope" name="scope"><!-- 검색 범위 선택 -->
										 <option value="" <c:out value="${pagingCreator.myBoardPagingDTO.scope == null
										 ? 'selected':''}" /> >검색범위</option>
										 <option value="T" <c:out value="${pagingCreator.myBoardPagingDTO.scope eq 'T'
										 ? 'selected' : ''}" /> >제목</option>
										 <option value="C" <c:out value="${pagingCreator.myBoardPagingDTO.scope eq 'C'
										 ? 'selected' : ''}" /> >내용</option>
										 <option value="W" <c:out value="${pagingCreator.myBoardPagingDTO.scope eq 'W'
										 ? 'selected' : ''}" /> >작성자</option>
										 <option value="TC" <c:out value="${pagingCreator.myBoardPagingDTO.scope eq 'TC'
										 ? 'selected' : ''}" /> >제목 + 내용</option>
										 <option value="TW" <c:out value="${pagingCreator.myBoardPagingDTO.scope eq 'TW'
										 ? 'selected' : ''}" /> >제목 + 작성자</option>
										 <option value="TCW" <c:out value="${pagingCreator.myBoardPagingDTO.scope eq 'TCW'
										 ? 'selected' : ''}" /> >제목 + 내용 + 작성자</option>
									 </select>
									 
									 <div class="input-group"><!-- 검색어 입력 -->
										 <input class="form-control" id="inputKeyword" name="keyword" type="text" placeholder="검색어를 입력하세요"
																		 value='<c:out value="${pagingCreator.myBoardPagingDTO.keyword}" />' />
										 <span class="input-group-btn"><!-- 전송버튼 -->
											 <button class="btn btn-info" type="button" id="btnSearchGo">
											 검색 &nbsp;<i class="fa fa-search"></i>
										 </button>
										 </span>
									 </div>

									 <div class="input-group"><!-- 검색 초기화 버튼 -->
									 <button id="btnReset" class="btn btn-warning" type="reset">검색초기화</button>
									 </div>
								 </div>
								 
								 <%-- /.form-group --%>
								 <input type='hidden' name='pageNum' value='${pagingCreator.myBoardPagingDTO.pageNum}'>
								 <input type='hidden' name='rowAmountPerPage' value='${pagingCreator.myBoardPagingDTO.rowAmountPerPage}'>
								 <input type='hidden' name='lastPageNum' value='${pagingCreator.lastPageNum}'>
						</form><%-- END 검색범위 및 검색어 입력 폼 --%>
								<br>
					<table class="table table-striped table-bordered table-hover"
						style="width: 100%; text-align: center;">
						<thead>
							<tr>
								<th style="text-align:center;">번호</th> 
								 <th style="text-align:center;">제목</th>
								 <th style="text-align:center;">작성자</th>
								 <th style="text-align:center;">작성일</th>
								 <th style="text-align:center;">수정일</th>
								 <th style="text-align:center;">조회수</th>
							</tr>
						</thead>
						<tbody>
						<c:forEach items="${boardList }" var="board">
							<c:if test="${board.bdelFlag ==1 }">
								<tr style="background-color:Moccasin; text-align:center">
									<td><c:out value="${board.bno }"/></td>
									 <td colspan="5"><em>작성자에 의하여 삭제된 게시글입니다.</em></td>
								</tr>
							</c:if>
							<c:if test="${board.bdelFlag == 0}">
								<tr class="moveDetail" data-bno='<c:out value="${board.bno }"/>'>
								
									<td><c:out value="${board.bno }" /></td>
									<td style="text-align:left;" ><c:out value="${board.btitle}"/></td>
									 <td><c:out value="${board.bwriter}" /></td>
									 <td><fmt:formatDate pattern="yyyy/MM/dd" value="${board.bregDate}" /><br>
									 </td>
									 <td><fmt:formatDate pattern="yyyy/MM/dd HH:mm:ss" value="${board.bmodDate}" /><br>
									 </td>
									 <td>${board.bviewsCnt }</td>
								</tr>
							</c:if>
						</c:forEach>					

						</tbody>
					</table><%-- /.table-responsive --%>
					<%-- Pagination 시작 --%><!-- 
					<div class="pull-right"> -->
					<div style="text-align:center;">
						<ul class="pagination pagination-sm">
						<c:if test="${pagingCreator.prev }">
							<li class="pagination-button">
							    <a href="1" aria-label="Previous">
							      <span aria-hidden="true">&laquo;</span>
							    </a>
						  	</li>
						 </c:if>
						<c:if test="${pagingCreator.prev }">
							<li class="pagination-button">
							    <a href="${pagingCreator.startPagingNum - 1}" aria-label="Previous">
							      <span aria-hidden="true">Prev</span>
							    </a>
						  	</li>
						 </c:if>
						 
						<%-- 페이징 그룹의 페이징 숫자(10개 표시) --%>
						<c:forEach var="pageNum" begin="${pagingCreator.startPagingNum}" end="${pagingCreator.endPagingNum}" step="1"> 
					 		<li class='pagination-button ${pagingCreator.myBoardPagingDTO.pageNum == pageNum ? "active" : ""}'>
								<a href="${pageNum }">${pageNum }</a>
							</li>
						</c:forEach>	
							
						<c:if test="${pagingCreator.next }">
							<li class="pagination-button">
								<a href="${pagingCreator.endPagingNum + 1 }" aria-label="Next">
									<span aria-hidden="true">Next</span>
								</a>
							</li>
						</c:if>
						<c:if test="${pagingCreator.next }">
							<li class="pagination-button">
							  <a href="${pagingCreator.lastPageNum }" aria-label="Next">
							    <span aria-hidden="true">&raquo;</span>
							  </a>
							</li>
						</c:if>
						</ul>
					
					</div>                    
					                 					
					
					<%-- Modal 모달 시작--%>
				<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
					 <div class="modal-dialog">
						 <div class="modal-content">
							 <div class="modal-header">
							    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
							 <h4 class="modal-title" id="myModalLabel">처리결과</h4>
							 </div>
							 <div class="modal-body">처리가 완료되었습니다.</div>  
							 <div class="modal-footer">
							    <button type="button" class="btn btn-default" data-dismiss="modal">확인</button>
							 </div>
						</div><%-- END .modal-content --%>
					</div><%-- END .modal-dialog --%>
				</div><%-- END .modal --%>
						
					
				</div>
				<%-- /.panel-body --%>
			</div>
			<%-- /.panel --%>
		</div>
		<%-- /.col-lg-12 --%>
	</div>
	<%-- /.row --%>
</div>
<!-- /#page-wrapper -->

<script type="text/javascript">
	<!-- 게시글 상세 페이지 이동  -->

	var frmSendValue = $("#frmSendValue");
	$(".moveDetail").on("click",function(e){
		
		frmSendValue.append("<input type='hidden' name='bno'  value='" + $(this).data("bno") + "'/>");
		
		frmSendValue.attr("action","${contextPath}/myboard/detail");
		frmSendValue.attr("method","get");
		frmSendValue.submit();
		
	})
	
<!--  새글 등록 버튼 이벤트  -->

$("#btnMoveRegister").on("click",function(){
	self.location = "${contextPath}/myboard/register";
})



<!--모달처리-->
var result ='<c:out value="${result}"/>';
function checkModal(result){
	if(result == '' || history.state){
		return;
	}
	else if(result=='successRemove'){
		var myMsg="글이 삭제되었습니다.";
	}
	else if(parseInt(result)>0){
		var myMsg = "게시글" + parseInt(result) + "번이 등록되었습니다.";
	}
	
	$(".modal-body").html(myMsg);
	$("#myModal").modal("show");
	myMsg='';
	
}

$(".pagination-button a").on("click", function(e){
	e.preventDefault() ;
	
	frmSendValue.find("input[name='pageNum']").val($(this).attr("href")) ;
	frmSendValue.attr("action", "${contextPath}/myboard/list") ;
	frmSendValue.attr("method", "get") ;
	
	frmSendValue.submit() ;
	
});


<%--검색 관련 요소의 이벤트 처리--%>
<%--표시행수 변경 이벤트 처리--%>
$("#selectAmount").on("change", function(){
	 frmSendValue.find("input[name='pageNum']").val(1);
	 frmSendValue.attr("action", "${contextPath}/myboard/list");
	 frmSendValue.attr("method", "get");
	 frmSendValue.submit();
});
<%--검색버튼 클릭 이벤트 처리 --%>
$("#btnSearchGo").on("click", function(e) {
	 if (!$("#selectScope").find("option:selected").val()) {
		 alert("검색범위를 선택하세요");
		 return false;
	 }
 
 //if (!frmSendValue.find("input[name='keyword']").val()) {
 if (!( (frmSendValue.find("input[name='keyword']").val()) ||
 		(frmSendValue.find("input[name='keyword']").val() !="") ) {
	 alert("검색어를 입력하세요");
	 return false;
	 }
 
 frmSendValue.find("input[name='pageNum']").val("1");
 
 frmSendValue.submit();

 });
<%--검색초기화 버튼 이벤트처리, 버튼 초기화 시, 1페이지에 목록 정보 다시 표시 --%>
$("#btnReset").on("click", function(){
 $("#selectAmount").val(10);
 $("#selectScope").val("");
 $("#inputKeyword").val("") ;
 $("#hiddenPageNum").val(1);
 $("#hiddenLastPageNum").val("");
 
 frmSendValue.submit();
});

//게시글 등록 후 , 리스트가 표시 -> 뒤로가기를 누르면 다시 게시글과 입력값이 그대로 보임, 
//이떄 사용자가 등록을 다시 입력하면,입력값 요청이 두번 들어오게됨(bno의 경우 primary라서 오류날 확률 .. )
//따라서 등록 후 리스트가 표시되면 뒤로가기 버튼을 못하게 해야함 
$(document).ready(function(){
	  
	
	checkModal(result);
	window.addEventListener('popstate',function(event){
		history.pushState(null,null,location.href);
	})
	
	history.pushState(null,null,location.href);
	
})


</script>

<%@ include file="../myinclude/myfooter.jsp"%>
