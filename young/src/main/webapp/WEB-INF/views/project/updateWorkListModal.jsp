<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script>
function completeWorkList(){
	
	$('#mes').val("업무 완료");
	var frm = document.getElementById('projectDetailForm');/* document.getElementById('projectDetailForm'); */

 		if(parseInt($("#startDate").val())>parseInt($("#endDate").val())){
				alert("시작일과 종료일을 확인하세요.");
				$("#startDate").focus();
			}else if($('input[name=workNum]').val().trim()==""){
					alert("업무번호을 입력하시오");
					$('input[name=workNum]').focus();
			}else if($('input[name=workSubject]').val().trim()==""){
					alert("업무명을 입력하시오");
					$('input[name=workSubject]').focus();
			}else if($('textarea[name=workContent]').val().trim()==""){
					alert("업무내용을 입력하시오");
					$('textarea[name=workContent]').focus();
			}else if($('input[name=startDate]').val().trim()==""){
					alert("시작일을 입력하시오");
					$('input[name=startDate]').focus();
			}else if($('input[name=endDate]').val().trim()==""){
					alert("종료일을 입력하시오");
					$('input[name=endDate]').focus();
			}else{	 
				frm.action="/project/completeWorkList.do";
				frm.submit();
			}
}
function updateWorkListModalId(){
	$('#mes').val("업무 수정 성공");
	var frm = document.getElementById('projectDetailForm');/* document.getElementById('projectDetailForm'); */

 		if(parseInt($("#startDate").val())>parseInt($("#endDate").val())){
				alert("시작일과 종료일을 확인하세요.");
				$("#startDate").focus();
			}else if($('input[name=workNum]').val().trim()==""){
					alert("업무번호을 입력하시오");
					$('input[name=workNum]').focus();
			}else if($('input[name=workSubject]').val().trim()==""){
					alert("업무명을 입력하시오");
					$('input[name=workSubject]').focus();
			}else if($('textarea[name=workContent]').val().trim()==""){
					alert("업무내용을 입력하시오");
					$('textarea[name=workContent]').focus();
			}else if($('input[name=startDate]').val().trim()==""){
					alert("시작일을 입력하시오");
					$('input[name=startDate]').focus();
			}else if($('input[name=endDate]').val().trim()==""){
					alert("종료일을 입력하시오");
					$('input[name=endDate]').focus();
			}else{	 
				frm.action="/project/updateCheckList.do";
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
	$("#endDate").datepicker({
		showAnimation:'slide',
	});
	$("#startDate").datepicker({
		showAnimation:'slide',
	});

});

</script>
<!--  -->       
          <div class="form-group">
            <div class="form-row">
              <div class="col-md-6">
                <label>*업무번호</label>
                <div class="input-group-btn">
                <input name="workNum" class="form-control" type="text" maxlength="30" value="${updateWorkListModalView.workNum}" />
				</div>
              </div>
            </div>
            <div class="form-row">
              <div class="col-md-6">
                <label>*업무명</label>
                <div class="input-group-btn">
                <input name="workSubject" class="form-control" type="text" maxlength="30" value="${updateWorkListModalView.workSubject}" />
				</div>
              </div>
            </div>
            <div class="form-row">
              <div class="col-md-6">
                <label>*업무 세부내용</label>
                <div class="input-group-btn">
                <textarea name="workContent" class="form-control" maxlength="1000">${updateWorkListModalView.workContent}</textarea>
				</div>
              </div>
            </div>
            <div class="form-row">
              <div class="col-md-6">
                <label>*시작일</label>
                <div class="input-group-btn">
                <input name="startDate" id="startDate" class="form-control" placeholder="시작일 선택" type="text" value="${updateWorkListModalView.startDate}"  readOnly/>
				</div>
              </div>
            </div>
             <div class="form-row">
              <div class="col-md-6">
                <label>*종료일</label>
                <div class="input-group-btn">
                <input name="endDate" id="endDate" class="form-control" placeholder="종료일 선택" type="text" value="${updateWorkListModalView.endDate}" readOnly/>
				</div>
              </div>
            </div>
            <div class="form-row">
              <div class="col-md-6">
                <div class="input-group-btn" id="memo" style="display:none">
                <textarea class="form-control" > </textarea>
				</div>
              </div>
            </div>
            
<!--             <div class="form-row">
              <div class="col-md-6">
                <label>*메모</label>
                <div class="input-group-btn">
                <textarea name="memo" id="memo" class="form-control"></textarea>
				</div>
              </div>
            </div> -->
      </div>
      <c:if test="${updateWorkListModalView.userId==params.userId || params.adminYn=='Y'}">
      <button type="button" class="btn btn-primary" onclick="updateWorkListModalId()">수정</button>
      </c:if>
      <button type="button" id="openMemo" class="btn btn-primary" onclick="openMemo()">메모작성</button>
      <button type="button" id="createMemo" class="btn btn-primary" onclick="createMemo()" style="display:none">메모생성</button>
      <c:if test="${updateWorkListModalView.userId==params.userId || params.adminYn=='Y'}">
      	<button type="button" class="btn btn-primary" onclick="completeWorkList()">완료하기</button>
	  </c:if>