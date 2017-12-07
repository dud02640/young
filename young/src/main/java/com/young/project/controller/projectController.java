package com.young.project.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.text.DateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.catalina.servlet4preview.http.HttpServletRequest;
import org.apache.jasper.tagplugins.jstl.core.Out;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.young.login.sevice.loginService;
import com.young.project.service.projectService;
import com.young.join.service.joinService;
/**
 * Handles requests for the application home page.
 */
@Controller
public class projectController {
	
	private static final Logger logger = LoggerFactory.getLogger(projectController.class);
	
	@Resource(name="projectService")
	private projectService projectService;
	
	@Resource(name="loginService")
	private loginService loginService;

	@Resource(name="joinService")
	private joinService joinService;
	
	
	@RequestMapping(value = "/project/main.do")
	public String loginCheck(HttpServletRequest req,@RequestParam Map<String,Object> params ,Model model) throws IOException {		
		
		HttpSession session = req.getSession();		
		params.put("adminYn", session.getAttribute("adminYn"));
		List<Map<String,Object>> JoinId= joinService.selectJoinId(params);		
		List<Map<String,Object>> projectLeader= joinService.projectLeader(params);
		//페이징//
		int currentpage=(params.get("selectPage")==null||params.get("selectPage")==""? 1:Integer.parseInt(params.get("selectPage").toString()));
		int startpage=(params.get("startpage")==null? 1:1);
		int endpageNo=(params.get("endpageNo")==null? 10:10);
		int endpage = 0;
		int currentpageDB=0;				//DB에서의 시작 컬럼 번호
		int paging=8;						//한페이지당 list 컬럼의 수
		
		 //다음버튼 클릭시 첫페이지랑 마지막 페이지를 +10 
		if(endpageNo<currentpage) {
			startpage=endpageNo+1;
			endpageNo+=10;	
		}
		 //이전버튼 클릭시 첫페이지를 -10 마지막 페이지는 startpage에서 +10 (endpageNo가 유동적으로 바뀌므로 startpage를 기준잡음)  
		else if(currentpage<startpage) {	
			startpage-=10;
			endpageNo=startpage+9;
		}						
		
		if(params.get("selectPage")==null||params.get("selectPage")=="") {
			currentpageDB=0;
			params.put("selectPage",startpage);
		}else 
			currentpageDB=Integer.parseInt(params.get("selectPage").toString())-1;
		
		params.put("paging",paging);
		params.put("currentpageDB",currentpageDB*paging);				//0~9,10~19 10개씩 보여준다
		params.put("startpage",startpage);
		
		List<Map<String,Object>> WorkCheckList = projectService.selectWorkCheckList(params);
		List<Map<String,Object>> list = projectService.selectBoardList(params);	
		int selectboardlistcnt= projectService.selectBoardListCnt(params);			//member 총인원
		
		if(selectboardlistcnt%paging!=0)							//paging으로 나누었을떄 0 이면 나뉜 페이지 보여줌
			endpage=selectboardlistcnt/paging+1;					//맴버 총 수에서 10을 나누고 나머지 페이지
		else
			endpage=selectboardlistcnt/paging;
		
		if(endpageNo>endpage) {
			endpageNo=endpage;
		}
		params.put("currentpage", currentpage);
		params.put("endpage",endpage);
		params.put("endpageNo",endpageNo);
		
		model.addAttribute("WorkCheckList",WorkCheckList);
		model.addAttribute("JoinId",JoinId);
		model.addAttribute("params", params);
		model.addAttribute("list", list);
		
		return "/project/main";
	}
	
	@RequestMapping(value = "/include/commonnav.do")
	public String commonNav(){		

		return "/include/commonnav";
	}
	@RequestMapping(value = "/project/createProjectModal.do")
	public String createProjectModal(HttpServletRequest req,HttpServletResponse response,@RequestParam Map<String,Object> params,Model model) throws IOException{
		
		int currentpage=(params.get("selectPage")==null||params.get("selectPage")==""? 1:Integer.parseInt(params.get("selectPage").toString()));
		int startpage=(params.get("startpage")==null? 1:1);
		int endpageNo=(params.get("endpageNo")==null? 10:10);
		int endpage = 0;
		int currentpageDB=0;				//DB에서의 시작 컬럼 번호
		int paging=5;						//한페이지당 list 컬럼의 수

		 //다음버튼 클릭시 첫페이지랑 마지막 페이지를 +10 
		if(endpageNo<currentpage) {
			startpage=endpageNo+1;
			endpageNo+=10;	
		}
		 //이전버튼 클릭시 첫페이지를 -10 마지막 페이지는 startpage에서 +10 (endpageNo가 유동적으로 바뀌므로 startpage를 기준잡음)  
		else if(currentpage<startpage) {	
			startpage-=10;
			endpageNo=startpage+9;
		}						
		
		if(params.get("selectPage")==null||params.get("selectPage")=="") {
			currentpageDB=0;
			params.put("selectPage",startpage);
		}else 
			currentpageDB=Integer.parseInt(params.get("selectPage").toString())-1;
		
		params.put("paging",paging);
		params.put("currentpageDB",currentpageDB*paging);				//0~9,10~19 10개씩 보여준다
		params.put("startpage",startpage);
	
		List<Map<String,Object>> indivisualView = loginService.indivisualView(params);

		int membercnt= loginService.indivisualViewCnt(params);			//member 총인원
		
		if(membercnt%paging!=0)							//paging으로 나누었을떄 0 이면 나뉜 페이지 보여줌
			endpage=membercnt/paging+1;					//맴버 총 수에서 10을 나누고 나머지 페이지
		else
			endpage=membercnt/paging;
		
		if(endpageNo>endpage) {
			endpageNo=endpage;
		}
		params.put("currentpage", currentpage);
		params.put("endpage",endpage);
		params.put("endpageNo",endpageNo);
		
		model.addAttribute("indivisualView",indivisualView);
		model.addAttribute("params",params);
		
		return "/project/createProjectModal";
		
	}
	@RequestMapping(value = "/project/createproject.do")
	public String createProject(HttpServletRequest req,HttpServletResponse response,@RequestParam Map<String,Object> params,Model model) throws IOException{
		
		HttpSession session = req.getSession();		
		params.put("adminYn", session.getAttribute("adminYn"));
				
		String mes=(String) params.get("mes");
		if(mes==null||mes=="") {	
		}
		else{
			response.setContentType("text/html; charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println("<script>alert('" + mes + "');</script>");
			out.flush();
		}
		
		model.addAttribute("params",params);
		return "/project/createproject";
	}
	
	@RequestMapping(value = "/project/insertProject.do")
	public String insertProject(HttpServletResponse response,HttpServletRequest req,@RequestParam Map<String,Object> params){	
		System.out.println(params);
		String mes=URLEncoder.encode(params.get("mes").toString());
		
		HttpSession session = req.getSession();
		String projectContent=(String) params.get("projectContent");
		projectContent = projectContent.replace("\r\n","<br>");
		
		params.put("projectContent",projectContent);
		params.put("userId", session.getAttribute("userId"));
		projectService.insertProject(params);
		
		// 프로젝트 생성자가 관리자이면 선택된 JoinId가 들어가고 사용자이면 자기 자신이JoinId로 들어가서 리더가 된다//
		if(params.get("JoinId")!=null)
			projectService.insertProjectLeader(params);
		else {
			params.put("JoinId",session.getAttribute("userId"));
			projectService.insertProjectLeader(params);
		}
		/* */
		return "redirect:/project/createproject.do?mes="+mes;
	}
	
	@RequestMapping(value = "/project/updateProject.do")
	public String updateProject(HttpServletRequest req,@RequestParam Map<String,Object> params,HttpServletResponse response,Model model) throws IOException {	
		
		HttpSession session = req.getSession();
		String projectContent=(String) params.get("projectContent");
		projectContent = projectContent.replace("\r\n","<br>");
		
		String mes=(String) params.get("mes");
		if(mes==null||mes=="") {	
		}
		else{
			response.setContentType("text/html; charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println("<script>alert('" + mes + "');</script>");
			out.flush();
		}
		params.put("projectContent",projectContent);
		params.put("userId", session.getAttribute("userId"));
		projectService.updateProject(params);
		
		model.addAttribute("params", params);
		return "forward:/project/projectDetailView.do";
	}
	@RequestMapping(value = "/project/deleteProject.do")
	public String deleteProject(@RequestParam Map<String,Object> params,Model model){		

		projectService.deleteProject(params);

		return "forward:/project/main.do";
	}
	
	@RequestMapping(value = "/project/projectDetailView.do")
	public String projectDetailView(HttpServletRequest req,@RequestParam Map<String,Object> params,Model model){		

		HttpSession session = req.getSession();		
		params.put("userId", session.getAttribute("userId"));
		params.put("adminYn", session.getAttribute("adminYn"));
		session.setAttribute("projectNo", req.getParameter("projectNo"));
		
		String sessionProjectNo = (String) session.getAttribute("projectNo");
		if (sessionProjectNo == null || sessionProjectNo == ""){
			return "forward:/project/main.do";
		}else 
		{
			Map<String,Object> projectdetail = projectService.selectProjectDetail(params);
			String projectContent=(String) projectdetail.get("projectContent");
			projectContent = projectContent.replace("<br>","\n");
		
			List<Map<String,Object>> joinmember= joinService.joinMember(params);			
			List<Map<String,Object>> projectLeader= joinService.projectLeader(params);
			Map<String,Object> joinMemberCheck= joinService.joinMemberCheck(params);	

	/*		model.addAttribute("selectWorkList",selectWorkList);*/
			model.addAttribute("params",params);
			model.addAttribute("joinMemberCheck",joinMemberCheck);
			model.addAttribute("projectLeader",projectLeader);
			model.addAttribute("joinmember",joinmember);
			model.addAttribute("projectContent",projectContent);
			model.addAttribute("projectdetail",projectdetail);
			
			return "/project/projectdetailview";
		}
		
	}
	
	@RequestMapping(value = "/project/projectJoinList.do")
	public ModelAndView projectJoinList(HttpServletRequest req,@RequestParam Map<String,Object> params,Model model){
		
		ModelAndView mav= new ModelAndView();
		List<Map<String,Object>> JoinId= joinService.selectJoinId(params);	
		//페이징//
		int currentpage=(params.get("selectPage")==null||params.get("selectPage")==""? 1:Integer.parseInt(params.get("selectPage").toString()));
		int startpage=(params.get("startpage")==null? 1:1);
		int endpageNo=(params.get("endpageNo")==null? 10:10);
		int endpage = 0;
		int currentpageDB=0;				//DB에서의 시작 컬럼 번호
		int paging=5;						//한페이지당 list 컬럼의 수

		 //다음버튼 클릭시 첫페이지랑 마지막 페이지를 +10 
		if(endpageNo<currentpage) {
			startpage=endpageNo+1;
			endpageNo+=10;	
		}
		 //이전버튼 클릭시 첫페이지를 -10 마지막 페이지는 startpage에서 +10 (endpageNo가 유동적으로 바뀌므로 startpage를 기준잡음)  
		else if(currentpage<startpage) {	
			startpage-=10;
			endpageNo=startpage+9;
		}						
		
		if(params.get("selectPage")==null||params.get("selectPage")=="") {
			currentpageDB=0;
			params.put("selectPage",startpage);
		}else 
			currentpageDB=Integer.parseInt(params.get("selectPage").toString())-1;
		
		params.put("paging",paging);
		params.put("currentpageDB",currentpageDB*paging);				//0~9,10~19 10개씩 보여준다
		params.put("startpage",startpage);
		
		int leaderNum = joinService.leaderNum(params);			//리더의 수
		int joinNum = joinService.joinNum(params);			//팀원의 수
		
		
		List<Map<String,Object>> joinlist = loginService.selectJoinList(params);
		int membercnt= loginService.selectJoinCnt(params);			//member 총인원
		
		if(membercnt%paging!=0)							//paging으로 나누었을떄 0 이면 나뉜 페이지 보여줌
			endpage=membercnt/paging+1;					//맴버 총 수에서 10을 나누고 나머지 페이지
		else
			endpage=membercnt/paging;
		
		if(endpageNo>endpage) {
			endpageNo=endpage;
		}
		params.put("currentpage", currentpage);
		params.put("endpage",endpage);
		params.put("endpageNo",endpageNo);
		
		mav.addObject("leaderNum",leaderNum);
		mav.addObject("joinNum",joinNum);
		mav.addObject("JoinId",JoinId);

		mav.addObject("joinlist",joinlist);
		mav.addObject("params",params);
		mav.setViewName("/project/insertdeleteJoinModal");		
		
		return mav;
		//페이징//		
	}
	
	@RequestMapping(value = "/project/workNum.do")
	@ResponseBody
	public String workNum(HttpServletRequest req,@RequestParam Map<String,Object> params,Model model){
	
		int workNum = projectService.workNum(params);		//팀원의 작업량
		
		return Integer.toString(workNum);
	}
	
	@RequestMapping(value ="/project/projectmultidelete.do")
	public String projectmultidelete(@RequestParam("projectcheckbox")String[] checkbox,@RequestParam Map<String,Object> params, HttpServletResponse response) throws IOException {
		
		for(String chk : checkbox) {
			params.put("projectNo", chk);
			projectService.deleteProject(params);
		}
		
		String mes=(String) params.get("mes");
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println("<script>alert('" + mes + "');</script>");
		out.flush();
		
		return "forward:/project/main.do";	
	}	
	
	@RequestMapping(value ="/project/insertCheckList.do")
	public ModelAndView insertCheckList(HttpServletRequest req,@RequestParam Map<String,Object> params, HttpServletResponse response) throws IOException {
		
		ModelAndView mav=new ModelAndView();

		HttpSession session = req.getSession();
		params.put("userId", session.getAttribute("userId"));
		
		projectService.insertCheckList(params);

		String mes=(String) params.get("mes");
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println("<script>alert('" + mes + "');</script>");
		out.flush();
		mav.setViewName("/project/createcheckListModal");
		
		return mav;	
	}
	@RequestMapping(value ="/project/insertCheckListPage.do")
	public String insertCheckListPage(HttpServletRequest req,@RequestParam Map<String,Object> params, HttpServletResponse response) {
		
		return "/project/createcheckListModal";	
	}
	@RequestMapping(value ="/project/updateCheckListModalView.do")
	public ModelAndView updateListModalPage(HttpServletRequest req,@RequestParam Map<String,Object> params, HttpServletResponse response,Model model) {
		ModelAndView mav = new ModelAndView();
		HttpSession session = req.getSession();
		params.put("userId", session.getAttribute("userId"));
		params.put("adminYn", session.getAttribute("adminYn"));
		
		Map<String,Object> joinMemberCheck= joinService.joinMemberCheck(params);	
		Map<String,Object> updateListModalPage= projectService.selectupdateListModalPage(params);
		
		mav.addObject("joinMemberCheck",joinMemberCheck);
		mav.addObject("updateListModalPage", updateListModalPage);
		mav.addObject("params", params);
		
		mav.setViewName("/project/updateCheckListModal");
		
		return mav;	
	}
	
	@RequestMapping(value ="/project/updateWorkListModalView.do")
	public ModelAndView updateWorkListModalView(HttpServletRequest req,@RequestParam Map<String,Object> params, HttpServletResponse response,Model model) {
		ModelAndView mav = new ModelAndView();
		HttpSession session = req.getSession();
		params.put("userId", session.getAttribute("userId"));
		params.put("adminYn", session.getAttribute("adminYn"));
		
		Map<String,Object> updateWorkListModalView= projectService.updateWorkListModalView(params);
		
		mav.addObject("params", params);
		mav.addObject("updateWorkListModalView", updateWorkListModalView);
		mav.setViewName("/project/updateWorkListModal");
		return mav;	
	}
	
	@RequestMapping(value ="/project/checkListPage.do")
	public ModelAndView checkListPage(HttpServletRequest req,@RequestParam Map<String,Object> params,Model model) {
		
		HttpSession session = req.getSession();
		params.put("userId", session.getAttribute("userId"));
		params.put("adminYn", session.getAttribute("adminYn"));
		
		ModelAndView mav=new ModelAndView();
		
		int currentpage=(params.get("selectPage")==null||params.get("selectPage")==""? 1:Integer.parseInt(params.get("selectPage").toString()));
		int startpage=(params.get("startpage")==null? 1:1);
		int endpageNo=(params.get("endpageNo")==null? 10:10);		//아래쪽 페이징 최대개수
		int endpage = 0;
		int currentpageDB=0;				//DB에서의 시작 컬럼 번호
		int paging=5;						//한페이지당 list 컬럼의 수

		/* 다음버튼 클릭시 첫페이지랑 마지막 페이지를 +10 */
		if(endpageNo<currentpage) {
			startpage=endpageNo+1;
			endpageNo+=10;	
		}
		/* 이전버튼 클릭시 첫페이지를 -10 마지막 페이지는 startpage에서 +10 (endpageNo가 유동적으로 바뀌므로 startpage를 기준잡음)  */
		else if(currentpage<startpage) {	
			startpage-=10;
			endpageNo=startpage+9;
		}				

		if(params.get("selectPage")==null||params.get("selectPage")=="") {
			currentpageDB=0;
			params.put("selectPage",startpage);
		}else 
			currentpageDB=Integer.parseInt(params.get("selectPage").toString())-1;
		
		params.put("paging",paging);
		params.put("currentpageDB",currentpageDB*paging);				//0~9,10~19 10개씩 보여준다
		params.put("startpage",startpage);
		
		Map<String,Object> updateListModalPage= projectService.selectupdateListModalPage(params);
		List<Map<String,Object>> selectCheckListAll = projectService.selectCheckListAll(params);
																	
		int selectCheckListAllCnt= projectService.selectCheckListAllCnt(params);			//member 총인원

		if(selectCheckListAllCnt%paging!=0)							//paging으로 나누었을떄 0 이면 나뉜 페이지 보여줌
			endpage=selectCheckListAllCnt/paging+1;					//맴버 총 수에서 10을 나누고 나머지 페이지
		else
			endpage=selectCheckListAllCnt/paging;
		
		if(endpageNo>endpage) {
			endpageNo=endpage;
		}
		Map<String,Object> joinMemberCheck= joinService.joinMemberCheck(params);	

		params.put("currentpage", currentpage);
		params.put("endpage",endpage);
		params.put("endpageNo",endpageNo);
		
		mav.addObject("joinMemberCheck",joinMemberCheck);
		mav.addObject("updateListModalPage", updateListModalPage);
		mav.addObject("params",params);
		mav.addObject("selectCheckListAll",selectCheckListAll);
		mav.setViewName("/project/checkListPage");
		
		return mav;	
	}
	
	@RequestMapping(value ="/project/workListPage.do")
	public ModelAndView workListPage(HttpServletRequest req,@RequestParam Map<String,Object> params,Model model) {
		
		HttpSession session = req.getSession();
		params.put("userId", session.getAttribute("userId"));
		params.put("adminYn", session.getAttribute("adminYn"));

		ModelAndView mav=new ModelAndView();
		
		int currentpage=(params.get("selectPage")==null||params.get("selectPage")==""? 1:Integer.parseInt(params.get("selectPage").toString()));
		int startpage=(params.get("startpage")==null? 1:1);
		int endpageNo=(params.get("endpageNo")==null? 10:10);		//아래쪽 페이징 최대개수
		int endpage = 0;
		int currentpageDB=0;				//DB에서의 시작 컬럼 번호
		int paging=5;						//한페이지당 list 컬럼의 수

		/* 다음버튼 클릭시 첫페이지랑 마지막 페이지를 +10 */
		if(endpageNo<currentpage) {
			startpage=endpageNo+1;
			endpageNo+=10;	
		}
		/* 이전버튼 클릭시 첫페이지를 -10 마지막 페이지는 startpage에서 +10 (endpageNo가 유동적으로 바뀌므로 startpage를 기준잡음)  */
		else if(currentpage<startpage) {	
			startpage-=10;
			endpageNo=startpage+9;
		}				

		if(params.get("selectPage")==null||params.get("selectPage")=="") {
			currentpageDB=0;
			params.put("selectPage",startpage);
		}else 
			currentpageDB=Integer.parseInt(params.get("selectPage").toString())-1;
		
		params.put("paging",paging);
		params.put("currentpageDB",currentpageDB*paging);				//0~9,10~19 10개씩 보여준다
		params.put("startpage",startpage);
		
		Map<String,Object> updateListModalPage= projectService.selectupdateListModalPage(params);
		List<Map<String,Object>> selectWorkListAll = projectService.selectWorkListAll(params);

		int selectWorkListAllCnt= projectService.selectWorkListAllCnt(params);			//member 총인원

		if(selectWorkListAllCnt%paging!=0)							//paging으로 나누었을떄 0 이면 나뉜 페이지 보여줌
			endpage=selectWorkListAllCnt/paging+1;					//맴버 총 수에서 10을 나누고 나머지 페이지
		else
			endpage=selectWorkListAllCnt/paging;
		
		if(endpageNo>endpage) {
			endpageNo=endpage;
		}
		Map<String,Object> joinMemberCheck= joinService.joinMemberCheck(params);
		
		params.put("currentpage", currentpage);
		params.put("endpage",endpage);
		params.put("endpageNo",endpageNo);
		
		mav.addObject("joinMemberCheck", joinMemberCheck);
		mav.addObject("updateListModalPage", updateListModalPage);
		mav.addObject("params",params);
		mav.addObject("selectWorkListAll",selectWorkListAll);
		mav.setViewName("/project/workListPage");
		
		return mav;	
	}
	
	@RequestMapping(value ="/project/workMultiDelete.do")
	public String workMultiDelete(@RequestParam("checkbox2")String[] checkbox,@RequestParam Map<String,Object> params, HttpServletResponse response) throws IOException{

		
		for(String chk : checkbox) {
			params.put("workNo", chk);
			projectService.workMultiDelete(params);
		}
		
		String mes=(String) params.get("mes");
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println("<script>alert('" + mes + "');</script>");
		out.flush();
		
		return "forward:/project/projectDetailView.do";	
	}
	
	@RequestMapping(value ="/project/updateCheckList.do")
	public String updateCheckList(HttpServletRequest req,@RequestParam Map<String,Object> params, HttpServletResponse response,Model model) throws IOException{
		
		HttpSession session = req.getSession();
		params.put("userId", session.getAttribute("userId"));
		
		projectService.updateCheckList(params);

		String mes=(String) params.get("mes");
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println("<script>alert('" + mes + "');</script>");
		out.flush();
		
		return "forward:/project/projectDetailView.do";	
	}
	
	@RequestMapping(value ="/project/completeWorkList.do")
	public String completeWorkList(HttpServletRequest req,@RequestParam Map<String,Object> params, HttpServletResponse response,Model model) throws IOException{
		
		HttpSession session = req.getSession();
		params.put("userId", session.getAttribute("userId"));
		
		projectService.updateCompleteWorkList(params);

		String mes=(String) params.get("mes");
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println("<script>alert('" + mes + "');</script>");
		out.flush();
		
		return "forward:/project/projectDetailView.do";	
	}
	
	
	@RequestMapping(value ="/project/medo.do")
	public String medo(HttpServletRequest req,@RequestParam Map<String,Object> params, HttpServletResponse response,Model model) throws IOException{
		
		HttpSession session = req.getSession();
		params.put("userId", session.getAttribute("userId"));
		
		projectService.medo(params);

		String mes=(String) params.get("mes");
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println("<script>alert('" + mes + "');</script>");
		out.flush();
		
		return "forward:/project/projectDetailView.do";	
	}
	
	@RequestMapping(value ="/project/mutiDo.do")
	public String mutiDo(@RequestParam("checkbox2")String[] checkbox,HttpServletRequest req,@RequestParam Map<String,Object> params, HttpServletResponse response,Model model) throws IOException{
		
		HttpSession session = req.getSession();
		params.put("userId", session.getAttribute("userId"));

		for(String chk : checkbox) {
			params.put("workNo", chk);
			projectService.medo(params);
		}

		String mes=(String) params.get("mes");
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println("<script>alert('" + mes + "');</script>");
		out.flush();
		
		return "forward:/project/projectDetailView.do";	
	}
	
	@RequestMapping(value ="/project/giveWork.do")
	public String giveWork(HttpServletRequest req,@RequestParam Map<String,Object> params, HttpServletResponse response,Model model) throws IOException {
		System.out.println(params);
		//페이징//
		int currentpage=(params.get("selectPage")==null||params.get("selectPage")==""? 1:Integer.parseInt(params.get("selectPage").toString()));
		int startpage=(params.get("startpage")==null? 1:1);
		int endpageNo=(params.get("endpageNo")==null? 10:10);
		int endpage = 0;
		int currentpageDB=0;				//DB에서의 시작 컬럼 번호
		int paging=5;						//한페이지당 list 컬럼의 수

		 //다음버튼 클릭시 첫페이지랑 마지막 페이지를 +10 
		if(endpageNo<currentpage) {
			startpage=endpageNo+1;
			endpageNo+=10;	
		}
		 //이전버튼 클릭시 첫페이지를 -10 마지막 페이지는 startpage에서 +10 (endpageNo가 유동적으로 바뀌므로 startpage를 기준잡음)  
		else if(currentpage<startpage) {	
			startpage-=10;
			endpageNo=startpage+9;
		}						
		
		if(params.get("selectPage")==null||params.get("selectPage")=="") {
			currentpageDB=0;
			params.put("selectPage",startpage);
		}else 
			currentpageDB=Integer.parseInt(params.get("selectPage").toString())-1;
		
		params.put("paging",paging);
		params.put("currentpageDB",currentpageDB*paging);				//0~9,10~19 10개씩 보여준다
		params.put("startpage",startpage);
		
		int joinNum = joinService.joinNum(params);
		List<Map<String,Object>> joinlist = loginService.selectJoinList(params);
		int membercnt= loginService.selectJoinCnt(params);			//member 총인원
		
		if(membercnt%paging!=0)							//paging으로 나누었을떄 0 이면 나뉜 페이지 보여줌
			endpage=membercnt/paging+1;					//맴버 총 수에서 10을 나누고 나머지 페이지
		else
			endpage=membercnt/paging;
		
		if(endpageNo>endpage) {
			endpageNo=endpage;
		}
		params.put("currentpage", currentpage);
		params.put("endpage",endpage);
		params.put("endpageNo",endpageNo);

		model.addAttribute("joinlist",joinlist);
		model.addAttribute("params",params);

		return "/project/giveWork";	
	}
	
	@RequestMapping(value ="/project/workCancel.do")
	public String workCancel(HttpServletRequest req,@RequestParam Map<String,Object> params, HttpServletResponse response,Model model) throws IOException{
		
		HttpSession session = req.getSession();
		params.put("userId", session.getAttribute("userId"));
		
		projectService.workCancel(params);

		String mes=(String) params.get("mes");
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println("<script>alert('" + mes + "');</script>");
		out.flush();
		
		return "forward:/project/projectDetailView.do";	
	}
	
	@RequestMapping(value ="/project/workComplete.do")
	public String workComplete(HttpServletRequest req,@RequestParam Map<String,Object> params, HttpServletResponse response,Model model) throws IOException{
		
		HttpSession session = req.getSession();
		params.put("userId", session.getAttribute("userId"));
		
		projectService.updateCompleteWorkList(params);

		String mes=(String) params.get("mes");
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println("<script>alert('" + mes + "');</script>");
		out.flush();
		
		return "forward:/project/projectDetailView.do";	
	}
	
	@RequestMapping(value ="/project/workMultiCancel.do")
	public String workMultiCancel(@RequestParam("checkbox")String[] checkbox,HttpServletRequest req,@RequestParam Map<String,Object> params, HttpServletResponse response) throws IOException{
		
		HttpSession session = req.getSession();
		params.put("userId", session.getAttribute("userId"));
		
		for(String chk : checkbox) {
			params.put("workNo", chk);
			projectService.workCancel(params);
		}

		String mes=(String) params.get("mes");
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println("<script>alert('" + mes + "');</script>");
		out.flush();
		
		return "forward:/project/projectDetailView.do";	
	}
	
	@RequestMapping(value ="/project/workMultiComplete.do")
	public String workMultiComplete(@RequestParam("checkbox")String[] checkbox,HttpServletRequest req,@RequestParam Map<String,Object> params, HttpServletResponse response) throws IOException{
		
		HttpSession session = req.getSession();
		params.put("userId", session.getAttribute("userId"));
		
		for(String chk : checkbox) {
			params.put("workNo", chk);
			projectService.updateCompleteWorkList(params);
		}

		String mes=(String) params.get("mes");
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println("<script>alert('" + mes + "');</script>");
		out.flush();
		
		return "forward:/project/projectDetailView.do";	
	}

	@RequestMapping(value ="/project/giveWorkMulti.do")
	public String giveWorkMulti(@RequestParam("checkbox2")String[] checkbox,HttpServletRequest req,@RequestParam Map<String,Object> params, HttpServletResponse response,Model model) throws IOException{
	
		HttpSession session = req.getSession();
		params.put("userId", session.getAttribute("userId"));

		for(String chk : checkbox) {
			params.put("workNo", chk);
			projectService.giveWorkMulti(params);
		}

		String mes=(String) params.get("mes");
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println("<script>alert('" + mes + "');</script>");
		out.flush();
		
		return "forward:/project/projectDetailView.do";	
	}
	
	@RequestMapping(value ="/project/deletecheckListModalId.do")
	public String deletecheckListModalId(HttpServletRequest req,@RequestParam Map<String,Object> params, HttpServletResponse response,Model model) throws IOException{
		
		projectService.deletecheckListModalId(params);
		
		String mes=(String) params.get("mes");
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println("<script>alert('" + mes + "');</script>");
		out.flush();
		
		return "forward:/project/projectDetailView.do";	
	}
	
	
/*	//테스트//
	@RequestMapping(value = "/project/projectDetailView2.do")
	public String projectDetailView2(HttpServletRequest req,@RequestParam Map<String,Object> params,Model model){		

		Map<String,Object> projectdetail = projectService.selectProjectDetail(params);
		String projectContent=(String) projectdetail.get("projectContent");
		projectContent = projectContent.replace("<br>","\n");
		
		List<Map<String,Object>> JoinId= joinService.selectJoinId(params);	
		
		//페이징//
		int currentpage=(params.get("selectPage")==null||params.get("selectPage")==""? 1:Integer.parseInt(params.get("selectPage").toString()));
		int startpage=(params.get("startpage")==null? 1:Integer.parseInt(params.get("startpage").toString()));
		int endpageNo=(params.get("endpageNo")==null? 10:Integer.parseInt(params.get("endpageNo").toString()));
		int endpage = 0;
		int currentpageDB=0;				//DB에서의 시작 컬럼 번호
		int paging=5;						//한페이지당 list 컬럼의 수
		int underpaging=10;					//아래쪽 페이징 최대 개수
		
		 다음버튼 클릭시 첫페이지랑 마지막 페이지를 +10 
		if(endpageNo<currentpage) {
			startpage=endpageNo+1;
			endpageNo+=10;	
		}
		 이전버튼 클릭시 첫페이지를 -10 마지막 페이지는 startpage에서 +10 (endpageNo가 유동적으로 바뀌므로 startpage를 기준잡음)  
		else if(currentpage<startpage) {	
			startpage-=10;
			endpageNo=startpage+9;
		}						
		
		if(params.get("selectPage")==null||params.get("selectPage")=="") {
			currentpageDB=0;
			params.put("selectPage",startpage);
		}else 
			currentpageDB=Integer.parseInt(params.get("selectPage").toString())-1;
		
		params.put("paging",paging);
		params.put("currentpageDB",currentpageDB*paging);				//0~9,10~19 10개씩 보여준다
		params.put("startpage",startpage);
		
		
		List<Map<String,Object>> joinlist = loginService.selectJoinList(params);
		System.out.println(joinlist);
		System.out.println(params);
		int membercnt= loginService.selectJoinCnt(params);			//member 총인원
		
		if(membercnt%paging!=0)							//paging으로 나누었을떄 0 이면 나뉜 페이지 보여줌
			endpage=membercnt/paging+1;					//맴버 총 수에서 10을 나누고 나머지 페이지
		else
			endpage=membercnt/paging;
		
		if(endpageNo>endpage) {
			endpageNo=endpage;
		}
		params.put("currentpage", currentpage);
		params.put("endpage",endpage);
		params.put("endpageNo",endpageNo);
		
		model.addAttribute("params",params);
		model.addAttribute("joinlist",joinlist);	
		model.addAttribute("JoinId",JoinId);
		//페이징//	
		
		model.addAttribute("projectContent",projectContent);
		model.addAttribute("projectdetail",projectdetail);

		return "/project/insertdeleteJoinModal";
	}*/

}
