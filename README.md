# Olist Marketplace Analytics Project

![Python](https://img.shields.io/badge/Python-3.10%2B-3776AB?logo=python&logoColor=white)
![SQL Server](https://img.shields.io/badge/SQL%20Server-2019%2B-CC2927?logo=microsoftsqlserver&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-Desktop-F2C811?logo=powerbi&logoColor=black)
![DAX](https://img.shields.io/badge/DAX-Measure%20Logic-FF7F0E)
![Git](https://img.shields.io/badge/Git-Version%20Control-F05032?logo=git&logoColor=white)

This project is a business intelligence and analytics case study built around the Olist Brazilian E-commerce dataset. The goal is to transform raw transactional data into meaningful insights using Python, SQL Server, and Power BI. The work is structured around business questions that matter to marketplace stakeholders: growth, seller performance, customer satisfaction, and operational efficiency.

## Project Objective

The project aims to analyze the performance of the Olist marketplace from multiple business perspectives. The analysis focuses on understanding:

- overall marketplace growth and revenue trends
- seller contribution and marketplace concentration
- customer experience and review behavior
- delivery and logistics performance

This repository is designed to showcase an end-to-end analytics workflow suitable for a data analyst portfolio.

## Business Understanding

The main objective of this project is to support data-driven decision making by turning operational and customer data into business insights. The analysis is not only about technical transformation, but also about answering strategic questions such as:

- How is the marketplace performing over time?
- Which sellers contribute the most value?
- Are customers satisfied with their experience?
- Are deliveries efficient and on time?

## Analysis Planning

The project is divided into four business-focused dashboards.

### 1. Executive Summary Dashboard
**Purpose**

Provide a high-level view of marketplace performance.

**Key Questions**

- How is the marketplace performing?
- Is revenue growing?
- How many customers, sellers, and orders are generated?
- What are the overall business trends?

**Key KPIs**

- GMV
- Total Orders
- Total Customers
- Total Sellers
- Average Order Value
- Monthly Revenue Trend

### 2. Seller Performance Dashboard
**Purpose**

Evaluate seller contribution and marketplace concentration.

**Key Questions**

- Who generates the highest revenue?
- Is revenue concentrated among a few sellers?
- How many new sellers join the platform?
- How is seller performance distributed?

**Key KPIs**

- Top Sellers
- Seller Ranking
- Revenue Distribution
- Pareto Analysis
- New Seller Growth

### 3. Customer Satisfaction Dashboard
**Purpose**

Measure customer experience using review data.

**Key Questions**

- Are customers satisfied?
- How does satisfaction change over time?
- What proportion of reviews are positive?
- Does delivery performance influence customer satisfaction?

**Key KPIs**

- Average Rating
- Positive Review Rate
- Negative Review Rate
- Rating Distribution
- Rating Trend
- Review Volume

### 4. Operations Dashboard
**Purpose**

Evaluate fulfillment and logistics efficiency.

**Key Questions**

- Are orders delivered on time?
- How long does delivery take?
- Which order statuses occur most frequently?
- Is logistics performance improving?

**Key KPIs**

- Average Delivery Days
- On-time Delivery Rate
- Late Delivery Rate
- Order Status Distribution
- Delivery Performance Trend

## Data Source

The project uses the public Olist Brazilian E-commerce dataset from Kaggle. It includes transactional and customer behavior data from an online marketplace in Brazil.

### Main tables included

- orders
- customers
- sellers
- products
- order_items
- payments
- reviews
- geolocation
- category_translation

## Data Analysis Process

The project follows a structured analytics workflow:

1. Explore the raw Olist dataset.
2. Design a reporting-ready structure for analysis.
3. Use python to EDA the dataset and import into SQL
3. Build SQL to prepare dashboard-ready datasets and check measures.
4. Import data into Power BI.
5. Create DAX measures and KPIs.
6. Design interactive dashboards.
7. Analyze business performance.
8. Generate insights and recommendations.

## ETL and Analytics Workflow

The repository contains the core components of the analysis pipeline:

- Python notebooks for data exploration and cleaning
- SQL scripts for database creation and business queries
- SQL views for analytical reporting
- Power BI dashboard file for visualization and KPI tracking

## Business Insights

The dashboards are designed to uncover insights such as:

### Marketplace

- revenue growth over time
- seasonal sales patterns
- customer acquisition trends

### Sellers

- revenue concentration among top sellers
- identification of high-performing sellers
- growth of new sellers

### Customers

- overall customer satisfaction
- review behavior over time
- relationship between service quality and customer feedback

### Operations

- delivery efficiency
- impact of delays on customer experience
- order fulfillment performance

## Recommendations

Based on the analysis, possible recommendations include:

### Business

- strengthen relationships with high-performing sellers
- support new sellers to improve marketplace diversity
- expand successful product categories

### Customer Experience

- improve response to negative feedback
- enhance post-purchase support
- encourage customer reviews and engagement

### Operations

- reduce delivery delays through logistics optimization
- monitor delivery KPIs continuously
- improve fulfillment processes in regions with weaker performance

## Repository Structure

```text
OlistProject/
├── Cleaned Dataset/           # Cleaned CSV and PKL files
├── Notebook/                  # Jupyter notebooks for EDA and preprocessing
├── SQL Queries/               # SQL Server schema and business queries
├── Olist_BI.pbix              # Power BI dashboard file
└── README.md                  # Project documentation
```

## Installation and Setup

### Prerequisites

- Python 3.9 or newer
- SQL Server
- Power BI Desktop
- Git

### Setup Steps

1. Clone the repository:

```bash
git clone https://github.com/your-username/OlistProject.git
cd OlistProject
```

2. Create a Python environment and install dependencies:

```bash
python -m venv .venv
source .venv/bin/activate   # Windows: .venv\Scripts\activate
pip install pandas numpy matplotlib seaborn jupyter
```

3. Create the SQL Server database using the scripts in the SQL Queries folder.

4. Run the business queries to generate analytical views and KPIs.

5. Open the Power BI file and connect it to your SQL Server instance.

## Usage

- Open the notebooks in the Notebook folder to review the exploratory analysis and data cleaning steps.
- Use the SQL scripts for database creation and metric calculation.
- Open the Power BI dashboard file to explore the interactive dashboards.
- Analyze trends by time, seller, region, and delivery performance.

## Screenshots

### Executive Summary Dashboard
![Executive Summary Placeholder](https://via.placeholder.com/1200x700?text=Executive+Summary+Dashboard)

### Seller Performance Dashboard
![Seller Performance Placeholder](https://via.placeholder.com/1200x700?text=Seller+Performance+Dashboard)

### Customer Satisfaction Dashboard
![Customer Satisfaction Placeholder](https://via.placeholder.com/1200x700?text=Customer+Satisfaction+Dashboard)

### Operations Dashboard
![Operations Dashboard Placeholder](https://via.placeholder.com/1200x700?text=Operations+Dashboard)

## Future Improvements

Potential next steps for this project include:

- add predictive analytics for late deliveries and customer churn
- automate data refresh with scheduled ETL jobs
- expand analysis with deeper regional and category drill-throughs
- apply NLP-based review sentiment analysis
- publish the dashboard to Power BI Service

## Summary

This project demonstrates a complete analytics workflow from raw data to business insight. It combines Python, SQL, and Power BI to tell a clear story about marketplace growth, seller performance, customer satisfaction, and operational efficiency.
