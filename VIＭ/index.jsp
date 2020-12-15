<!DOCTYPE html>
<html>

<head>
  <meta charset="UTF-8">
  <%@page contentType="text/html" pageEncoding="UTF-8"%>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>VIM Game</title>
  <link rel="stylesheet" href="stylesheets/all.css">
  <link rel="stylesheet" href="stylesheets/mula.css">
</head>

<body>
  <div class="container-fluid">
    <div class="mx-auto pt-3">
      <div class="row  justify-content-center">
        <div class="col-12 col-md-9 col-lg-8">
          <div class="row">
            <div class="col-md-4 col-12 pt-1">
              <h3 class="text-center">VIM </h3>
              <hr>
              <div class="card text-center mx-auto">
                <div class="card-body">
                  <h5 class="card-text">華新VMI戰隊</h5>
                  <h5 class="card-text">歡迎您的加入</h5>
                  <form class="text-left" action="pages/app/add_player.jsp">
                    <div class="form-group">
                      <label for="exampleInputPassword1">請輸入學號</label>
                      <input type="text" class="form-control" id="input_stuid" name="stu_id" placeholder="Your ID">
                    </div>
                    <div class="form-group">
                      <label for="exampleInputPassword1">請輸入姓名</label>
                      <input type="text" class="form-control" id="input_name" name="name" placeholder="name">
                    </div>
                    <button type="submit" class="btn btn-primary btn-block">Start</button>
                  </form>
                </div>
              </div>
            </div>
            <div class="col-md-8 col-12 pt-1">
              <div class="card">
                <div class="card-header">
                  說明
                </div>
                <div class="card-body">
                  <ul>
                    <li>華新麗華公司投入智慧製造多年，一直想要在新莊新設一個全自動電線生產線，該廠可以用最低的成本，大量供應最高品質的標準電線給國內市場</li>
                    <li>但是，有個問題，它需要很大的規模經濟。必須要有大規模標準產品的訂單才能回本…。國內市場怕不夠大</li>
                    <li>華新麗華公司籌畫多年之後，決定先針對三家國內主要經銷商(北蓋、中通、南生)，針對三款最常用的建築用電線，實施供應商庫存管理VMI(Supplier inventory
                      management)模式
                    </li>
                    <li>各位經焦董事長親自挑選，成為專案小組的成員</li>
                    <li>各位要負責營運這個創新模式，幫公司綁死這三家總交易量占了全國建築用電線電纜70%以上市場，極其重要的經銷商們</li>
                    <li>有了這70%的市占率當基底，公司在新莊新設的全自動電線生產線，就可以有那個量，可以大規模的生產最高品質的標準電線喽…</li>
                  </ul>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

</html>