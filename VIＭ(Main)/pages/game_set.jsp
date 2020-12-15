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
  //Get Value
  String stu_id = new String(request.getParameter("stu_id").getBytes("ISO-8859-1"));
  String name = new String(request.getParameter("name").getBytes("ISO-8859-1"));
  String month = new String(request.getParameter("month"));
  int monthnum = Integer.parseInt(month);
  String srGameId = new String(request.getParameter("gameID"));
  String[][][] arrayDB;
  arrayDB = new String[4][4][2]; // 產生陣列
  for(int i=0;i<4;i++){
    for(int j=0;j<4;j++){
      arrayDB[i][j][0]="";
      arrayDB[i][j][1]="";
    }
  }
  if(monthnum==1){
    
  }
  else{
    //set value from DB    
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
    			String sql = "";
          String srProducer = "";
          int indexProducer = 0;
          String srProduct = "";
          int indexProduct = 0;

          sql = "select `rentQuantity`,`restockDay`,`idProducer`,`idProduct` from `monthparameter` where `idGameLogin` = '"+ srGameId +"'AND `month`="+(monthnum-1) ;
    			ResultSet tmp =  con.createStatement().executeQuery(sql);
    			while(tmp.next()){		
    				indexProduct = Integer.parseInt(tmp.getString("idProduct"));
            indexProducer = Integer.parseInt(tmp.getString("idProducer"));
            arrayDB[indexProducer][indexProduct][0] = tmp.getString("rentQuantity");
    				arrayDB[indexProducer][indexProduct][1] = tmp.getString("restockDay");
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
%>
<body>
  <div class="container-fluid">
    <div class="mx-auto pt-3">
      <form class="" action="app/add_month_parameter.jsp">
        <input type="hidden" name="month" value="<%=month%>">
        <input type="hidden" name="name" value="<%=name%>">
        <input type="hidden" name="stu_id" value="<%=stu_id%>">
        <input type="hidden" name="gameID" value="<%=srGameId%>">
        
        <div class="row">
          <div class="col-md-3 col-12 pt-1">
            <h1 class="text-center">VIM </h1>
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
                <p class="text-left">設定補貨參數</p>
                <div class="text-left">
                  <div class="form-group">
                    <label for="input_month">月份</label>
                    <input required type="number" max="12" min="1" class="form-control" id="input_month" disabled
                      name="month" placeholder="Month" value="<%=monthnum%>" >
                  </div>
                </div>
                <small id="alert" class="text-left text-danger">所設定之參數將於下次補貨後適用！</small>
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
                          <input required type="number" class="form-control" id="set_N_IV_Rent" name="N_IV_Rent"
                            placeholder="數量" value="<%=arrayDB[1][1][0]%>" >

                        </div>
                        <div class="form-group">
                          <label for="title">幾天補一次貨</label>
                          <input required type="number" class="form-control" id="set_N_IV_Give" name="N_IV_Give"
                            placeholder="數量" value="<%=arrayDB[1][1][1]%>">
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="col-12 col-md-6 col-lg-4">
                    <div class="card">
                      <div class="card-body">
                        <h5 class="card-title">北蓋VV</h5>
                        <div class="form-group">
                          <label for="title">承租欄位數量</label>
                          <input required type="number" class="form-control" id="set_N_VV_Rent" name="N_VV_Rent"
                            placeholder="數量" value="<%=arrayDB[1][2][0]%>">

                        </div>
                        <div class="form-group">
                          <label for="title">幾天補一次貨</label>
                          <input required type="number" class="form-control" id="set_N_VV_Give" name="N_VV_Give"
                            placeholder="數量" value="<%=arrayDB[1][2][1]%>">

                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="col-12 col-md-6 col-lg-4">
                    <div class="card">
                      <div class="card-body">
                        <h5 class="card-title">北蓋CVV</h5>
                        <div class="form-group">
                          <label for="title">承租欄位數量</label>
                          <input required type="number" class="form-control" id="set_N_CVV_Rent" name="N_CVV_Rent"
                            placeholder="數量" value="<%=arrayDB[1][3][0]%>">

                        </div>
                        <div class="form-group">
                          <label for="title">幾天補一次貨</label>
                          <input required type="number" class="form-control" id="set_N_CVV_Give" name="N_CVV_Give"
                            placeholder="數量" value="<%=arrayDB[1][3][1]%>">

                        </div>
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
                          <input required type="number" class="form-control" id="set_m_IV_Rent" name="M_IV_Rent"
                            placeholder="數量" value="<%=arrayDB[2][1][0]%>">

                        </div>
                        <div class="form-group">
                          <label for="title">幾天補一次貨</label>
                          <input required type="number" class="form-control" id="set_m_IV_Give" name="M_IV_Give"
                            placeholder="數量" value="<%=arrayDB[2][1][1]%>">

                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="col-12 col-md-6 col-lg-4">
                    <div class="card">
                      <div class="card-body">
                        <h5 class="card-title">中通VV</h5>
                        <div class="form-group">
                          <label for="title">承租欄位數量</label>
                          <input required type="number" class="form-control" id="set_m_VV_Rent" name="M_VV_Rent"
                            placeholder="數量" value="<%=arrayDB[2][2][0]%>">

                        </div>
                        <div class="form-group">
                          <label for="title">幾天補一次貨</label>
                          <input required type="number" class="form-control" id="set_m_VV_Give" name="M_VV_Give"
                            placeholder="數量" value="<%=arrayDB[2][2][1]%>">

                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="col-12 col-md-6 col-lg-4">
                    <div class="card">
                      <div class="card-body">
                        <h5 class="card-title">中通CVV</h5>
                        <div class="form-group">
                          <label for="title">承租欄位數量</label>
                          <input required type="number" class="form-control" id="set_m_CVV_Rent" name="M_CVV_Rent"
                            placeholder="數量" value="<%=arrayDB[2][3][0]%>">

                        </div>
                        <div class="form-group">
                          <label for="title">幾天補一次貨</label>
                          <input required type="number" class="form-control" id="set_m_CVV_Give" name="M_CVV_Give"
                            placeholder="數量" value="<%=arrayDB[2][3][1]%>">

                        </div>
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
                          <input required type="number" class="form-control" id="set_s_IV_Rent" name="S_IV_Rent"
                            placeholder="數量" value="<%=arrayDB[3][1][0]%>">

                        </div>
                        <div class="form-group">
                          <label for="title">幾天補一次貨</label>
                          <input required type="number" class="form-control" id="set_s_IV_Give" name="S_IV_Give"
                            placeholder="數量" value="<%=arrayDB[3][1][1]%>">

                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="col-12 col-md-6 col-lg-4">
                    <div class="card">
                      <div class="card-body">
                        <h5 class="card-title">南生VV</h5>
                        <div class="form-group">
                          <label for="title">承租欄位數量</label>
                          <input required type="number" class="form-control" id="set_s_VV_Rent" name="S_VV_Rent"
                            placeholder="數量" value="<%=arrayDB[3][2][0]%>">

                        </div>
                        <div class="form-group">
                          <label for="title">幾天補一次貨</label>
                          <input required type="number" class="form-control" id="set_s_VV_Give" name="S_VV_Give"
                            placeholder="數量" value="<%=arrayDB[3][2][1]%>">

                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="col-12 col-md-6 col-lg-4">
                    <div class="card">
                      <div class="card-body">
                        <h5 class="card-title">南生CVV</h5>
                        <div class="form-group">
                          <label for="title">承租欄位數量</label>
                          <input required type="number" class="form-control" id="set_s_CVV_Rent" name="S_CVV_Rent"
                            placeholder="數量" value="<%=arrayDB[3][3][0]%>">

                        </div>
                        <div class="form-group">
                          <label for="title">幾天補一次貨</label>
                          <input required type="number" class="form-control" id="set_s_CVV_Give" name="S_CVV_Give"
                            placeholder="數量" value="<%=arrayDB[3][3][1]%>">
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

</html>
