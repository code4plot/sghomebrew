source("utils/parameters.R")

#function to compile multiple .csv files from dirName.
#returns a tibble of compiled table. All col_types default to character
get_csvs <- function(dirName){
  csvList <- list.files(dirName, "*.csv", full.names = T)
  csvs <- csvList %>% map_df(~read_csv(.x, col_types = cols(.default = "c")))
  print(csvs)
  return(csvs)
}

#updates order/name.csv file
#df is the new order input that will be appended to existing file, otherwise a new file will be written.
#the new order is grouped by klid to update the quantity.
#a 0 or negative sum(q) will remove the entire row.
csv_order <- function(fileName, df){
  if(file.exists(fileName)){
    tmp <- read.csv(fileName, stringsAsFactors = F)
    tmp <- dplyr::bind_rows(tmp, df) %>%
      group_by(name, klid) %>% summarise(q = sum(q), .groups = "drop")
    tmp <- dplyr::filter(tmp, q > 0)
    if(nrow(tmp) == 0){
      file.remove(fileName)
    } else {
      write.csv(tmp, fileName, row.names = F)
    }
  } else {
    write.csv(df, fileName, row.names = F)
  }
  #csv_compile_order()
}

#a function to display individual order
#that will be passed to renderDT() in app.R
get_csv_order <- function(name){
  fileName <- file.path(response_order,sprintf("%s.csv",name))
  if(!file.exists(fileName)){
    #return empty table
    orderCols <- c("name","klid","q","pricebreak","price","total","ship","sgd","klname")
    return(as_tibble(sapply(orderCols, function(x) character())))
  }
  tbl <- read_csv(fileName)
  tbl <- dplyr::mutate(left_join(tbl,
                                 get_sml(), by = "klid"),
                       total = q * price,
                       ship = q * price * ship_est,
                       sgd = q * price * (1 + ship_est) * USDSGD) %>%
    relocate(klname, .after = sgd)
  return(tbl)
}

#a function to compile all orders to a file
#this function is no longer called by csv_order
csv_compile_order <- function(){
  #read orders/*.csv file
  ordercsvList <- list.files(response_order, "*.csv", full.names = T)
  ordercsv <- dplyr::bind_rows(lapply(ordercsvList, read.csv))
  write.csv(ordercsv, order_file, row.names = F)
}

#function to assign small, medium or large price break
#on all orders by aggregating the q for each klid
get_sml <- function(){
  ordercsv <- get_csvs(response_order)
  ordercsv <- mutate_at(ordercsv, vars(q), as.integer)
  tmp <- dplyr::transmute(select(left_join(group_by(ordercsv, klid) %>%
                                             summarise(q = sum(q)),
                                           priceList, by = "klid"),
                                 klid, klname, q, mediumqty,largeqty,
                                 largeprice, mediumprice,smallprice),
                          klid = klid,
                          klname = klname,
                          pricebreak = get_pricebreak_vec(q, mediumqty, largeqty),
                          price = ((q >= largeqty) * largeprice +
                                     (q < largeqty & q >= mediumqty) * mediumprice +
                                     (q < mediumqty) * smallprice)
  )
  return(tmp)
}

#function to get the price break
get_pricebreak <- function(q, med, large){
  if(q < med){
    return("small")
  } else if(q >= large){
    return("large")
  } else {
    return("medium")
  }
}

#function to allow vector input for get_pricebreak
get_pricebreak_vec <- Vectorize(get_pricebreak)

#function to output a catalog table to renderDT() in app.R
get_catalog <- function(){
  tbl <- dplyr::select(priceList, klid, klname, smallprice)
  return(tbl)
}
