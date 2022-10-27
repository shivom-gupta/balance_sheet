# SET THE YEAR HERE
SET @year := 2015;



# Table for balance sheet summary
SELECT statement_section AS Particulars ,ABS(ROUND(COALESCE(sum(debit),0)-COALESCE(sum(credit),0),2)) AS Amount 
FROM accounting.journal_entry
JOIN accounting.journal_entry_line_item
ON journal_entry.journal_entry_id = journal_entry_line_item.journal_entry_id
JOIN accounting.account
ON account.account_id = journal_entry_line_item.account_id
JOIN accounting.journal_type
ON journal_type.journal_type_id = journal_entry.journal_type_id
JOIN accounting.statement_section
ON statement_section.statement_section_id = account.balance_sheet_section_id
WHERE journal_entry.company_id = 1 AND YEAR(entry_date) = @year
GROUP BY 1;

# Table for detailed balance sheet
SELECT statement_section AS Particulars , account, ABS(ROUND(COALESCE(sum(debit),0)-COALESCE(sum(credit),0),2)) AS Amount 
FROM accounting.journal_entry
JOIN accounting.journal_entry_line_item
ON journal_entry.journal_entry_id = journal_entry_line_item.journal_entry_id
JOIN accounting.account
ON account.account_id = journal_entry_line_item.account_id
JOIN accounting.journal_type
ON journal_type.journal_type_id = journal_entry.journal_type_id
JOIN accounting.statement_section
ON statement_section.statement_section_id = account.balance_sheet_section_id
WHERE journal_entry.company_id = 1 AND YEAR(entry_date) = @year
GROUP BY 1,2;

# Table for gains
# First part of table for all particulars
(SELECT statement_section AS Particulars ,ROUND(sum(debit),2) AS Amount 
FROM accounting.journal_entry
JOIN accounting.journal_entry_line_item
ON journal_entry.journal_entry_id = journal_entry_line_item.journal_entry_id
JOIN accounting.account
ON account.account_id = journal_entry_line_item.account_id
JOIN accounting.journal_type
ON journal_type.journal_type_id = journal_entry.journal_type_id
JOIN accounting.statement_section
ON statement_section.statement_section_id = account.profit_loss_section_id
WHERE (journal_entry.company_id = 1) AND (statement_section IN ("Revenue", "Other Income")) AND (YEAR(entry_date) = @year)
GROUP BY 1)

UNION

# Second part of table for the total
(SELECT "Total Profit",ROUND(sum(debit),2) FROM accounting.journal_entry
JOIN accounting.journal_entry_line_item
ON journal_entry.journal_entry_id = journal_entry_line_item.journal_entry_id
JOIN accounting.account
ON account.account_id = journal_entry_line_item.account_id
JOIN accounting.journal_type
ON journal_type.journal_type_id = journal_entry.journal_type_id
JOIN accounting.statement_section
ON statement_section.statement_section_id = account.profit_loss_section_id
WHERE (journal_entry.company_id = 1) AND (statement_section IN ("Revenue", "Other Income")) AND (YEAR(entry_date) = @year)
);


# Table for all losses

# First part for all particulars
(SELECT statement_section AS Particulars,ROUND(sum(credit),2) AS Amount
FROM accounting.journal_entry
JOIN accounting.journal_entry_line_item
ON journal_entry.journal_entry_id = journal_entry_line_item.journal_entry_id
JOIN accounting.account
ON account.account_id = journal_entry_line_item.account_id
JOIN accounting.journal_type
ON journal_type.journal_type_id = journal_entry.journal_type_id
JOIN accounting.statement_section
ON statement_section.statement_section_id = account.profit_loss_section_id
WHERE (journal_entry.company_id = 1) AND (statement_section IN ("COST OF GOODS AND SERVICES", "SELLING EXPENSES", "OTHER EXPENSES")) AND (YEAR(entry_date) = @year)
GROUP BY 1)

UNION

# Second part for the total of all losses
((SELECT "Total Expenses", ROUND(sum(credit),2)
FROM accounting.journal_entry
JOIN accounting.journal_entry_line_item
ON journal_entry.journal_entry_id = journal_entry_line_item.journal_entry_id
JOIN accounting.account
ON account.account_id = journal_entry_line_item.account_id
JOIN accounting.journal_type
ON journal_type.journal_type_id = journal_entry.journal_type_id
JOIN accounting.statement_section
ON statement_section.statement_section_id = account.profit_loss_section_id
WHERE (journal_entry.company_id = 1) AND (statement_section IN ("COST OF GOODS AND SERVICES", "SELLING EXPENSES", "OTHER EXPENSES") AND (YEAR(entry_date) = @year))));



# Table for Net profit/loss

# Table t1 for profits
WITH t1 AS
(SELECT "Profit/Loss",ROUND(sum(debit),2) AS Amount
FROM accounting.journal_entry
JOIN accounting.journal_entry_line_item
ON journal_entry.journal_entry_id = journal_entry_line_item.journal_entry_id
JOIN accounting.account
ON account.account_id = journal_entry_line_item.account_id
JOIN accounting.journal_type
ON journal_type.journal_type_id = journal_entry.journal_type_id
JOIN accounting.statement_section
ON statement_section.statement_section_id = account.profit_loss_section_id
WHERE (journal_entry.company_id = 1) AND (statement_section IN ("Revenue", "Other Income")) AND (YEAR(entry_date) = @year)), 

# table t2 for losses
t2 AS
(SELECT "Total Expenses", ROUND(sum(credit),2) AS Amount
FROM accounting.journal_entry
JOIN accounting.journal_entry_line_item
ON journal_entry.journal_entry_id = journal_entry_line_item.journal_entry_id
JOIN accounting.account
ON account.account_id = journal_entry_line_item.account_id
JOIN accounting.journal_type
ON journal_type.journal_type_id = journal_entry.journal_type_id
JOIN accounting.statement_section
ON statement_section.statement_section_id = account.profit_loss_section_id
WHERE (journal_entry.company_id = 1) AND (statement_section IN ("COST OF GOODS AND SERVICES", "SELLING EXPENSES", "OTHER EXPENSES")) AND (YEAR(entry_date) = @year))

# Union of all losses, gains and net profit
(SELECT *
FROM t1)
UNION 
(SELECT *
FROM t2)
UNION
(SELECT "NET PROFIT/LOSS", ROUND((SELECT Amount FROM t1) - (SELECT Amount FROM t2),2)
FROM t1);

