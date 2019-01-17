<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.net.URLDecoder" %>
    <%@ page import="user.UserDAO" %>
<!DOCTYPE html>
<html>
<head>

	<%
		// user 세션확인
		String userID = null;
		if (session.getAttribute("userID") != null){
			userID = (String)session.getAttribute("userID");
		}
		
		String toID =null;
		if (request.getParameter("toID") != null){
			toID = (String) request.getParameter("toID");
		}
		if (userID == null){
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "현재 로그인이 되어있지 않습니다.");
			response.sendRedirect("index.jsp");
			return;
		}
		if (toID == null){
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "대화 상대가 지정되지 않았습니다.");
			response.sendRedirect("index.jsp");
			return;
		}
		if(userID.equals(URLDecoder.decode(toID,"UTF-8"))){
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "자신에게는 쪽지를 보낼 수 없습니다.");
			response.sendRedirect("box.jsp");
			return;
		}
		
		String fromProfile = new UserDAO().getProfile(userID);
		String toProfile = new UserDAO().getProfile(toID);
	%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1" >
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
	<title>jsp Ajax 실시간 회원제 채팅 시스템</title>
	
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
	<!-- ajax를 통한 비동기식 통신을 이용한 메시지 submit 함수 -->
	<script type="text/javascript">
	
	// 결과 massage 함수
		function autoClosingAlert(selector, delay){
			var alert = $(selector).alert();
			alert.show();
			window.setTimeout(function(){alert.hide()}, delay);
		}
	// chat submit to DB function
		function submitFunction(){  
			var fromID = '<%= userID %>';
			var toID = '<%= toID %>';
			var chatContent = $('#chatContent').val();
			$.ajax({
				type: "POST",
				url: "./chatSubmitServlet",
				data:{
					fromID: encodeURIComponent(fromID),
					toID: encodeURIComponent(toID),
					chatContent: encodeURIComponent(chatContent),
				},
				success: function(result){
					if(result == 1){
						autoClosingAlert('#successMessage',2000);
					} else if (result == 0){
						autoClosingAlert('#dangerMessage',2000);
					} else {
						autoClosingAlert('#warningMessage',2000);
					}
				}
			});
			$('#chatContent').val('');
		}
	// chat List view function
		var lastID = 0; // 마지막 대화 ID
		function chatListFunction(type){
			var fromID = '<%= userID %>';
			var toID ='<%= toID %>';
			$.ajax({
				type:"POST",
				url:"./chatListServlet",
				data:{
					fromID: encodeURIComponent(fromID),
					toID: encodeURIComponent(toID),
					listType: type
				},
				success: function(data){
					if(data == "") return;
					var parsed = JSON.parse(data);
					var result = parsed.result;
					for(var i = 0; i< result.length; i++){
						if(result[i][0].value == fromID){
							result[i][0].value = '나';
						}
						addChat(result[i][0].value, result[i][2].value, result[i][3].value);
					}
					lastID = Number(parsed.last);
				}
			});
		}
		function addChat(chatName, chatContent, chatTime){
			if(chatName == '나'){
			$('#chatList').append('<div class="row">' + 
					'<div class = "col-lg-12">' +
					'<div class = "media">' +
					'<a class = "pull-left" href="#">' +
					'<img class="media-object img-circle" style="width:30px; height:30px;"src="<%= fromProfile %>" alt="">' +
					'</a>' +
					'<div class="media-body">' +
					'<h4 class="media-heading">' +
					chatName +
					'<span class="small pull-right">' +
					chatTime +
					'</span>' +
					'</h4>' +
					'<p>' +
					chatContent +
					'</p>' +
					'</div>' +
					'</div>' +
					'</div>' +
					'</div>' +
					'<hr>');
			} else {
				$('#chatList').append('<div class="row">' + 
						'<div class = "col-lg-12">' +
						'<div class = "media">' +
						'<a class = "pull-left" href="#">' +
						'<img class="media-object img-circle" style="width:30px; height:30px;"src="<%= toProfile %>" alt="">' +
						'</a>' +
						'<div class="media-body">' +
						'<h4 class="media-heading">' +
						chatName +
						'<span class="small pull-right">' +
						chatTime +
						'</span>' +
						'</h4>' +
						'<p>' +
						chatContent +
						'</p>' +
						'</div>' +
						'</div>' +
						'</div>' +
						'</div>' +
						'<hr>');
			}
			$('#chatList').scrollTop($('#chatList')[0].scrollHeight);
		}
		function getInfiniteChat(){	// '3000'(3초)간격으로 채팅이 왔는지 확인 함수
			setInterval(function(){
				chatListFunction(lastID);
			}, 3000);
		}
		
		function getUnread() {
			$.ajax({
				type: "POST",
				url: "./chatUnread",
				data: {
					userID: encodeURIComponent('<%= userID %>'),
				},
				success : function (result){
					if(result >=1 ){
						showUnread(result);
					}else{
						showUnread('');
					}
				}
			});
		}
		function getInfiniteUnread(){
			setInterval(function(){
				getUnread();
			}, 2000);
		}
		function showUnread(result){
			$('#unread').html(result);
		}
		
	</script>
</head>
<body>
	
	
	<!-- nav -->
	<nav class="navbar navbar-default" >
			<div class="navbar-header">
				<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" 
				data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
 					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="index.jsp">RealTime Chat</a>
			</div>
			<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
				 <ul class="nav navbar-nav">
				 	<li><a href="index.jsp">메인</a></li>
				 	<li><a href="find.jsp">친구찾기</a></li>
				 	<li><a href="box.jsp">메시지함<span id="unread" class="label label-info"></span></a></li>
				 	<li><a href="boardView.jsp">자유게시판</a></li>
				 </ul>
				 <%
				 	if(userID != null){
				 %>
				<ul class="nav navbar-nav navbar-right">
					<li class="dropdown">
						<a href="#" class = "dropdown-toggle" data-toggle="dropdown" role ="button" 
							aria-haspopup="true"aria-expanded="false">회원관리<span class="caret"></span>
						</a>
						<ul class="dropdown-menu">
							<li><a href="update.jsp">회원정보수정</a></li>
							<li><a href="profileUpdate.jsp">프로필사진수정</a></li>
							<li><a href="logoutAction.jsp">Logout</a></li>
						</ul>
					</li>
				 </ul>
				<%
					}
				%>
		</div>
	</nav><!-- /nav -->
	
	<!-- chat snipper -->
	<div class = "container bootstrap snipper">
		<div class="row">
			<div class="col-xs-12">
				<div class="portlet portlet-default">
					<div class="portlet-heading">
						<div class="portlet-title">
							<h4><i class="fa fa-circle text-green"></i>실시간 채팅창</h4>
						</div>
						<div class="clearfix"></div>
					</div>
					<div id="chat" class="panel-collapse collapse in">
						<div id ="chatList" class="portlet-body chat-widget" style="overflow-y: auto; width: auto; height:auto;">
						</div>
						<div class="portlet-footer">
							<div class="row" style="heigh:90px;">
								<div class="form-group col-xs-10">
									<textarea style="height:80px;" id="chatContent" class="form-control" placeholder="메세지를 입력하세요." maxlength="100"></textarea>
								</div>
								<div class="form-group col-xs-2">
									<button type="button" class="btn btn-default pull-right" onclick="submitFunction();">전송</button>
									<div class="clearfix"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="alert alert-success" id="successMessage" style="display:none;">
		<strong>메시지 전송에 성공했습니다.</strong>
	</div>
	<div class="alert alert-danger" id="dangerMessage" style="display:none;">
		<strong>이름과 내용을 모두 입력해주세요</strong>
	</div>
	<div class="alert alert-warning" id="warningMessage" style="display:none;">
		<strong>데이터베이스 오류가 발생했습니다.</strong>
	</div>
	
	<%
		String messageContent = null;
		if(session.getAttribute("messageContent")!= null){
			messageContent = (String) session.getAttribute("messageContent");
		}
		String messageType = null;
		if(session.getAttribute("messageType")!= null){
			messageType = (String) session.getAttribute("messageType");
		}
		if(messageContent!=null){
	%>
	
	<div class="modal fade" id="messageModal" tabindex="-1" role="dialog" aria-hideen="true">
		<div class="vertical-alignment-helper">
			<div class="modal-dialog vertical-align-center">
				<div class="modal-content <% if(messageType.equals("오류 메시지")) out.println("panel-warnig"); else out.println("panel-success"); %> ">
					<div class="modal-header panel-heading">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times</span>
							<span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title">
							<%= messageType %>
						</h4>
					</div>
					<div class="modal-body">
							<%= messageContent %>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" data-dismiss="modal">확인</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<script>
		$('#messageModal').modal("show"); 
	</script>
	<%
		session.removeAttribute("messageContent");
		session.removeAttribute("messageType");
		}
	%>
		<script>
		$(document).ready(function(){
			getUnread(); // 안읽은 메시지 수 바로 로딩하기.
			chatListFunction('0');
			getInfiniteChat();
			getInfiniteUnread();
		});
	</script>
</body>
</html>