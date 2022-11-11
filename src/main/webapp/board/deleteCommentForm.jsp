<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html; charset=utf-8");
	response.setCharacterEncoding("utf-8");
	
	//1. 요청분석 
	if(request.getParameter("boardNo") == null || request.getParameter("boardNo").equals("") || request.getParameter("commentNo") == null || request.getParameter("commentNo").equals("")){
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
		return;
	}
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>delete board</title>
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
		<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
		<script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.3/dist/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
		<link rel="stylesheet" href="../css/style.css">
	</head>
	<body class="bg-secondary">
		<div class="container rounded bg-white p-5 mt-5 w-50">
			<div class="fw-bold text-left font-weight-bold"><h3>댓글 삭제</h3></div>
			<form action="<%=request.getContextPath()%>/board/deleteCommentAction.jsp?commentNo=<%=commentNo%>&boardNo=<%=boardNo%>" method="post">
				<%
					if(request.getParameter("msg") != null){
				%>
						<div class="text-danger"><%=request.getParameter("msg")%></div>
						비밀번호 : <input class="form-control is-invalid" type="password" name="commentPw" required>
				<%		
					}else{
				%>
						비밀번호 : <input class="form-control" type="password" name="commentPw" required>
				<%		
					}
				%>
				
				<button class="btn btn-sm btn-outline-danger mt-3" type="submit">삭제하기</button>
			</form>
		</div>
	</body>
</html>