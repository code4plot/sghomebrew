# The kegORDERator
This project is initiated to continually improve the homebrew Singapore kegland group buy platform.  
It will utilise the shiny app capabilities of accepting inputs, displaying tables and graphs.
Shiny App's capabilities has been further advanced by DataTables (https://rstudio.github.io/DT/).  
To accept input like filling up a Google Form, I have gotten guidance and ideas from Dean Attali (https://deanattali.com/2015/06/14/mimicking-google-form-shiny/), including an R package he wrote (https://www.rdocumentation.org/packages/shinyforms/versions/0.0.0.9000). Both have been tremendously resourceful.

# app.R
wrapper script to deploy the shiny app

# utils
Contains various scripts that are called by app.R - paramters.R, utils.R, order.R, basicinfo.R

## parameters.R
Various parameters are assigned to variables used in the entire app.

## utils.R
functions to compile orders into tables for writing to csv locally and displaying on shiny.

## order.R
functions to handle the order form

## basicinfo.R
functions to handle new user registration.
