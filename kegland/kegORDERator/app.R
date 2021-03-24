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
  formData_user <- reactive({
    data_user <- sapply(fields_user, function(x) input[[paste("basicinfo-",x, sep = "")]])
    data_user <- bind_rows(data_user)
  })
  observeEvent(input[["basicinfo-submit"]], {
    print(names(input))
    rds_user(formData_user())
    shinyjs::reset("basicinfo-form")
    shinyjs::hide("basicinfo-form")
    shinyjs::show("basicinfo-thankyou_msg")
  })
  observeEvent(input[["basicinfo-submit_another"]], {
    shinyjs::show("basicinfo-form")
    shinyjs::hide("basicinfo-thankyou_msg")
  })
  formData_order <- reactive({
    data_order <- sapply(fields_order, function(x) input[[x]])
    data_order <- bind_rows(data_order) %>% mutate(q = as.integer(q))
  })
  observeEvent(input$submit_order, {
    #save_order(formData_order(), input$name)
    rds_order(formData_order())
  })
  output$tbl <- DT::renderDataTable({
    if(input$action == "order"){
      DT::datatable(get_catalog(), container = catalog_header, rownames = F) %>% 
        formatCurrency(c('smallprice'))
    }
  })
  order_df <- reactive({
    input$submit_order
    get_individual_order(input$name)
  })
  output$tbl_myorder <- DT::renderDataTable({
    DT::datatable(order_df(), container = order_header, rownames = F,
                  options = list(scrollX = T)
                  ) %>%
      formatCurrency(c('price', 'total', 'ship', 'sgd'))
  })
}

shinyApp(ui = ui, server = server)
