<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script>
$(function(){
	$('form').submit(function() {return false;});
});


function giveWorkMulti(userId){
	$('#mes').val("업무 주기 완료");
	$('#JoinId').val(userId);
	var frm =document.getElementById('projectDetailForm');
 	  		var retVal = confirm("정말로 하시겠습니까?");
 	  		if(retVal){
 	  			frm.action="/project/giveWorkMulti.do";
 	  			frm.submit();
 	  		}else{
 	  			alert("취소");
 	  		}
}
</script>
<!--  -->
          <div class="form-group">
            <div class="form-row">
              <div class="col-md-6">
                <div class="input-group-btn">
                <input name="searchkeyword" class="form-control" type="text" maxlength="30" placeholder="아이디,이름 검색" value="${params.searchkeyword}"/>
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
                			<th>업무주기</th>
                		</tr>
                	</thead>
                	<tbody>
                	<c:forEach var="list" items="${joinlist}" varStatus="status">
                		<tr>
							<td>${list.loginUserName}</td>
							<td>${list.loginUserId}</td>
							<td><button class="btn btn-primary" onclick="giveWorkMulti('${list.loginUserId}')">업무주기</button></td>
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
		<input type="hidden" id="JoinId" name="JoinId" value=""/>
		<input type="hidden" name="userName" value=""/>
		<input type="hidden" name="selectPage" value="${params.selectPage}"/>
		<input type="hidden" name="underPaging" value=""/>
		<input type="hidden" name="startpage" value="${params.startpage}"/>
		<input type="hidden" name="endpageNo" value="${params.endpageNo}"/>
		<input type="hidden" name="projectNo" value="${projectdetail.projectNo}"/>
		
	  	<input type="hidden" id="mes" name="mes"/>
		</ul>
		</div>
		</div>
		<!-- 페이징 -->
