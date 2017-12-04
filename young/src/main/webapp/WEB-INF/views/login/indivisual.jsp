<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/WEB-INF/views/include/design.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script>
$(function(){
	  $('form').submit(function() {return false;});
});
/* 페이징 */
function searchMember(pIndex){
		$('input[name=selectPage]').val(pIndex);
		
		var frm = document.getElementById('mainForm');
		
		frm.action = "/login/indivisualView.do";
		frm.submit();	
}
/* 페이징 */
	function logout() {
		var frm = document.getElementById('mainForm');
		alert("로그아웃");
		frm.action = "/login/logout.do";
		frm.submit();
	}

	function searchProject() {
		
		
	}

</script>
<title>Code-Farm 현황판</title>
</head>
<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<form id="mainForm" method="post">
		<!-- Navigation-->
		<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top" id="mainNav">
		<div class="input-group">
			<span class="input-group-btn" > 
			<!-- 검색 -->
			<select class="form-control" name="searchOption1" width="1000">
					<option value="1" ${params.searchOption1 eq "1" ? "selected" : ""}>이름</option>
					<option value="2" ${params.searchOption1 eq "2" ? "selected" : ""}>직책</option>
					<option value="3" ${params.searchOption1 eq "3" ? "selected" : ""}>팀</option>
					<option value="4" ${params.searchOption1 eq "4" ? "selected" : ""}>프로젝트</option>
			</select>
			</span> 
			<span class="input-group-btn"> 
			<input class="form-control" type="text" name="searchkeyword" value="${params.searchkeyword}" />
			<button class="btn btn-primary" onclick="">
				<i class="fa fa-search"></i>
			</button>
			<!--  -->	
			</span> <a class="navbar-brand" href="/project/main.do">&emsp;&emsp;&emsp; Code-Farm현황판</a>
			<label class="navbar-brand"><%=session.getAttribute("userId")%>님
			</label>
			<button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation" align="right">
				<span class="navbar-toggler-icon"></span>
			</button>
		</div>
		<div class="collapse navbar-collapse" id="navbarResponsive">
			<ul class="navbar-nav navbar-sidenav" id="exampleAccordion">
				<li class="nav-item">
					<a class="nav-link" href="/project/main.do"> 
					<i class="fa fa-fw fa-file"></i> 
					<span class="nav-link-text">프로젝트</span>
				</a>
				</li>
				<li class="nav-item" >
					<a class="nav-link" href="/login/indivisualView.do"> 
					<i class="fa fa-fw fa-file"></i>
					<span class="nav-link-text">개인</span>
				</a>
				</li>
				<li class="nav-item" >
					<a class="nav-link" href="/login/memberlist.do"> 
					<span class="nav-link-text">회원관리</span>
				</a>
				</li>
				<li class="nav-item">
					<a href="#" class="nav-link" onclick="logout();"> 
					<span class="nav-link-text">로그아웃</span>
				</a>
				</li>
			</ul>
		</div>
		</nav>
		<div class="content-wrapper">
			<div class="container-fluid">
				<!-- Breadcrumbs-->
				<ol class="breadcrumb">
					<li class="breadcrumb-item"><a href="#">개인</a></li>
					<li class="breadcrumb-item active">개인 참여 현황</li>
				</ol>
				<!-- Icon Cards-->
				<div class="row">
					<table>
						<c:forEach var="indivisualView" items="${indivisualView}">
							<div class="col-xl-3 col-sm-6 mb-3">
								<div class="card text-white o-hidden h-5 bg-info">
									<!-- 색 치환 -->
									<div class="card-body">										
										<div class="mr-3">${indivisualView.userPosition} ${indivisualView.userRank} <h4>${indivisualView.userName}</h4></div>
										<div class="mr-3"> </div>
										<div class="mr-3">*진행중인 프로젝트</div>
											<c:forEach var="iVproject" items="${iVproject}">
		 										<c:if test="${indivisualView.userId==iVproject.userId}">
													<li class="mr-3"> ${iVproject.projectName}</li>
												</c:if> 
											</c:forEach>
										<div class="mr-3">업무량:
											<c:forEach var="iVwork" items="${iVwork}" varStatus="status">
		 										<c:if test="${indivisualView.userId==iVwork.userId}">
													<div class="mr-3">${iVwork.count}</div>
												</c:if> 
											</c:forEach>
										</div>
									</div>
									<button class="card-footer text-white clearfix small z-1">
										<span class="float-left">자세히</span> <span class="float-right">
											<i class="fa fa-angle-right"></i>
									</span>
									</button>
								</div>
							</div>
						</c:forEach>
					</table>
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
		<input type="hidden" name="selectPage" value="${params.selectPage}"/>
		<input type="hidden" name="startpage" value="${params.startpage}"/>
		<input type="hidden" name="endpageNo" value="${params.endpageNo}"/>
		<input type="hidden" name="projectNo" value="${projectdetail.projectNo}"/>
		</ul>
		</div>
		</div>
		<!-- 페이징 -->
			</div>
			</div>
			<input type="hidden" id="mes" name="mes" >
		<input type="hidden" name="projectNo" value=""/>
	</form>
</body>
</html>
