<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Game Over</title>
  <link rel="stylesheet" href="../stylesheets/all.css">
  <link rel="stylesheet" href="../stylesheets/mula.css">
</head>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import = "java.sql.*"%>

<%
//Call Value
int beginDay = 0;
int endDay = 0;
String srGameId = "1";
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
String srDate = "";
String sql = "";
int totalRevenue=0;
int totalRentCost=0;
int totalRestockCost =0;
int totalEmergencyCost =0;
int show_DividendBonus =0;
int show_totalCost =0;
int show_yearGet =0;
int IntegerRam =0;
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
      

			con.createStatement().execute("use consult");  
      //	服務數值設定
      float serviceIncomePerOne=0;
      sql = "SELECT `value` FROM `parameter` WHERE `parameter` = 'serviceIncome'";
      ResultSet  tmp =  con.createStatement().executeQuery(sql);
      while(tmp.next()){		
		    srRam = tmp.getString("value");
        serviceIncomePerOne = Float.parseFloat(srRam);
		  }
      // RENT Cost PerOne
      float rentPricePerOne=0;
      sql = "SELECT `value` FROM `parameter` WHERE `parameter` = 'rentPrice'";
      tmp =  con.createStatement().executeQuery(sql);
      while(tmp.next()){		
		    srRam = tmp.getString("value");
        rentPricePerOne = Float.parseFloat(srRam);
		  }
      // Restock Price PerOne
      float restockPricePerOne=0;
      sql = "SELECT `value` FROM `parameter` WHERE `parameter` = 'restockPrice'";
      tmp =  con.createStatement().executeQuery(sql);
      while(tmp.next()){		
		    srRam = tmp.getString("value");
        restockPricePerOne = Float.parseFloat(srRam);
		  }
      // Emergency Cost PERONE
      float emergencyPricePerOne=0;
      sql = "SELECT `value` FROM `parameter` WHERE `parameter` = 'emergencyPrice'";
      tmp =  con.createStatement().executeQuery(sql);
      while(tmp.next()){		
		    srRam = tmp.getString("value");
        emergencyPricePerOne = Float.parseFloat(srRam);
		  }
      // 分紅SHARE PERCENT
      float sharePercent=0;
      sql = "SELECT `value` FROM `parameter` WHERE `parameter` = 'dividendPercent'";
      tmp =  con.createStatement().executeQuery(sql);
      while(tmp.next()){		
		    srRam = tmp.getString("value");
        sharePercent = Float.parseFloat(srRam);
		  } 
      
      //選擇資料庫
			con.createStatement().execute("use transaction");  
      //GET SELLVALUE 
      int sellValue =0;
      sql = "SELECT COALESCE(SUM(`sellValue`),0) AS `RS`  FROM `dayrunning` WHERE `idGameLogin` = '"+srGameId+"' AND `sellValue` IS NOT NULL Group by `idGameLogin` = '"+srGameId+"'" ;
      tmp =  con.createStatement().executeQuery(sql);
      while(tmp.next()){	
	      sellValue = tmp.getInt("RS");
		  } 
      totalRevenue = sellValue * Math.round(serviceIncomePerOne);
      
      // GET RENTED VALUE
      int rentQuantity=0;
      sql = "SELECT COALESCE(SUM(`rentQuantity`)) AS `RS`  FROM `monthparameter` WHERE `idGameLogin` = '"+srGameId+"' AND `rentQuantity` IS NOT NULL Group by `idGameLogin` = '"+srGameId+"'" ;
      tmp =  con.createStatement().executeQuery(sql);
      while(tmp.next()){	
	      srRam = tmp.getString("RS");
        rentQuantity = Integer.parseInt(srRam);
		  }
          
      IntegerRam = Math.round(rentPricePerOne);
      totalRentCost = rentQuantity * IntegerRam;

      //GET RESTOCK TIMES
      int restockTimes =0;
      sql = "SELECT COUNT(`restockValue`) AS `DELIVER_TIMES` FROM `dayrunning` WHERE `restockValue` > 0 AND `idGameLogin` = '"+srGameId+"'";
      tmp =  con.createStatement().executeQuery(sql);
      while(tmp.next()){		
		    restockTimes = tmp.getInt("DELIVER_TIMES");
			}
      totalRestockCost = Math.round(restockPricePerOne) * restockTimes;

      //GET Emergency Cost
      int emergencyValue =0;
			sql = "SELECT COALESCE(SUM(`emergencyValue`)) AS `RS` FROM `dayrunning` WHERE `idGameLogin` = '"+srGameId+"' AND `emergencyValue` IS NOT NULL Group by `idGameLogin` = '"+srGameId+"'" ;
      tmp =  con.createStatement().executeQuery(sql);
      while(tmp.next()){		
		    emergencyValue = tmp.getInt("RS");
			}
      totalEmergencyCost = Math.round(emergencyPricePerOne) * emergencyValue;

      // UPDATE DATA TO DB
      sql="UPDATE `gamelogin` SET `totalRevenue` = '"+totalRevenue+"', `totalRent`='"+totalRentCost+"', `totalRestock`='"+totalRestockCost+"',`totalEmergency`='"+totalEmergencyCost+"' WHERE `idGameLogin` = '"+srGameId+"'";
      boolean no= con.createStatement().execute(sql); //執行成功傳回false
      show_totalCost = totalRentCost + totalRestockCost + totalEmergencyCost;
      show_yearGet = totalRevenue - show_totalCost;
      show_DividendBonus = Math.round(show_yearGet * sharePercent);

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




<body>
  <div class="container-fluid">
    <div class="mx-auto pt-3">
      <form class="">
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
                      placeholder="Stu_ID" value="00000">
                  </div>
                  <div class="form-group">
                    <label for="show_name">姓名</label>
                    <input required type="text" class="form-control" disabled id="show_name" name="name"
                      placeholder="Name" value="0000">
                  </div>
                </div>
                <h1 class="text-center">恭喜完成挑戰</h1>
                <a href="../index.jsp" class="btn btn-info btn-block">結束遊戲</a>
              </div>
            </div>
          </div>
          <div class="col-md-9 col-12 pt-1">
            <div class="row">
              <div class="col-12">
                <h1 class="text-center">2021年營運成果報表</h1>
                <hr>
              </div>
              <div class="col-12 col-md-4 col-lg-3 text-right">
                <table class="table table-hover border border-light">
                  <tbody>
                    <tr>
                      <th scope="row">總收入</th>
                      <td><%=totalRevenue%></td>
                    </tr>
                    <tr>
                      <th scope="row">總支出</th>
                      <td><%=show_totalCost%></td>
                    </tr>
                    <tr>
                      <th scope="row">儲位租金</th>
                      <td><%=totalRentCost%></td>
                    </tr>
                    <tr>
                      <th scope="row">補貨支出</th>
                      <td><%=totalRestockCost%></td>
                    </tr>
                    <tr>
                      <th scope="row">緊急運送支出</th>
                      <td><%=totalEmergencyCost%></td>
                    </tr>
                    <tr>
                      <th scope="row">全年收益</th>
                      <td><%=show_yearGet%></td>
                    </tr>
                    <tr>
                      <th scope="row">全年分紅獎金</th>
                      <td><%=show_DividendBonus%></td>
                    </tr>
                  </tbody>
                </table>
              </div>
              <div class="col-12 col-md-8 col-lg-9">
                <img src="../src/end_pic.jpg" class="img-fluid" alt="Responsive image">
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