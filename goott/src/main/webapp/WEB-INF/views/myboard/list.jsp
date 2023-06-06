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
									 ${board.bregDate}
									 </td>
									 <td><fmt:formatDate pattern="yyyy/MM/dd HH:mm:ss" value="${board.bmodDate}" /><br>
									 ${board.bmodDate}
									 </td>
									 <td>${board.bviewsCnt }</td>
								</tr>
							</c:if>
						</c:forEach>					

						</tbody>
					</table><%-- /.table-responsive --%>
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
						
					
					<form id="frmSendValue">
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

//checkModal(result);
</script>

<script>
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
