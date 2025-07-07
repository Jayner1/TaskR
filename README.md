# Overview

As a software engineer, I’m continually looking for opportunities to expand my skills in full-stack development, data pipelines, and visualization. This project focuses on analyzing task management data stored in a Firebase Firestore database. The goal was to extract and interpret trends in productivity and task behavior by using R to visualize completion rates and overdue trends.

The data set consists of tasks stored in Firebase, each with attributes such as description, priority, category, due date, and completion status. These records were retrieved using Firebase's REST API.

The purpose of this software is to help understand user productivity patterns—like how often high-priority tasks are completed or how frequently tasks become overdue. By turning this raw task data into actionable insights and visualizations, the software provides a foundation for decision-making and future app improvements.

[Software Demo Video] - https://youtu.be/IvLDN7zScFk

# Data Analysis Results

**Questions and Answers:**

1. **How do task completion rates differ by priority level?**  
   Tasks with lower priorities were completed at a slightly higher rate. Higher-priority tasks were often left incomplete, suggesting possible procrastination or complexity.

2. **How many tasks are overdue versus on-time?**  
   The analysis showed a significant portion of incomplete tasks were past their due date, indicating a need for better deadline management.

3. **Are overdue tasks associated with any specific priority level?**  
   There was a tendency for medium and high-priority tasks to be overdue, reinforcing the idea that complexity or importance doesn't guarantee timely completion.

# Development Environment

- **Operating System:** macOS
- **Text Editor / IDE:** VS Code
- **Database:** Firebase Firestore (NoSQL)
- **Language:** R
- **Version Control:** Git

**Libraries Used:**

- `httr` – HTTP requests to access Firebase REST API  
- `jsonlite` – JSON parsing  
- `dplyr` – Data transformation  
- `ggplot2` – Data visualization  
- `lubridate` – Date parsing and manipulation  

# Useful Websites

* [Firebase REST API Documentation](https://firebase.google.com/docs/firestore/use-rest-api)
* [ggplot2 Documentation](https://ggplot2.tidyverse.org/)
* [RStudio Cheatsheets](https://posit.co/resources/cheatsheets/)
* [R for Data Science Book](https://r4ds.hadley.nz/)
* [Stack Overflow](https://stackoverflow.com/)

# Future Work

* Add support for filtering by category or due date ranges  
* Improve error handling for malformed or missing Firestore fields  
* Generate PDF reports or dashboards for broader sharing  
* Schedule recurring data pulls via CRON for real-time monitoring  
* Connect with a frontend to visualize data in-app