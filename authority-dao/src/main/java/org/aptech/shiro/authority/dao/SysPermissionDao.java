package org.aptech.shiro.authority.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.aptech.shiro.authority.pojo.SysPermission;

public interface SysPermissionDao extends CommonDao<SysPermission, Integer> {
	
	public List<Integer> getPermissionIdsByRoleId(Integer roleId);
	
	public void deletePermissionsByRoleId(Integer roleId);
	
	public void addRolePermissions(@Param("roleId")Integer roleId,@Param("permissionIds")Integer[] permissionIds);
	
	//根据用户Id，和类型查询权限和功能，
	public List<SysPermission> getPermissionByUserId(@Param("userId")Integer userId,@Param("type")String type);
	
}
