# Case Study - Basket Analysis for Retail Data

Source: [Online Retail II  Dataset](https://archive.ics.uci.edu/dataset/502/online+retail+ii)

The Online Retail dataset contains sales data from a UK-based online store between December 1, 2009 and December 9, 2011 and that includes information on invoices, stock codes, product descriptions, quantities, prices, customer IDs, countries, and invoice dates.

- Period: 2010 - 2011 

- Data Size: 531.283 Rows

- Business case: Business case: Perform a market basket analysis for the product "JAM MAKING SET WITH JARS" and suggest at least 3 products to bundle with it.

![image](https://github.com/BedirK/Customer-Analytics/assets/103532330/eaaf524b-6b20-4551-bc1b-5e3e2bfe4bda)

By analyzing this data set, I performed a market basket analysis to uncover patterns and associations between items purchased to gain insight into customers' purchasing behavior and intentions.

## Steps

- Step 1: PIVOT Table for Invoice vs Count of Invoice *-->turns-->* Basket vs Number of Products
  
 ![image](https://github.com/BedirK/Customer-Analytics/assets/103532330/d4f9b405-08ab-4672-8faf-2ad16afbd480)
 

 - Step 2: PIVOT Table for Description vs Count of Invoice *-->turns-->* Product Description vs How many times products bought?
   
 - Step 3: Calculation of Support Values for each products by using (How many times products bought? / Total Basket Size)
   
   
 ![image](https://github.com/BedirK/Customer-Analytics/assets/103532330/0261c128-fdc8-4d1d-ba26-14a31400f32b)
 
 - Step 4: Specify Target Baskets that contain "JAM MAKING SET WITH JARS" product with others

   ![image](https://github.com/BedirK/Customer-Analytics/assets/103532330/c55f1682-a1c6-4c22-b3a1-8a33dd398fb7)

   
 ![image](https://github.com/BedirK/Customer-Analytics/assets/103532330/5f2507f5-46e9-47d8-b81e-38ec417453e0)

 - Step 5: PIVOT Table from Target Basket table to obtain specific list with Invoice vs Count of Invoice

   ![image](https://github.com/BedirK/Customer-Analytics/assets/103532330/92582145-3f19-46ed-8c1f-3959c9c0e8b5)

 - Step 6: Calculate Confindence, Support and Lift Values for products in the target basket
 - Values for "JAM MAKING SET WITH JARS" product

   Confidence : 1142 / 1142 = 100%
   
   Support : 1142 / 20.725 = 6%
   
   Lift : Confidence / Support = 18

  ![image](https://github.com/BedirK/Customer-Analytics/assets/103532330/8555bc03-b77f-454c-aa14-df99e9a2dbb1)

 - FINAL STEP: By calculating case for "Support >= 4% & Lift >= 5" from our list, we can find related products that can be sold together with "JAM MAKING SET WITH JARS". These ratios can be changed on our sensitivity interval.
   
   ![image](https://github.com/BedirK/Customer-Analytics/assets/103532330/2d90960a-9bfe-44e7-8f44-16e7fb8e0f33)


## Conclusion 

With this basket analysis, we found products that are more likely to be sold together with the product "JAM MAKING SET WITH JARS" and we can prepare a campaign to sell these products together.

