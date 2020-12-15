<%@page import = "java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    //GET VALUE
    String stu_id = new String(request.getParameter("stu_id").getBytes("ISO-8859-1"));
    String name = new String(request.getParameter("name").getBytes("ISO-8859-1"));
    String month = new String(request.getParameter("month"));
    int monthnum = Integer.parseInt(month);
    String srGameId = new String(request.getParameter("gameID"));
    String[][][] arrayDB;
    arrayDB = new String[4][4][2]; // 產生陣列
    
    arrayDB[1][1][0] = request.getParameter("N_IV_Rent");
    arrayDB[1][2][0] = request.getParameter("N_VV_Rent");
    arrayDB[1][3][0] = request.getParameter("N_CVV_Rent");
    arrayDB[2][1][0] = request.getParameter("M_IV_Rent");
    arrayDB[2][2][0] = request.getParameter("M_VV_Rent");
    arrayDB[2][3][0] = request.getParameter("M_CVV_Rent");
    arrayDB[3][1][0] = request.getParameter("S_IV_Rent");
    arrayDB[3][2][0] = request.getParameter("S_VV_Rent");
    arrayDB[3][3][0] = request.getParameter("S_CVV_Rent");

    arrayDB[1][1][1] = request.getParameter("N_IV_Give");
    arrayDB[1][2][1] = request.getParameter("N_VV_Give");
    arrayDB[1][3][1] = request.getParameter("N_CVV_Give");
    arrayDB[2][1][1] = request.getParameter("M_IV_Give");
    arrayDB[2][2][1] = request.getParameter("M_VV_Give");
    arrayDB[2][3][1] = request.getParameter("M_CVV_Give");
    arrayDB[3][1][1] = request.getParameter("S_IV_Give");
    arrayDB[3][2][1] = request.getParameter("S_VV_Give");
    arrayDB[3][3][1] = request.getParameter("S_CVV_Give");


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
    			String sql ="";
                for(int indexProducer=1; indexProducer<4;indexProducer++){
                    for(int indexProduct=1;indexProduct<4;indexProduct++){
                        sql = "INSERT monthparameter(idGameLogin,month,idProducer,idProduct,rentQuantity,restockDay) " + "VALUES ('"+srGameId+"','"+month+"','"+indexProducer+"','"+indexProduct+"','"+arrayDB[indexProducer][indexProduct][0]+"','"+arrayDB[indexProducer][indexProduct][1]+"')";
                        out.println(sql);
                        boolean no= con.createStatement().execute(sql);
                        if (!no){
                        }
                        else{
                            out.println("新增失敗"); 
                            
                        }
                        
                    }
                }
                String sendUrl = "../game_running.jsp?stu_id="+stu_id+"&name="+name+"&month="+monthnum+"&gameID="+ srGameId+"&times=1";
                response.sendRedirect(sendUrl);
                
    			//關閉連線  
    			con.close();
    		}
    	}        
    	catch (SQLException sExec) {
    		out.println("SQL錯誤"+sExec.toString());
            %>
                <script>window.history.go(-1)</script>
            <%
    	}
    }
    catch (ClassNotFoundException err) {
    	out.println("class錯誤"+err.toString());
        %>
             <script>window.history.go(-1)</script>
        <%
    }
%>