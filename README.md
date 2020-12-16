# 2020SA_DB
## VMI(Front)
>This Package Only Include HTML Front End 

- index.html  **Home Page ID:S1**
- stylesheets/  **Floder of CSS of PAGE (From BootStrap 4.3)**
- src/  **Floder of Image or Other Items**
- pages
  -  game_ends.html **S5**
  -  game_result.html **S3**
  -  game_running.html **S4**
  -  game_set.html **S2**
  
- packagelock.json  **nodejs Setup**
- mode_modules/
  - bootstrap  **Front Package**

## VMI(Main)
>This Package Include the Function of Game

- index.jsp  **Home Page ID:S1**
- stylesheets/  **Floder of CSS of PAGE (From BootStrap 4.3)**
- src/  **Floder of Image or Other Items**
- pages
  - game_ends.jsp **S5**
  - game_result.jsp **S3**
  - game_running.jsp **S4**
  - game_set.jsp **S2**
  - app/
    - add_month_parameter.jsp **Connect From S4**
    - add_player.jsp  **Connect From S1 Send to game_set**
    - count_month_result.jsp  **Connect From S4 Sent to S3**
  
- packagelock.json  **nodejs Setup**
- mode_modules/
  - bootstrap  **Front Package**
  
## VIM DB
>The Database of this app. Use SQL File

>We Have TWO Database.

>The following is the the DB and the table name that in the DB

EN
| consult      | transcation   |
|:------------:|:-------------:|
| comparedate  | dayrunning    |
| parameter    | gamelogin     |
| producer     | monthparameter|
| product      | monthresult   |
| sellrecord   |               |

ZH
| 參考檔案      | 交易檔案      |
|:------------:|:-------------:|
| 第幾天對照    | 每日營運      |
| 參數         | 遊戲燈入檔     |
| 廠商         | 每月參數       |
| 產品         | 每月營運       |
| 銷售紀錄     |               |
