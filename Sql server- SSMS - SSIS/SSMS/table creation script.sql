CREATE DATABASE financial_transactions_db;
use financial_transactions_db;

--create insert values into financial_transactions_db.financial_transactions
CREATE TABLE financial_transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    supplier_name VARCHAR(50),
    transaction_date DATE,
    amount DECIMAL(10, 2),
    currency VARCHAR(10)
);

--insert values 
DECLARE @counter INT = 1;

WHILE @counter <= 1000000
BEGIN
    INSERT INTO financial_transactions (transaction_id, customer_id, supplier_name, transaction_date, amount, currency)
    VALUES
        (@counter, (101 + (@counter % 1000)), 
         CASE 
            WHEN @counter % 3 = 0 THEN 'ABC Corp'
            WHEN @counter % 3 = 1 THEN 'XYZ Ltd'
            ELSE 'Global Inc'
         END,
         DATEADD(DAY, @counter % 365, '2024-01-01'),
         ROUND(RAND() * 10000, 2),
         CASE 
            WHEN @counter % 4 = 0 THEN 'USD'
            WHEN @counter % 4 = 1 THEN 'EUR'
            ELSE 'GBP'
         END);
    SET @counter = @counter + 1;
END;
--select * from financial_transactions;

--create insert values into financial_transactions_db.customer_details

CREATE TABLE customer_details (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20)
);

--insert
DECLARE @customer_id INT = 101;

WHILE @customer_id <= 1100
BEGIN
    INSERT INTO customer_details (customer_id, customer_name, email, phone)
    VALUES
        (@customer_id, CONCAT('Customer ', @customer_id), CONCAT('customer', @customer_id, '@example.com'), 
        CONCAT('123-456-', RIGHT('0000' + CAST(@customer_id AS VARCHAR(4)), 4)));
    SET @customer_id = @customer_id + 1;
END;

--select * from dbo.customer_details;
select f.*,c.customer_name,c.email,c.phone 
from dbo.financial_transactions f join dbo.customer_details c on f.customer_id=c.customer_id ;


CREATE TABLE financial_analysis (
    transaction_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    supplier_name VARCHAR(50),
    transaction_date DATE,
    amount_usd DECIMAL(10, 2),
    supplier_phone VARCHAR(20)
);

drop table financial_analysis

------------------------------------------------------------------
--create data warehouse DB
CREATE DATABASE financial_data_warehouse;
use financial_data_warehouse;

--create financial_data_warehouse.exchange_rates
CREATE TABLE dbo.exchange_rates (
    from_currency VARCHAR(4),
    to_currency VARCHAR(4),
    exchange_rate DECIMAL(10, 4),
    effective_date DATE
);

/*
alter table dbo.financial_transactions
add [customer_name] [varchar](50) NULL,
	[email] [varchar](100) NULL,
	[phone] [varchar](20) NULL

alter table dbo.financial_transactions
drop column [customer_name] ,[email],[phone]

truncate table dbo.financial_transactions
*/

select * from financial_transactions;

--create financial_data_warehouse.suppliers
CREATE TABLE suppliers (
    supplier_id INT,
    supplier_name VARCHAR(30),
    contact_name VARCHAR(30),
    phone VARCHAR(14)
	);



