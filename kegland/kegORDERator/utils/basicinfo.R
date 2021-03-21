source("utils/parameters.R")
questions <- list(
  list(id = "uname", type = "text", title = "Name", mandatory = T),
  list(id = "paynow", type = "numeric", title = "PayNow Number", mandatory = T)
)

formInfo <- list(
  id = "basicinfo",
  questions = questions,
  storage = list(
    type = STORAGE_TYPES$FLATFILE,
    path = response_user
  )
)