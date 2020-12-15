<!DOCTYPE html>
<html lang="en">

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

int indexProducer = 0;
int indexProduct = 0;
String srRam="";
float numRam = 0;
int numRamInt1 =0 ;
int numRamInt2 =0 ;
int numRamInt3 =0 ;
int numRamInt4 =0 ;
String srDate = "";

int loopRunTime =0;
String sql = "";
String[][][] arrayDB;
arrayDB = new String[4][4][2]; // 產生陣列
for(int i=0;i<4;i++){
  for(int j=0;j<4;j++){
    arrayDB[i][j][0]="0";//上月租數量
    arrayDB[i][j][1]="0";//上月補貨間格天數
  }
}

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
      loopRunTime = endDay - beginDay + 1;

      con.createStatement().execute("use transaction");  
      sql = "select `rentQuantity`,`restockDay`,`idProducer`,`idProduct` from `monthparameter` where `idGameLogin` = '"+ srGameId +"'AND `month`="+(monthnum-1) ;
    	tmp =  con.createStatement().executeQuery(sql);
    	while(tmp.next()){		
    		indexProduct = Integer.parseInt(tmp.getString("idProduct"));
        indexProducer = Integer.parseInt(tmp.getString("idProducer"));
        arrayDB[indexProducer][indexProduct][0] = tmp.getString("rentQuantity");
    		arrayDB[indexProducer][indexProduct][1] = tmp.getString("restockDay");
    	}

%>
<body>
  <div class="container-fluid">
  <form action="app/add_month_parameter.jsp">
    <div class="mx-auto pt-3">
      <div class="row">
        <div class="col-md-3 col-12 pt-1">
          <h1 class="text-center">VIM </h1>
          <hr>
          <div class="card mx-auto">
            <div class="card-body">
              <div class="text-left">
                <div class="form-group">
                  <label for="show_stuid">學號</label>
                  <input type="text" class="form-control" disabled id="show_stuid" name="stu_id" placeholder="Stu_ID" value="<%=stu_id%>">
                </div>
                <div class="form-group">
                  <label for="show_name">姓名</label>
                  <input type="text" class="form-control" disabled id="show_name" name="name" placeholder="Name" value="<%=name%>" >
                </div>
              </div>
              <p class="text-left">設定補貨參數</p>
              <div class="text-left">
                <div class="form-group">
                  <label for="input_month">月份</label>
                  <input type="number" max="12" min="1" class="form-control" id="input_month" disable name="month"
                    placeholder="Password" value="<%=monthnum%>">
                </div>
              </div>
              <small id="alert" class="text-left text-danger">所設定之參數將於下次補貨後適用！</small>
              <input type="hidden" name="month" value="<%=month%>">
              <input type="hidden" name="name" value="<%=name%>">
              <input type="hidden" name="stu_id" value="<%=stu_id%>">
              <input type="hidden" name="gameID" value="<%=srGameId%>">
              <button type="submit" class="btn btn-primary btn-block mt-1">設定完成 開始吧!</button>
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
                        <label for="title">承租欄位數量</label>
                        <input type="number" class="form-control" id="set_n_IV_Rent" name="N_IV_Rent" placeholder="數量" value="<%=arrayDB[1][1][0]%>" value="<%=arrayDB[1][1][0]%>">
                      </div>
                      <div class="form-group">
                        <label for="title">幾天補一次貨</label>
                        <input type="number" class="form-control" id="set_n_IV_Give" name="N_IV_Give"
                          placeholder="數量" value="<%=arrayDB[1][1][0]%>" value="<%=arrayDB[1][1][1]%>">
                      </div>
                      <button type="button" class="btn btn-primary" data-toggle="modal"
                        data-target="#Modal_N_IV">檢視上月營運</button>
                    </div>
                  </div>
                </div>
                <div class="col-12 col-md-6 col-lg-4">
                  <div class="card">
                    <div class="card-body">
                      <h5 class="card-title">北蓋VV</h5>
                      <div class="form-group">
                        <label for="title">承租欄位數量</label>
                        <input type="number" class="form-control" id="set_n_VV_Rent" name="N_VV_Rent"
                          placeholder="數量" value="<%=arrayDB[1][1][0]%>" value="<%=arrayDB[1][2][0]%>">
                      </div>
                      <div class="form-group">
                        <label for="title">幾天補一次貨</label>
                        <input type="number" class="form-control" id="set_n_VV_Give" name="N_VV_Give"
                          placeholder="數量" value="<%=arrayDB[1][1][0]%>" value="<%=arrayDB[1][2][1]%>">
                      </div>
                      <button type="button" class="btn btn-primary" data-toggle="modal"
                        data-target="#Modal_N_VV">檢視上月營運</button>
                    </div>
                  </div>
                </div>
                <div class="col-12 col-md-6 col-lg-4">
                  <div class="card">
                    <div class="card-body">
                      <h5 class="card-title">北蓋CVV</h5>
                      <div class="form-group">
                        <label for="title">承租欄位數量</label>
                        <input type="number" class="form-control" id="set_n_CVV_Rent" name="N_CVV_Rent"
                          placeholder="數量" value="<%=arrayDB[1][1][0]%>" value="<%=arrayDB[1][3][0]%>">
                      </div>
                      <div class="form-group">
                        <label for="title">幾天補一次貨</label>
                        <input type="number" class="form-control" id="set_n_CVV_Give" name="N_CVV_Give"
                          placeholder="數量" value="<%=arrayDB[1][1][0]%>" value="<%=arrayDB[1][3][1]%>">
                      </div>
                      <button type="button" class="btn btn-primary" data-toggle="modal"
                        data-target="#Modal_N_CVV">檢視上月營運</button>
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
                        <label for="title">承租欄位數量</label>
                        <input type="number" class="form-control" id="set_M_IV_Rent" name="M_IV_Rent"
                          placeholder="數量" value="<%=arrayDB[2][1][0]%>">
                      </div>
                      <div class="form-group">
                        <label for="title">幾天補一次貨</label>
                        <input type="number" class="form-control" id="set_M_IV_Give" name="M_IV_Give"
                          placeholder="數量" value="<%=arrayDB[2][1][1]%>">
                      </div>
                      <button type="button" class="btn btn-primary" data-toggle="modal"
                        data-target="#Modal_M_IV">檢視上月營運</button>
                    </div>
                  </div>
                </div>
                <div class="col-12 col-md-6 col-lg-4">
                  <div class="card">
                    <div class="card-body">
                      <h5 class="card-title">中通VV</h5>
                      <div class="form-group">
                        <label for="title">承租欄位數量</label>
                        <input type="number" class="form-control" id="set_M_VV_Rent" name="M_VV_Rent"
                          placeholder="數量" value="<%=arrayDB[2][2][0]%>">
                      </div>
                      <div class="form-group">
                        <label for="title">幾天補一次貨</label>
                        <input type="number" class="form-control" id="set_M_VV_Give" name="M_VV_Give"
                          placeholder="數量" value="<%=arrayDB[2][2][1]%>">
                      </div>
                      <button type="button" class="btn btn-primary" data-toggle="modal"
                        data-target="#Modal_M_VV">檢視上月營運</button>
                    </div>
                  </div>
                </div>
                <div class="col-12 col-md-6 col-lg-4">
                  <div class="card">
                    <div class="card-body">
                      <h5 class="card-title">中通CVV</h5>
                      <div class="form-group">
                        <label for="title">承租欄位數量</label>
                        <input type="number" class="form-control" id="set_M_CVV_Rent" name="M_CVV_Rent"
                          placeholder="數量" value="<%=arrayDB[2][3][0]%>">
                      </div>
                      <div class="form-group">
                        <label for="title">幾天補一次貨</label>
                        <input type="number" class="form-control" id="set_M_CVV_Give" name="M_CVV_Give"
                          placeholder="數量" value="<%=arrayDB[2][3][1]%>">
                      </div>
                      <button type="button" class="btn btn-primary" data-toggle="modal"
                        data-target="#Modal_M_CVV">檢視上月營運</button>
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
                        <label for="title">承租欄位數量</label>
                        <input type="number" class="form-control" id="set_S_IV_Rent" name="S_IV_Rent"
                          placeholder="數量" value="<%=arrayDB[3][1][0]%>">
                      </div>
                      <div class="form-group">
                        <label for="title">幾天補一次貨</label>
                        <input type="number" class="form-control" id="set_S_IV_Give" name="S_IV_Give"
                          placeholder="數量" value="<%=arrayDB[3][1][1]%>">
                      </div>
                      <button type="button" class="btn btn-primary" data-toggle="modal"
                        data-target="#Modal_S_IV">檢視上月營運</button>
                    </div>
                  </div>
                </div>
                <div class="col-12 col-md-6 col-lg-4">
                  <div class="card">
                    <div class="card-body">
                      <h5 class="card-title">南生VV</h5>
                      <div class="form-group">
                        <label for="title">承租欄位數量</label>
                        <input type="number" class="form-control" id="set_S_VV_Rent" name="S_VV_Rent"
                          placeholder="數量" value="<%=arrayDB[3][2][0]%>">
                      </div>
                      <div class="form-group">
                        <label for="title">幾天補一次貨</label>
                        <input type="number" class="form-control" id="set_S_VV_Give" name="S_VV_Give"
                          placeholder="數量" value="<%=arrayDB[3][2][1]%>">
                      </div>
                      <button type="button" class="btn btn-primary" data-toggle="modal"
                        data-target="#Modal_S_VV">檢視上月營運</button>
                    </div>
                  </div>
                </div>
                <div class="col-12 col-md-6 col-lg-4">
                  <div class="card">
                    <div class="card-body">
                      <h5 class="card-title">南生CVV</h5>
                      <div class="form-group">
                        <label for="title">承租欄位數量</label>
                        <input type="number" class="form-control" id="set_S_CVV_Rent" name="S_CVV_Rent"
                          placeholder="數量" value="<%=arrayDB[3][3][0]%>">
                      </div>
                      <div class="form-group">
                        <label for="title">幾天補一次貨</label>
                        <input type="number" class="form-control" id="set_S_CVV_Give" name="S_CVV_Give"
                          placeholder="數量" value="<%=arrayDB[3][3][0]%>">
                      </div>
                      <button type="button" class="btn btn-primary" data-toggle="modal"
                        data-target="#Modal_S_CVV">檢視上月營運</button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </form>
  </div>



  <!-- Modal N IV-->
  <div class="modal fade" id="Modal_N_IV" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
    aria-hidden="true">
    <div class="modal-dialog modal-xl" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="exampleModalLabel">北蓋IV</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <div class="row">
            <div class="col-12">
              <table class="table table-hover">
                <thead>
                  <tr>
                    <th scope="col">日期</th>
                    <th scope="col">當日銷售軸數</th>
                    <th scope="col">補貨軸數</th>
                    <th scope="col">緊急供貨軸數</th>
                  </tr>
                </thead>
                <tbody>
                <%
                monthnum--;
                month = monthnum +"";
                indexProducer = 1;
                indexProduct = 1;
                sql = "SELECT `date`, `sellValue`, `restockValue`, `emergencyValue` FROM `dayrunning` WHERE `idGameLogin` = '"+srGameId+"' AND `idProducer` = '"+indexProducer+"' AND `idProduct` = '"+indexProduct+"'" ;
                tmp =  con.createStatement().executeQuery(sql);
	  	          while(tmp.next()){  
                %>
                  <tr>
                    <th scope="row"><%=tmp.getString("date")%></th>
                    <td><%=tmp.getString("sellValue")%></td>
                    <td><%=tmp.getString("restockValue")%></td>
                    <td><%=tmp.getString("emergencyValue")%></td>
                  </tr>
                <%
                }
                %>
                </tbody>
              </table>
            </div>
            <div class="col-12">
              <h3>營收資訊</h3>
            </div>
            <div class="col-12">
              <table class="table table-hover">
                <tbody class="text-right">
                <%
                sql = "SELECT `monthRevenue`, `monthRent`, `monthRestock`, `monthEmergency` FROM `monthresult` WHERE `idGameLogin` = '"+srGameId+"' AND `month` = '"+month+"' AND `idProducer` = '"+indexProducer+"' AND `idProduct` = '"+indexProduct+"'" ;
                tmp =  con.createStatement().executeQuery(sql);
	  	          while(tmp.next()){ 
                    numRamInt1 = tmp.getInt("monthRent");
                    numRamInt2 = tmp.getInt("monthRestock");
                    numRamInt3 = tmp.getInt("monthEmergency");
                    numRamInt4 = numRamInt1 + numRamInt2 + numRamInt3 ;
                %>
                  <tr>
                    <th scope="row">收入</th>
                    <td><%=tmp.getString("monthRevenue")%></td>
                  </tr>
                  <tr>
                    <th scope="row">總支出</th>
                    <td><%=numRamInt4%></td>
                  </tr>
                  <tr>
                    <th scope="row">儲位租金</th>
                    <td><%=numRamInt1%></td>
                  </tr>
                  <tr>
                    <th scope="row">補貨支出</th>
                    <td><%=numRamInt2%></td>
                  </tr>
                  <tr>
                    <th scope="row">緊急運送支出</th>
                    <td><%=numRamInt3%></td>
                  </tr>
                <%
                }
                %>
                </tbody>
              </table>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        </div>
      </div>
    </div>
  </div>

  <!-- Modal N VV-->
  <div class="modal fade" id="Modal_N_VV" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
    aria-hidden="true">
    <div class="modal-dialog modal-xl" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="exampleModalLabel">北蓋VV</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <div class="row">
            <div class="col-12">
              <table class="table table-hover">
                <thead>
                  <tr>
                    <th scope="col">日期</th>
                    <th scope="col">當日銷售軸數</th>
                    <th scope="col">補貨軸數</th>
                    <th scope="col">緊急供貨軸數</th>
                  </tr>
                </thead>
                <tbody>
                  <%
                indexProducer = 1;
                indexProduct = 2;
                sql = "SELECT `date`, `sellValue`, `restockValue`, `emergencyValue` FROM `dayrunning` WHERE `idGameLogin` = '"+srGameId+"' AND `idProducer` = '"+indexProducer+"' AND `idProduct` = '"+indexProduct+"'" ;
                tmp =  con.createStatement().executeQuery(sql);
	  	          while(tmp.next()){  
                %>
                  <tr>
                    <th scope="row"><%=tmp.getString("date")%></th>
                    <td><%=tmp.getString("sellValue")%></td>
                    <td><%=tmp.getString("restockValue")%></td>
                    <td><%=tmp.getString("emergencyValue")%></td>
                  </tr>
                <%
                }
                %>
                </tbody>
              </table>
            </div>
            <div class="col-12">
              <h3>營收資訊</h3>
            </div>
            <div class="col-12">
              <table class="table table-hover">
                <tbody class="text-right">
                  <%
                sql = "SELECT `monthRevenue`, `monthRent`, `monthRestock`, `monthEmergency` FROM `monthresult` WHERE `idGameLogin` = '"+srGameId+"' AND `month` = '"+month+"' AND `idProducer` = '"+indexProducer+"' AND `idProduct` = '"+indexProduct+"'" ;
                tmp =  con.createStatement().executeQuery(sql);
	  	          while(tmp.next()){ 
                    numRamInt1 = tmp.getInt("monthRent");
                    numRamInt2 = tmp.getInt("monthRestock");
                    numRamInt3 = tmp.getInt("monthEmergency");
                    numRamInt4 = numRamInt1 + numRamInt2 + numRamInt3 ;
                %>
                  <tr>
                    <th scope="row">收入</th>
                    <td><%=tmp.getString("monthRevenue")%></td>
                  </tr>
                  <tr>
                    <th scope="row">總支出</th>
                    <td><%=numRamInt4%></td>
                  </tr>
                  <tr>
                    <th scope="row">儲位租金</th>
                    <td><%=numRamInt1%></td>
                  </tr>
                  <tr>
                    <th scope="row">補貨支出</th>
                    <td><%=numRamInt2%></td>
                  </tr>
                  <tr>
                    <th scope="row">緊急運送支出</th>
                    <td><%=numRamInt3%></td>
                  </tr>
                <%
                }
                %>
                </tbody>
              </table>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        </div>
      </div>
    </div>
  </div>

  <!-- Modal N CVV-->
  <div class="modal fade" id="Modal_N_CVV" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
    aria-hidden="true">
    <div class="modal-dialog modal-xl" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="exampleModalLabel">北蓋CVV</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <div class="row">
            <div class="col-12">
              <table class="table table-hover">
                <thead>
                  <tr>
                    <th scope="col">日期</th>
                    <th scope="col">當日銷售軸數</th>
                    <th scope="col">補貨軸數</th>
                    <th scope="col">緊急供貨軸數</th>
                  </tr>
                </thead>
                <tbody>
                  <%
                indexProducer = 1;
                indexProduct = 3;
                sql = "SELECT `date`, `sellValue`, `restockValue`, `emergencyValue` FROM `dayrunning` WHERE `idGameLogin` = '"+srGameId+"' AND `idProducer` = '"+indexProducer+"' AND `idProduct` = '"+indexProduct+"'" ;
                tmp =  con.createStatement().executeQuery(sql);
	  	          while(tmp.next()){  
                %>
                  <tr>
                    <th scope="row"><%=tmp.getString("date")%></th>
                    <td><%=tmp.getString("sellValue")%></td>
                    <td><%=tmp.getString("restockValue")%></td>
                    <td><%=tmp.getString("emergencyValue")%></td>
                  </tr>
                <%
                }
                %>
                </tbody>
              </table>
            </div>
            <div class="col-12">
              <h3>營收資訊</h3>
            </div>
            <div class="col-12">
              <table class="table table-hover">
                <tbody class="text-right">
                  <%
                sql = "SELECT `monthRevenue`, `monthRent`, `monthRestock`, `monthEmergency` FROM `monthresult` WHERE `idGameLogin` = '"+srGameId+"' AND `month` = '"+month+"' AND `idProducer` = '"+indexProducer+"' AND `idProduct` = '"+indexProduct+"'" ;
                tmp =  con.createStatement().executeQuery(sql);
	  	          while(tmp.next()){ 
                    numRamInt1 = tmp.getInt("monthRent");
                    numRamInt2 = tmp.getInt("monthRestock");
                    numRamInt3 = tmp.getInt("monthEmergency");
                    numRamInt4 = numRamInt1 + numRamInt2 + numRamInt3 ;
                %>
                  <tr>
                    <th scope="row">收入</th>
                    <td><%=tmp.getString("monthRevenue")%></td>
                  </tr>
                  <tr>
                    <th scope="row">總支出</th>
                    <td><%=numRamInt4%></td>
                  </tr>
                  <tr>
                    <th scope="row">儲位租金</th>
                    <td><%=numRamInt1%></td>
                  </tr>
                  <tr>
                    <th scope="row">補貨支出</th>
                    <td><%=numRamInt2%></td>
                  </tr>
                  <tr>
                    <th scope="row">緊急運送支出</th>
                    <td><%=numRamInt3%></td>
                  </tr>
                <%
                }
                %>
                </tbody>
              </table>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        </div>
      </div>
    </div>
  </div>


  <!-- Modal M IV-->
  <div class="modal fade" id="Modal_M_IV" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
    aria-hidden="true">
    <div class="modal-dialog modal-xl" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="exampleModalLabel">中通IV</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <div class="row">
            <div class="col-12">
              <table class="table table-hover">
                <thead>
                  <tr>
                    <th scope="col">日期</th>
                    <th scope="col">當日銷售軸數</th>
                    <th scope="col">補貨軸數</th>
                    <th scope="col">緊急供貨軸數</th>
                  </tr>
                </thead>
                <tbody>
                  <%
                indexProducer = 2;
                indexProduct = 1;
                sql = "SELECT `date`, `sellValue`, `restockValue`, `emergencyValue` FROM `dayrunning` WHERE `idGameLogin` = '"+srGameId+"' AND `idProducer` = '"+indexProducer+"' AND `idProduct` = '"+indexProduct+"'" ;
                tmp =  con.createStatement().executeQuery(sql);
	  	          while(tmp.next()){  
                %>
                  <tr>
                    <th scope="row"><%=tmp.getString("date")%></th>
                    <td><%=tmp.getString("sellValue")%></td>
                    <td><%=tmp.getString("restockValue")%></td>
                    <td><%=tmp.getString("emergencyValue")%></td>
                  </tr>
                <%
                }
                %>
                </tbody>
              </table>
            </div>
            <div class="col-12">
              <h3>營收資訊</h3>
            </div>
            <div class="col-12">
              <table class="table table-hover">
                <tbody class="text-right">
                  <%
                sql = "SELECT `monthRevenue`, `monthRent`, `monthRestock`, `monthEmergency` FROM `monthresult` WHERE `idGameLogin` = '"+srGameId+"' AND `month` = '"+month+"' AND `idProducer` = '"+indexProducer+"' AND `idProduct` = '"+indexProduct+"'" ;
                tmp =  con.createStatement().executeQuery(sql);
	  	          while(tmp.next()){ 
                    numRamInt1 = tmp.getInt("monthRent");
                    numRamInt2 = tmp.getInt("monthRestock");
                    numRamInt3 = tmp.getInt("monthEmergency");
                    numRamInt4 = numRamInt1 + numRamInt2 + numRamInt3 ;
                %>
                  <tr>
                    <th scope="row">收入</th>
                    <td><%=tmp.getString("monthRevenue")%></td>
                  </tr>
                  <tr>
                    <th scope="row">總支出</th>
                    <td><%=numRamInt4%></td>
                  </tr>
                  <tr>
                    <th scope="row">儲位租金</th>
                    <td><%=numRamInt1%></td>
                  </tr>
                  <tr>
                    <th scope="row">補貨支出</th>
                    <td><%=numRamInt2%></td>
                  </tr>
                  <tr>
                    <th scope="row">緊急運送支出</th>
                    <td><%=numRamInt3%></td>
                  </tr>
                <%
                }
                %>
                </tbody>
              </table>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        </div>
      </div>
    </div>
  </div>

  <!-- Modal M VV-->
  <div class="modal fade" id="Modal_M_VV" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
    aria-hidden="true">
    <div class="modal-dialog modal-xl" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="exampleModalLabel">中通VV</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <div class="row">
            <div class="col-12">
              <table class="table table-hover">
                <thead>
                  <tr>
                    <th scope="col">日期</th>
                    <th scope="col">當日銷售軸數</th>
                    <th scope="col">補貨軸數</th>
                    <th scope="col">緊急供貨軸數</th>
                  </tr>
                </thead>
                <tbody>
                <%indexProducer = 2;
                indexProduct = 2;
                sql = "SELECT `date`, `sellValue`, `restockValue`, `emergencyValue` FROM `dayrunning` WHERE `idGameLogin` = '"+srGameId+"' AND `idProducer` = '"+indexProducer+"' AND `idProduct` = '"+indexProduct+"'" ;
                tmp =  con.createStatement().executeQuery(sql);
	  	          while(tmp.next()){  
                %>
                  <tr>
                    <th scope="row"><%=tmp.getString("date")%></th>
                    <td><%=tmp.getString("sellValue")%></td>
                    <td><%=tmp.getString("restockValue")%></td>
                    <td><%=tmp.getString("emergencyValue")%></td>
                  </tr>
                <%
                }
                %>
                </tbody>
              </table>
            </div>
            <div class="col-12">
              <h3>營收資訊</h3>
            </div>
            <div class="col-12">
              <table class="table table-hover">
                <tbody class="text-right">
                  <%
                sql = "SELECT `monthRevenue`, `monthRent`, `monthRestock`, `monthEmergency` FROM `monthresult` WHERE `idGameLogin` = '"+srGameId+"' AND `month` = '"+month+"' AND `idProducer` = '"+indexProducer+"' AND `idProduct` = '"+indexProduct+"'" ;
                tmp =  con.createStatement().executeQuery(sql);
	  	          while(tmp.next()){ 
                    numRamInt1 = tmp.getInt("monthRent");
                    numRamInt2 = tmp.getInt("monthRestock");
                    numRamInt3 = tmp.getInt("monthEmergency");
                    numRamInt4 = numRamInt1 + numRamInt2 + numRamInt3 ;
                %>
                  <tr>
                    <th scope="row">收入</th>
                    <td><%=tmp.getString("monthRevenue")%></td>
                  </tr>
                  <tr>
                    <th scope="row">總支出</th>
                    <td><%=numRamInt4%></td>
                  </tr>
                  <tr>
                    <th scope="row">儲位租金</th>
                    <td><%=numRamInt1%></td>
                  </tr>
                  <tr>
                    <th scope="row">補貨支出</th>
                    <td><%=numRamInt2%></td>
                  </tr>
                  <tr>
                    <th scope="row">緊急運送支出</th>
                    <td><%=numRamInt3%></td>
                  </tr>
                <%
                }
                %>
                </tbody>
              </table>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        </div>
      </div>
    </div>
  </div>

  <!-- Modal M CVV-->
  <div class="modal fade" id="Modal_M_CVV" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
    aria-hidden="true">
    <div class="modal-dialog modal-xl" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="exampleModalLabel">中通CVV</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <div class="row">
            <div class="col-12">
              <table class="table table-hover">
                <thead>
                  <tr>
                    <th scope="col">日期</th>
                    <th scope="col">當日銷售軸數</th>
                    <th scope="col">補貨軸數</th>
                    <th scope="col">緊急供貨軸數</th>
                  </tr>
                </thead>
                <tbody>
                  <%
                indexProducer = 2;
                indexProduct = 3;
                sql = "SELECT `date`, `sellValue`, `restockValue`, `emergencyValue` FROM `dayrunning` WHERE `idGameLogin` = '"+srGameId+"' AND `idProducer` = '"+indexProducer+"' AND `idProduct` = '"+indexProduct+"'" ;
                tmp =  con.createStatement().executeQuery(sql);
	  	          while(tmp.next()){  
                %>
                  <tr>
                    <th scope="row"><%=tmp.getString("date")%></th>
                    <td><%=tmp.getString("sellValue")%></td>
                    <td><%=tmp.getString("restockValue")%></td>
                    <td><%=tmp.getString("emergencyValue")%></td>
                  </tr>
                <%
                }
                %>
                </tbody>
              </table>
            </div>
            <div class="col-12">
              <h3>營收資訊</h3>
            </div>
            <div class="col-12">
              <table class="table table-hover">
                <tbody class="text-right">
                  <%
                sql = "SELECT `monthRevenue`, `monthRent`, `monthRestock`, `monthEmergency` FROM `monthresult` WHERE `idGameLogin` = '"+srGameId+"' AND `month` = '"+month+"' AND `idProducer` = '"+indexProducer+"' AND `idProduct` = '"+indexProduct+"'" ;
                tmp =  con.createStatement().executeQuery(sql);
	  	          while(tmp.next()){ 
                    numRamInt1 = tmp.getInt("monthRent");
                    numRamInt2 = tmp.getInt("monthRestock");
                    numRamInt3 = tmp.getInt("monthEmergency");
                    numRamInt4 = numRamInt1 + numRamInt2 + numRamInt3 ;
                %>
                  <tr>
                    <th scope="row">收入</th>
                    <td><%=tmp.getString("monthRevenue")%></td>
                  </tr>
                  <tr>
                    <th scope="row">總支出</th>
                    <td><%=numRamInt4%></td>
                  </tr>
                  <tr>
                    <th scope="row">儲位租金</th>
                    <td><%=numRamInt1%></td>
                  </tr>
                  <tr>
                    <th scope="row">補貨支出</th>
                    <td><%=numRamInt2%></td>
                  </tr>
                  <tr>
                    <th scope="row">緊急運送支出</th>
                    <td><%=numRamInt3%></td>
                  </tr>
                <%
                }
                %>
                </tbody>
              </table>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        </div>
      </div>
    </div>
  </div>

  
  <!-- Modal S IV-->
  <div class="modal fade" id="Modal_S_IV" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
    aria-hidden="true">
    <div class="modal-dialog modal-xl" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="exampleModalLabel">南生IV</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <div class="row">
            <div class="col-12">
              <table class="table table-hover">
                <thead>
                  <tr>
                    <th scope="col">日期</th>
                    <th scope="col">當日銷售軸數</th>
                    <th scope="col">補貨軸數</th>
                    <th scope="col">緊急供貨軸數</th>
                  </tr>
                </thead>
                <tbody>
                indexProducer = 3;
                indexProduct = 1;
                sql = "SELECT `date`, `sellValue`, `restockValue`, `emergencyValue` FROM `dayrunning` WHERE `idGameLogin` = '"+srGameId+"' AND `idProducer` = '"+indexProducer+"' AND `idProduct` = '"+indexProduct+"'" ;
                </tbody>
              </table>
            </div>
            <div class="col-12">
              <h3>營收資訊</h3>
            </div>
            <div class="col-12">
              <table class="table table-hover">
                <tbody class="text-right">
                  <%
                sql = "SELECT `monthRevenue`, `monthRent`, `monthRestock`, `monthEmergency` FROM `monthresult` WHERE `idGameLogin` = '"+srGameId+"' AND `month` = '"+month+"' AND `idProducer` = '"+indexProducer+"' AND `idProduct` = '"+indexProduct+"'" ;
                tmp =  con.createStatement().executeQuery(sql);
	  	          while(tmp.next()){ 
                    numRamInt1 = tmp.getInt("monthRent");
                    numRamInt2 = tmp.getInt("monthRestock");
                    numRamInt3 = tmp.getInt("monthEmergency");
                    numRamInt4 = numRamInt1 + numRamInt2 + numRamInt3 ;
                %>
                  <tr>
                    <th scope="row">收入</th>
                    <td><%=tmp.getString("monthRevenue")%></td>
                  </tr>
                  <tr>
                    <th scope="row">總支出</th>
                    <td><%=numRamInt4%></td>
                  </tr>
                  <tr>
                    <th scope="row">儲位租金</th>
                    <td><%=numRamInt1%></td>
                  </tr>
                  <tr>
                    <th scope="row">補貨支出</th>
                    <td><%=numRamInt2%></td>
                  </tr>
                  <tr>
                    <th scope="row">緊急運送支出</th>
                    <td><%=numRamInt3%></td>
                  </tr>
                <%
                }
                %>
                </tbody>
              </table>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        </div>
      </div>
    </div>
  </div>

  <!-- Modal S VV-->
  <div class="modal fade" id="Modal_S_VV" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
    aria-hidden="true">
    <div class="modal-dialog modal-xl" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="exampleModalLabel">南生VV</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <div class="row">
            <div class="col-12">
              <table class="table table-hover">
                <thead>
                  <tr>
                    <th scope="col">日期</th>
                    <th scope="col">當日銷售軸數</th>
                    <th scope="col">補貨軸數</th>
                    <th scope="col">緊急供貨軸數</th>
                  </tr>
                </thead>
                <tbody>
                indexProducer = 3;
                indexProduct = 2;
                sql = "SELECT `date`, `sellValue`, `restockValue`, `emergencyValue` FROM `dayrunning` WHERE `idGameLogin` = '"+srGameId+"' AND `idProducer` = '"+indexProducer+"' AND `idProduct` = '"+indexProduct+"'" ;
                </tbody>
              </table>
            </div>
            <div class="col-12">
              <h3>營收資訊</h3>
            </div>
            <div class="col-12">
              <table class="table table-hover">
                <tbody class="text-right">
                  <%
                sql = "SELECT `monthRevenue`, `monthRent`, `monthRestock`, `monthEmergency` FROM `monthresult` WHERE `idGameLogin` = '"+srGameId+"' AND `month` = '"+month+"' AND `idProducer` = '"+indexProducer+"' AND `idProduct` = '"+indexProduct+"'" ;
                tmp =  con.createStatement().executeQuery(sql);
	  	          while(tmp.next()){ 
                    numRamInt1 = tmp.getInt("monthRent");
                    numRamInt2 = tmp.getInt("monthRestock");
                    numRamInt3 = tmp.getInt("monthEmergency");
                    numRamInt4 = numRamInt1 + numRamInt2 + numRamInt3 ;
                %>
                  <tr>
                    <th scope="row">收入</th>
                    <td><%=tmp.getString("monthRevenue")%></td>
                  </tr>
                  <tr>
                    <th scope="row">總支出</th>
                    <td><%=numRamInt4%></td>
                  </tr>
                  <tr>
                    <th scope="row">儲位租金</th>
                    <td><%=numRamInt1%></td>
                  </tr>
                  <tr>
                    <th scope="row">補貨支出</th>
                    <td><%=numRamInt2%></td>
                  </tr>
                  <tr>
                    <th scope="row">緊急運送支出</th>
                    <td><%=numRamInt3%></td>
                  </tr>
                <%
                }
                %>
                </tbody>
              </table>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        </div>
      </div>
    </div>
  </div>

  <!-- Modal S CVV-->
  <div class="modal fade" id="Modal_S_CVV" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
    aria-hidden="true">
    <div class="modal-dialog modal-xl" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="exampleModalLabel">南生CVV</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <div class="row">
            <div class="col-12">
              <table class="table table-hover">
                <thead>
                  <tr>
                    <th scope="col">日期</th>
                    <th scope="col">當日銷售軸數</th>
                    <th scope="col">補貨軸數</th>
                    <th scope="col">緊急供貨軸數</th>
                  </tr>
                </thead>
                <tbody>
                indexProducer = 3;
                indexProduct = 3;
                sql = "SELECT `date`, `sellValue`, `restockValue`, `emergencyValue` FROM `dayrunning` WHERE `idGameLogin` = '"+srGameId+"' AND `idProducer` = '"+indexProducer+"' AND `idProduct` = '"+indexProduct+"'" ;
                </tbody>
              </table>
            </div>
            <div class="col-12">
              <h3>營收資訊</h3>
            </div>
            <div class="col-12">
              <table class="table table-hover">
                <tbody class="text-right">
                  <%
                sql = "SELECT `monthRevenue`, `monthRent`, `monthRestock`, `monthEmergency` FROM `monthresult` WHERE `idGameLogin` = '"+srGameId+"' AND `month` = '"+month+"' AND `idProducer` = '"+indexProducer+"' AND `idProduct` = '"+indexProduct+"'" ;
                tmp =  con.createStatement().executeQuery(sql);
	  	          while(tmp.next()){ 
                    numRamInt1 = tmp.getInt("monthRent");
                    numRamInt2 = tmp.getInt("monthRestock");
                    numRamInt3 = tmp.getInt("monthEmergency");
                    numRamInt4 = numRamInt1 + numRamInt2 + numRamInt3 ;
                %>
                  <tr>
                    <th scope="row">收入</th>
                    <td><%=tmp.getString("monthRevenue")%></td>
                  </tr>
                  <tr>
                    <th scope="row">總支出</th>
                    <td><%=numRamInt4%></td>
                  </tr>
                  <tr>
                    <th scope="row">儲位租金</th>
                    <td><%=numRamInt1%></td>
                  </tr>
                  <tr>
                    <th scope="row">補貨支出</th>
                    <td><%=numRamInt2%></td>
                  </tr>
                  <tr>
                    <th scope="row">緊急運送支出</th>
                    <td><%=numRamInt3%></td>
                  </tr>
                <%
                }
                monthnum++;
                month = monthnum + "";
                %>
                </tbody>
              </table>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        </div>
      </div>
    </div>
  </div>

<%
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

 
  <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
    integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous">
  </script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.6/umd/popper.min.js"
    integrity="sha384-wHAiFfRlMFy6i5SRaxvfOCifBUQy1xHdJ/yoi7FRNXMRBu5WHdZYu1hA6ZOblgut" crossorigin="anonymous">
  </script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.2.1/js/bootstrap.min.js"
    integrity="sha384-B0UglyR+jN6CkvvICOB2joaf5I4l3gm9GU6Hc1og6Ls7i6U/mkkaduKaBhlAXv9k" crossorigin="anonymous">
  </script>

</html>