<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html; charset=utf-8");
	response.setCharacterEncoding("utf-8");
	//1) 요청 분석(Controller)
	String deptNo = null;
	String deptName = null;
	if(! request.getParameter("deptNo").equals("") && request.getParameter("deptName").equals("")){
		deptNo = request.getParameter("deptNo");
		deptName = request.getParameter("deptName");		
	}else{
		response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
		return;
	}
	
	//db정보
	String url = "jdbc:mariadb://localhost:3306/employees";
	String user = "root";
	String password = "java1234";
	String sql = "INSERT INTO departments(dept_no, dept_name) VALUES(?,?);";
	
	// mariadb 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩 성공");
	
	// 연결
	Connection conn = DriverManager.getConnection(url, user, password);
	System.out.println(conn + " <--- 연결 성공");
	
	// 쿼리 실행
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, deptNo);
	stmt.setString(2, deptName);
	int row = stmt.executeUpdate();
	// 디버깅
	if(row == 1){
		System.out.println("입력 성공");
	}else{
		System.out.println("입력 실패");
	}
	
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
%>