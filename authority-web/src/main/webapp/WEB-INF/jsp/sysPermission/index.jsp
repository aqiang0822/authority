<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="zh">
<head>
<base href="<%=basePath%>">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<script type="text/javascript" src="easyui/jquery.min.js"></script>
<script type="text/javascript" src="easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="easyui/locale/easyui-lang-zh_CN.js"></script>
<link rel="stylesheet" type="text/css" href="easyui/themes/material/easyui.css"/>
<link rel="stylesheet" type="text/css" href="easyui/themes/icon.css"/>
<script type="text/javascript">
	$(function(){
		$("#permissionTable").treegrid({
			toolbar:$('#tb'),
			idField:"id",
			treeField:"text",
			animate:true,
			onLoadSuccess:function(){
				$(this).treegrid("collapseAll");
			},
			//数据加载过来以后再过滤一下
			loadFilter:function(data){
				$.each(data,function(){
					this.state = "closed";
				});
				return data;
			}
		});
	})
</script>
</head>
<body>
	<table id=permissionTable title="permissionList" 
	    data-options="url:'permission/list',fitColumns:true,striped:true,rownumbers:true,iconCls:'icon-search'">
	    
	    <thead>
			<tr>
				<th data-options="field:'id',width:50,sortable:true"></th>
	            <th data-options="field:'text',width:100,sortable:true">Text</th>
	            <th data-options="field:'available',width:100,sortable:true">Available</th>
	            <th data-options="field:'url',width:50">Url</th>
			</tr>
	    </thead>
	</table>
<div id="tb">
	<a  href="javaScript:void(0)" onclick="addRole()" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">添加</a>
	<a  href="javaScript:void(0)" onclick="editRole()" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">修改</a>
	<a  href="javaScript:void(0)" onclick="deleteROle()" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true">删除</a>
</div>
</body>
</html>