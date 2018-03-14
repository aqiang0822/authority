package org.aptech.shiro.authority.controller;

import java.util.List;

import javax.annotation.Resource;

import org.aptech.shiro.authority.dao.SysPermissionDao;
import org.aptech.shiro.authority.pojo.SysPermission;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/permission")
public class SysPermissionController {
	@Resource
	private SysPermissionDao sysPermissionDao;

	public void setSysPermissionDao(SysPermissionDao sysPermissionDao) {
		this.sysPermissionDao = sysPermissionDao;
	}
	@RequestMapping(value="/index",method=RequestMethod.GET)
	public String index() throws Exception{
		
		return "sysPermission/index";
	}
	
	@RequestMapping("/list")
	@ResponseBody
	public List<SysPermission> list() throws Exception{
		return sysPermissionDao.getAll();
	}
	
}
