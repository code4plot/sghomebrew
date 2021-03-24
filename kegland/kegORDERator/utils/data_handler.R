library(RMySQL)
source("utils/parameters.R")


options(mysql = db_cred)

db_connect <- function(){
  db <- dbConnect(MySQL(), 
                  dbname = databaseName, 
                  host = options()$mysql$host,
                  port = options()$mysql$port,
                  user = options()$mysql$user,
                  password = options()$mysql$password
  )
  return(db)
}

saveData <- function(data, tbl){
  db <- db_connect()
  query <- sprintf(
    "INSERT INTO %s (%s) VALUES ('%s')",
    tbl,
    paste(names(data), collapse = ", "),
    paste(data, collapse = "', '")
  )
  dbGetQuery(db, query)
  dbDisconnect(db)
}

loadUsers <- function(tbl = table_users){
  db <- db_connect()
  query <- sprintf("SELECT uname FROM %s",
                   tbl)
  data <- dbGetQuery(db, query)
  dbDisconnect(db)
  return(data)
}

loadOrders <- function(tbl = table_orders, name){
  db <- db_connect()
  query <- sprintf("SELECT b.name, b.klid, b.q FROM
                  (SELECT name, klid, SUM(q) as q FROM %s
                   WHERE name = '%s'
                   GROUP BY klid) as b
                   WHERE b.q > 0
                   ", tbl, name)
  data <- dbGetQuery(db, query)
  dbDisconnect(db)
  return(data)
}

loadAllOrders <- function(tbl = table_orders){
  db <- db_connect()
  query <- sprintf("SELECT b.klid, SUM(b.q) as q FROM 
                  (SELECT a.name, a.klid, SUM(a.q) as q FROM %s AS a
                   GROUP BY a.name, a.klid) AS b
                   WHERE b.q > 0
                   GROUP BY b.klid", tbl)
  data <- dbGetQuery(db, query)
  dbDisconnect(db)
  return(data)
}