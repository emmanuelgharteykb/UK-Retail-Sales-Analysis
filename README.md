# UK Retail Sales Intelligence Dashboard

## 📌 Project Overview
An end-to-end Data Analytics project focused on extracting actionable insights from a UK retail dataset. This project bridges the gap between raw infrastructure and business intelligence.

## 🛠 Tech Stack
* **Database:** SQL (Data Cleaning, Casting, Window Functions)
* **Visualization:** Power BI (DAX, Power Query)
* **Cloud/DevOps:** GitHub (Version Control)

## 📊 Key Insights (Day 1)
* **Seasonality:** Identified December as the peak revenue month via SQL time-series analysis.
* **Customer Logic:** Performed a Pareto (80/20) analysis to identify high-value customer segments.
* **Data Integrity:** Handled inconsistent date formats and decimal precision issues using SQL `CAST` and `STR_TO_DATE` functions.

## 📈 Advanced Analytics & Visualization (Day 2)
Transitioned from backend data validation to a high-fidelity Power BI executive dashboard, focusing on Star Schema modeling and Time Intelligence.

## 🧩 Data Modeling
* **Star Schema Implementation:** Designed a custom `Calendar` dimension table to handle time-series analysis, overcoming the limitations of standard auto-date hierarchies.
*  **Relational Mapping:** Established One-to-Many relationships between the Calendar and Sales tables to enable seamless filtering across months and regions.

## 🧪 DAX & Business Logic
Developed a suite of custom Data Analysis Expressions (DAX) to drive the "Big Three" KPI cards:
* **Total Revenue:** Dynamic sum of sales after data casting.
* **Total Profit:** Aggregated profit margins per product line.
* **Total Margin %:** A calculated ratio ($Total Profit / Total Revenue$) formatted to provide immediate executive "Health Checks" (35.18% overall).

## 🎨 Dashboard Features & UX
* **Geospatial Intelligence:** Integrated Bing Maps to visualize regional revenue hotspots, identifying Glasgow as a primary growth hub.
* **Interaction Drill-Downs:** Implemented a **Region Slicer** to allow stakeholders to instantly toggle between city-specific performances.
* **Product Performance:** Used a Clustered Bar Chart to identify **Running Shoes** as the most profitable item, despite "Sports" being a broad category.

## 🏁 Final Project Conclusions
* **The "February Spike":** By connecting SQL findings to Power BI visuals, I confirmed a **35.94% revenue increase** in February, providing a data-driven basis for seasonal marketing adjustments.
*  **VIP Segmentation:** The dashboard successfully visualizes the Pareto analysis, making high-value customer identification a 1-click process for the sales team.

## 📸 Final Dashboard


## 📂 Repository Contents
* `/SQL_Scripts`: Contains advanced queries for MoM growth and customer segmentation.
* `/Data`: The raw 1,000-row UK retail dataset.
* `/PowerBI_Report`: The final `.pbix` file with the interactive dashboard.
* `/Screenshots`: High-resolution captures of the final dashboard layout.
