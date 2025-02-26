--- Using Profiler in Data\ ETL testing
--1. Check the First_name in the column
SELECT
    COUNT(*) AS total_row_count,
    COUNT(distinct(ptnt_1st_name) as unique_first_name,
    COUNT(case when ptnt_1st_name is null then 1 end) as Null_value_count_in_FirstName,
    COUNT(case when ptnt_1st_name = '' then 1 end) as Empty_value_count_in_FirstName,
    MAX(LENGTH(ptnt_1st_name)) as Max_firstname_length,
    MIN(LENGTH(ptnt_1st_name)) as Min_firstname_length,
    AVG(LENGTH(ptnt_1st_name)) as Average_firstname_length,
    COUNT(case when ptnt_1st_name like ' %' or ptnt_1st_name like '% ' then 1 end) as leading_or_trailing_white_space
FROM ptnt.ptnt;


--2. Patient_id in the column
SELECT
    COUNT(*) AS total_row_count,
    COUNT(distinct ptnt_id) as Unique_patient_id_count,
    COUNT(case when ptnt_id is null then 1 end) as  Null_value_count_in_patient_id,
    COUNT(case when ptnt_id = 0 then 1 end) as Empty_value_count_in_patient_id,
    MAX(ptnt_id) as Max_Patient_id,
    MIN(ptnt_id) as Min_Patient_id
FROM ptnt.ptnt;

--3. Patient transferred or not transferred ( Checking boolean value )
SELECT
    COUNT(*) AS total_rows,
    COUNT(ptnt_transfered) as non_null_count,
    COUNT(case when ptnt_transfered is null then 1 end) as  Null_value_count_in_transfer_column,
    COUNT(case when ptnt_transfered = true then 1 end) as True_count,
    COUNT(case when ptnt_transfered = false then 1 end) as False_count
FROM ptnt.ptnt;

--4. Transferred date validation
SELECT
    COUNT(*) AS total_rows
    COUNT(transfer_date) as not_null_count
    COUNT(CASE WHEN transfer_date IS NULL THEN 1 END) AS  Null_in_transfer_date,
    MIN(transfer_date) AS First_transfer_date,
    MAX(transfer_date) AS Most_recent_transfer_date,
    COUNT(DISTINCT(transfer_date) AS unique_date_count
FROM ptnt.ptnt;

--6. Calculate the average salary within the department
SELECT
    ptnt_id,
    Age,
    treatment,
    amount,
    AVG(amount) OVER
        (PARTITION by department) as Average_payment_by_treatment
FROM ptnt.demographic ;

--# Use of RANK function

SELECT
    ptnt_id,
    Age,
    treatment,
    amount,
    RANK() OVER
        (PARTITION by department prder by amount DESC) as Rank_by_payment
FROM ptnt.demographic ;

--
===============================================================