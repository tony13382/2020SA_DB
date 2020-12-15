<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import = "java.sql.*"%>

<%
//Call Value
int beginDay = 0;
int endDay = 0;
String srGameId = "";
String stu_id = new String(request.getParameter("stu_id").getBytes("ISO-8859-1"));
String name = new String(request.getParameter("name").getBytes("ISO-8859-1"));
String reurl = "";
String month = new String(request.getParameter("month"));
int monthnum = Integer.parseInt(month);
srGameId = request.getParameter("gameID");

String[][][] arrayDB;
arrayDB = new String[4][4][11]; // 產生陣列
for(int i=0;i<4;i++){
    for(int j=0;j<4;j++){
        arrayDB[i][j][0]="0"; //承租數量
        arrayDB[i][j][1]="0"; //幾天補貨
        arrayDB[i][j][2]="0"; //當月總SellTOTAL
        arrayDB[i][j][3]="0"; //當月總收入
        arrayDB[i][j][4]="0"; //當月儲位數量
        arrayDB[i][j][5]="0"; //當月儲位租金
        arrayDB[i][j][6]="0"; //當月補貨次數
        arrayDB[i][j][7]="0"; //當月補貨費用
        arrayDB[i][j][8]="0"; //當月緊急運輸
        arrayDB[i][j][9]="0"; //當月運輸費用
    }
}

int indexProducer = 0;
int indexProduct = 0;
String srRam="";
float numRam = 0;
String srDate = "";
String sql = "";
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
			con.createStatement().execute("use consult");  
		
            //執行 SQL 指令        
            sql = "SELECT `date` from `comparedate` WHERE `month`='"+ monthnum +"'ORDER BY `date` DESC Limit 1" ;
	  	  	ResultSet tmp =  con.createStatement().executeQuery(sql);
	  	  	while(tmp.next()){ 
                srDate = tmp.getString("date");
                endDay = Integer.parseInt(srDate);
            }
            sql = "SELECT `date` from `comparedate` WHERE `month`='"+monthnum+"'ORDER BY `date` Limit 1" ;
	  	  	tmp =  con.createStatement().executeQuery(sql);
	  	  	while(tmp.next()){ 
                srDate = tmp.getString("date");
                beginDay = Integer.parseInt(srDate);
            }
            float floatRam = 0;
            for(indexProducer=1;indexProducer<4;indexProducer++){
                for(indexProduct=1;indexProduct<4;indexProduct++){
			        con.createStatement().execute("use transaction");  
                    sql = "SELECT COALESCE(SUM(`sellValue`), 0) AS `RS`,`idProducer`,`idProduct`  from `dayrunning` WHERE `idProducer` = '"+indexProducer+"' AND `idProduct` = '"+indexProduct+"' AND `idGameLogin` ='"+ srGameId +"' AND `date` >= '"+ beginDay+"' AND `date` <= '"+endDay+"' AND `sellValue` IS NOT NULL Group by `idGameLogin` = '"+srGameId+"'" ;
                    tmp =  con.createStatement().executeQuery(sql);
                    while(tmp.next()){
                        arrayDB[indexProducer][indexProduct][2] = tmp.getString("RS");
                    }
                }
            }
            floatRam = 0;
            float incomePerOne=0;
			con.createStatement().execute("use consult");  
	        sql = "SELECT `value` FROM `parameter` WHERE `parameter` = 'serviceIncome'";
            tmp =  con.createStatement().executeQuery(sql);
            while(tmp.next()){		
		        srRam = tmp.getString("value");
                incomePerOne = Float.parseFloat(srRam);
		    }
            for(indexProducer=0;indexProducer<4;indexProducer++){
                for(indexProduct=0;indexProduct<4;indexProduct++){
                    srRam = arrayDB[indexProducer][indexProduct][2];
                    numRam = Float.parseFloat(srRam);
                    arrayDB[indexProducer][indexProduct][3] = "" + (numRam*incomePerOne);
                }
            }

			con.createStatement().execute("use transaction");  
            
			//執行 SQL 指令        
			sql = "SELECT `rentQuantity` FROM `monthparameter` WHERE `idProducer` = '"+indexProducer+"' AND `idProduct` = '"+indexProduct+"' AND `idGameLogin` = '"+srGameId+"' AND `month` = '"+month+"'" ;
	  	  	tmp =  con.createStatement().executeQuery(sql);
            while(tmp.next()){
                indexProducer = tmp.getInt("idProducer");
                indexProduct = tmp.getInt("idProduct");
			    arrayDB[indexProducer][indexProduct][4] = tmp.getString("rentQuantity");
            }
            
			con.createStatement().execute("use consult");  
            float rentPricePerOne=0;
            sql = "SELECT `value` FROM `parameter` WHERE `parameter` = 'rentPrice'";
            tmp =  con.createStatement().executeQuery(sql);
            while(tmp.next()){		
		        srRam = tmp.getString("value");
                rentPricePerOne = Float.parseFloat(srRam);
		    }
            for(indexProducer=0;indexProducer<4;indexProducer++){
                for(indexProduct=0;indexProduct<4;indexProduct++){
                    srRam = arrayDB[indexProducer][indexProduct][4];
                    numRam = Float.parseFloat(srRam);
                    arrayDB[indexProducer][indexProduct][5] = "" + (numRam*rentPricePerOne);
                }
            }

            floatRam = 0;
            //執行 SQL 指令      

            con.createStatement().execute("use transaction");    
			for(indexProducer=1;indexProducer<4;indexProducer++){
                for(indexProduct=1;indexProduct<4;indexProduct++){
                    sql = "SELECT COUNT(`restockValue`) AS `DELIVER_TIMES` FROM `dayrunning` WHERE `restockValue` > 0 AND `idProducer` = '"+indexProducer+"' AND `idProduct` ='"+indexProduct+"' AND `idGameLogin` = '"+srGameId+"' AND `date` >= "+beginDay+" AND `date` <= '"+endDay+"' ";
                    tmp =  con.createStatement().executeQuery(sql);
                    while(tmp.next()){		
			            arrayDB[indexProducer][indexProduct][6] = tmp.getString("DELIVER_TIMES");
			        }
                }
            }

			con.createStatement().execute("use consult");  
            float restockPricePerOne=0;
            sql = "SELECT `value` FROM `parameter` WHERE `parameter` = 'restockPrice'";
            tmp =  con.createStatement().executeQuery(sql);
            while(tmp.next()){		
		        srRam = tmp.getString("value");
                restockPricePerOne = Float.parseFloat(srRam);
		    }
            for(indexProducer=0;indexProducer<4;indexProducer++){
                for(indexProduct=0;indexProduct<4;indexProduct++){
                    srRam = arrayDB[indexProducer][indexProduct][6];
                    numRam = Float.parseFloat(srRam);
                    arrayDB[indexProducer][indexProduct][7] = "" + (numRam*rentPricePerOne);
                }
            }
            
			con.createStatement().execute("use transaction");  
            for(indexProducer=1;indexProducer<4;indexProducer++){
                for(indexProduct=1;indexProduct<4;indexProduct++){
			        sql = "SELECT COALESCE(SUM(`emergencyValue`)) AS `RS` , `idProducer`, `idProduct` FROM `dayrunning` WHERE `idProducer`= '"+indexProducer+"' AND `idProduct` = '"+indexProduct+"' AND `date` >= '"+beginDay+"' AND `date` <= '"+endDay+"' AND `idGameLogin` = '"+srGameId+"' AND `emergencyValue` IS NOT NULL Group by `idGameLogin` = '"+srGameId+"'" ;
                    tmp =  con.createStatement().executeQuery(sql);
                    while(tmp.next()){		
			            arrayDB[indexProducer][indexProduct][8] = tmp.getString("RS");
			        }
                }
            }
			con.createStatement().execute("use consult");  
            float emergencyPricePerOne=0;
            sql = "SELECT `value` FROM `parameter` WHERE `parameter` = 'emergencyPrice'";
            tmp =  con.createStatement().executeQuery(sql);
            while(tmp.next()){		
		        srRam = tmp.getString("value");
                emergencyPricePerOne = Float.parseFloat(srRam);
		    }
            for(indexProducer=0;indexProducer<4;indexProducer++){
                for(indexProduct=0;indexProduct<4;indexProduct++){
                    srRam = arrayDB[indexProducer][indexProduct][8];
                    numRam = Float.parseFloat(srRam);
                    arrayDB[indexProducer][indexProduct][9] = "" + (numRam*emergencyPricePerOne);
                }
            }

			con.createStatement().execute("use transaction");  
            for(indexProducer = 1;indexProducer < 4;indexProducer++){
                for(indexProduct= 1 ;indexProduct <4; indexProduct++){
                    sql = "INSERT `monthresult`(`idGameLogin`,`month`,`idProducer`,`idProduct`,`monthRevenue`,`monthRent`,`monthRestock`,`monthEmergency`) VALUES ('"+srGameId+"','"+month+"','"+indexProducer+"','"+indexProduct+"','"+arrayDB[indexProducer][indexProduct][3]+"','"+arrayDB[indexProducer][indexProduct][5]+"','"+arrayDB[indexProducer][indexProduct][7]+"','"+arrayDB[indexProducer][indexProduct][9]+"')";
                    boolean no= con.createStatement().execute(sql); //執行成功傳回false
                    //int no=con.createStatement().executeUpdate(sql); //可回傳異動數
                    if (!no){
                    	//顯示結果 
                    }
                    else{
                        out.println("新增失敗"); 
                    }
                }
            }
            reurl = "../game_result.jsp?stu_id="+stu_id+"&name="+name+"&month="+monthnum+"&gameID="+ srGameId+"&times=1";
            response.setHeader ("refresh","0;URL="+reurl);
			//關閉連線  
			con.close();
		}
	}        
	catch (SQLException sExec) {
		out.println("SQL錯誤"+sExec.toString());
	}
}
catch (ClassNotFoundException err) {
	out.println("class錯誤"+err.toString());
}


%>