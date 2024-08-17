# Balance Sheet SQL Queries

### Overview

This project provides a set of SQL queries to generate balance sheets, income statements, and other financial summaries for a company based on its accounting data. The queries are designed to calculate key financial figures such as total assets, liabilities, net income, and more for a specific year.

### Features

- **Balance Sheet Summary**: Generates a high-level overview of assets, liabilities, and equity.
- **Detailed Balance Sheet**: Provides a detailed breakdown of each account within the balance sheet sections.
- **Income Statement**: Separates revenue and expenses to calculate total profit and total expenses.
- **Net Profit/Loss Calculation**: Computes the net profit or loss by comparing total revenue and total expenses.

### SQL Code Explanation

1. **Set the Year**:
   - Define the fiscal year for which the balance sheet and income statement will be generated.

2. **Balance Sheet Summary**:
   - Summarizes financial position by calculating the difference between debits and credits for each section of the balance sheet.

3. **Detailed Balance Sheet**:
   - Breaks down the balance sheet into individual accounts, showing specific amounts for each.

4. **Income Statement - Gains**:
   - Calculates total revenue and other income to display profits.

5. **Income Statement - Losses**:
   - Calculates the total cost of goods sold, selling expenses, and other expenses to display losses.

6. **Net Profit/Loss Calculation**:
   - Combines the results of the profit and loss queries to calculate the final net profit or loss.

### How to Use

1. **Database Setup**:
   - Ensure your database schema includes the necessary tables: `journal_entry`, `journal_entry_line_item`, `account`, `journal_type`, and `statement_section`.

2. **Set the Fiscal Year**:
   - Modify the `@year` variable to the desired fiscal year.

3. **Run the Queries**:
   - Execute the provided SQL queries in your database management tool to generate the financial statements.

### Requirements

- **Database**: The SQL queries are designed for a relational database with a standard accounting schema.
- **Tables**: The required tables include `journal_entry`, `journal_entry_line_item`, `account`, `journal_type`, and `statement_section`.

### Conclusion

These SQL queries provide a comprehensive toolset for generating essential financial reports from your accounting data. By setting the desired fiscal year, you can easily produce balance sheets, income statements, and net profit/loss summaries to assess the financial health of your business.
