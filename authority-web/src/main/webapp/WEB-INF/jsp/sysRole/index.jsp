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
<script type="text/javascript">
	$(function(){
		$("#roleTable").datagrid({
			pagination:true,
			toolbar:'#tb',
			idField:"id",
			onLoadSuccess:function(){
				$("a.op").tooltip({
					position:'right'
				});
			}
		})
	})
	
	function setCondition(){	
		var postData = {name :$("#rolename").val()};
		$("#roleTable").datagrid("reload",postData);
	}
	function deleteRole(){
		var selRows = $("#roleTable").datagrid("getSelections");
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
				$.post("role/bathDelete",postData,function(data){
					if(data.result==true){
						//刷新表格,
						$("#roleTable").datagrid("reload");
					}
				})
			}
		})
	}
	function addRole(){
		var d = $("<div></div>").appendTo("body");

		d.dialog({
			title:"添加角色",
			iconCls : "icon-add",
			width:500,
			height:500,
			modal:true,
			href:"role/form",
			onClose:function(){$(this).dialog("destroy"); },
			buttons:[{
				iconCls:"icon-ok",
				text:"确定",
				handler:function(){
					$("#roleFrom").form("submit",{
						url : "role/add",
						success : function(data){
							d.dialog("close");
							$("#roleTable").datagrid("reload");
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
	
	function editRole(){
		var row = $("#roleTable").datagrid("getSelected");
		if(row == null){
			return;
		}
		$("#roleTable").datagrid("clearSelections");
		$("#roleTable").datagrid("selectRecord",row.id);
		
		
		var d = $("<div></div>").appendTo("body");
		d.dialog({
			title:"修改用户",
			iconCls : "icon-edit",
			width:500,
			height:500,
			modal:true,
			href:"role/form",
			onClose:function(){$(this).dialog("destroy"); },
 			onLoad:function(){
				$.post("role/selectById",{id:row.id},function(data){
					$("#roleForm").form("load",data); 
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
				 	$("#roleForm").form("submit",{
						url : "role/edit",
						success : function(data){
							d.dialog("close");
							$("#roleTable").datagrid("reload");
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
	

	
	function opFormatter(value,row,index){
		return "<a href='javascript:void(0)' title='分配权限' onclick='assignPermission("+row.id+");' class='op'><img src='easyui/themes/icons/large_chart.png' width='16'/></a>";
	}
	
	function assignPermission(roleId){
		$("#roleTable").datagrid("clearSelections");
		var d = $("<div></div>").appendTo("body");
		d.dialog({
			title:"分配权限",
			width:250,
			height:400,
			href:"role/toAssign?roleId="+roleId,
			modal:true,
			onClose:function(){$(this).dialog("destroy")},
			buttons:[{
				iconCls:"icon-ok",
				text:"确定",
				handler:function(){
					//选中的节点，checked,indeterminate
					
					var nodes = $("#assignTree").tree("getChecked","checked");
					var half_nodes = $("#assignTree").tree("getChecked","indeterminate");
					//合并数组
					$.merge(nodes,half_nodes);
					
					//获取选中节点的编号，
					var postData = "";
					for (var i = 0; i < nodes.length; i++) {
						postData += "ids="+nodes[i].id+"&";
					}
					postData+="roleId="+roleId;
					
					$.post("role/assign",postData,function(data){
						
						//弹框提示:
						$.messager.show({
							title:'My Title',
							msg:'成功',
							timeout:3000,
							showType:'slide'
						});
						d.dialog("close");
					})
					
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
<body>

<form id="userCondition">
	<div class="easyui-panel" title="查询条件">
		rolename:<input type="text" name="" id="rolename" />
    	<a id="btn" href="javaScript:void(0)" onclick="setCondition()" class="easyui-linkbutton" data-options="iconCls:'icon-search'">serch</a>
	</div>
</form>

<div id="tb">
	<a  href="javaScript:void(0)" onclick="addRole()" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">添加</a>
	<a  href="javaScript:void(0)" onclick="editRole()" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">修改</a>
	<a  href="javaScript:void(0)" onclick="deleteROle()" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true">删除</a>
</div>
	<table id="roleTable" title="roleList" 
	    data-options="url:'role/list',fitColumns:true,striped:true,rownumbers:true,iconCls:'icon-search'">
	    
	    <thead>
			<tr>
				<th data-options="field:'asddsa',checkbox:true" ></th>
				<th data-options="field:'id',width:30,sortable:true,order:'desc'">Id</th>
				<th data-options="field:'name',width:100,sortable:true,order:'desc'	">name</th>
				<th data-options="field:'available',width:200">available</th>
				<th data-options="field:'hello',width:50,formatter:opFormatter">操作</th>
			</tr>
	    </thead>
	</table>
</body>
</html>