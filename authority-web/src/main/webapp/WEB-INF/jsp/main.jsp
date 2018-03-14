<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh">
<head>
<base href="<%=basePath%>">
<title>Insert title here</title>
<script type="text/javascript" src="easyui/jquery.min.js"></script>
<script type="text/javascript" src="easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="easyui/locale/easyui-lang-zh_CN.js"></script>
<link rel="stylesheet" type="text/css" href="easyui/themes/material/easyui.css"/>
<link rel="stylesheet" type="text/css" href="easyui/themes/icon.css"/>
<link rel="stylesheet" href="css/wu.css" type="text/css"/>
</head>
<body class="easyui-layout">
    <div class="" data-options="region:'north'" style="height:70px;background-color: pink;" title="">
    	<h1>esayUI管理系统</h1>
    	<h2>欢迎，${sessionScope.loginUser.username }，角色:     	<c:forEach items="${sessionScope.loginUser.sysRoles }" var = "role">
    		${role.name } 
    	</c:forEach></h2>

    	
    </div>
    <div data-options="region:'south',title:'版权'" style="height:100px;"></div>
    <div class="wu-sidebar" data-options="region:'west',title:'导航菜单',split:true" style="width:200px;">
		<div id="aa" class="easyui-accordion" data-options="border:false,fit:true">
			<c:forEach items="${sessionScope.loginUser.permissions }" var = "parent">
				<c:if test="${parent.parentId == null }">
					<div title="${parent.name }"> 
						<ul class="easyui-tree wu-side-tree">
							<li iconCls="icon-tip"><a href="javascript:void(0)" data-icon="icon-tip" data-link="${parent.url }" iframe="0">${parent.name }</a></li>
		 				</ul>
					</div>
				</c:if>
			</c:forEach>
			
		</div>
    </div>
    <div data-options="region:'center'">
		<div id="wu-tabs" class="easyui-tabs" data-options="border:false,fit:true">
		    <div title="Tab1" style="padding:20px;display:none;">
				tab1
		    </div>
		    <div title="Tab2" data-options="closable:true" style="overflow:auto;padding:20px;display:none;">
				tab2
		    </div>
		    <div title="Tab3" data-options="iconCls:'icon-reload',closable:true" style="padding:20px;display:none;">
				tab3
		    </div>
		</div>
    </div>
    <!-- end of footer -->  
    <script type="text/javascript">
		$(function(){
			$('.wu-side-tree li a').bind("click",function(){
				var title = $(this).text();
				var url = $(this).attr('data-link');
				var iconCls = $(this).attr('data-icon');
				var iframe = $(this).attr('iframe')==1?true:false;
				addTab(title,url,iconCls,iframe);
			});	
		})
		
		/**
		* Name 载入树形菜单 
		*/
		$('#wu-side-tree').tree({
			url:'temp/menu.php',
			cache:false,
			onClick:function(node){
				var url = node.attributes['url'];
				if(url==null || url == ""){
					return false;
				}
				else{
					addTab(node.text, url, '', node.attributes['iframe']);
				}
			}
		});
		
		/**
		* Name 选项卡初始化
		*/
		$('#wu-tabs').tabs({
			tools:[{
				iconCls:'icon-reload',
				border:false,
				handler:function(){
					$('#wu-datagrid').datagrid('reload');
				}
			}]
		});
			
		/**
		* Name 添加菜单选项
		* Param title 名称
		* Param href 链接
		* Param iconCls 图标样式
		* Param iframe 链接跳转方式（true为iframe，false为href）
		*/	
		function addTab(title, href, iconCls, iframe){
			var tabPanel = $('#wu-tabs');
			if(!tabPanel.tabs('exists',title)){
				var content = '<iframe scrolling="auto" frameborder="0"  src="'+ href +'" style="width:100%;height:100%;"></iframe>';
				if(iframe){
					tabPanel.tabs('add',{
						title:title,
						content:content,
						iconCls:iconCls,
						fit:true,
						cls:'pd3',
						closable:true
					});
				}
				else{
					tabPanel.tabs('add',{
						title:title,
						href:href,
						iconCls:iconCls,
						fit:true,
						cls:'pd3',
						closable:true
					});
				}
			}
			else
			{
				tabPanel.tabs('select',title);
			}
		}
		/**
		* Name 移除菜单选项
		*/
		function removeTab(){
			var tabPanel = $('#wu-tabs');
			var tab = tabPanel.tabs('getSelected');
			if (tab){
				var index = tabPanel.tabs('getTabIndex', tab);
				tabPanel.tabs('close', index);
			}
		}
	</script>
</body>
</html>