<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<%
	// user 세션확인
	String userID = null;
	if (session.getAttribute("userID") != null){
		userID = (String)session.getAttribute("userID");
	}
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1" >
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
	<title>jsp Ajax 실시간 회원제 채팅 시스템</title>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
	<script type="text/javascript">
	
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
				 	<li class="active"><a href="index.jsp">메인</a></li>
				 	<li><a href="find.jsp">친구찾기</a></li>
				 	<li><a href="box.jsp">메시지함<span id="unread" class="label label-info"></span></a></li>
				 	<li><a href="boardView.jsp">자유게시판</a></li> 
				 </ul>
				<%
					if(userID == null){
				%>
				 <ul class="nav navbar-nav navbar-right">
					<li class="dropdown">
						<a href="#" class = "dropdown-toggle" data-toggle="dropdown" role ="button" 
							aria-haspopup="true" aria-expanded="false">접속하기<span class="caret"></span>
						</a>
						<ul class="dropdown-menu">
							<li><a href="login.jsp">Login</a></li>
							<li><a href="join.jsp">Join</a></li>					
						</ul>
						</li>
					</ul>
				<%
					}else{
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

		if(userID != null){
	%>
			<script type="text/javascript">
				$(document).ready(function(){
					getUnread(); // 안읽은 메시지 수 바로 로딩하기.
					getInfiniteUnread();
				});
			</script>
	<%
		}
	%>
	<div class="container">
		<!-- Jumnbotron -->
		<div class="jumbotron">
			<div class="container">
				<h1>Hello.パク君です。</h1>
				<p class="lead">RealTimeChat Site made of Ajax, JSP, Sevlet, Bootstap</p>
				<p> 이 사이트는 Ajax와 model-2형식으로 만들어진 채팅 사이트입니다.	<br>
					답변을 달 수 있는 게시판도 구현했습니다. <br>
					디자인 템플릿은 푸트스트랩을 이용했습니다.</p>
			</div>
		</div>
	</div>
</body>
</html>