package org.aptech.shiro.authority.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.annotations.Mapper;
import org.apache.log4j.chainsaw.Main;
import org.apache.shiro.crypto.hash.Md5Hash;
import org.aptech.shiro.authority.dao.SysPermissionDao;
import org.aptech.shiro.authority.dao.SysUserDao;
import org.aptech.shiro.authority.pojo.SysPermission;
import org.aptech.shiro.authority.pojo.SysUser;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;


@Controller
@RequestMapping("/user")
public class SysUserController {
	
	@Resource
	private SysUserDao sysUserDao;
	@Resource
	private SysPermissionDao sysPermissionDao;
	
	public void setSysUserDao(SysUserDao sysUserDao) {
		this.sysUserDao = sysUserDao;
	}
	
	public void setSysPermissionDao(SysPermissionDao sysPermissionDao) {
		this.sysPermissionDao = sysPermissionDao;
	}



	@RequestMapping("/index")
	public String index() throws Exception {
		
		return "sysUser/index";
	}
	@RequestMapping(value="/login",method=RequestMethod.GET)
	public String login()throws Exception{
		return "login";
	}
	@RequestMapping(value="/login.shtml",method=RequestMethod.POST)
	public String login(String username,String password,HttpSession session)throws Exception{
		
		SysUser user = sysUserDao.getByUsername(username);
			
		if(user!=null) {
			
			String salt = user.getSalt();
			
			Md5Hash md5Hash = new Md5Hash(username, user.getSalt());
			String pwd = md5Hash.toString();
			
			System.out.println(pwd+","+user.getPassword());
			
			System.out.println(user);
			
			if(pwd.equals(user.getPassword())) {
				
				List<SysPermission> permissions = sysPermissionDao.getPermissionByUserId(user.getId(), "menu");
				session.setAttribute("permissions", permissions);
				
				for (SysPermission sysPermission : permissions) {
					System.out.println(sysPermission);
				}
				
				session.setAttribute("loginUser", user);
				
				return "redirect:/user/main";
				
			}
		}
		session.setAttribute("error", "账号或密码错误");
		
		return "login";
	}
	@RequestMapping("/main")
	public String main()throws Exception{
		
		return "main";
	}
	
	@RequestMapping("/list")
	@ResponseBody
	public Map<String, Object> list(Integer page,Integer rows,SysUser condition,@RequestParam(defaultValue="id")String sort,@RequestParam(defaultValue="asc")String order) throws Exception{
		
		int start = (page-1)*rows;
		
		Map<String, Object> map = new HashMap<>();
		
		List<SysUser> list = sysUserDao.getListByCondition(start, rows, condition, sort, order);
		
		int total = sysUserDao.getCountByCondition(null);
		
		map.put("total", total);
		map.put("rows", list);
		
		return map;
	}
	
	@RequestMapping(value="/form",method=RequestMethod.GET)
	public String form() throws Exception {
		return "sysUser/sysuser_form";
	}
	@RequestMapping("/add")
	@ResponseBody
	public Map<String, Object> add(SysUser user,Integer [] roleIds)throws Exception{
		Map<String, Object> map = new HashMap<>();
		Md5Hash md5Hash = new Md5Hash(user.getPassword(), user.getSalt());
		user.setPassword(md5Hash.toString());
		sysUserDao.add(user);
		sysUserDao.addUserRole(user.getId(), roleIds);
		map.put("result", true);
		return map;
	}
	@RequestMapping("/bathDelete")
	@ResponseBody
	public Map<String, Object> bathDelete(Integer[] ids)throws Exception{
		
		Map<String, Object> map = new HashMap<>();
		
		sysUserDao.deleteByIds(ids);
		
		map.put("result", true);
		
		return map;
		
	}
	
	@RequestMapping("/selectById")
	@ResponseBody
	public SysUser selectById(Integer id)throws Exception{
		return sysUserDao.getById(id);
	}
	
	@RequestMapping(value="/edit",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> edit(SysUser user,Integer[] roleIds)throws Exception{
		Map<String, Object> map = new HashMap<>();
		Md5Hash md5Hash = new Md5Hash(user.getPassword(), user.getSalt());
		user.setPassword(md5Hash.toString());
		sysUserDao.update(user);
		sysUserDao.deleteRoleGuanxiByUserId(user.getId());
		sysUserDao.addUserRole(user.getId(), roleIds);
		map.put("result", true);
		return map;
		
	}
}
