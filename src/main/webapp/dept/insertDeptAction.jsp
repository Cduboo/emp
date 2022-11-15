<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import = "java.net.URLEncoder"%>
<%
	//인코딩
	request.setCharacterEncoding("utf-8");
	response.setContentType("text/html; charset=utf-8");
	response.setCharacterEncoding("utf-8");
	//1) 요청 분석(Controller)
	String deptNo = null;
	String deptName = null;
	// 빈 값 검사
	if(request.getParameter("deptNo")==null ||  request.getParameter("deptName")==null || request.getParameter("deptNo").equals("") || request.getParameter("deptName").equals("")){
		response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
		return;
	}else{
		deptNo = request.getParameter("deptNo");
		deptName = request.getParameter("deptName");		
	}
	
	//db정보
	String url = "jdbc:mariadb://localhost:3306/employees";
	String user = "root";
	String password = "java1234";
	String sql = "INSERT INTO departments(dept_no, dept_name) VALUES(?,?);";
	String sql1 = "SELECT dept_no FROM departments WHERE dept_no=?";
	String sql2 = "SELECT dept_name FROM departments WHERE dept_name=?";
	//2)
	// mariadb 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	// 연결
	Connection conn = DriverManager.getConnection(url, user, password);
	
	//2-1) dept_no 중복 검사
	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	stmt1.setString(1, deptNo);
	ResultSet rs1 = stmt1.executeQuery();
	if(rs1.next()){
		String msg1 = URLEncoder.encode(deptNo+"는 사용할 수 없습니다.","utf-8");
		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp?msg1="+msg1+"&deptName="+deptName);
		return;
	}
	//2-2) dept_name 중복 검사
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, deptName);
	ResultSet rs2 = stmt2.executeQuery();
	if(rs2.next()){
		String msg2 = URLEncoder.encode(deptName+"는 사용할 수 없습니다.","utf-8");
		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp?msg2="+msg2+"&deptNo="+deptNo);
		return;
	}
	//2-3)
	// 입력 쿼리 실행
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, deptNo);
	stmt.setString(2, deptName);
	int row = stmt.executeUpdate();
	
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
	
	rs1.close();
	rs2.close();
	stmt.close();
	stmt1.close();
	stmt2.close();
	conn.close();
%>