library(httr)
library(jsonlite)
library(dplyr)
library(ggplot2)

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
  
  # The 'fields' column is itself a data frame with nested columns
  fields_df <- docs_df$fields
  
  if (is.null(fields_df) || nrow(fields_df) == 0) {
    message("No fields data found.")
    return(data.frame())
  }
  
  # Extract columns safely with null coalescing fallback
  description <- if ("description" %in% names(fields_df)) fields_df$description$stringValue else rep(NA, nrow(fields_df))
  category_id <- if ("category_id" %in% names(fields_df)) as.integer(fields_df$category_id$integerValue) else rep(NA, nrow(fields_df))
  priority_id <- if ("priority_id" %in% names(fields_df)) as.integer(fields_df$priority_id$integerValue) else rep(NA, nrow(fields_df))
  is_completed <- if ("_completed" %in% names(fields_df)) fields_df$`_completed`$booleanValue else rep(NA, nrow(fields_df))
  # Try alternative field name if needed:
  if (all(is.na(is_completed)) && "is_completed" %in% names(fields_df)) {
    is_completed <- fields_df$is_completed$booleanValue
  }
  firebaseId <- if ("firebaseId" %in% names(fields_df)) fields_df$firebaseId$stringValue else rep(NA, nrow(fields_df))
  task_id <- if ("task_id" %in% names(fields_df)) as.integer(fields_df$task_id$integerValue) else rep(NA, nrow(fields_df))
  
  # Construct data frame
  df <- data.frame(
    description = description,
    category_id = category_id,
    priority_id = priority_id,
    is_completed = is_completed,
    firebaseId = firebaseId,
    task_id = task_id,
    stringsAsFactors = FALSE
  )
  
  # Remove rows missing required fields
  df <- df[complete.cases(df[, c("priority_id", "is_completed")]), ]
  
  if (nrow(df) == 0) {
    message("No valid task documents with required fields found after filtering.")
    return(data.frame())
  }
  
  df
}

# Main
raw_data <- fetch_tasks()

tasks_df <- parse_tasks(raw_data)

if (nrow(tasks_df) == 0) {
  stop("No task data to process.")
}

tasks_df$is_completed <- factor(tasks_df$is_completed, levels = c(FALSE, TRUE), labels = c("Incomplete", "Completed"))

plot <- ggplot(tasks_df, aes(x = factor(priority_id), fill = is_completed)) +
  geom_bar(position = "dodge") +
  labs(
    title = "Task Completion by Priority",
    x = "Priority Level",
    y = "Number of Tasks",
    fill = "Status"
  ) +
  scale_fill_manual(values = c("tomato", "springgreen")) +
  theme_minimal() +
  theme(
    plot.background = element_rect(fill = "black", color = NA),
    panel.background = element_rect(fill = "black"),
    panel.grid.major = element_line(color = "gray40"),
    panel.grid.minor = element_line(color = "gray30"),
    axis.text = element_text(color = "white"),
    axis.title = element_text(color = "white"),
    plot.title = element_text(color = "white", size = 16, face = "bold"),
    legend.background = element_rect(fill = "black"),
    legend.key = element_rect(fill = "black"),
    legend.text = element_text(color = "white"),
    legend.title = element_text(color = "white")
  )

print(plot)

ggsave("task_completion_by_priority.png", plot = plot, width = 7, height = 5, bg = "black")

message("✅ Plot saved as 'task_completion_by_priority.png' in working directory.")
