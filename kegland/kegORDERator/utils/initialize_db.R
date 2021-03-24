library(RMySQL)
source("utils/parameters.R")
source("utils/data_handler.R")



options(mysql = db_cred)

db <- db_connect()

#drop tables
drop_users <- "DROP TABLE users"
drop_orders <- "DROP TABLE orders"

#create users tbl
create_users <- "CREATE TABLE users
(
  id INT AUTO_INCREMENT PRIMARY KEY,
  ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  uname varchar(90) NOT NULL,
  paynow INT NOT NULL
)
"

#create orders tbl
create_orders <- "CREATE TABLE orders
(
  id INT AUTO_INCREMENT PRIMARY KEY,
  ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  name varchar(90) NOT NULL,
  klid varchar(10) NOT NULL,
  q INT NOT NULL
)
"

dbGetQuery(db, drop_users)
dbGetQuery(db, drop_orders)

dbGetQuery(db, create_users)
dbGetQuery(db, create_orders)

dbDisconnect(db)
