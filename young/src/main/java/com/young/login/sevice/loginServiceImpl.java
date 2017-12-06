package com.young.login.sevice;

import java.util.*;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.young.login.dao.loginDAO;

@Service("loginService")
public class loginServiceImpl implements loginService{

	@Resource(name="loginDAO")
	private loginDAO loginDAO;

	@Override
	public void insertMember(Map<String, Object> gomap) {
		// TODO Auto-generated method stub
		 loginDAO.insertMember(gomap);
	}

	@Override
	public int selectCheckId(Map<String, Object> gomap) {
		
		return (int) loginDAO.selectCheckId(gomap);
	}
	
	@Override
	public Map<String, Object> selectCheckMember(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return loginDAO.selectCheckMember(params);
	}

	@Override
	public List<Map<String, Object>> selectMemberList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return loginDAO.selectMemberList(params);
	}

	@Override
	public int selectMemberCnt(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return loginDAO.selectMemberCnt(params);
	}

	@Override
	public List<Map<String, Object>> selectMember(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return loginDAO.selectMember(params);
	}

	@Override
	public Map<String, Object> selectMemberinfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return (Map)loginDAO.selectMemberinfo(params);
	}

	@Override
	public void updateMemberinfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		loginDAO.updateMemberinfo(params);
	}

	@Override
	public void deleteMemberinfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		loginDAO.deleteMemberinfo(params);
	}

	@Override
	public void multiDelete(String chk) {
		// TODO Auto-generated method stub
		loginDAO.multiDelete(chk);
	}

	@Override
	public List<Map<String, Object>> selectJoinList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return loginDAO.selectJoinList(params);
	}

	@Override
	public int selectJoinCnt(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return loginDAO.selectJoinCnt(params);
	}

	@Override
	public List<Map<String, Object>> indivisualView(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return loginDAO.indivisualView(params);
	}

	@Override
	public int indivisualViewCnt(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return loginDAO.indivisualViewCnt(params);
	}

	@Override
	public List<Map<String, Object>> memberListView(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return loginDAO.memberListView(params);
	}

	@Override
	public Map<String, Object> userInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return loginDAO.userInfo(params);
	}
}
