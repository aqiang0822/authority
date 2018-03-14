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
</head>
<body>
<script type="text/javascript">
	$(function(){
		$("#userTable").datagrid({
			pagination:true,
			toolbar:'#tb',
			idField:"id"
		})
	})
	function roleFormatter(value,row,index){
		if(value.length ==0){
			return "大哥";
		}
		var str = "";
		for (var i = 0; i < value.length; i++) {
			str+= value[i].name;
			if(i<value.length-1){
				str+=",";
			}
		}
		return str;
	}
	function setCondition(){	
		var postData = {username :$("#username").val()};
		var ids = $("#roles").combobox("getValues");
		for (var i = 0; i < ids.length; i++) {
			postData["sysRoles["+i+"].id"] = ids[i];
		}
		$("#userTable").datagrid("reload",postData);
	}
	
	function deleteUser(){
		var selRows = $("#userTable").datagrid("getSelections");
		if(selRows.length == 0){
			$.messager.alert("提示","请选择要删除的数据行！","warning");
			return;
		}
		
		$.messager.confirm("提示","确定删除吗?",function(r){
			if(r==true){
				//拼接删除条件，
				var postData = "";
				$.each(selRows,function(i){
					postData+="ids="+this.id;
					if(i<postData.length -1){
						postData+="&";
					}
				})
				$.post("user/bathDelete",postData,function(data){
					if(data.result==true){
						//刷新表格,
						$("#userTable").datagrid("reload");
					}
				})
			}
		})
	}
	function addUser(){
		var d = $("<div></div>").appendTo("body");

		d.dialog({
			title:"添加用户",
			iconCls : "icon-add",
			width:500,
			height:500,
			model:true,
			href:"user/form",
			onClose:function(){$(this).dialog("destroy"); },
			buttons:[{
				iconCls:"icon-ok",
				text:"确定",
				handler:function(){
					$("#userForm").form("submit",{
						url : "user/add",
						success : function(data){
							d.dialog("close");
							$("#userTable").datagrid("reload");
						}
					});
				}
			},{
				iconCls:"icon-cancel",
				text:"取消",
				handler:function(){
					d.dialog("close");
				}
			}]
		})
	}
	
	function editUser(){
		var row = $("#userTable").datagrid("getSelected");
		if(row == null){
			return;
		}
		$("#userTable").datagrid("clearSelections");
		$("#userTable").datagrid("selectRecord",row.id);
		
		
		var d = $("<div></div>").appendTo("body");
		d.dialog({
			title:"修改用户",
			iconCls : "icon-edit",
			width:500,
			height:500,
			model:true,
			href:"user/form",
			onClose:function(){$(this).dialog("destroy"); },
 			onLoad:function(){
				$.post("user/selectById",{id:row.id},function(data){
					$("#userForm").form("load",data); 
					var roles = new Array();
					$.each(data.sysRoles,function(){
						roles.push(this.id);
					})
					$("#roles_form").combobox("setValues",roles);
				})
			}, 
			buttons:[{
				iconCls:"icon-ok",
				text:"确定",
				handler:function(){
				 	$("#userForm").form("submit",{
						url : "user/edit",
						success : function(data){
							d.dialog("close");
							$("#userTable").datagrid("reload");
						}
					});
				}
			},{
				iconCls:"icon-cancel",
				text:"取消",
				handler:function(){
					d.dialog("close");
				}
			}]
		})
	}
</script>

<form id="userCondition">
	<div class="easyui-panel" title="查询条件">
		username:<input type="text" name="" id="username" />
		roles: <input id="roles" class="easyui-combobox" name="dept"
    			data-options="valueField:'id',textField:'name',url:'role/getAll',multiple:true,panelHeight:'auto',panelMaxWidth:500">
    	<a id="btn" href="javaScript:void(0)" onclick="setCondition()" class="easyui-linkbutton" data-options="iconCls:'icon-search'">serch</a>
	</div>
</form>

<div id="tb">
	<a  href="javaScript:void(0)" onclick="addUser()" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">添加</a>
	<a  href="javaScript:void(0)" onclick="editUser()" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">修改</a>
	<a  href="javaScript:void(0)" onclick="deleteUser()" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true">删除</a>
</div>
	<table id="userTable" title="userList" 
	    data-options="url:'user/list',fitColumns:true,striped:true,rownumbers:true,iconCls:'icon-search'">
	    
	    <thead>
			<tr>
				<th data-options="field:'asddsa',checkbox:true" ></th>
				<th data-options="field:'id',width:30,sortable:true,order:'desc'">Id</th>
				<th data-options="field:'username',width:100,sortable:true,order:'desc'	">userName</th>
				<th data-options="field:'password',width:200">pasword</th>
				<th data-options="field:'salt',width:100">salt</th>
				<th data-options="field:'sysRoles',width:100,formatter:roleFormatter">roels</th>
			</tr>
	    </thead>
	</table>
</body>
</html>