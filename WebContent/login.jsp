<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1" >
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
	<title>jsp Ajax 실시간 회원제 채팅 시스템</title>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
	<script type="text/javascript">
	function registerCheckFunction(){
			var userID = $('#userID').val();
			$.ajax({
				type:'POST',
				url:'./UserRegisterCheckServlet',
				data : {userID: userID},
				success : function(result){
					if(result ==1){
						$('#checkMessage').html('사용할 수 있는 아이디입니다.');
						$('#checkType').attr('class','modal-content panel-success');
					}else{
						$('#checkMessage').html('사용할 수 없는 아이디입니다.');
						$('#checkType').attr('class','modal-content panel-warning');
					}
					$('#checkModal').modal("show");
				}
			});
	}
	function passwordCheckFunction(){
			var userPassword1 = $('#userPassword1').val();
			var userPassword2 = $('#userPassword2').val();
			if(userPassword1 != userPassword2){
				$('#passwordCheckMessage').html('비밀번호가 서로 일치하지 않습니다.');
			}else{
				$('#passwordCheckMessage').html('');
			}
	}
	</script>
	
</head>
<body>
	<%
		// user 세션확인
		String userID = null;
		if (session.getAttribute("userID") != null){
			userID = (String)session.getAttribute("userID");
		}
		if (userID != null){
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "현재 로그인이 되어있습니다.");
			response.sendRedirect("index.jsp");
			return;
		}
	%>
	
	
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
				 	<li><a href="index.jsp">메인</a>
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
							<li class="active"><a href="login.jsp">Login</a></li>
							<li><a href="join.jsp">Join</a></li>					
						</ul>
						</li>
					</ul>
				<%
					}
				%>
		</div>
	</nav>
	<!-- /nav -->
	
	<div class="container">
		<form method="post" action="./userLogin">
			<table class="table table-bordered table-hover" style="text-align:center; border:1px solid #dddddd">
				<thead>
					<tr>
						<th colspan="2"><h4>로그인 양식</h4></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style = "width:110px;"><h5>ID</h5></td>
						<td><input class="form-control" type="text" name="userID" maxlength="20" placeholder="아이디를 입력하세요."></td>
					</tr>
					<tr>
						<td style = "width:110px;"><h5>PW</h5></td>
						<td><input class="form-control" type="password" name="userPassword" maxlength="20" placeholder="패스워드를 입력하세요."></td>
					</tr>
					<tr>
						<td style = "text-align:left;" colspan="2"><input class = "btn btn-primary pyll-rignt" type="submit" value="login"></td>
					</tr>	
				</tbody>
			</table>
		</form>
	
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
	
	<div class="modal fade" id="checkModal" tabindex="-1" role="dialog" aria-hidden="true"> 
		<div class="vertical-alignment-helper">
			<div class="modal-dialog vertical-align-center">
				<div id="checkType" class="modal-content panel-info">
					<div class="modal-header panel-heading">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times</span>
							<span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title">
							확인 메시지
						</h4>
					</div>
					<div id="checkMessage" class="modal-body">
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" data-dismiss="modal">확인</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>