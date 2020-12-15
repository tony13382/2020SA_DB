<%@page import = "java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String stu_id = new String(request.getParameter("stu_id").getBytes("ISO-8859-1"));
    String name = new String(request.getParameter("name").getBytes("ISO-8859-1"));
    String gameId ="";

    
    try{
	    //載入資料庫驅動程式 
	    Class.forName("com.mysql.jdbc.Driver");	  
	    try {
	    	//建立連線 
	    	String url="jdbc:mysql://localhost/";
	    	Connection con=DriverManager.getConnection(url,"root","1234");   				
	    	if(con.isClosed())
	    		out.println("連線建立失敗");
	    	else{	
	    		//選擇資料庫
	    		con.createStatement().execute("use transaction");  
    
	    		//執行 SQL 指令        
	    		String sql = "Insert Into gamelogin(`stuId`, `name`,`totalRevenue`,`totalRent`,`totalRestock`,`totalEmergency`) VALUES ('"+stu_id+"', '"+name+"', '0', '0', '0', '0') ;";
	    		boolean no= con.createStatement().execute(sql); //執行成功傳回false
	    		
                //int no=con.createStatement().executeUpdate(sql); //可回傳異動數
                if (!no){
                    //顯示結果 
                    out.println("新增成功");
                    ResultSet rs2=con.createStatement().executeQuery("SELECT `idGameLogin` FROM gamelogin ORDER BY idGameLogin DESC Limit 1;");
                    while(rs2.next()){
                        gameId = rs2.getString("idGameLogin");
                    }
                    String sendUrl = "../game_set.jsp?stu_id="+stu_id+"&name="+name+"&month=1&gameID="+ gameId;
                    response.sendRedirect(sendUrl);
                }
                else{
                    out.println("新增失敗"); 
                    response.sendRedirect("../../index.jsp");
                }

	    		//關閉連線  
	    		con.close();
	    	}
	    }        
	    catch (SQLException sExec) {
	    	out.println("SQL錯誤"+sExec.toString());
            response.sendRedirect("../../index.jsp");
	    }
    }
    catch (ClassNotFoundException err) {
	    out.println("class錯誤"+err.toString());
        response.sendRedirect("../../index.jsp");
    }

%>