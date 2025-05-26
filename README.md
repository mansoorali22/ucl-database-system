# UEFA Champions League (UCL) Database

## 📁 Overview

This repository contains the full working solution for the **Database Systems**, based on a case study of the **UEFA Champions League (UCL)** from 2016 to 2022.

The assignment involves designing a relational database from real-world football data, normalizing it, loading data from Excel, and running complex SQL queries to retrieve meaningful insights.

---

## 🧠 Case Study Summary

The UEFA Champions League (UCL), one of the most prestigious football competitions globally, serves as the context for this database assignment. The dataset spans from **2016 to 2022**, containing player stats, matches, teams, goals, stadiums, and more.

The assignment was divided into 3 parts:

---

## ✅ PART 1 – Database Design (50 Marks)

- **ER Modeling and Schema Design:**
  - Identified major entities such as `Players`, `Teams`, `Matches`, `Goals`, `Managers`, and `Stadiums`.
  - Defined appropriate attributes, data types, primary keys, and foreign keys to map relationships.
  
- **Functional Dependency Analysis:**
  - Analyzed and documented full and partial functional dependencies for all tables.
  
- **Normalization:**
  - Ensured all tables meet **3NF** by eliminating transitive and partial dependencies.
  - Justified normalization steps to avoid redundancy and anomalies.

---

## 📥 PART 2 – Data Insertion (20 Marks)

- Loaded the dataset from Excel to SQL Server using **bulk import techniques** (e.g., SQL Server Import Wizard / Python / Excel import).
- Handled NULL values, ensured data integrity, and followed proper schema mappings.

---

## 🔍 PART 3 – SQL Queries (150 Marks)

- **EASY (5 queries – 25 marks):** Simple queries using `SELECT`, `JOIN`, `WHERE`, and aggregations.
- **MEDIUM (5 queries – 50 marks):** Conditional aggregations, filtering by year, and subqueries.
- **HARD (5 queries – 75 marks):** Advanced analytics using subqueries, grouping, ordering, and nested aggregations.

All queries return **complete and meaningful information**, not just IDs. They are written **generically** to support dynamic inputs and future data.

---

## ⭐ BONUS (10 Marks)

- Identified **winner teams for each UCL season** (2016-2022) using efficient aggregation and logic.

---



## 💻 Technologies Used

- **SQL Server** (preferred for loading and querying)
- **Microsoft Excel** (data preprocessing)
- **SQL** (DDL and DML)
- Optional tools: SSMS, DB Diagram tools, Python (for bulk insert scripting)

---

## 🏁 How to Run

1. Open SQL Server Management Studio (SSMS).
2. Use **SQL Server Import Wizard** or custom script to load `ucl_dataset.xlsx`.
3. Run `ucl-database-system.sql` to create, test and explore the data.

---

## 📜 License

This project is part of the academic coursework and is intended for educational purposes only. Reuse or distribution without permission is discouraged.

---

## 🙌 Acknowledgments

- FAST NUCES – Database Systems Course Team
- UEFA for the inspiration of the case study