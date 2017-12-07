<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>프로젝트 상세 화면</title>
<%@ include file="/WEB-INF/views/include/design.jsp"%>
<!-- <base target="_self" />   -->
<script>

$(function(){
	  $('form').submit(function() {return false;});
});

function refresh(userId){
	$("#userId").val(userId);
	var frm = document.getElementById('userindivisualForm');
	frm.action="/login/userIndivisualView.do";
	frm.submit(); 
	//location.reload(); //alert가 새로고침시 나오므로 x
}
function logout(){
	var frm = document.getElementById('userindivisualForm');
		alert("로그아웃");
  		frm.action="/login/logout.do";
  		frm.submit();
}

	var emailregExp = /^[0-9a-zA-Z]+@[0-9a-zA-Z]+([.][a-zA-Z]{2,3})+$/i;
	var phoneregExp = /^\d{2,3}-\d{3,4}-\d{4}$/;
	var idregExp=/^[ㄱ-ㅎ|가-힣|a-z|A-Z|0-9|\*]+$/;

	function go_update(){
		var frm = $('#userindivisualForm').serialize();

		if($('input[name=userId1]').val().trim()==""){
			alert("아이디를 입력하시오");
			$('input[name=userId1]').focus();
		}
		else if(!idregExp.test($('input[name=userId1]').val().trim())){
			alert("아이디는 숫자,영어,한글만 사용가능합니다.");
			$('input[name=userId1]').focus();
		}
		else if($('input[name=userPw]').val().trim()==""){
			alert("비밀번호를 입력하시오");
			$('input[name=userPw]').focus();
		}
		else if($('input[name=userRepw]').val().trim()==""){
			alert("재비밀번호를 입력하시오");
			$('input[name=userRepw]').focus();
		}
		else if($('input[name=userPw]').val().trim()!=$('input[name=userRepw]').val().trim()){
			alert("비밀번호랑 비밀번호 재입력을 같게 입력하시오");
			$('input[name=userPw]').focus();
		}		
		else if($('input[name=userName]').val().trim()==""){
			alert("이름을 입력하시오");
			$('input[name=userName]').focus();
		}
		else if($('input[name=userRank]').val().trim()==""){
			alert("직책을 입력하시오");
			$('input[name=userRank]').focus();
		}		
		else if($('input[name=userPosition]').val().trim()==""){
			alert("소속을 입력하시오");
			$('input[name=userPosition]').focus();
		}
		else if($('input[name=userEmail]').val().trim()==""){
			alert("이메일을 입력하시오");
			$('input[name=userEmail]').focus();
		}
		else if(!emailregExp.test($('input[name=userEmail]').val().trim())){
			alert("잘못된 형식의 이메일 입니다.")
			$('input[name=userEmail]').focus();
		}
		else if($('input[name=userPhoneNumber]').val().trim()==""){
			alert("전화번호를 입력하시오");
			$('input[name=userPhoneNumber]').focus();
		}
		else if(!phoneregExp.test($('input[name=userPhoneNumber]').val().trim())){
			alert("잘못된 형식의 전화번호 입니다. ");
			$('input[name=userPhoneNumber]').focus();
		}
		else{
			$.ajax({
  			type:"POST",
  			url:"/login/checkId.do",
  			data: frm,
  			success: function(data){
				$('#mes').val("수정 완료");
				$.post("/login/updatUserInfo.do",frm,function(data){
					$('#optionModal').modal("show");
					$('#updateUserInfo').modal("hide");
				});
  			}
  		});
		} 
	}
	function checkId(){	
/*   		if($('input[name=userId]').val().trim()=="")
			alert("아이디를 입력하시오");
		else{ */
  		$.ajax({
  			type:"POST",
  			url:"/login/checkId.do",
  			data: {"userId":$('input[name=userId]').val().trim()},
  			success: function(data){
  				if($('input[name=userId]').val()==$('input[name=gibonId]').val()){
  					$("#Ymessage").html("사용할 수 있는 아이디 입니다.");
  					$("#Nmessage").empty();
  				}else if(data>0){
/* 	  					$('#insertMember').attr('disabled',true);	//아이디가 이미 존재하면 버튼을 다시 disabled true */
  					$("#Nmessage").html("아이디가 중복입니다.");
  					$("#Ymessage").empty();
  				}
  				else if($('input[name=userId1]').val().trim()==""){
  					$("#Nmessage").html("*필수 입력 항목 입니다.");
  					$("#Ymessage").empty();
  				}else{
  					$("#Ymessage").html("사용할 수 있는 아이디 입니다.");
  					$("#Nmessage").empty();
  				}
  				
  			}
  		});
		/* } */ 
	}
	function check_key(){
		if(event.keyCode>=48&&event.keyCode<=57){
			return true;
		}else if(event.keyCode==45){
			return true;
		}else
			event.returnValue=false;
	}
	function checkPw(){	
	if($('input[name=userPw]').val().trim()!=$('input[name=userRepw]').val().trim()){
		$("#pwN_message").html("비밀 번호와 재입력 비밀번호가  다릅니다!");
		$("#pwY_message").empty();
	}else if($('input[name=userPw]').val().trim()==""){
		$("#pwN_message").html("*필수 입력 항목 입니다.");
		$("#pwY_message").empty();
	}else{
		$("#pwY_message").html("사용가능한 비밀번호입니다.");
		$("#pwN_message").empty();
	}
}
function checkEmail(){	
		if($('input[name=userEmail]').val().trim()==""){
			$("#emN_message").html("*필수 입력 항목 입니다.");
			$("#emY_message").empty();
		}else if(!emailregExp.test($('input[name=userEmail]').val().trim())){
			$("#emN_message").html("잘못된 형식의 이메일 입니다.");
			$("#emY_message").empty();
		}else{
			$("#emN_message").empty();
		}
}
function checkPhone(){
  		if($('input[name=userPhoneNumber]').val().trim()==""){
			$("#phN_message").html("*필수 입력 항목 입니다.");
			$("#phY_message").empty();
		}else if(!phoneregExp.test($('input[name=userPhoneNumber]').val().trim())){
			$("#phN_message").html("잘못된 형식의 전화번호 입니다.");
			$("#phY_message").empty();
		}else{
			$("#phN_message").empty();
		}
}
	function go_delete(){
		var frm = document.getElementById('userindivisualForm');
		var retVal = confirm($('input[name=gibonId]').val()+"님을 삭제 하시겠습니까?");
		if(retVal==true){
			$('#mes').val("삭제 완료");
			frm.action="/login/deletemember.do";
		  	frm.submit();
		}
	}
	function pwCheck(){
		if($('input[name=pwcheck]').val().trim()==""){
			alert("비밀번호를 입력하시오.");
		}else{
	  		$.ajax({
	  			type:"POST",
	  			url:"/login/pwCheck.do",
	  			data: {"userPw":$('input[name=pwcheck]').val().trim(),"userId":$('input[name=userId]').val()},
	  			success: function(data){
	  				if(data>=1){
						$("#pwCheck").modal("hide");
						$("#updateUserInfo").modal("show");	
	  				}else{
	  					alert("비밀번호가 틀렷습니다.");
	  				}
	  			},
	  		});
		}
	}

	function searchWork1(pIndex){
		$('input[name=selectPage]').val(pIndex);
		
		var frm =$("#projectDetailForm").serialize();
		$.ajax({
			type:"POST",
			url:"/login/userIndivisualView.do",
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
</head>
<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<form name="userindivisualForm" id="userindivisualForm" method="post">
		<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top" id="mainNav">
		<div class="input-group">
			<a class="navbar-brand" href="/project/main.do">Code-Farm 현황판</a> <label
				class="navbar-brand"><%=session.getAttribute("userName")%>(<%=session.getAttribute("userId")%>)님
			</label>
			<button class="navbar-toggler navbar-toggler-right" type="button"
				data-toggle="collapse" data-target="#navbarResponsive"
				aria-controls="navbarResponsive" aria-expanded="false"
				aria-label="Toggle navigation" align="right">
				<span class="navbar-toggler-icon"></span>
			</button>
		</div>
		<div class="collapse navbar-collapse" id="navbarResponsive">
			<ul class="navbar-nav navbar-sidenav" id="exampleAccordion">
				<li class="nav-item"><a class="nav-link"
					href="/project/main.do"> <i class="fa fa-fw fa-file"></i> <span
						class="nav-link-text">프로젝트</span>
				</a></li>
				<li class="nav-item"><a class="nav-link"
					href="/login/indivisualView.do"> <i class="fa fa-fw fa-file"></i>
						<span class="nav-link-text">개인</span>
				</a></li>
				<c:if test="${adminYn=='Y'}">
					<li class="nav-item"><a class="nav-link"
						href="/login/memberlist.do"> <span class="nav-link-text">회원관리</span>
					</a></li>
				</c:if>
				<li class="nav-item"><a class="nav-link" href="#"
					onclick="logout()"> <span class="nav-link-text">로그아웃</span>
				</a></li>
			</ul>
		</div>
		</nav>
		<div class="content-wrapper">
			<div class="container-fluid">
				<ol class="breadcrumb">
					<li class="breadcrumb-item">${userInfo.userRank}</li>
					<li class="breadcrumb-item active">${userInfo.userName}</li>
					<c:if
						test="${params.adminYn=='Y' || params.userId eq userInfo.userId }">
						<!-- 관리자인지 아닌지 자기자신인지 아닌지 -->
						<li>
							<button type="button" class="btn btn-primary" data-toggle="modal"
								data-target="#optionModal">설정</button>
						</li>
					</c:if>
				</ol>
				<div class="card mb-3">
					<div class="card-body bg-faded">
						<div class="row">
							<div class="media">
								<img whidth="200" height="200" src="/css/noimg.PNG">
								<div class="media-body">
									<ul class="list-inline mb-0">>개인정보	</ul>
									<ul class="list-inline mb-0">이름 : ${userInfo.userName}</ul>
									<ul class="list-inline mb-0">직책 : ${userInfo.userRank}</ul>
									<ul class="list-inline mb-0">소속 : ${userInfo.userPosition}</ul>
									<ul class="list-inline mb-0">이메일 : ${userInfo.userEmail}</ul>
									<ul class="list-inline mb-0">전화번호:	${userInfo.userPhoneNumber}</ul>
									<ul class="list-inline mb-0"></ul>
									<ul class="list-inline mb-0">>진행중인 프로젝트</ul>
									<c:forEach var="userProjectInfo" items="${userProjectInfo}" >
									<c:set var="array" value="${fn:split(userProjectInfo.projectName,',')}" />
									</c:forEach>
									<c:forEach var="list" items="${array}" >
										${list}
									</c:forEach>
								</div>
							</div>
						</div>
						<div class="row"></div>
						<div class="row">
							<div class="col-sm-12 col-md-7"></div>
						</div>
					</div>
				</div>
				<div class="card mb-3">
					<div class="card-body bg-faded">
						<div class="row">개인 업무 진행 리스트</div>
						<div id="userworklist">

							<div class="col-md-6">
								<div class="input-group-btn">
									<span class="input-group-btn"> <select
										class="form-control" name="searchOption1">
											<option value="1"
												${params.searchOption1 eq "1" ? "selected" : ""}>업무번호</option>
											<option value="2"
												${params.searchOption1 eq "2" ? "selected" : ""}>업무명</option>
									</select> <input name="searchkeyword1" class="form-control" type="text"
										maxlength="30" placeholder="" value="${params.searchkeyword1}"
										onkeypress="if(event.keyCode==13){searchWork1();}" />
										<button class="btn btn-primary" type="submit"
											onclick="searchWork1()">검색</button>
									</span>
								</div>
							</div>
							<table class="table table-bordered dataTable" id="dataTable"
								role="grid" width="100%" cellspacing="0">
								<thead>
									<tr>
										<th><input type="checkbox" name="allcheckbox"
											onclick="allclick();" /></th>
										<th>순번</th>
										<th>업무번호</th>
										<th>업무명</th>
										<th>기간</th>
										<th>진행자</th>
										<th>진행상태</th>
										<c:choose>
											<c:when test="${joinMemberCheck.userId!=null || joinMemberCheck.leaderYn=='Y'|| params.adminYn=='Y'}">
												<th>취소</th>
												<th>완료</th>
											</c:when>
										</c:choose>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="userWorkList" items="${userWorkList}"
										varStatus="status">
										<tr>
											<c:choose>
												<c:when
													test="${joinMemberCheck.leaderYn=='Y' || params.adminYn=='Y'}">
													<td><input type="checkbox" name="checkbox"
														value="${userWorkList.workNo}"></td>
												</c:when>
												<c:when
													test="${params.adminYn=='N' && params.userId==userWorkList.userId}">
													<td><input type="checkbox" name="checkbox"
														value="${userWorkList.workNo}"></td>
												</c:when>
												<c:otherwise>
													<td><input type="checkbox" name="checkbox"
														value="${userWorkList.workNo}" disabled="true"></td>
												</c:otherwise>
											</c:choose>
											<td>${params.currentpageDB=params.currentpageDB+1}</td>
											<td><c:choose>
													<c:when
														test="${joinMemberCheck.userId!=null || joinMemberCheck.leaderYn=='Y'|| params.adminYn=='Y'}">
														<a href="#" data-toggle="modal"
															data-target="#updateWorkListModal"
															onclick="updateWorkListModalView(${userWorkList.workNo})">${userWorkList.workNum}</a>
													</c:when>
													<c:otherwise>
														${userWorkList.workNum}
													</c:otherwise>
												</c:choose>
											</td>
											<td>${userWorkList.workSubject}</td>
											<td>${userWorkList.startDate}~ ${userWorkList.endDate}</td>
											<td>${userWorkList.userName}</td>
											<td>${userWorkList.state}</td>
											<c:choose>
												<c:when
													test="${userWorkList.userId==params.userId || joinMemberCheck.leaderYn=='Y'|| params.adminYn=='Y'}">
													<c:choose>
														<c:when
															test="${joinMemberCheck.leaderYn=='Y' || params.adminYn=='Y'}">
															<td><a href="#checklist"
																onclick="workCancel(${userWorkList.workNo})">취소하기</a></td>
															<td><a href="#checklist"
																onclick="workComplete(${userWorkList.workNo})">완료하기</a></td>
														</c:when>
														<c:when
															test="${params.adminYn=='N' && params.userId==userWorkList.userId}">
															<td><a href="#checklist"
																onclick="workCancel(${userWorkList.workNo})">취소하기</a></td>
															<td><a href="#checklist"
																onclick="workComplete(${userWorkList.workNo})">완료하기</a></td>
														</c:when>
													</c:choose>
												</c:when>
											</c:choose>
										</tr>
									</c:forEach>
								</tbody>
							</table>

							<div class="col-sm-12 col-md-7">
								<div class="dataTables_paginate paging_simple_numbers"
									id="dataTable_paginate">
									<ul class="pagination">
										<c:if test="${params.selectPage-1!=0}">
											<li class="paginate_button page-item prvious disable"><button
													name="prv" class="page-link"
													onclick="searchWork1(${params.selectPage - 1})">이전</button></li>
										</c:if>
										<c:forEach var="pIndex" begin="${params.startpage}"
											end="${params.endpageNo}" step="1">
											<c:choose>
												<c:when test="${params.currentpage eq pIndex}">
													<li id="pagingNumbering"
														class="paginate_button page-item active"><a
														class="page-link" href="#worklist"
														onclick="searchWork1(${pIndex})">${pIndex}</a></li>
												</c:when>
												<c:otherwise>
													<li id="pagingNumbering" class="paginate_button page-item"><a
														class="page-link" href="#worklist"
														onclick="searchWork1(${pIndex})">${pIndex}</a></li>
												</c:otherwise>
											</c:choose>
										</c:forEach>
										<c:if test="${params.endpage != params.currentpage}">
											<li class="paginate_button page-item next"><button
													name="next" class="page-link"
													onclick="searchWork1(${params.selectPage +1})">다음</button></li>
										</c:if>
										<input type="hidden" name="joinId" value="" />
										<input type="hidden" name="selectPage"
											value="${params.selectPage}" />
										<input type="hidden" name="underPaging" value="" />
										<input type="hidden" name="startpage"
											value="${params.startpage}" />
										<input type="hidden" name="endpageNo"
											value="${params.endpageNo}" />
										<input type="hidden" name="projectNo"
											value="${projectdetail.projectNo}" />
									</ul>
								</div>
							</div>
							<div class="col-sm-12">
								<c:if
									test="${ joinMemberCheck.userId==params.userId || params.adminYn=='Y'}">
									<button class="btn btn-primary" type="button"
										onclick="go_multicomplete()">완료</button>
									<button class="btn btn-default" type="button"
										onclick="go_multicancel()">취소</button>
								</c:if>
							</div>
							<input type="hidden" name="workNo" id="workNo" />
						</div>
					</div>
				</div>
				<button type="button" class="btn btn-primary">내 히스토리</button>
			</div>
		</div>
		<input type="hidden" name="userId" id="userId" value="${userInfo.userId}" />

		<!-- porjectModal -->
		<div class="modal fade" id="optionModal">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title">설정</h4>
						<button type="button" class="close" data-dismiss="modal"
							onclick="refresh('${userInfo.userId}')">
							<span>x</span>
						</button>
					</div>
					<div class="modal-body">
					<c:choose>
					<c:when test="${params.adminYn=='Y'}">
						<button type="button" class="btn btn-primary btn-block" data-toggle="modal" data-target="#updateUserInfo"  data-dismiss="modal">정보 수정하기</button>
					</c:when>
					<c:otherwise>
						<button type="button" class="btn btn-primary btn-block" data-toggle="modal" data-target="#pwCheck"  data-dismiss="modal">정보 수정하기</button>
					</c:otherwise>	
					</c:choose>
						<button tpye="button" class="btn btn-primary btn-block"
							data-toggle="modal" data-target="" onclick=""
							data-dismiss="modal">회원 탈퇴</button>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal"
							onclick="refresh('${userInfo.userId}')">닫기</button>
					</div>
				</div>
			</div>
		</div>
		<!-- porjectModal -->

		<!-- porjectModal -->
		<div class="modal fade" id="pwCheck">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title">비밀번호 확인</h4>
						<button type="button" class="close" data-dismiss="modal"
							onclick="refresh('${userInfo.userId}')">
							<span>x</span>
						</button>
					</div>
					<div class="modal-body">
						<div class="form-row">
							<div class="col-md-6">
								<label>*비밀번호 입력</label>
								<div class="input-group-btn">
									<input class="form-control" type="text" name="pwcheck" />
								</div>
							</div>
						</div>
						<div class="form-row">
							<div class="btn-group">
								<button type="button" class="btn btn-primary" onclick="pwCheck()">확인</button>
							</div>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal" data-toggle="modal" data-target="#optionModal">뒤로</button>
					</div>
				</div>
			</div>
		</div>
		<!-- porjectModal -->

		<!-- porjectModal -->
		<div class="modal fade" id="updateUserInfo">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title">회원정보 수정</h4>
						<button type="button" class="close" data-dismiss="modal"
							onclick="refresh('${userInfo.userId}')">
							<span>x</span>
						</button>
					</div>
					<div class="modal-body">
						<div id="updateUserInfo">
							<div class="form-group">
								<div class="form-row">
									<div class="col-md-6">
										<input type="hidden" id="mes" name="mes"> <label>*아이디</label>
										<div class="input-group-btn">
											<input name="userId1" id="userId1" class="form-control"
												type="text" value="${userInfo.userId}" maxlength="8"
												oninput="checkId()" disabled> <input type="hidden"
												name="gibonId" value="${userInfo.userId}">
										</div>
										<label style="color: green" id="Ymessage"></label> <label
											style="color: red" id="Nmessage"></label>
									</div>
								</div>
								<div class="form-row">
									<div class="col-md-6">
										<label>*비밀번호</label> <input name="userPw" class="form-control"
											type="password" value="${userInfo.userPw}"
											oninput="checkPw()">
									</div>
								</div>
								<div class="form-row">
									<div class="col-md-6">
										<label>*비밀번호 재입력</label> <input name="userRepw"
											class="form-control" type="password" value="${repw}"
											oninput="checkPw()">
									</div>
								</div>
								<label style="color: green" id="pwY_message"></label> <label
									style="color: red" id="pwN_message"></label>
								<div class="form-row">
									<div class="col-md-6">
										<label>*이름</label> <input name="userName" class="form-control"
											maxlength="8" type="text" value="${userInfo.userName}">
									</div>
								</div>
								<div class="form-row">
									<div class="col-md-6">
										<label>*직책</label> <input name="userRank" class="form-control"
											maxlength="8" type="text" value="${userInfo.userRank}">
									</div>
								</div>
								<div class="form-row">
									<div class="col-md-6">
										<label>*소속</label> <input name="userPosition"
											class="form-control" maxlength="8" type="text"
											placeholder="ex) 개발팀" value="${userInfo.userPosition}">
									</div>
								</div>
								<div class="form-row">
									<div class="col-md-6">
										<label for="exampleInputEmail1">*이메일</label> <input
											class="form-control" name="userEmail" maxlength="24"
											type="email" placeholder="ex) dudo200@codefarm.co.kr"
											value="${userInfo.userEmail}" oninput="checkEmail()">
									</div>
								</div>
								<label style="color: green" id="emY_message"></label> <label
									style="color: red" id="emN_message"></label>
								<div class="form-row">
									<div class="col-md-6">
										<label>*전화번호</label> <input name="userPhoneNumber"
											class="form-control" maxlength="24" type="text"
											placeholder="ex) 010-1111-1111"
											value="${userInfo.userPhoneNumber}" onkeypress="check_key()"
											oninput="checkPhone()">
									</div>
								</div>
							</div>
							<label style="color: green" id="phY_message"></label> <label
								style="color: red" id="phN_message"></label>
							<div class="form-row">
								<div class="btn-group">
									<button name="updateMember" id="insertMember"
										class="btn btn-primary " onclick="go_update()">수정</button>
									<c:if test="${memberinfo.adminYn=='N'}">
										<button name="deleteMember" id="deleteMember"
											class="btn btn-primary " onclick="go_delete()">삭제</button>
									</c:if>
									<a href="/login/memberlist.do" class="btn btn-primary"> 뒤로
									</a>
								</div>
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-default"
									data-dismiss="modal" data-toggle="modal"
									data-target="#optionModal">뒤로</button>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- porjectModal -->
		</div>
	</form>
</body>
</html>