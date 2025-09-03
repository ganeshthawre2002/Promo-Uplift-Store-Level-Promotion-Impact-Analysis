# 📊 Promo Uplift & Store-Level Promotion Impact Analysis


This project is a **comprehensive data analytics case study** that evaluates the effectiveness of promotional campaigns across multiple stores.
Using **Python, PostgreSQL-style queries, Excel, and Power BI dashboards**, we conducted uplift analysis and store-level promotional performance measurement.  

---

## 🚀 Project Overview

- **Objective:** Measure the true impact of promotional activities on sales and identify which stores, products, and campaigns delivered the highest ROI.  
- **Datasets Used:**
  - `promo uplift.csv` → Promotional uplift % across different campaigns.
  - `store level promo impact.csv` → Store-wise promotional performance metrics.

---



## 📂 Dataset Summary


### 1️⃣ `promo uplift.csv`
- Records: **1,500+ campaign entries**
- Key Fields:
  - `Campaign_ID`
  - `Product_Category`
  - `Promo_Start` / `Promo_End`
  - `Uplift_%` (percentage increase in sales due to promotion)
  - `Revenue_Before` / `Revenue_After`




**Example Numbers:**
- Avg uplift across all promos: **12.6%**
- Best performing category: **Beverages (+22.4%)**
- Worst performing category: **Household (-3.1%)**

---



### 2️⃣ `store level promo impact.csv`
- Records: **250+ store-level entries**
- Key Fields:
  - `Store_ID`
  - `Region`
  - `Promo_Days`
  - `Incremental_Sales`
  - `Baseline_Sales`
  - `ROI`



**Example Numbers:**
- Highest ROI store: **Store 104 (Mumbai) → 3.2x ROI**
- Lowest ROI store: **Store 207 (Delhi NCR) → 0.8x ROI**
- Regional Performance:
  - **West Zone → Avg uplift 15.2%**
  - **South Zone → Avg uplift 10.1%**
  - **North Zone → Avg uplift 8.4%**

---



## 📈 Methodology

1. **Data Cleaning & Preparation**
   - Removed nulls, duplicates, and standardized dates.
   - Calculated incremental uplift = `(Revenue_After - Revenue_Before) / Revenue_Before`.

2. **Exploratory Data Analysis (EDA)**
   - Sales uplift trend analysis (before vs after promo).
   - Store-level comparative performance.
   - ROI distribution across campaigns.

3. **Visualization**
   - Power BI dashboard: Campaign trends, Store ROI, Regional uplift.
   - Python Matplotlib/Seaborn: Uplift distribution & correlation analysis.

4. **Insights Generation**
   - Identified top-performing campaigns, regions, and stores.
   - Quantified ROI per promo type.
   - Segmented underperforming vs high-performing campaigns.

---


## 🔑 Key Insights

📌 **Overall Promotion Effectiveness**
- Avg uplift: **12.6%**
- Campaigns with >20% uplift: **23 campaigns (15%)**
- Campaigns with negative impact: **11 campaigns (-3% to -7%)**

📌 **Store-Level Impact**
- **Top Store:** Mumbai (Store 104) → **+21% uplift, 3.2x ROI**
- **Underperforming:** Delhi NCR (Store 207) → **-2% uplift, 0.8x ROI**

📌 **Regional Impact**
- **West Zone leads** (avg uplift 15.2%) → Strong consumer promo response.
- **North Zone lags** (avg uplift 8.4%) → Requires targeted strategies.

📌 **Product Category Insights**
- Beverages & Snacks → **Most responsive** (+20% avg uplift).
- Household → **Weak response** (-3.1% avg uplift).

---



## 📊 Dashboard Preview
👉 Power BI dashboards & Python visuals showcase:
- Campaign uplift distribution  
- Store-level ROI comparison  
- Regional impact maps  
- Category-wise promo effectiveness  

*(Add screenshots from `visuals/` folder)*

---


## 📘 Deliverables

1. **Promo Impact Report (PDF)** → In-depth campaign & store analysis.  
2. **Executive Summary (PDF)** → Concise business-focused report.  
3. **Power BI Dashboard** → Interactive visualization.  
4. **Python Notebooks** → Reproducible analysis scripts.  

---

## 🛠️ Tech Stack
- **Python** → Pandas, Matplotlib, Seaborn
- **Excel** → Data exploration & pivot analysis
- **Power BI** → Interactive dashboards
- **GitHub** → Project hosting & documentation
- **PostgreSQL** → Queries 
---

## 📌 Business Recommendations

- Scale promos in **West Zone & high-ROI stores** (e.g., Mumbai).
- Reallocate promo budget away from **low-performing North Zone stores**.
- Double down on **Beverages & Snacks promotions** (highest ROI).
- Redesign or stop promos for **Household category**.
- Consider **personalized regional campaigns** based on response.

---

## 👨‍💻 Author
**Ganesh Chandrashekhar Thaware**  
Data Analyst | Business Analytics | Power BI | SQL | Python  
📍 Saoner, Maharashtra, India  
🔗 [LinkedIn](www.linkedin.com/in/ganesh-thawre2002) | [GitHub](https://github.com/ganeshthawre2002)

---
