package org.aptech.shior.authority.test;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.apache.shiro.crypto.hash.Md5Hash;
import org.aptech.shiro.authority.dao.SysPermissionDao;
import org.aptech.shiro.authority.dao.SysUserDao;
import org.aptech.shiro.authority.pojo.SysPermission;
import org.aptech.shiro.authority.pojo.SysRole;
import org.aptech.shiro.authority.pojo.SysUser;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath:applicationContext-mybatis.xml")
public class test1 {

	@Resource
	private SysUserDao sysUserDao;
	@Resource
	private SysPermissionDao sysPermissionDao;
	
	
	
	public void setSysPermissionDao(SysPermissionDao sysPermissionDao) {
		this.sysPermissionDao = sysPermissionDao;
	}


	public void setSysUserDao(SysUserDao sysUserDao) {
		this.sysUserDao = sysUserDao;
	}
	
	
	@Test
	public void test() {
		
		SysUser sysUser = new SysUser();
		
		
		List<SysRole> sysRoles = new ArrayList<>();
		SysRole sysRole = new SysRole();
		sysRole.setId(2);
		sysRoles.add(sysRole);
		sysUser.setSysRoles(sysRoles);
		
		List<SysUser> list = sysUserDao.getListByCondition(0, 5, sysUser, "id", "asc");
		for (SysUser sysUser1 : list) {
			System.out.println(sysUser1);
		}
	}

	@Test
	public void testAdd() {
		SysUser sysUser = new SysUser();
		Md5Hash md5Hash = new Md5Hash("liqiang", "7829");
		sysUser.setUsername("liqiang");
		sysUser.setPassword(md5Hash.toString());
		sysUser.setSalt("7829");
		sysUserDao.add(sysUser);
	}
	@Test
	public void testGetAllPers() {
		List<SysPermission> list = sysPermissionDao.getAll();
		for (SysPermission parent : list) {
			System.out.println(parent.getText());
			for (SysPermission child : parent.getChildren()) {
				System.out.println("\t"+child.getText());
			}
		}
	}
	@Test
	public void testGetByUserName() {
		SysUser sysUser = sysUserDao.getByUsername("liqiang");
		System.out.println(sysUser);
	}
	@Test
	public void testGetpermissionByuserId() {
		List<SysPermission> list = sysPermissionDao.getPermissionByUserId(44, "menu");
		
		for (SysPermission sysPermission : list) {
			System.out.println(sysPermission);
		}
	}
}
