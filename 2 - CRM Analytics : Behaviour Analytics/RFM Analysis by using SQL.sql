
-- Customer Segmentation with RFM from Online Retail 2010_2011 dataset by using MSSQL (Azure Data Studio)
-- 541.910 observations, 8 different variables (Invoice, StockCode, Description, Quantity, InvoiceDate, Price, Customer_ID, Country)

/*
###############################################################
# TASK 1: Data Understanding and Preparation
###############################################################
#In the dataset:
    # a. The first 10 observations,
    # b. Variable names,
    # c. Descriptive statistics,
    # d. Null values,
    # e. Variable types, review.
*/

-- a. The first 10 observations

SELECT TOP 10 * FROM onlineretaildb.dbo.retail_2010_2011

SELECT * FROM onlineretaildb.INFORMATION_SCHEMA.COLUMNS

-- b. Variable names

SELECT COLUMN_NAME AS DEGISKEN_ISIMLERI
FROM onlineretaildb.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'retail_2010_2011'

--c. Descriptive statistics

SELECT COUNT(*) AS SATIR_SAYISI , 
       (SELECT COUNT(COLUMN_NAME) AS DEGISKEN_ISIMLERI
    FROM onlineretaildb.INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'retail_2010_2011') AS KOLON_SAYISI
FROM onlineretaildb.dbo.retail_2010_2011 

-- d. Null values,

--SELECT * FROM onlineretaildb.dbo.retail_2010_2011 WHERE column_name IS NULL;
SELECT * FROM onlineretaildb.dbo.retail_2010_2011 WHERE Invoice IS NULL;
SELECT * FROM onlineretaildb.dbo.retail_2010_2011 WHERE StockCode IS NULL;
SELECT * FROM onlineretaildb.dbo.retail_2010_2011 WHERE [Description] IS NULL; -- There are NULL values in [Description] columns 
SELECT * FROM onlineretaildb.dbo.retail_2010_2011 WHERE Quantity IS NULL;
SELECT * FROM onlineretaildb.dbo.retail_2010_2011 WHERE InvoiceDate IS NULL;
SELECT * FROM onlineretaildb.dbo.retail_2010_2011 WHERE Price IS NULL;
SELECT * FROM onlineretaildb.dbo.retail_2010_2011 WHERE Customer_ID IS NULL;  -- There are NULL values in Customer_ID columns 
SELECT * FROM onlineretaildb.dbo.retail_2010_2011 WHERE Country IS NULL;

-- e. Variable types, review.

SELECT COLUMN_NAME, DATA_TYPE 
FROM onlineretaildb.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'retail_2010_2011'

-- e1. Working on restricted databases (Creating new tables in different databases to be able to make CRUD operations)

SELECT * 
INTO RetailBK
FROM onlineretaildb.dbo.retail_2010_2011

SELECT * FROM RetailBK  -- New Retail Table is created in  unrestricted different database
  
-- 3. Create new variables for each customer's total purchases and spending.
-- See the breakdown of the number of customers, average number of products purchased, and average spending across shopping channels.
-- Rank the top 10 customers with the highest revenue.
-- List the top 10 customers with the most orders.

SELECT COUNT(DISTINCT (Customer_ID)) AS toplam_musteri_sayisi FROM RetailBK -- total number of customers

SELECT Customer_ID, COUNT(DISTINCT (Invoice)) AS alisveris_sayisi FROM RetailBK GROUP BY Customer_ID -- number of purchasing

ALTER TABLE RetailBK ADD Revenue AS (Quantity * Price);  -- new column added as revenue

SELECT TOP 10 Customer_ID, Revenue FROM RetailBK ORDER BY Revenue DESC -- top 10 customers with the highest revenue.

SELECT TOP 10 Customer_ID, COUNT(DISTINCT (Invoice)) AS alisveris_sayisi FROM RetailBK
GROUP BY Customer_ID ORDER BY alisveris_sayisi DESC   --  top 10 customers with the most orders.

SELECT TOP 10 * FROM RetailBK   -- check

/*
###############################################################
# TASK 2: Calculating RFM Metrics
###############################################################
*/
-- TODAY'S DATE SET AS 01.01.2012

SELECT 
    Customer_ID,
    DATEDIFF(DAY,MIN(InvoiceDate),'20120101') AS TENURE,
    DATEDIFF(DAY,MAX(InvoiceDate),'20120101') AS RECENCY,
    COUNT(DISTINCT(Invoice)) AS FREQUENCY,
    SUM(Revenue) AS MONETARY,
    NULL RECENCY_SCORE,
    NULL FREQUENCY_SCORE,
    NULL MONETARY_SCORE
INTO RetailBK_RFM
FROM RetailBK
GROUP BY Customer_ID

SELECT * FROM RetailBK_RFM   --- RFM Metriklerini içerecek olan yeni tablo oluşturuldu

ALTER TABLE RetailBK_RFM ADD BASKET_SIZE AS ( MONETARY / FREQUENCY ) -- Müşteri bazlı basket size değerleri tabloya eklenildi.

-- Recency, Frequency ve Monetary değerlerinin incelenmesi

SELECT * FROM RetailBK_RFM

/*
###############################################################
# TASK 3: Calculating RF and RFM Scores
###############################################################
#  Converting Recency, Frequency, and Monetary metrics to scores between 1-5
#  recording these scores as recency_score, frequency_score, and monetary_score
*/

-- Expressing and Creating RECENCY_SCORE 

UPDATE RetailBK_RFM SET RECENCY_SCORE = 
(SELECT SCORE FROM
        (SELECT A.*,
        NTILE(5) OVER(ORDER BY RECENCY DESC) AS SCORE
        FROM RetailBK_RFM AS A ) T 
WHERE T.Customer_ID = RetailBK_RFM.Customer_ID
);

SELECT * FROM RetailBK_RFM -- CHECK

-- Expressing and Creating FREQUENCY_SCORE 

UPDATE RetailBK_RFM SET FREQUENCY_SCORE = 
(SELECT SCORE FROM
        (SELECT A.*,
        NTILE(5) OVER(ORDER BY FREQUENCY DESC) AS SCORE
        FROM RetailBK_RFM AS A ) T 
WHERE T.Customer_ID = RetailBK_RFM.Customer_ID
);

SELECT * FROM RetailBK_RFM -- CHECK

-- Expressing and Creating MONETARY_SCORE 

UPDATE RetailBK_RFM SET MONETARY_SCORE = 
(SELECT SCORE FROM
        (SELECT A.*,
        NTILE(5) OVER(ORDER BY MONETARY DESC) AS SCORE
        FROM RetailBK_RFM AS A ) T 
WHERE T.Customer_ID = RetailBK_RFM.Customer_ID
);

SELECT * FROM RetailBK_RFM -- CHECK

-- ###### RF_SCORE and RFM_SCORE Creation ###### --

-- #  Expressing RECENCY_SCORE and FREQUENCY_SCORE as a single variable and saving it as RF_SCORE

ALTER TABLE RetailBK_RFM ADD RF_SCORE AS (CONVERT(VARCHAR,RECENCY_SCORE) + CONVERT(VARCHAR,FREQUENCY_SCORE));

SELECT * FROM RetailBK_RFM

-- # RECENCY_SCORE ve FREQUENCY_SCORE ve MONETARY_SCORE'u tek bir değişken olarak ifade edilmesi ve RFM_SCORE olarak kaydedilmesi

ALTER TABLE RetailBK_RFM ADD RFM_SCORE AS (CONVERT(VARCHAR,RECENCY_SCORE) + CONVERT(VARCHAR,FREQUENCY_SCORE) + CONVERT(VARCHAR, MONETARY_SCORE));


-- CHECK

SELECT * FROM RetailBK_RFM


###############################################################
# TASK 4: Segment Definition of RF Scores
###############################################################

-- # Segment definition, and converting RF_SCORE so that the generated RFM scores can be explained more clearly

--Creating a new column as SEGMENT 

ALTER TABLE RetailBK_RFM ADD SEGMENT VARCHAR(50);

SELECT * FROM RetailBK_RFM

-- Creating Hibernating Class

UPDATE RetailBK_RFM SET SEGMENT ='hibernating'
WHERE RECENCY_SCORE LIKE '[1-2]%' AND FREQUENCY_SCORE LIKE '[1-2]%'

SELECT * FROM RetailBK_RFM

-- Creating  at Risk Class

UPDATE RetailBK_RFM SET SEGMENT ='at_Risk'
WHERE RECENCY_SCORE LIKE '[1-2]%' AND FREQUENCY_SCORE LIKE '[3-4]%'

-- Creating  Can't Loose Class

UPDATE RetailBK_RFM SET SEGMENT ='cant_loose'
WHERE RECENCY_SCORE LIKE '[1-2]%' AND FREQUENCY_SCORE LIKE '[5]%'

-- Creating  About to Sleep Class

UPDATE RetailBK_RFM SET SEGMENT ='about_to_sleep'
WHERE RECENCY_SCORE LIKE '[3]%' AND FREQUENCY_SCORE LIKE '[1-2]%'

-- Creating  Need Attention Class

UPDATE RetailBK_RFM SET SEGMENT ='need_attention'
WHERE RECENCY_SCORE LIKE '[3]%' AND FREQUENCY_SCORE LIKE '[3]%'

-- Creating  Loyal Customers Class

UPDATE RetailBK_RFM SET SEGMENT ='loyal_customers'
WHERE RECENCY_SCORE LIKE '[3-4]%' AND FREQUENCY_SCORE LIKE '[4-5]%'

-- Creating Promising Class

UPDATE RetailBK_RFM SET SEGMENT ='promising'
WHERE RECENCY_SCORE LIKE '[4]%' AND FREQUENCY_SCORE LIKE '[1]%'

-- Creating  New Customers Class

UPDATE RetailBK_RFM SET SEGMENT ='new_customers'
WHERE RECENCY_SCORE LIKE '[5]%' AND FREQUENCY_SCORE LIKE '[1]%'

-- Creating  Potential Loyalist Class

UPDATE RetailBK_RFM SET SEGMENT ='potential_loyalists'
WHERE RECENCY_SCORE LIKE '[4-5]%' AND FREQUENCY_SCORE LIKE '[2-3]%'

-- Creating  Champions Class

UPDATE RetailBK_RFM SET SEGMENT ='champions'
WHERE RECENCY_SCORE LIKE '[5]%' AND FREQUENCY_SCORE LIKE '[4-5]%'

SELECT Customer_ID, RFM_SCORE, SEGMENT FROM RetailBK_RFM;

/*
###############################################################
# Action Time :)
###############################################################
Examine the recency, frequency, and monetary averages of the segments.
*/
SELECT SEGMENT,
    COUNT(RECENCY) AS COUNT_RECENCY,
    AVG(RECENCY) AS AVG_RECENCY,
   -- COUNT(FREQUENCY) AS COUNT_FREQUENCY,
    ROUND(AVG(FREQUENCY),3) AS AVG_FREQUENCY,
    --COUNT(MONETARY) AS COUNT_MONETARY,
    ROUND(AVG(MONETARY),3) AS AVG_MONETARY
FROM RetailBK_RFM
GROUP BY SEGMENT

