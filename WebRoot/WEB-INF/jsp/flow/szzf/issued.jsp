<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
	<head>
		<title>下发案件</title>
		<%@ include file="/common/meta.jsp"%>
    <link rel="stylesheet" type="text/css" href="${ctx}/styles/css/plan.css"/>
    <link rel="stylesheet" type="text/css" href="${ctx}/styles/css/style.css"  media="all" />
     <link rel="stylesheet" type="text/css" href="${ctx}/views/common/css/themes/css/jquery-ui-jquiGui.css"/>
    <link rel="stylesheet" type="text/css" href="${ctx}/views/common/css/themes/css/flexigrid/flexigrid.css"/>
    <link rel="stylesheet" type="text/css" href="${ctx}/views/common/css/themes/css/jquiGui.css"/>
    <style> 
.from-below,.from-below-to-below .effeckt-modal {
	-webkit-transform: translateX(100%);
	-ms-transform: scale(0.5);
	-o-transform: scale(0.5);
	transform: scale(0.5);
	opacity: 0;
	-webkit-transition: all 500ms;
	-o-transition: 500ms;
	transition: 500ms;
}

.effeckt-show,.effeckt-show.from-below-to-below .effeckt-modal {
	-webkit-transform: translateX(0);
	-ms-transform: scale(1);
	-o-transform: scale(1);
	transform: scale(1);
	opacity: 1;
}

.effeckt-show .effeckt-modal {
	visibility: visible;
}
    
	fieldset{border:1px solid #9AC3E1;margin-top:10px;}
	legend{font-size: 16px;color: #0071b1;font-weight: bold;}
    </style> 
    <script src="${ctx}/views/common/js/jquery.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="${ctx}/views/common/js/jquery-ui.custom.min.js"></script>
    <script type="text/javascript" src="${ctx}/views/common/js/common.js"></script>
		 		<script type="text/javascript">
		 		var szzf_user = {
					changeAuth:function(){
			        var dlg_auth_distribute = $("#dlg_auth_distribute").dialog({
				        position: ['center','top'],
        				draggable :false,     
						autoOpen: false,
						height:$(window).height()*0.8,
					    width:$(window).width()*0.5,
						show: "slide",
						modal:true,
						cache:false,
						/* hide: "explode", */
						title:'批量分配角色',
						buttons:{
							"确定":function(){
								szzf_user.saveAuth();
							}
						}
					});
			        $.ajax({
			            type:"get",
			            dataType:"text",
			            async:false,
			            url:"queryUser!getUserList.action?assignee=${map.assignee}",
			            success:function(result) {
			            $("#username_list1").html("");
			            $("#username_list2").html("");
			            	var data=eval("("+result+")");
							var html = '';
							var html2 = '';
							var leftValue = $("#userList").val();
							if(leftValue.length == 0){
								for (var i in data) {
									html += '<option value="'+data[i].USERNAME+'">'+data[i].TRUENAME+'</option>';
								}
								$("#username_list1").append(html);
							}else{
								var leftVals = leftValue.split(",");
								for (var i in data) {
								var flag = false;
									for(var j in leftVals){
										if(data[i].TRUENAME == leftVals[j]){
										flag = true;
											html2 += '<option value="'+data[i].USERNAME+'">'+data[i].TRUENAME+'</option>'; 
										}
									}
									if(!flag){
										html += '<option value="'+data[i].USERNAME+'">'+data[i].TRUENAME+'</option>';
									}
								}
								$("#username_list1").append(html);
								$("#username_list2").append(html2);
							}
			            }
			        });
			        dlg_auth_distribute.dialog("open");
			},
			saveAuth:function(){
				var admin_id ="";
				var username ="";
				if(document.authchoose.username_list2.options.length==0){
					showMsg("请选择用户！");
					return;
				}
				 for(var i=0;i<document.authchoose.username_list2.options.length;i++){
					admin_id += document.authchoose.username_list2.options[i].value+",";
					username += document.authchoose.username_list2.options[i].text+",";
				}
				$("#userList").val(admin_id);
				$('#dlg_auth_distribute').dialog('close');
				var data = {};
				data.processId = $("#processId").val();
				data.issFile = $("#path_plann_file").val();
				data.orderId = $("#orderId").val();
				data.taskId = $("#taskId").val();
				data.taskName = $("#taskName").val();
				data.assignee = $("#assignee").val();
				data.userList =$("#userList").val();
				 $.ajax({
		        	url:"szzf!process.action",
		        	type:"POST",
		        	cache: false,
		    		data:data,
		    		success: function(msg){
		    			if("success" === msg){
		    				alert("提交成功");		    				
		    			    //跳转到审批列表
		    				bakIframe("${map.label}","${map.bakurl}");
		    			}
		    		}     	
        		});   
			}
	
	};
	
//        function closeIframe(){
//     	$(window.top.document).find(".ui-tabs-nav > li.ui-state-active > div > span.tabs-close").click();
//     }
    
    $(function(){
    	$("#begin").click();
    	$("#plann_file1").change(function() 
    	{        
    		$("#upplann_form1").submit();
    	});
    });
 
    //调用返回上传结果 
    function get_upfile_result(res){
     	if(1 == Number(res.mess_state)){
     		alert(res.message);
     		$("#promotionShow_plann").html(res.newFileName);
   	        $("#path_plann_file").val(res.rs_path);
     	}else{
     		alert(res.message);
     	}
    };
 
       function moveOption(list1,list2){
			 var options = list1.options;
			 for(var i=0;i<options.length;i++){
				 if(options[i].selected){
					 list2.appendChild(options[i]);
					 i--;
				 }
			 }
	} 
      
	
 function personDetails(com) {
			$("#formTable_issued").html("");
				$("#flowTable_issued").html("");
		         
							var orderId = "${map.orderId}"; 
							var pid = "${map.processId}";
							
								
								if(com == 2){
									url = "borrow!view.action";
									 data = {"orderId" : orderId,"processId":pid,"path":"${map.path}"};
								}else{
									
									 url = "lczl!viewStep.action";
									 data = {"orderId" : orderId};
								}
							
							$.ajax({
								type:"POST",
								data:data,
								cache: false,
								async:false,
								url: url,
								success:function(result)
								{	
								
								    if(com == 1){
								    var result_str = createHtml(result);
								    $("#flowTable_issued").append(result_str);
								    }else{
								    $("#formTable_issued").append(result);
								    }
								    $("#view_issued .tab li").click(function(){
											$("#view_issued .tab li").removeClass("current");
											$(this).addClass("current");
											var n = $(this).index();
											$("#view_issued .content_y ul").hide();
											$("#view_issued .content_y ul").eq(n).show();
		                            });
								}								
							});						
						document.getElementById("msg_end").click();
		
			}
	
</script>
		
	</head>
	<body style=" overflow: auto;">
	<%-- 	<form id="inputForm" action="${ctx}/szzf!process.action" method="post" target="mainFrame"> --%>
			<input type="hidden" name="processId" id="processId" value="${map.processId }" />
			<input type="hidden" name="orderId" id="orderId" value="${map.orderId }" />
			<input type="hidden" name="taskId" id="taskId" value="${map.taskId }" />
			<input type="hidden" name="taskName" id="taskName" value="${map.taskName}" />
			<input type="hidden" id="assignee" id="assignee" name="assignee" value="${map.assignee}"/>
			<input type="hidden" name="userList" id="userList"/>
			<input type="hidden" name="path_plann_file" id="path_plann_file" />
			<fieldset>
             <legend>【${map.label}】</legend>
			<table align="center" border="0" cellpadding="0"
				cellspacing="0" style="border-top: 1px solid #9AC3E1;">
				<tr>
				<td class="td_table_1">
					<span>附件</span>
				</td>
				<td class="td_table_2" >
			    <img src="${ctx}/images/loading.gif" id="loading" style="display: none;">
			    <form action="upload!upl.action" method="POST" enctype="multipart/form-data" id="upplann_form1" target="result_upfile_iss">
				<input type="file" id="plann_file1" name="plann_file1" />
				</form>
				<div id="promotionShow_plann"></div>
				<iframe id="result_upfile_iss" name="result_upfile_iss" style="position:absolute; top:-9999px; left:-9999px"></iframe>
				</td>
			</tr>
			
           </table>
           </fieldset>
           
    <table align="center" border="0" cellpadding="0" cellspacing="0">
				<tbody>	<tr align="center">
					<td colspan="2" class="h50">
						<input type="button" class="selectBtn"  value="提交" onclick="szzf_user.changeAuth();"/>
						&nbsp;&nbsp;
						<input type="button" class="selectBtn" name="reback" value="返回"
							onclick="bakIframe('${map.label}','${map.bakurl}')">
					</td>
				</tr>
			</tbody></table>       
           
           
           
           
           
		<!-- </form> -->
		<div id="view_issued">
		<div class="outer">
			<ul class="tab">
				<li class="current" onclick="personDetails(1)" id="begin">流程详情</li>
				<li onclick="personDetails(2)">查看表单</li>
			</ul>
			<div class="content_y">

						<div id="flowTable_issued"></div>

						<div id="formTable_issued"></div>

			</div>
		</div>

	</div>
<div><a id="msg_end" name="1" href="#1">&nbsp</a></div>		
		<div id="dlg_auth_distribute" style="display:none">
		<form method = "post" name ="authchoose">
			<table border="0">
				<tr style="height:35px">
					<td class="wi-align-l" style="text-align:center">待分配用户：</td>
					<td class="wi-align-l" ></td>
					<td class="wi-align-l" style="text-align:center">已选择用户：</td>
					
				</tr>
				<tr>
					<td>
						<select multiple name="username_list1" id="username_list1" class="wi-sel-1" style="width:150px;height:260px" >
						</select>
					</td>
					<td style="width:200px;text-align:center">
						<input style="width:50px" type ="button" value ="添加" onclick="moveOption(document.authchoose.username_list1,document.authchoose.username_list2);"><br/><br/>
						<input style="width:50px" type ="button" value ="移除" onclick="moveOption(document.authchoose.username_list2,document.authchoose.username_list1);"><br/>
					</td>
					<td >
						<select multiple name="username_list2" id="username_list2" class="wi-sel-1" style="width:150px;height:260px" >
						</select>
					</td>
				</tr>
			</table>
		</form>
	</div>
	
	</body>
</html>
