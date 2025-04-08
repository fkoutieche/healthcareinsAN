SELECT * FROM healthcare.insurance;

SHOW COLUMNS FROM healthcare.insurance;


### DATA CLEANING 
# Checking for missing values 

SELECT
    SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS age_null_count,
    SUM(CASE WHEN sex IS NULL THEN 1 ELSE 0 END) AS sex_null_count,
    SUM(CASE WHEN bmi IS NULL THEN 1 ELSE 0 END) AS bmi_null_count,
    SUM(CASE WHEN children IS NULL THEN 1 ELSE 0 END) AS children_null_count,
    SUM(CASE WHEN smoker IS NULL THEN 1 ELSE 0 END) AS smoker_null_count,
    SUM(CASE WHEN region IS NULL THEN 1 ELSE 0 END) AS region_null_count,
    SUM(CASE WHEN charges IS NULL THEN 1 ELSE 0 END) AS charges_null_count
FROM healthcare.insurance;

# No missing values on any columns, now let's check for data standartization

### DATA CLEANING 
# Checking for misspelings on 'sex', 'region', 'smoker' columns

SELECT DISTINCT sex AS unique_sex_values
FROM healthcare.insurance;

SELECT DISTINCT region AS unique_region_values
FROM healthcare.insurance;

SELECT DISTINCT smoker AS unique_smoker_values
FROM healthcare.insurance;

# Great, no misspelings accross the selected columns
#####--------------------------------------------------------#####

### DATA CLEANING 
# Checking for unusual values (values that are outside of company policies)

SELECT 
	MIN(age) AS min_age
FROM healthcare.insurance;

SELECT 
	MAX(age) AS max_age
FROM healthcare.insurance;


#### DATA ANALYSIS
# Total male and female clients

SELECT  
	SUM(CASE WHEN sex = "female" THEN 1 ELSE 0 END) AS total_female,
    SUM(CASE WHEN sex = "male" THEN 1 ELSE 0 END) AS total_male,
	ROUND(SUM(CASE WHEN sex = 'female' THEN 1 ELSE 0 END) * 100.0 / COUNT(sex), 2) AS female_percentage,
    ROUND(SUM(CASE WHEN sex = 'male' THEN 1 ELSE 0 END) * 100.0 / COUNT(sex), 2) AS male_percentage
FROM healthcare.insurance;

# Average BMI (all clients)

SELECT 
	AVG(bmi)
FROM healthcare.insurance;

# Average BMI for each gender

SELECT
	sex,
	AVG(bmi)
FROM healthcare.insurance
GROUP BY sex;

# Average Charges for each gender

SELECT
	sex,
	AVG(charges)
FROM healthcare.insurance
GROUP BY sex;

# Does Family Size affect the charges?

SELECT
	children, 
    AVG(charges)
FROM healthcare.insurance
GROUP BY children;

# PLOT THIS (there does not seem to be a correlation that indicates an increase in charges when the family size increases)

# CHARGES vs SMOKER: Is there a correlation in Charges and Smoker and Not Smoker clients?

SELECT 
	smoker,
    AVG(charges)
FROM healthcare.insurance
GROUP BY smoker;

# PLOT THIS (there is a significant correlation between charges of a smoker and not smoker)

# BMI vs CHARGES: 

SELECT bmi, charges
FROM healthcare.insurance;
## SCATTER PLOT

# Group by BMI segments and check for average CHARGES

SELECT 
    CASE 
        WHEN bmi < 18.5 THEN 'Underweight'
        WHEN bmi BETWEEN 18.5 AND 24.9 THEN 'Normal weight'
        WHEN bmi BETWEEN 25 AND 29.9 THEN 'Overweight'
        ELSE 'Obese'
    END AS bmi_category,
    CASE 
        WHEN bmi < 18.5 THEN 1
        WHEN bmi BETWEEN 18.5 AND 24.9 THEN 2
        WHEN bmi BETWEEN 25 AND 29.9 THEN 3
        ELSE 4
    END AS bmi_category_label,
    AVG(charges) AS avg_charges
FROM healthcare.insurance
GROUP BY bmi_category, bmi_category_label
ORDER BY bmi_category_label;

# PLOT THIS (BAR CHART)
# There is a correlation between the BMI and the Average Charge



# REGIONAL ANALYSIS
# CLIENTS PER REGION (total and percentage)

SELECT 
    region,
    COUNT(*) AS total_clients,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM healthcare.insurance), 2) AS percentage_clients
FROM healthcare.insurance
GROUP BY region
ORDER BY percentage_clients DESC;

# Average Charges by Region

SELECT 
	region,
    AVG(charges) AS avg_charges
FROM healthcare.insurance
GROUP BY region
ORDER BY avg_charges DESC;
	
# PLOT THIS:: Southeast is the region that has the highest average charges, but looking deepere into it 
# It also shows that it is the region with the largest OBESE clients population

# OBESE clients by region

WITH bmi_cat AS (
SELECT 
    CASE 
        WHEN bmi < 18.5 THEN 'Underweight'
        WHEN bmi BETWEEN 18.5 AND 24.9 THEN 'Normal weight'
        WHEN bmi BETWEEN 25 AND 29.9 THEN 'Overweight'
        ELSE 'Obese'
    END AS bmi_category,
    CASE 
        WHEN bmi < 18.5 THEN 1
        WHEN bmi BETWEEN 18.5 AND 24.9 THEN 2
        WHEN bmi BETWEEN 25 AND 29.9 THEN 3
        ELSE 4
    END AS bmi_category_label,
    COUNT(*) AS total_clients, region
FROM healthcare.insurance
GROUP BY region, bmi_category, bmi_category_label
ORDER BY bmi_category_label) 
SELECT 
	bmi_category, bmi_category_label,
    region, total_clients
FROM bmi_cat
WHERE bmi_category = 'Obese'
ORDER BY total_clients DESC;

# PLOT THIS (Bar Chart): Southeast is the region with the largest OBESE population, also the highest in AVG CHARGES
#####-----------

# OVERWEIGHT clients by region
 
 WITH bmi_cat AS (
SELECT 
    CASE 
        WHEN bmi < 18.5 THEN 'Underweight'
        WHEN bmi BETWEEN 18.5 AND 24.9 THEN 'Normal weight'
        WHEN bmi BETWEEN 25 AND 29.9 THEN 'Overweight'
        ELSE 'Obese'
    END AS bmi_category,
    CASE 
        WHEN bmi < 18.5 THEN 1
        WHEN bmi BETWEEN 18.5 AND 24.9 THEN 2
        WHEN bmi BETWEEN 25 AND 29.9 THEN 3
        ELSE 4
    END AS bmi_category_label,
    COUNT(*) AS total_clients, region
FROM healthcare.insurance
GROUP BY region, bmi_category, bmi_category_label
ORDER BY bmi_category_label) 
SELECT 
	bmi_category, bmi_category_label,
    region, total_clients
FROM bmi_cat
WHERE bmi_category = 'Overweight'
ORDER BY total_clients DESC;


# Total clients by Age Group

SELECT 
    CASE 
        WHEN age BETWEEN 0 AND 18 THEN '0-18'
        WHEN age BETWEEN 19 AND 35 THEN '19-35'
        WHEN age BETWEEN 36 AND 50 THEN '36-50'
        ELSE '51+'
    END AS age_group,
    COUNT(*) AS total_clients
FROM healthcare.insurance
GROUP BY age_group
ORDER BY total_clients DESC;

## PLOT THIS (Bar Chart)

# Average Charges by Age Group

SELECT 
    CASE 
        WHEN age BETWEEN 0 AND 18 THEN '0-18'
        WHEN age BETWEEN 19 AND 35 THEN '19-35'
        WHEN age BETWEEN 36 AND 50 THEN '36-50'
        ELSE '51+'
    END AS age_group,
    AVG(charges) AS avg_charges
FROM healthcare.insurance
GROUP BY age_group
ORDER BY age_group;

# PLOT THIS 

# BMI by Age Group

SELECT 
    CASE 
        WHEN age BETWEEN 0 AND 18 THEN '0-18'
        WHEN age BETWEEN 19 AND 35 THEN '19-35'
        WHEN age BETWEEN 36 AND 50 THEN '36-50'
        ELSE '51+'
    END AS age_group,
    AVG(bmi) AS avg_bmi
FROM healthcare.insurance
GROUP BY age_group
ORDER BY age_group;

# There does not seem to be a correlation that indicates that as age increases BMI will also increase



