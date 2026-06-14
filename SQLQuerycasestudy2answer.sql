SELECT * 
FROM sys.schemas
WHERE name = 'data_bank';
use loke;
select * from data_bank.regions;
select * from data_bank.customer_nodes;
select * from data_bank.customer_transactions;
select count(*) from data_bank.customer_transactions;
select count(*) from data_bank.customer_nodes;
--1 answer
select count(distinct node_id) as unique_nodes from data_bank.customer_nodes;
--2answer
select r.region_name,count(distinct s.node_id) as nodes_count from data_bank.customer_nodes s join data_bank.regions r on r.region_id=s.region_id group by r.region_name;
--3 answer
select r.region_name,count(distinct customer_id) as total_customer_eachregion from data_bank.customer_nodes s join data_bank.regions r on  r.region_id=s.region_id group by r.region_name;
--4answer
select avg(datediff(day,start_date,end_date)) as average_day from data_bank.customer_nodes where end_date < > '9999-12-31';
--5answer
select distinct r.region_name,percentile_cont(0.5) within group(order by datediff(day,start_date,end_date)) over(partition by r.region_name) as median,
PERCENTILE_CONT(0.8) within group(order by datediff(day,start_date,end_date)) over(partition by r.region_name) as p80percentile,
percentile_cont(0.95) within group(order by datediff(day,start_date,end_date)) over(partition by r.region_name) as p95percentile from data_bank.customer_nodes s join data_bank.regions r on r.region_id=s.region_id where end_date <> '9999-12-31';
--b.customer transaction
--1 answer
select txn_type,count(txn_amount) as txn_count,sum(txn_amount) as totalamount from data_bank.customer_transactions group by txn_type;
--2 answer
WITH deposits AS
(
    SELECT
        customer_id,
        COUNT(*) AS deposit_count,
        SUM(txn_amount) AS deposit_amount
    FROM data_bank.customer_transactions
    WHERE txn_type = 'deposit'
    GROUP BY customer_id
)
SELECT
    AVG(deposit_count * 1.0) AS avg_deposit_count,
    AVG(deposit_amount * 1.0) AS avg_deposit_amount
FROM deposits;
--3 answer
WITH monthly_txn AS
(
    SELECT
        customer_id,
        MONTH(txn_date) AS month_no,

        SUM(CASE
                WHEN txn_type='deposit'
                THEN 1 ELSE 0
            END) AS deposits,

        SUM(CASE
                WHEN txn_type IN ('purchase','withdrawal')
                THEN 1 ELSE 0
            END) AS other_txn
    FROM data_bank.customer_transactions
    GROUP BY
        customer_id,
        MONTH(txn_date)
)
SELECT
    month_no,
    COUNT(DISTINCT customer_id) AS customer_count
FROM monthly_txn
WHERE deposits > 1
  AND other_txn >= 1
GROUP BY month_no
ORDER BY month_no;