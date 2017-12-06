<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script>
$(function(){
	$('form').submit(function() {return false;});
});
function insertjoin(userId,userName){
	$('#mes').val("추가 완료");
	$('input[name=joinId]').val(userId);
	$('input[name=userName]').val(userName);
	var frm =$("#projectDetailForm").serialize();/* document.getElementById('projectDetailForm'); */
	
 	$.ajax({
		type:"POST",
		url:"/join/insertJoin.do",
		data: frm,
		success: function(data){
			/* location.reload(); */			
			$("#optionModalInsertMemberId").empty();
			$("#optionModalInsertMemberId").append(data);
		},
		
	}); 
}

function deletejoin(userId,userName,joinNum,workNum,leaderNum,projectNo){
	$('input[name=projectNo]').val(projectNo);
	$('#mes').val("삭제 완료");
	$('input[name=joinId]').val(userId);
	$('input[name=userName]').val(userName);
	var frm =$("#projectDetailForm").serialize();/* document.getElementById('projectDetailForm'); */
		if(leaderNum>1){
			if(joinNum>1){
				 	$.ajax({
						type:"POST",
						url:"/join/deleteJoin.do",
						data: frm,
						success: function(data){
							/* location.reload(); */
								$("#optionModalInsertMemberId").empty();
								$("#optionModalInsertMemberId").append(data);
						}
					});
				}else{
					alert("팀원은 한명이상 있어야 합니다.");
				}
			}else{
				alert("팀장은 한명이상 있어야 합니다.");
			}
}
function selectYReader(userId,userName){
	$('#mes').val("팀장 선택");
	$('input[name=userName]').val(userName);
	$('input[name=joinId]').val(userId);			//*히든에 먼저 아이디를 넣고 업데이트를 시킴 
	var frm =$("#projectDetailForm").serialize();

 	$.ajax({
		type:"POST",
		url:"/join/updateYleader.do",
		data: frm,
		success: function(data){
			/* location.reload(); */
			$("#optionModalInsertMemberId").empty();
			$("#optionModalInsertMemberId").append(data);	
		},		
	}); 

}
function selectNReader(userId,userName,leaderNum){
	$('#mes').val("팀장 해제");
	$('input[name=userName]').val(userName);
	$('input[name=joinId]').val(userId);			//*히든에 먼저 아이디를 넣고 업데이트를 시킴 
	var frm =$("#projectDetailForm").serialize();
		if(leaderNum>1){	
		 	$.ajax({
				type:"POST",
				url:"/join/updateNleader.do",
				data: frm,
				success: function(data){
					/* location.reload(); */
					$("#optionModalInsertMemberId").empty();
					$("#optionModalInsertMemberId").append(data);	
				},		
			});
		}else{
			alert("팀장은 한명이상 있어야 합니다.");
		}
}

</script>
<!--  -->
          <div class="form-group">
            <div class="form-row">
              <div class="col-md-6">
                <div class="input-group-btn">
                <input name="searchkeyword" class="form-control" type="text" maxlength="30" placeholder="아이디,이름 검색" value="${params.searchkeyword}" onkeypress="if(event.keyCode==13){searchMember();}"/>
                <button class="btn btn-primary" type="button" onclick="searchMember()">검색</button>
				</div>	
              </div>
            </div>
            <div class="form-row">
              <div class="col-md-12">
                <table class="table table-bordered dataTable" id="dataTable" role="grid" width="100%" cellspacing="0">
                	<thead>
                		<tr>
                			<th>이름</th>
                			<th>아이디</th>
                			<th>팀원추가/삭제</th>
                			<th>팀장체크</th>
                		</tr>
                	</thead>
                	<tbody>
                	<c:forEach var="list" items="${joinlist}" varStatus="status">
                		<tr>
							<td>${list.loginUserName}</td>
							<td>${list.loginUserId}</td>
							<c:choose>
<%-- 						<c:when test="${list.leaderYn eq 'Y' && joinNum==1}">
								<td><button class="btn btn-default" type="button">삭제</button></td>
							</c:when> --%>
							<c:when test="${list.loginUserId eq list.joinUserId && list.joinProjectNo eq params.projectNo}">
								<td><button class="btn btn-primary" type="button" onclick="deletejoin('${list.loginUserId}','${list.loginUserName}','${joinNum}','${workNum}','${leaderNum}','${params.projectNo}')">삭제</button></td>
							</c:when>
							<c:otherwise>
								<td><button class="btn btn-primary" type="button" onclick="insertjoin('${list.loginUserId}','${list.loginUserName}');">추가</button></td>
							</c:otherwise>
							</c:choose>
							<c:choose>
<%-- 							<c:when test="${list.leaderYn eq 'Y' && joinNum==1}">
									<td><button class="btn btn-default" type="button">팀장</button></td>
								</c:when> --%>
								<c:when test="${list.leaderYn eq 'Y' }">
								<td><button class="btn btn-danger" type="button" onclick="selectNReader('${list.loginUserId}','${list.loginUserName}','${leaderNum}')">*팀장</td>								
								</c:when>
								<c:when test="${list.leaderYn eq 'N'}">
								<td><button class="btn btn-success" type="button" onclick="selectYReader('${list.loginUserId}','${list.loginUserName}')">팀원</td>
								</c:when>
								<c:otherwise>
								<td></td>
								</c:otherwise>
							</c:choose>
                		</tr>
                	</c:forEach>
                	
             		</tbody>
                </table>
              </div>
            </div>
           </div>
      <!-- 페이징 -->
		<div class="col-sm-12 col-md-7">
		<div class="dataTables_paginate paging_simple_numbers" id="dataTable_paginate">
		<ul class="pagination">
			<c:if test="${params.selectPage-1!=0}">
			<li class="paginate_button page-item prvious disable"><button name="prv" class="page-link" onclick="searchMember(${params.selectPage - 1})">이전</button></li>
				</c:if>
			<c:forEach var="pIndex" begin="${params.startpage}" end="${params.endpageNo}" step="1">
				<c:choose>
					<c:when test="${params.currentpage eq pIndex}">
						<li id="pagingNumbering" class="paginate_button page-item active"><a class="page-link" href="#" onclick="searchMember(${pIndex})">${pIndex}</a></li>
					</c:when>
					<c:otherwise>
						<li id="pagingNumbering" class="paginate_button page-item"><a class="page-link" href="#" onclick="searchMember(${pIndex})">${pIndex}</a></li>
					</c:otherwise>
				</c:choose>
			</c:forEach>
			<c:if test="${params.endpage != params.currentpage}">
				<li class="paginate_button page-item next"><button name="next" class="page-link" onclick="searchMember(${params.selectPage +1})">다음</button></li>
			</c:if>
		<input type="hidden" name="joinId" value=""/>
		<input type="hidden" name="userName" value=""/>
		<input type="hidden" name="selectPage" value="${params.selectPage}"/>
		<input type="hidden" name="underPaging" value=""/>
		<input type="hidden" name="startpage" value="${params.startpage}"/>
		<input type="hidden" name="endpageNo" value="${params.endpageNo}"/>
		<input type="hidden" name="projectNo" value="${params.projectNo}"/>

	  	<input type="hidden" id="mes" name="mes" >
		</ul>
		</div>
		</div>
		<!-- 페이징 -->

      
  
