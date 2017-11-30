package com.young.login.sevice;

import java.util.*;

public interface loginService {



	void insertMember(Map<String, Object> gomap);

	int selectCheckId(Map<String, Object> params);

	Map<String, Object> selectCheckMember(Map<String, Object> params);

	List<Map<String, Object>> selectMemberList(Map<String, Object> params);

	int selectMemberCnt(Map<String, Object> params);

	List<Map<String, Object>> selectMember(Map<String, Object> params);

	Map<String, Object> selectMemberinfo(Map<String, Object> params);

	void updateMemberinfo(Map<String, Object> params);

	void deleteMemberinfo(Map<String, Object> params);

	void multiDelete(String chk);

	List<Map<String, Object>> selectJoinList(Map<String, Object> params);

	int selectJoinCnt(Map<String, Object> params);

}
