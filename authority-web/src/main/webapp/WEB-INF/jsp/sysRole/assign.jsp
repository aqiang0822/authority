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
		
		

		$.post("role/getPermissions",{roleId:${roleId}},function(d){
			$("#assignTree").tree({
				//数据加载回来后，处理一下
				loadFilter:function(data){
					$.each(data,function(){
						//子节点
						$.each(this.children,function(){
							if($.inArray(this.id,d)!=-1){
								this.checked=true;
							}
						})
					})
					return data;
				}
			})
		})
	})
</script>

	<ul id="assignTree" data-options="url:'permission/list',checkbox:true"></ul>

</body>
</html>