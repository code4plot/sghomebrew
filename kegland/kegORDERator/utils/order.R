source("utils/parameters.R")
source("utils/utils.R")

orderForm <- function(selected){
  users <- loadUsers()
  #usercsvList <- list.files(response_user, "*.csv", full.names = T)
  #users <- dplyr::bind_rows(lapply(usercsvList, read.csv))
  return(fluidPage(
    selectInput("name","Name", choices = users$uname, multiple = F),
    fluidRow(column(width = 8, selectInput("klid", "Item", selected = selected, choices = priceList$klid, multiple = F)),
                column(width = 4, numericInput("q", "Quantity", value = 1, min = 0, step = 1))
    ),
    actionButton("submit_order", "Submit", class = "btn-primary")
))
}



save_order <- function(data, name){
  fileName <- file.path(response_order, sprintf("%s.csv", name))
  csv_order(fileName, data)
}

