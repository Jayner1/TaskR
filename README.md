# Overview

As a software engineer expanding my data analysis and visualization skills, I created a script in **R** that connects to a Firestore database, retrieves task data, and displays it graphically. This project demonstrates how to use R to interact with a real-world NoSQL backend, transform JSON data into usable data frames, and create clean, meaningful visualizations.

The main goal of this software is to fetch task information (such as priority and completion status) from a Firebase Firestore collection, parse and clean the data, and produce a bar chart that shows how many tasks are completed or incomplete by priority level.

This helped me gain hands-on experience with HTTP requests, data wrangling in R, and the `ggplot2` visualization system.

[Software Demo Video] https://youtu.be/BRVFOPt9T_o

# Development Environment

- **OS:** macOS
- **Editor:** Visual Studio Code with the R extension
- **Language:** R
- **Packages Used:**
  - `httr` – for making API calls to Firebase
  - `jsonlite` – for parsing JSON responses
  - `dplyr` – for data manipulation
  - `ggplot2` – for building the task visualization chart

# Useful Websites

- [Firebase REST API Reference](https://firebase.google.com/docs/firestore/use-rest-api)
- [ggplot2 Documentation](https://ggplot2.tidyverse.org/)
- [HTTR Package Reference](https://cran.r-project.org/web/packages/httr/index.html)
- [dplyr Package Reference](https://dplyr.tidyverse.org/)
- [jsonlite Package Reference](https://cran.r-project.org/web/packages/jsonlite/index.html)

# Future Work

- Add ability to write or update tasks directly from R
- Enhance error handling and logging for edge cases in the data
- Export parsed data to a CSV file for offline analysis
- Support filtering by date range or completion status in plots
- Add command-line argument support for reusable script execution
