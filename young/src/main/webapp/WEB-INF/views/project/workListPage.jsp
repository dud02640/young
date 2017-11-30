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
function allclick1(){
	$('input:checkbox[name=checkbox1]').not(":disabled").prop("checked",$('input:checkbox[name=allcheckbox1]').is(":checked"));
}
function go_multidel(){
	$('#mes').val("삭제 완료");
	var frm =document.getElementById('projectDetailForm');
		if($('input:checkbox[name=checkbox]:checked').length>0){
 	  		var retVal = confirm("정말로 삭제 하시겠습니까?");
 	  		if(retVal){
 	  			frm.action="/project/workMultiDelete.do";
 	  			frm.submit();
 	  		}else{
 	  			alert("취소");
 	  		}
		}else{
 			alert("삭제할 회원을 한 명 이상 선택하십시오.");
 		}
}
function workCancel(workNo){
	$('#mes').val("취소 완료");
	$('#workNo').val(workNo);
	var frm=document.getElementById('projectDetailForm');
	frm.action="/project/workCancel.do";
	frm.submit();
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
                <input name="searchkeyword1" class="form-control" type="text" maxlength="30" placeholder="" value="${params.searchkeyword1}"/>
                <button class="btn btn-primary" type="submit" onclick="searchWork1()">검색</button>
                </span>
				</div>	
              </div>
	<table class="table table-bordered dataTable" id="dataTable" role="grid" width="100%" cellspacing="0">
		<thead>
			<tr>
			<th><input type="checkbox" name="allcheckbox1" onclick="allclick1();"/></th>
			<th>업무번호</th>
			<th>업무명</th>
			<th>기간</th>
			<th>진행자</th>
			<th>진행상태</th>
			<th>취소</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="selectWorkListAll" items="${selectWorkListAll}">
			<tr>
					<td><input type="checkbox" name="checkbox1" value="${selectWorkListAll.workNo}"></td>
					<td>${selectWorkListAll.workNum}</td>
					<td>${selectWorkListAll.workSubject}</td>
					<td>${selectWorkListAll.startDate} ~ ${selectWorkListAll.endDate}</td>
					<td>${selectWorkListAll.userId}</td>
					<td>${selectWorkListAll.state}</td>
					<td><a href="#" onclick="workCancel(${selectWorkListAll.workNo})">취소하기</a></td>
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
					<li id="pagingNumbering" class="paginate_button page-item active"><a class="page-link" href="#" onclick="searchWork1(${pIndex})">${pIndex}</a></li>
				</c:when>
				<c:otherwise>
					<li id="pagingNumbering" class="paginate_button page-item"><a class="page-link" href="#" onclick="searchWork1(${pIndex})">${pIndex}</a></li>
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
		<button class="btn btn-primary" type="button" onclick="go_multidel()">삭제</button>
	</div>
	<input type="hidden" name="workNo" id="workNo"/>