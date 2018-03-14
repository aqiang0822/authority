package org.aptech.shiro.authority.dao;

import org.apache.ibatis.annotations.Param;
import org.aptech.shiro.authority.pojo.SysUser;

public interface SysUserDao extends CommonDao<SysUser, Integer> {
	
	public void addUserRole(@Param("userId")Integer userId,@Param("roleIds")Integer[] roleIds);
	
	public void deleteRoleGuanxiByUserId(Integer userId);
	
	/**
	 * 根据用户名查询,   登陆
	 * @param userName
	 */
	public SysUser getByUsername(String username);
	
}
