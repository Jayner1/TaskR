library(httr)
library(jsonlite)
library(dplyr)
library(ggplot2)
library(lubridate)

project_id <- "task-manager-706fc"
collection <- "tasks"
api_key <- "AIzaSyDRS-meN_FI83E1TalKl2fZqePGt6DCVoQ"

base_url <- paste0("https://firestore.googleapis.com/v1/projects/", project_id, "/databases/(default)/documents/")

`%||%` <- function(a, b) if (!is.null(a)) a else b

fetch_tasks <- function() {
  url <- paste0(base_url, collection, "?key=", api_key)
  res <- GET(url)
  
  if (status_code(res) != 200) {
    stop("Failed to fetch data: ", content(res, "text"))
  }
  
  content(res, "parsed", simplifyVector = TRUE)
}

parse_tasks <- function(raw_data) {
  docs_df <- raw_data$documents
  
  if (is.null(docs_df) || nrow(docs_df) == 0) {
    message("No tasks found in Firestore.")
    return(data.frame())
  }

  fields_df <- docs_df$fields
  
  if (is.null(fields_df) || nrow(fields_df) == 0) {
    message("No fields data found.")
    return(data.frame())
  }

  description   <- fields_df$description$stringValue %||% rep(NA, nrow(fields_df))
  category_id   <- as.integer(fields_df$category_id$integerValue %||% rep(NA, nrow(fields_df)))
  priority_id   <- as.integer(fields_df$priority_id$integerValue %||% rep(-1, nrow(fields_df)))
  is_completed  <- fields_df$is_completed$booleanValue %||% rep(FALSE, nrow(fields_df))
  firebaseId    <- fields_df$firebaseId$stringValue %||% rep(NA, nrow(fields_df))
  task_id       <- as.integer(fields_df$task_id$integerValue %||% rep(NA, nrow(fields_df)))
  due_date      <- fields_df$due_date$stringValue %||% rep(NA, nrow(fields_df))

  df <- data.frame(
    description   = description,
    category_id   = category_id,
    priority_id   = priority_id,
    is_completed  = is_completed,
    firebaseId    = firebaseId,
    task_id       = task_id,
    due_date      = due_date,
    stringsAsFactors = FALSE
  )

  df <- df %>% filter(!is.na(description) & !is.na(priority_id) & !is.na(is_completed))

  if (nrow(df) == 0) {
    message("No valid tasks found.")
    return(data.frame())
  }

  return(df)
}

# Fetch and parse tasks
raw_data <- fetch_tasks()
tasks_df <- parse_tasks(raw_data)

if (nrow(tasks_df) == 0) stop("No task data to process.")

# Convert due_date to Date
tasks_df$due_date <- ymd(tasks_df$due_date)

# Add overdue status column
today <- Sys.Date()
tasks_df$overdue <- ifelse(!tasks_df$is_completed & !is.na(tasks_df$due_date) & tasks_df$due_date < today, "Overdue", "On Time")

# ---- Plot 1: Completion by Priority ----
tasks_df$is_completed <- factor(tasks_df$is_completed, levels = c(FALSE, TRUE), labels = c("Incomplete", "Completed"))

p1 <- ggplot(tasks_df, aes(x = factor(priority_id), fill = is_completed)) +
  geom_bar(position = "dodge") +
  labs(
    title = "Task Completion by Priority",
    x = "Priority Level",
    y = "Number of Tasks",
    fill = "Status"
  ) +
  scale_fill_manual(values = c("tomato", "springgreen")) +
  theme_minimal()

ggsave("task_completion_by_priority.png", p1, width = 7, height = 5, bg = "white")

# ---- Plot 2: Overdue Task Breakdown ----
p2 <- ggplot(tasks_df, aes(x = overdue, fill = is_completed)) +
  geom_bar(position = "dodge") +
  labs(
    title = "Overdue vs On-Time Tasks",
    x = "Due Status",
    y = "Count",
    fill = "Completion"
  ) +
  scale_fill_manual(values = c("tomato", "springgreen")) +
  theme_minimal()

ggsave("task_overdue_status.png", p2, width = 7, height = 5, bg = "white")

# ---- CSV Export ----
write.csv(tasks_df, "firebase_tasks_export.csv", row.names = FALSE)

# ---- Console Summary ----
cat("✅ Plots saved: task_completion_by_priority.png and task_overdue_status.png\n")
cat("✅ Task data exported to: firebase_tasks_export.csv\n")
cat("\n📋 Overdue Task Summary:\n")
print(tasks_df[tasks_df$overdue == "Overdue", c("description", "due_date", "is_completed")])
