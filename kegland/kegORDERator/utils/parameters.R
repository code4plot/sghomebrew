##list parameters here
##use comment character to describe the param

#check if directory exists, otherwise create
dirExist <- function(d){
  if(!dir.exists(d)){
    dir.create(d)
  }
}

#new user responses dir
response_user <- file.path("users")
dirExist(response_user)

#price list
priceList <- read_csv("tables/priceList_test.csv")
colnames(priceList) <- c("klid","klname","Units.Per.Outter.Carton.Bag",
                         "mediumqty","largeqty","largeprice","mediumprice","smallprice")
priceList <- dplyr::mutate(priceList, largeprice = parse_number(largeprice),
                           mediumprice = parse_number(mediumprice),
                           smallprice = parse_number(smallprice))


# DB
## db credentials
db_cred <- readRDS("credentials/db_cred.RDS")
databaseName <- "kegorderator"
table_users <- "users"
table_orders <- "orders"

#input fields to extract user input
fields_user <- c("uname", "paynow")

#input fields to extract order input
fields_order <- c("name", "klid", "q")

#new order responses dir
response_order <- file.path("orders")
dirExist(response_order)

#compiled order csv file
order_file <- file.path("tables", "orders.csv")

catalog_header <- htmltools::withTags(table(
  tableHeader(c("KLID","Product Name", "Price (USD)"))
))

order_header <- htmltools::withTags(table(
  tableHeader(c("Name", "KLID","Qty", "Price Break", 
                "Price (USD)", "SubTotal (USD)", "Est. Ship (USD)", "Est. SGD", "Product Name"))
))

ship_est = 0.2
USDSGD = 1.34 * 1.05

