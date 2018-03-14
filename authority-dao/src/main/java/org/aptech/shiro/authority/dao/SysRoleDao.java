package org.aptech.shiro.authority.dao;

import java.util.List;

import org.aptech.shiro.authority.pojo.SysRole;

public interface SysRoleDao extends CommonDao<SysRole, Integer> {
	
	/**
	 * 根据用户id查询角色
	 * @param id
	 * @return
	 */
	public List<SysRole> getRolesByUserId(Integer id);
	
	
}
