# Load required libraries
library(tidyverse)

# Load CSV data
task_data <- read_csv("tasks.csv")

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
plot_tasks(task_data)                         # Show visualization
