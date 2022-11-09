<%@page import="vo.Department"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.Department.*" %>
<%@ page import = "java.net.URLEncoder"%>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html; charset=utf-8");
	response.setCharacterEncoding("utf-8");
	
	//1) 요청 분석(Controller)
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");
	// 빈 값 검사
	if(deptNo == null || deptName == null || deptNo.equals("") || deptName.equals("")){
		response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
    	return;
	}
	Department d = new Department();
	d.deptNo = deptNo;
	d.deptName = deptName;
	
	//db정보
	String url = "jdbc:mariadb://localhost:3306/employees";
	String user = "root";
	String password = "java1234";
	String sql = "UPDATE departments SET dept_name=? WHERE dept_no = ?";
	String dupSql = "SELECT dept_name FROM departments WHERE dept_name = ?";
	// mariadb 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩 성공");
	
	// 연결
	Connection conn = DriverManager.getConnection(url, user, password);
	System.out.println(conn + " <--- 연결 성공");
	
	// 중복 검사 쿼리 실행
	PreparedStatement dupStmt = conn.prepareStatement(dupSql);
	dupStmt.setString(1, deptName);
	ResultSet dupRs = dupStmt.executeQuery();
	if(dupRs.next()){
		String msg = URLEncoder.encode(deptName+"은 사용할 수 없습니다.","utf-8");
		response.sendRedirect(request.getContextPath()+"/dept/updateDeptForm.jsp?msg="+msg+"&deptNo="+deptNo);
		return;
	}
	
	// 쿼리 실행
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, d.deptName);
	stmt.setString(2, d.deptNo);
	int row = stmt.executeUpdate();
	// 디버깅
	if(row == 1){
		System.out.println("수정 성공");
	}else{
		System.out.println("수정 실패");
	}
	
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
%>
