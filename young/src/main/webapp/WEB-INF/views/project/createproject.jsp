<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file ="/WEB-INF/views/include/design.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>프로젝트 생성 페이지</title>
<script>
$(function(){
	  $('form').submit(function() {return false;});
});
function insertProject(){
	var frm = document.getElementById('projectForm');
	
	if(parseInt($("#start").val())>parseInt($("#end").val())){
			alert("시작일과 종료일을 확인하세요.");
			$('input[name=projectStartDate]').focus();
	}else if($('input[name=projectName]').val().trim()==""){
  			alert("프로젝트명을 입력하시오");
  			$('input[name=projectName]').focus();
  	}else if($('input[name=institutionName]').val().trim()==""){
  			alert("기관명을 입력하시오");
  			$('input[name=institutionName]').focus();
  	}else if($('input[name=projectStartDate]').val().trim()==""){
  			alert("시작일을 입력하시오");
  			$('input[name=projectStartDate]').focus();
  	}else if($('input[name=projectEndDate]').val().trim()==""){
  			alert("종료일을 입력하시오");
  			$('input[name=projectEndDate]').focus();
  	}else{
		$('#mes').val("프로젝트 생성 완료");
		frm.action="/project/insertProject.do";
		frm.submit();
	}
}
$(function(){
	$.datepicker.setDefaults({
		dateFormat: 'yymmdd',
		prevText: '이전 달',
		nextText: '다음 달',
		monthNames:['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		monthNamesShort:['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		dayNames:['일','월','화','수','목','금','토'],
		dayNamesShort:['일','월','화','수','목','금','토'],
		dayNamesMin:['일','월','화','수','목','금','토'],
		showOtherMonths:true,
		selectOtherMonths:true,
		
	});
	$("#start").datepicker({
		showAnimation:'slide',
	});
	$("#end").datepicker({
		showAnimation:'slide',
	});
});
/* 	function nocheck(){
  		if(event){
  			event.returnValue=false;
  	} */
</script>
</head>
<body class="bg-dark">
<form name="projectForm" id="projectForm" enctype="multipart/form-data">
  <div class="container">
    <div class="card card-register mx-auto mt-5">
      <div class="card-header">프로젝트 생성</div>
      <div class="card-body">
          <div class="form-group">
            <div class="form-row">
              <div class="col-md-6">
                <label>*프로젝트명</label>
                <input type="hidden" id="mes" name="mes"/>
                <div class="input-group-btn">
                <input name="projectName" class="form-control" type="text" maxlength="30">
				</div>
              </div>
            </div>
            <div class="form-row">
              <div class="col-md-6">
                <label>*기관명</label>
                <div class="input-group-btn">
                <input name="institutionName" class="form-control" type="text" maxlength="30" >
				</div>
              </div>
            </div>
            <div class="form-row">
              <div class="col-md-6">
                <label>*시작일</label>
                <div class="input-group-btn">
                <input id="start" name="projectStartDate" class="form-control" placeholder="시작일 선택" type="text" readOnly/>
				</div>
              </div>
            </div>
            <div class="form-row">
              <div class="col-md-6">
                <label>*종료일</label>
                <div class="input-group-btn">
                <input id="end" name="projectEndDate" class="form-control" placeholder="종료일 선택" type="text" readOnly/>
				</div>
              </div>
            </div>
            <div class="form-row">
              <div class="col-md-6">
                <label>*상태</label>
                <div class="input-group-btn">
                <select class="form-control" name="projectState">
					<option value="1" ${params.projectState eq "1" ? "selected" : ""}>평소</option>
					<option value="2" ${params.projectState eq "2" ? "selected" : ""}>긴급</option>
					<option value="3" ${params.projectState eq "3" ? "selected" : ""}>매우긴급</option>
				</select> 
				</div>
              </div>
            </div>
            <div class="form-row">
              <div class="col-md-6">
                <label>내용</label>
                </div>
            </div>
            <div class="form-row">
              <div class="col-md-6">
                <textarea name="projectContent" class="textarea"  maxlength="1000"></textarea>
 				</div>
            </div>
			<button name="insert1" class="btn btn-primary btn-block" onclick="insertProject()" >
         	 프로젝트생성
            </button>
        <div class="text-center">
          <a class="d-block small mt-3" href="/project/main.do">뒤로</a>
        </div>									
      </div>
    </div>
  </div>
  <input type="hidden" id="mes" name="mes"/>
  </form>
</body>
</html>