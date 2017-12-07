<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script>
$(function(){
	$('form').submit(function() {return false;});
});
function searchWork1(pIndex){
	$('input[name=selectPage]').val(pIndex);
	
	var frm =$("#projectDetailForm").serialize();
	$.ajax({
		type:"POST",
		url:"/project/workListPage.do",
		data: frm,
		success: function(data){
			/* location.reload(); */
			$("#worklist").empty();
			$("#worklist").append(data);	
		}
	}); 
}
function allclick(){
	$('input:checkbox[name=checkbox]').not(":disabled").prop("checked",$('input:checkbox[name=allcheckbox]').is(":checked"));
}
function go_multicancel(){
	$('#mes').val("취소 완료");
	var frm =document.getElementById('projectDetailForm');
		if($('input:checkbox[name=checkbox]:checked').length>0){
 	  		var retVal = confirm("정말로 취소 하시겠습니까?");
 	  		if(retVal){
 	  			frm.action="/project/workMultiCancel.do";
 	  			frm.submit();
 	  		}
		}else{
 			alert("삭제할 업무를 하나 이상 선택하십시오.");
 		}
}
function go_multicomplete(){
	$('#mes').val("업무 완료");
	var frm =document.getElementById('projectDetailForm');
		if($('input:checkbox[name=checkbox]:checked').length>0){
 	  		var retVal = confirm("정말로 완료 하시겠습니까?");
 	  		if(retVal){
 	  			frm.action="/project/workMultiComplete.do";
 	  			frm.submit();
 	  		}
		}else{
 			alert("완료할 업무를 하나 이상 선택하십시오.");
 		}
}
function workCancel(workNo){
	$('#mes').val("취소 완료");
	$('#workNo').val(workNo);
	var frm=document.getElementById('projectDetailForm');
 		var retVal = confirm("정말로 취소 하시겠습니까?");
 		if(retVal){
 			frm.action="/project/workCancel.do";
 			frm.submit();
 		}
}
function workComplete(workNo){
	$('#mes').val("업무 완료");
	$('#workNo').val(workNo);
	
	var frm=document.getElementById('projectDetailForm');
 	frm.action="/project/workComplete.do";
 	frm.submit();

}


function updateWorkList(workNo){
	$('#workNo').val(workNo);
}

</script>
<div class="row">
              <div class="col-md-6">
                <div class="input-group-btn">
           		<span class="input-group-btn"> 
				<select class="form-control" name="searchOption1">
						<option value="1" ${params.searchOption1 eq "1" ? "selected" : ""}>업무번호</option>
						<option value="2" ${params.searchOption1 eq "2" ? "selected" : ""}>업무명</option>
				</select> 
                <input name="searchkeyword1" class="form-control" type="text" maxlength="30" placeholder="" value="${params.searchkeyword1}" onkeypress="if(event.keyCode==13){searchWork1();}"/>
                <button class="btn btn-primary" type="submit" onclick="searchWork1()">검색</button>
                </span>
				</div>	
              </div>
	<table class="table table-bordered dataTable" id="dataTable" role="grid" width="100%" cellspacing="0">
		<thead>
			<tr>
			<th><input type="checkbox" name="allcheckbox" onclick="allclick();"/></th>
			<th>순번</th>
			<th>업무번호</th>
			<th>업무명</th>
			<th>기간</th>
			<th>진행자</th>
			<th>진행상태</th>
			<c:choose>
			<c:when test="${joinMemberCheck.userId!=null || joinMemberCheck.leaderYn=='Y'|| params.adminYn=='Y'}">
				<th>취소 </th>
				<th>완료 </th>				
			</c:when>
			</c:choose>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="selectWorkListAll" items="${selectWorkListAll}" varStatus="status">
			<tr>
					<c:choose>
						<c:when test="${joinMemberCheck.leaderYn=='Y' || params.adminYn=='Y'}">
							<td><input type="checkbox" name="checkbox" value="${selectWorkListAll.workNo}"></td>
						</c:when>
						<c:when test="${params.adminYn=='N' && params.userId==selectWorkListAll.userId}">
							<td><input type="checkbox" name="checkbox" value="${selectWorkListAll.workNo}"></td>
						</c:when>
						<c:otherwise>
							<td><input type="checkbox" name="checkbox" value="${selectWorkListAll.workNo}" disabled="true"></td>
						</c:otherwise>
					</c:choose>
					<td>${params.currentpageDB=params.currentpageDB+1}</td>
					<td>
					<c:choose>
						<c:when test="${joinMemberCheck.userId!=null || joinMemberCheck.leaderYn=='Y'|| params.adminYn=='Y'}">
							<a href="#" data-toggle="modal" data-target="#updateWorkListModal" onclick="updateWorkListModalView(${selectWorkListAll.workNo})">${selectWorkListAll.workNum}</a>
						</c:when>
						<c:otherwise>
							${selectWorkListAll.workNum}
						</c:otherwise>
					</c:choose>
					</td>
					<td>${selectWorkListAll.workSubject}</td>
					<td>${selectWorkListAll.startDate} ~ ${selectWorkListAll.endDate}</td>
					<td>${selectWorkListAll.userName}</td>
					<td>${selectWorkListAll.state}</td>
					<c:choose>
					<c:when test="${selectWorkListAll.userId==params.userId || joinMemberCheck.leaderYn=='Y'|| params.adminYn=='Y'}">
					<c:choose>
	 					<c:when test="${joinMemberCheck.leaderYn=='Y' || params.adminYn=='Y'}">
							<td><a href="#checklist" onclick="workCancel(${selectWorkListAll.workNo})">취소하기</a></td>
							<td><a href="#checklist" onclick="workComplete(${selectWorkListAll.workNo})">완료하기</a></td>
						</c:when> 
						<c:when test="${params.adminYn=='N' && params.userId==selectWorkListAll.userId}">
							<td><a href="#checklist" onclick="workCancel(${selectWorkListAll.workNo})">취소하기</a></td>
							<td><a href="#checklist" onclick="workComplete(${selectWorkListAll.workNo})">완료하기</a></td>
						</c:when>
					<c:otherwise>
					<td>취소하기</td>
					<td>완료하기</td>
					</c:otherwise>
					</c:choose>
					</c:when>
					<c:otherwise>
					<td>취소하기</td>
					<td>완료하기</td>
					</c:otherwise>
					</c:choose>
			</tr>
			</c:forEach>
		</tbody>
	</table>
</div>
	<div class="col-sm-12 col-md-7">
	<div class="dataTables_paginate paging_simple_numbers" id="dataTable_paginate">
	<ul class="pagination">
		<c:if test="${params.selectPage-1!=0}">
		<li class="paginate_button page-item prvious disable"><button name="prv" class="page-link" onclick="searchWork1(${params.selectPage - 1})">이전</button></li>
			</c:if>
		<c:forEach var="pIndex" begin="${params.startpage}" end="${params.endpageNo}" step="1">
			<c:choose>
				<c:when test="${params.currentpage eq pIndex}">
					<li id="pagingNumbering" class="paginate_button page-item active"><a class="page-link" href="#worklist" onclick="searchWork1(${pIndex})">${pIndex}</a></li>
				</c:when>
				<c:otherwise>
					<li id="pagingNumbering" class="paginate_button page-item"><a class="page-link" href="#worklist" onclick="searchWork1(${pIndex})">${pIndex}</a></li>
				</c:otherwise>
			</c:choose>
		</c:forEach>
		<c:if test="${params.endpage != params.currentpage}">
			<li class="paginate_button page-item next"><button name="next" class="page-link" onclick="searchWork1(${params.selectPage +1})">다음</button></li>
		</c:if>
	<input type="hidden" name="joinId" value=""/>
	<input type="hidden" name="selectPage" value="${params.selectPage}"/>
	<input type="hidden" name="underPaging" value=""/>
	<input type="hidden" name="startpage" value="${params.startpage}"/>
	<input type="hidden" name="endpageNo" value="${params.endpageNo}"/>
	<input type="hidden" name="projectNo" value="${projectdetail.projectNo}"/>
	</ul>
	</div>
	</div>
	<div class="col-sm-12">
	<c:if test="${ joinMemberCheck.userId==params.userId || params.adminYn=='Y'}">
		<button class="btn btn-primary" type="button" onclick="go_multicomplete()">완료</button>
		<button class="btn btn-default" type="button" onclick="go_multicancel()">취소</button>
	</c:if>
	</div>
	
	<input type="hidden" name="workNo" id="workNo"/>