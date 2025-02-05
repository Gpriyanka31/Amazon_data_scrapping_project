# Selecting Database - 
USE amazon_scraped_data;

# Selecting the data from the table - 
SELECT * FROM products ; 

# Counting the number of rows - 
SELECT COUNT(*) As number_of_rows FROM products ; 

-- --------------------------------------------------------------------------------------------

# Adding a new column extracted_rating (out of rating) and changing its data type to float - 
-- First, keep the VARCHAR column
ALTER TABLE products
ADD COLUMN extracted_rating VARCHAR(10);

-- Disable safe updates
SET SQL_SAFE_UPDATES = 0;

-- Extract the number more safely
UPDATE products
SET extracted_rating = NULLIF(TRIM(REGEXP_REPLACE(
    SUBSTRING_INDEX(rating, ' ', 1),
    '[^0-9.]', ''  -- Remove any non-numeric characters except decimal point
)), '');

-- Now convert to FLOAT
ALTER TABLE products
MODIFY COLUMN extracted_rating FLOAT;

-- ------------------------------------------------------------------------------

# Adding a new column extracted_discount_% (out of discount_percentage) and changing its data type to float - 
-- First, add the new column
ALTER TABLE products
ADD COLUMN extracted_discount_percentage VARCHAR(10);

UPDATE products
SET extracted_discount_percentage = 
    CASE
        WHEN discount_percentage = 'No Discount' THEN NULL
        ELSE REGEXP_REPLACE(SUBSTRING_INDEX(discount_percentage, '%', 1), '[^0-9.]', '')
    END;
    
ALTER TABLE products
MODIFY COLUMN extracted_discount_percentage FLOAT;

-- -----------------------------------------------------------------------------------
 # creating a new column brand from the product_name - 
 
 ALTER TABLE products
ADD COLUMN brand VARCHAR(100);

UPDATE products
SET brand = 
    CASE
        WHEN SUBSTRING_INDEX(product_name, ' ', 1) = '(Refurbished)' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(product_name, ' ', 2), ' ', -1)
        ELSE SUBSTRING_INDEX(product_name, ' ', 1)
    END;


-- Displaying the data - 
SELECT * FROM products ;



