package com.young.login.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.text.DateFormat;
import java.util.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.swing.JOptionPane;

import org.apache.catalina.servlet4preview.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;

import com.young.login.sevice.loginService;


/**
 * Handles requests for the application home page.
 */
@Controller
public class loginController {
	
	private static final Logger logger = LoggerFactory.getLogger(loginController.class);
	
	@Resource(name="loginService")
	private loginService loginService;
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	
	@RequestMapping(value = "/login/login.do")
	public String loginview(HttpServletRequest req) {
		
		return "/login/login";
	}
	
	@RequestMapping(value = "/login/logout.do")
	public String loginout(HttpServletRequest req) {
		HttpSession session = req.getSession();
		session.invalidate();
		
		
		return "/login/login";
	}
	@RequestMapping(value = "/login/memberlist.do")
	public String memberlist(@RequestParam Map<String,Object> params, Model model) {	
		int currentpage=(params.get("selectPage")==null||params.get("selectPage")==""? 1:Integer.parseInt(params.get("selectPage").toString()));
		int startpage=(params.get("startpage")==null? 1:1);
		int endpageNo=(params.get("endpageNo")==null? 10:10);		//아래쪽 페이징 최대개수
		int endpage = 0;
		int currentpageDB=0;				//DB에서의 시작 컬럼 번호
		int paging=10;						//한페이지당 list 컬럼의 수

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
		
		List<Map<String,Object>> memberlist = loginService.selectMemberList(params);

		int membercnt= loginService.selectMemberCnt(params);			//member 총인원

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
		model.addAttribute("memberlist",memberlist);
		
		return "/login/memberlist";
	}
	
	
	@RequestMapping(value = "/login/member.do")
	public String insertmember(@RequestParam Map<String,Object> params, Model model,HttpServletResponse response) throws IOException {
		String mes=URLEncoder.encode(params.get("mes").toString());
		loginService.insertMember(params);		
		
		model.addAttribute("member",params);
		return "redirect:/login/memberview.do?mes="+mes;
	}
	
	@RequestMapping(value = "/login/memberview.do")
	public String memberview(@RequestParam Map<String,Object> params,Model model,HttpServletResponse response) throws IOException {
		String mes=(String) params.get("mes");
		System.out.println(mes);
		if(mes==null||mes==""){
		}
		else {
			response.setContentType("text/html; charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println("<script>alert('" + mes + "');</script>");
			out.flush();
		}
		return "/login/member";
	}

	@RequestMapping(value = "/login/checkId.do")
	@ResponseBody
	public String checkId(HttpServletResponse res,@RequestParam Map<String,Object> params,Model model) {
		
		System.out.println(params.get("userEmail"));
		params.put("userId", params.get("userId"));

		int checkdoubleId = loginService.selectCheckId(params);

		return Integer.toString(checkdoubleId);
	}
	
	@RequestMapping(value = "/login/logincheck.do")
	public String loginCheck(HttpServletRequest req,@RequestParam Map<String,Object> params ,Model model,HttpServletResponse response) throws IOException {
		System.out.println(params);
		Map<String,Object> logincheck = loginService.selectCheckMember(params);
		 		
		if(logincheck.get("userId").equals(params.get("userId"))&&logincheck.get("userPw").equals(params.get("userPw"))) {
			HttpSession session=req.getSession();
			session.setAttribute("userId",logincheck.get("userId"));
			session.setAttribute("adminYn",logincheck.get("adminYn"));
			return "forward:/project/main.do";
		}
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out=response.getWriter();
		out.println("<script>alert('회원정보를 정확히 입력하시오');</script>");
		out.flush();
		model.addAttribute("id", params.get("userId"));
    	
		return "/login/login";
	}
	@RequestMapping(value = "/login/updatememberView.do")
	public String memberupdate(@RequestParam Map<String,Object> params, Model model) {
		
		Map<String,Object> memberinfo = loginService.selectMemberinfo(params);

		model.addAttribute("memberinfo",memberinfo);
		
		return "/login/updatemember";
	}
	@RequestMapping(value = "/login/updatemember.do")
	public String memberupdatedo(@RequestParam Map<String,Object> params,HttpServletResponse response) throws IOException {
		
		loginService.updateMemberinfo(params);
		String mes=(String) params.get("mes");
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println("<script>alert('" + mes + "');</script>");
		out.flush();
		
		return "forward:/login/memberlist.do";
	}
	@RequestMapping(value = "/login/deletemember.do")
	public String memberdeletedo(@RequestParam Map<String,Object> params,HttpServletResponse response) throws IOException {
		
		loginService.deleteMemberinfo(params);
		
		String mes=(String) params.get("mes");
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println("<script>alert('" + mes + "');</script>");
		out.flush();
		
		return "forward:/login/memberlist.do";
	}
	
	@RequestMapping(value = "/login/multidelete.do")
	public String multidelete(@RequestParam("checkbox")String[] checkbox,@RequestParam Map<String,Object> params,HttpServletResponse response) throws IOException {

		for(String chk : checkbox) {
			loginService.multiDelete(chk);
		}
		
		String mes=(String) params.get("mes");
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println("<script>alert('" + mes + "');</script>");
		out.flush();
		
		return "forward:/login/memberlist.do";
	}
	
	@RequestMapping(value = "/login/indivisualView.do")
	public String indivisualView(@RequestParam Map<String,Object> params,HttpServletResponse response){
		
		return "/login/indivisual";
	}
	
}