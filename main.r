library(tidyverse)
library(lubridate)  # for date parsing and handling

# Load CSV data
task_data <- read_csv("tasks.csv")

# Convert due_date column to Date type (assuming due_date exists)
task_data <- task_data %>%
  mutate(due_date = ymd(due_date))  # parse 'YYYY-MM-DD' strings to Date

# Display first few rows
print("Task Data Preview:")
print(head(task_data))

# Function to display summary
display_summary <- function(data) {
  cat("\n--- Task Summary ---\n")
  print(summary(data))
  
  cat("\nTask counts by status:\n")
  print(table(data$status))
  
  cat("\nTask counts by priority:\n")
  print(table(data$priority))
}

# Function to filter tasks by priority
filter_by_priority <- function(data, level) {
  cat(paste("\n--- Tasks with Priority:", level, "---\n"))
  filtered <- filter(data, priority == level)
  print(filtered)
}

# Function to filter tasks by overdue status
filter_overdue_tasks <- function(data) {
  today <- Sys.Date()
  
  overdue <- filter(data, status != "Complete" & due_date < today)
  upcoming <- filter(data, status != "Complete" & due_date >= today)
  
  cat("\n--- Overdue Tasks ---\n")
  print(overdue)
  
  cat("\n--- Upcoming Tasks ---\n")
  print(upcoming)
}

# Function to plot task counts by priority and status
plot_tasks <- function(data) {
  ggplot(data, aes(x = priority, fill = status)) +
    geom_bar(position = "dodge") +
    labs(title = "Task Count by Priority and Status",
         x = "Priority",
         y = "Number of Tasks") +
    theme_minimal()
}

# Run the program
display_summary(task_data)                    # Show summary
filter_by_priority(task_data, "High")         # Filter example
filter_overdue_tasks(task_data)               # Overdue filtering
plot_tasks(task_data)                         # Show visualization
