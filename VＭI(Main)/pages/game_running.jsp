<!DOCTYPE html>
<html>

<head>
  <meta charset="UTF-8">
  <%@ page contentType="text/html" pageEncoding="UTF-8"%>
  <%@page import = "java.sql.*"%>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Game</title>
  <link rel="stylesheet" href="../stylesheets/all.css">
  <link rel="stylesheet" href="../stylesheets/mula.css">
</head>

<%
  int monthnum = 1; 
  int times = 1;
  String srGameId = "";
  String stu_id = new String(request.getParameter("stu_id").getBytes("ISO-8859-1"));
  String name = new String(request.getParameter("name").getBytes("ISO-8859-1"));
  String reurl = "";
  try{
    //GET VALUE
   
    String month = new String(request.getParameter("month"));
    monthnum = Integer.parseInt(month);
    srGameId = request.getParameter("gameID");
    String srTimes = new String(request.getParameter("times"));
    times = Integer.parseInt(srTimes);//Times At Time
  }
  catch (Exception sExec) {
    out.println("GET VALUE ERROR");
    %>
      <script>window.history.go(-1)</script>
    <%
	}
  // 產生DB陣列
  String[][][] arrayDB;
  arrayDB = new String[4][4][8]; // 產生陣列
  for(int i=0;i<4;i++){
    for(int j=0;j<4;j++){
      arrayDB[i][j][0]="0"; //承租數量
      arrayDB[i][j][1]="0"; //幾天補貨
      arrayDB[i][j][2]="0"; //當日銷售量
      arrayDB[i][j][3]="0"; //前一日庫存
      arrayDB[i][j][4]="0"; //當日庫存
      arrayDB[i][j][5]="0"; //當日緊急補貨
      arrayDB[i][j][6]="0"; //當日補貨
    }
  }
  int[][][] arrayDBofShow;
  arrayDBofShow = new int[4][4][2];
  for(int i=0;i<4;i++){
    for(int j=0;j<4;j++){
      arrayDBofShow[i][j][0]=0; //補貨
      arrayDBofShow[i][j][1]=0; //緊急補貨
    }
  }
  
  //Call Value
  int beginDay = 0;
  int endDay = 0;
  int today = 0; //Record Today
  String srDate = ""; //Record
  try{
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
	  	  	String sql = "";
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
	  	  	con.createStatement().execute("use transaction");          
          int indexProduct = 0;
          int indexProducer = 0;
          
          sql = "select `rentQuantity`,`restockDay`,`idProducer`,`idProduct` from `monthparameter` where `idGameLogin` = '"+ srGameId +"'AND `month`="+(monthnum) ;
    			tmp =  con.createStatement().executeQuery(sql);
    			while(tmp.next()){		
    				indexProduct = Integer.parseInt(tmp.getString("idProduct"));
            indexProducer = Integer.parseInt(tmp.getString("idProducer"));
            arrayDB[indexProducer][indexProduct][0] = tmp.getString("rentQuantity");
    				arrayDB[indexProducer][indexProduct][1] = tmp.getString("restockDay");
    			}

          //SET Today Value
          today = beginDay + times - 1; 

          String sql2="use transaction";
          ResultSet tmp2 =  con.createStatement().executeQuery(sql2);
	  	  	con.createStatement().execute("use transaction");  

          int ram_SellValue = 0;
          int ram_Stock = 0;
          int ram_RestockDay = 0;
          for(indexProducer = 1; indexProducer < 4;indexProducer++){
            for(indexProduct = 1; indexProduct < 4; indexProduct++){
              con.createStatement().execute("use consult");  
              //SET Sell Value
              sql = "SELECT `sellValue` from `sellrecord` WHERE `date`='"+today+"' AND `idProducer` = '"+indexProducer+"' AND `idProduct` = '"+indexProduct+"'" ;
	  	  	    tmp =  con.createStatement().executeQuery(sql);
              while(tmp.next()){ 
                arrayDB[indexProducer][indexProduct][2] = tmp.getString("sellValue"); 
              }
              //SET Stock of Product
              con.createStatement().execute("use transaction");  
              sql = "SELECT `dayInventory` from `dayrunning` WHERE `date`='"+(today-1)+"' AND `idProducer` = '"+indexProducer+"' AND `idProduct` = '"+indexProduct+"' AND `idGameLogin` ='"+srGameId+"'" ;
	  	  	    tmp =  con.createStatement().executeQuery(sql);
	  	  	    while(tmp.next()){ 
                arrayDB[indexProducer][indexProduct][3] = tmp.getString("dayInventory");
                arrayDB[indexProducer][indexProduct][4] = arrayDB[indexProducer][indexProduct][3] ;
              }
              con.createStatement().execute("use transaction");  
              sql2 = "SELECT `rentQuantity`, `restockDay` from `monthparameter` WHERE `idProducer` = '"+indexProducer+"' AND `idProduct` = '"+indexProduct+"' AND `month` = '"+(monthnum)+"' AND `idGameLogin` ='"+srGameId+"'" ;
              tmp2 =  con.createStatement().executeQuery(sql2);
              while(tmp2.next()){ 
                ram_RestockDay = tmp2.getInt("restockDay");
                
                if((today%ram_RestockDay) == 0){ //補貨日
                  arrayDB[indexProducer][indexProduct][6] = "" + (tmp2.getInt("rentQuantity") - Integer.parseInt(arrayDB[indexProducer][indexProduct][4]));
                  arrayDB[indexProducer][indexProduct][4] = tmp2.getString("rentQuantity");
                }
                else{
                  arrayDB[indexProducer][indexProduct][6] = "0";
                }
                
                ram_SellValue = Integer.parseInt(arrayDB[indexProducer][indexProduct][2]);
                ram_Stock = Integer.parseInt(arrayDB[indexProducer][indexProduct][4]);
                
                //判斷是否緊急補貨
                if(ram_SellValue > ram_Stock){ 
                  arrayDB[indexProducer][indexProduct][5] = "" + (ram_SellValue - ram_Stock) ; //緊急補貨
                  arrayDB[indexProducer][indexProduct][4] = "0";
                }
                else{
                  arrayDB[indexProducer][indexProduct][4] = "" + (ram_Stock - ram_SellValue) ;
                  arrayDB[indexProducer][indexProduct][5] = "0";
                }
                
                
              }
              //寫入DB
              con.createStatement().execute("INSERT `dayrunning`(`idGameLogin`,`idProducer`,`idProduct`,`date`,`beginInventory`,`sellValue`,`dayInventory`,`restockValue`,`emergencyValue`) VALUE('"+srGameId+"','"+indexProducer+"','"+indexProduct+"','"+today+"','"+arrayDB[indexProducer][indexProduct][3]+"','"+arrayDB[indexProducer][indexProduct][2]+"','"+arrayDB[indexProducer][indexProduct][4]+"','"+arrayDB[indexProducer][indexProduct][6]+"','" + arrayDB[indexProducer][indexProduct][5] + "')");  
            }
          }
          for(int i=1;i<4;i++){
            for(int j=1;j<4;j++){
              arrayDBofShow[i][j][0]=Integer.parseInt(arrayDB[i][j][6]); 
              arrayDBofShow[i][j][1]=Integer.parseInt(arrayDB[i][j][5]);
            }
          }
          
          if(today == endDay){
            times = 1;
            reurl = "app/count_month_result.jsp?stu_id="+stu_id+"&name="+name+"&month="+(monthnum)+"&gameID="+ srGameId+"&times="+times;  
            response.setHeader ("refresh","5;URL="+reurl);
          }
          else{
            times++;
            reurl = "game_running.jsp?stu_id="+stu_id+"&name="+name+"&month="+monthnum+"&gameID="+ srGameId+"&times="+times;
            response.setHeader ("refresh","5;URL="+reurl);
          }

          
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
  }
  catch(Exception dbExec) {
    application.log("GerDBError");
    response.setHeader ("refresh","5;URL=../game_result.jsp?stu_id="+stu_id+"&name="+name+"&month="+monthnum+"&gameID="+ srGameId+"&times=1");

  }

  //GET DAY


%>
<body>
  <div class="container-fluid">
    <div class="mx-auto pt-3">
      <form class=""> <fieldset disabled> 
        <div class="row">
          <div class="col-md-3 col-12 pt-1">
            <h1 class="text-center">VMI </h1>
            <hr>
            <div class="card mx-auto">
              <div class="card-body">
                <div class="text-left">
                  <div class="form-group">
                    <label for="show_stuid">學號</label>
                    <input required type="text" class="form-control" disabled id="show_stuid" name="stu_id"
                      placeholder="Stu_ID" value="<%=stu_id%>">
                  </div>
                  <div class="form-group">
                    <label for="show_name">姓名</label>
                    <input required type="text" class="form-control" disabled id="show_name" name="name"
                      placeholder="Name" value="<%=name%>">
                  </div>
                </div>
                <h1 class="text-center text-warning">營運中</h1>
                <div class="text-left">
                  <div class="form-group">
                    <label for="input_month">月份</label>
                    <input required type="number" max="12" min="1" class="form-control" id="input_month" disabled
                      name="month" placeholder="Month" value="<%=monthnum%>">
                  </div>
                  <div class="form-group">
                    <label for="input_month">第幾天</label>
                    <input required type="number" max="360" min="1" class="form-control" id="input_month" disabled
                      name="day" placeholder="Day" value="<%=today%>">
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="col-md-9 col-12 pt-1">
            <div class="row">
              <div class="col-12">
                <h1>設定</h1>
                <hr>
              </div>
              <div class="col-12">
                <div class="row">
                  <div class="col-12 pt-2">
                    <h3>北蓋</h3>
                  </div>
                  <div class="col-12 col-md-6 col-lg-4">
                    <div class="card">
                      <div class="card-body">
                        <h5 class="card-title">北蓋IV</h5>
                        <div class="form-group">
                          <label for="title">今日銷貨</label>
                          <input required type="number" class="form-control" id="N_IV_Sell" name="N_IV_Sell"
                            placeholder="數量" value="<%=arrayDB[1][1][2]%>">
                        </div>
                        <div class="form-group">
                          <label for="title">承租欄位數量</label>
                          <input required type="number" class="form-control" id="set_n_IV_Rent" name="N_IV_Rent"
                            placeholder="數量" value="<%=arrayDB[1][1][0]%>">
                        </div>
                        <div class="form-group">
                          <label for="title">幾天補一次貨</label>
                          <input required type="number" class="form-control" id="set_n_IV_Give" name="N_IV_Give"
                            placeholder="數量" value="<%=arrayDB[1][1][1]%>">
                        </div>
                        <%
                        if(arrayDBofShow[1][1][0]>0){  
                        %>
                          <div class="mt-1" id="alert_area">
                            <div class="p-3 mb-2 bg-info text-white">補貨 <%=arrayDBofShow[1][1][0]%></div>
                          </div>
                        <%
                        }
                        %>
                        <%
                        if(arrayDBofShow[1][1][1]>0){  
                        %>
                        <div class="mt-1" id="alert_area">
                          <div class="p-3 mb-2 bg-danger text-white">緊急補貨 <%=arrayDBofShow[1][1][1]%></div>
                        </div>
                        <%
                        }
                        %>
                      </div>
                    </div>
                  </div>
                  <div class="col-12 col-md-6 col-lg-4">
                    <div class="card">
                      <div class="card-body">
                        <h5 class="card-title">北蓋VV</h5>
                        <div class="form-group">
                          <label for="title">今日銷貨</label>
                          <input required type="number" class="form-control" id="N_VV_Sell" name="N_VV_Sell"
                            placeholder="數量" value="<%=arrayDB[1][2][2]%>">
                        </div>
                        <div class="form-group">
                          <label for="title">承租欄位數量</label>
                          <input required type="number" class="form-control" id="set_n_VV_Rent" name="N_VV_Rent"
                            placeholder="數量" value="<%=arrayDB[1][2][0]%>">

                        </div>
                        <div class="form-group">
                          <label for="title">幾天補一次貨</label>
                          <input required type="number" class="form-control" id="set_n_VV_Give" name="N_VV_Give"
                            placeholder="數量" value="<%=arrayDB[1][2][1]%>">
                        </div>
                        <%
                        if(arrayDBofShow[1][2][0]>0){  
                        %>
                          <div class="mt-1" id="alert_area">
                            <div class="p-3 mb-2 bg-info text-white">補貨 <%=arrayDBofShow[1][2][0]%></div>
                          </div>
                        <%
                        }
                        %>
                        <%
                        if(arrayDBofShow[1][2][1]>0){  
                        %>
                        <div class="mt-1" id="alert_area">
                          <div class="p-3 mb-2 bg-danger text-white">緊急補貨 <%=arrayDBofShow[1][2][1]%></div>
                        </div>
                        <%
                        }
                        %>
                      </div>
                    </div>
                  </div>
                  <div class="col-12 col-md-6 col-lg-4">
                    <div class="card">
                      <div class="card-body">
                        <h5 class="card-title">北蓋CVV</h5>
                        <div class="form-group">
                          <label for="title">今日銷貨</label>
                          <input required type="number" class="form-control" id="sell_n_CVV_Rent" name="N_CVV_Sell"
                            placeholder="數量" value="<%=arrayDB[1][3][2]%>">
                        </div>
                        <div class="form-group">
                          <label for="title">承租欄位數量</label>
                          <input required type="number" class="form-control" id="set_n_CVV_Rent" name="N_CVV_Rent"
                            placeholder="數量" value="<%=arrayDB[1][3][0]%>">
                        </div>
                        <div class="form-group">
                          <label for="title">幾天補一次貨</label>
                          <input required type="number" class="form-control" id="set_n_CVV_Give" name="N_CVV_Give"
                            placeholder="數量" value="<%=arrayDB[1][3][1]%>">
                        </div>
                        <%
                        if(arrayDBofShow[1][3][0]>0){  
                        %>
                          <div class="mt-1" id="alert_area">
                            <div class="p-3 mb-2 bg-info text-white">補貨 <%=arrayDBofShow[1][3][0]%></div>
                          </div>
                        <%
                        }
                        %>
                        <%
                        if(arrayDBofShow[1][3][1]>0){  
                        %>
                        <div class="mt-1" id="alert_area">
                          <div class="p-3 mb-2 bg-danger text-white">緊急補貨 <%=arrayDBofShow[1][3][1]%></div>
                        </div>
                        <%
                        }
                        %>
                      </div>
                    </div>
                  </div>
                  <div class="col-12 pt-2">
                    <h3>中通</h3>
                  </div>
                  <div class="col-12 col-md-6 col-lg-4">
                    <div class="card">
                      <div class="card-body">
                        <h5 class="card-title">中通IV</h5>
                        <div class="form-group">
                          <label for="title">今日銷貨</label>
                          <input required type="number" class="form-control" id="sell_M_CVV_Rent" name="M_IV_Sell"
                            placeholder="數量" value="<%=arrayDB[2][1][2]%>">
                        </div>
                        <div class="form-group">
                          <label for="title">承租欄位數量</label>
                          <input required type="number" class="form-control" id="set_M_IV_Rent" name="M_IV_Rent"
                            placeholder="數量" value="<%=arrayDB[2][1][0]%>">
                        </div>
                        <div class="form-group">
                          <label for="title">幾天補一次貨</label>
                          <input required type="number" class="form-control" id="set_M_IV_Give" name="M_IV_Give"
                            placeholder="數量" value="<%=arrayDB[2][1][1]%>">
                        </div>
                        <%
                        if(arrayDBofShow[2][1][0]>0){  
                        %>
                          <div class="mt-1" id="alert_area">
                            <div class="p-3 mb-2 bg-info text-white">補貨 <%=arrayDBofShow[2][1][0]%></div>
                          </div>
                        <%
                        }
                        %>
                        <%
                        if(arrayDBofShow[2][1][1]>0){  
                        %>
                        <div class="mt-1" id="alert_area">
                          <div class="p-3 mb-2 bg-danger text-white">緊急補貨 <%=arrayDBofShow[2][1][1]%></div>
                        </div>
                        <%
                        }
                        %>
                      </div>
                    </div>
                  </div>
                  <div class="col-12 col-md-6 col-lg-4">
                    <div class="card">
                      <div class="card-body">
                        <h5 class="card-title">中通VV</h5>
                        <div class="form-group">
                          <label for="title">今日銷貨</label>
                          <input required type="number" class="form-control" id="sell_M_VV_Rent" name="M_VV_Sell"
                            placeholder="數量" value="<%=arrayDB[2][2][2]%>">
                        </div>
                        <div class="form-group">
                          <label for="title">承租欄位數量</label>
                          <input required type="number" class="form-control" id="set_M_VV_Rent" name="M_VV_Rent"
                            placeholder="數量" value="<%=arrayDB[2][2][0]%>">

                        </div>
                        <div class="form-group">
                          <label for="title">幾天補一次貨</label>
                          <input required type="number" class="form-control" id="set_M_VV_Give" name="M_VV_Give"
                            placeholder="數量" value="<%=arrayDB[2][2][1]%>">
                        </div>
                        <%
                        if(arrayDBofShow[2][2][0]>0){  
                        %>
                          <div class="mt-1" id="alert_area">
                            <div class="p-3 mb-2 bg-info text-white">補貨 <%=arrayDBofShow[2][2][0]%></div>
                          </div>
                        <%
                        }
                        %>
                        <%
                        if(arrayDBofShow[2][2][1]>0){  
                        %>
                        <div class="mt-1" id="alert_area">
                          <div class="p-3 mb-2 bg-danger text-white">緊急補貨 <%=arrayDBofShow[2][2][1]%></div>
                        </div>
                        <%
                        }
                        %>
                      </div>
                    </div>
                  </div>
                  <div class="col-12 col-md-6 col-lg-4">
                    <div class="card">
                      <div class="card-body">
                        <h5 class="card-title">中通CVV</h5>
                        <div class="form-group">
                          <label for="title">今日銷貨</label>
                          <input required type="number" class="form-control" id="sell_M_CVV_Rent" name="M_CVV_Sell"
                            placeholder="數量" value="<%=arrayDB[2][3][2]%>">
                        </div>
                        <div class="form-group">
                          <label for="title">承租欄位數量</label>
                          <input required type="number" class="form-control" id="set_M_CVV_Rent" name="M_CVV_Rent"
                            placeholder="數量" value="<%=arrayDB[2][3][0]%>">
                        </div>
                        <div class="form-group">
                          <label for="title">幾天補一次貨</label>
                          <input required type="number" class="form-control" id="set_M_CVV_Give" name="M_CVV_Give"
                            placeholder="數量" value="<%=arrayDB[2][3][1]%>">
                        </div>
                        <%
                        if(arrayDBofShow[2][3][0]>0){  
                        %>
                          <div class="mt-1" id="alert_area">
                            <div class="p-3 mb-2 bg-info text-white">補貨 <%=arrayDBofShow[2][3][0]%></div>
                          </div>
                        <%
                        }
                        %>
                        <%
                        if(arrayDBofShow[2][3][1]>0){  
                        %>
                        <div class="mt-1" id="alert_area">
                          <div class="p-3 mb-2 bg-danger text-white">緊急補貨 <%=arrayDBofShow[2][3][1]%></div>
                        </div>
                        <%
                        }
                        %>
                      </div>
                    </div>
                  </div>
                  <div class="col-12 pt-2">
                    <h3>南生</h3>
                  </div>
                  <div class="col-12 col-md-6 col-lg-4">
                    <div class="card">
                      <div class="card-body">
                        <h5 class="card-title">南生IV</h5>
                        <div class="form-group">
                          <label for="title">今日銷貨</label>
                          <input required type="number" class="form-control" id="sell_S_IV_Rent" name="S_IV_Sell"
                            placeholder="數量" value="<%=arrayDB[3][1][2]%>">
                        </div>
                        <div class="form-group">
                          <label for="title">承租欄位數量</label>
                          <input required type="number" class="form-control" id="set_S_IV_Rent" name="S_IV_Rent"
                            placeholder="數量" value="<%=arrayDB[3][1][0]%>">
                        </div>
                        <div class="form-group">
                          <label for="title">幾天補一次貨</label>
                          <input required type="number" class="form-control" id="set_S_IV_Give" name="S_IV_Give"
                            placeholder="數量" value="<%=arrayDB[3][1][1]%>">
                        </div>
                        <%
                        if(arrayDBofShow[3][1][0]>0){  
                        %>
                          <div class="mt-1" id="alert_area">
                            <div class="p-3 mb-2 bg-info text-white">補貨 <%=arrayDBofShow[3][1][0]%></div>
                          </div>
                        <%
                        }
                        %>
                        <%
                        if(arrayDBofShow[3][1][1]>0){  
                        %>
                        <div class="mt-1" id="alert_area">
                          <div class="p-3 mb-2 bg-danger text-white">緊急補貨 <%=arrayDBofShow[3][1][1]%></div>
                        </div>
                        <%
                        }
                        %>
                      </div>
                    </div>
                  </div>
                  <div class="col-12 col-md-6 col-lg-4">
                    <div class="card">
                      <div class="card-body">
                        <h5 class="card-title">南生VV</h5>
                        <div class="form-group">
                          <label for="title">今日銷貨</label>
                          <input required type="number" class="form-control" id="sell_S_VV_Sell" name="S_VV_Sell"
                            placeholder="數量" value="<%=arrayDB[3][2][2]%>">
                        </div>
                        <div class="form-group">
                          <label for="title">承租欄位數量</label>
                          <input required type="number" class="form-control" id="set_S_VV_Rent" name="S_VV_Rent"
                            placeholder="數量" value="<%=arrayDB[3][2][0]%>">
                        </div>
                        <div class="form-group">
                          <label for="title">幾天補一次貨</label>
                          <input required type="number" class="form-control" id="set_S_VV_Give" name="S_VV_Give"
                            placeholder="數量" value="<%=arrayDB[3][2][1]%>">
                        </div>
                        <%
                        if(arrayDBofShow[3][2][0]>0){  
                        %>
                          <div class="mt-1" id="alert_area">
                            <div class="p-3 mb-2 bg-info text-white">補貨 <%=arrayDBofShow[3][2][0]%></div>
                          </div>
                        <%
                        }
                        %>
                        <%
                        if(arrayDBofShow[3][2][1]>0){  
                        %>
                        <div class="mt-1" id="alert_area">
                          <div class="p-3 mb-2 bg-danger text-white">緊急補貨 <%=arrayDBofShow[3][2][1]%></div>
                        </div>
                        <%
                        }
                        %>
                      </div>
                    </div>
                  </div>
                  <div class="col-12 col-md-6 col-lg-4">
                    <div class="card">
                      <div class="card-body">
                        <h5 class="card-title">南生CVV</h5>
                        <div class="form-group">
                          <label for="title">今日銷貨</label>
                          <input required type="number" class="form-control" id="sell_S_CVV_Rent" name="S_CVV_Sell"
                            placeholder="數量" value="<%=arrayDB[3][3][2]%>">
                        </div>
                        <div class="form-group">
                          <label for="title">承租欄位數量</label>
                          <input required type="number" class="form-control" id="set_S_CVV_Rent" name="S_CVV_Rent"
                            placeholder="數量" value="<%=arrayDB[3][3][0]%>">

                        </div>
                        <div class="form-group">
                          <label for="title">幾天補一次貨</label>
                          <input required type="number" class="form-control" id="set_S_CVV_Give" name="S_CVV_Give"
                            placeholder="數量" value="<%=arrayDB[3][3][1]%>">
                        </div>
                        <%
                        if(arrayDBofShow[3][3][0]>0){  
                        %>
                          <div class="mt-1" id="alert_area">
                            <div class="p-3 mb-2 bg-info text-white">補貨 <%=arrayDBofShow[3][3][0]%></div>
                          </div>
                        <%
                        }
                        %>
                        <%
                        if(arrayDBofShow[3][3][1]>0){  
                        %>
                        <div class="mt-1" id="alert_area">
                          <div class="p-3 mb-2 bg-danger text-white">緊急補貨 <%=arrayDBofShow[3][3][1]%></div>
                        </div>
                        <%
                        }
                        %>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </fieldset></form>
    </div>
  </div>
  <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
    integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous">
  </script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.6/umd/popper.min.js"
    integrity="sha384-wHAiFfRlMFy6i5SRaxvfOCifBUQy1xHdJ/yoi7FRNXMRBu5WHdZYu1hA6ZOblgut" crossorigin="anonymous">
  </script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.2.1/js/bootstrap.min.js"
    integrity="sha384-B0UglyR+jN6CkvvICOB2joaf5I4l3gm9GU6Hc1og6Ls7i6U/mkkaduKaBhlAXv9k" crossorigin="anonymous">
  </script>
</body>
</html>
