library(shiny)
library(tidyverse)
library(shinyforms)
library(DT)

#basic info form
source("utils/basicinfo.R")
source("utils/order.R")
source("utils/parameters.R")


ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(radioButtons("action", label = "Select One", 
                              choices = list("New User Registration" = "new",
                                             "New/View Orders" = "order",
                                             "Edit Orders" = "edit"
                                             )),
                 uiOutput("actionchoice")
  ),
  mainPanel(tabsetPanel(
    tabPanel("Price List", DT::dataTableOutput('tbl')),
    tabPanel("My Orders", DT::dataTableOutput('tbl_myorder'))
  )
)
)
)

server <- function(input, output, session){
  output$actionchoice <- renderUI({
    if(input$action == "new"){
      formUI(formInfo)
    } else if(input$action == "order"){
      orderForm(input$tbl_cell_clicked)
    }
  })
  formServer(formInfo)
  formData_order <- reactive({
    data_order <- sapply(fields_order, function(x) input[[x]])
    data_order <- bind_rows(data_order) %>% mutate(q = as.integer(q))
  })
  observeEvent(input$submit_order, {
    save_order(formData_order(), input$name)
  })
  output$tbl <- DT::renderDataTable({
    if(input$action == "order"){
      DT::datatable(get_catalog(), container = catalog_header, rownames = F) %>% 
        formatCurrency(c('smallprice'))
    }
  })
  order_df <- reactive({
    input$submit_order
    get_csv_order(input$name)
  })
  output$tbl_myorder <- DT::renderDataTable({
    DT::datatable(order_df(), container = order_header, rownames = F,
                  options = list(scrollX = T)
                  ) %>%
      formatCurrency(c('price', 'total', 'ship', 'sgd'))
  })
}

shinyApp(ui = ui, server = server)
