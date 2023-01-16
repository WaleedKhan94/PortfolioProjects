WITH temp1 AS (
SELECT primary_poc, LEFT(primary_poc, STRPOS(primary_poc, ' ')) AS firstname, RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) AS lastname, 
REPLACE(name, ' ', '' ) company_name
FROM accounts)

SELECT primary_poc, CONCAT(firstname, '.', lastname, '@', company_name, '.com') email,(LEFT(LOWER(firstname), 1) || RIGHT(LOWER(firstname), 2) || LEFT(LOWER(lastname),1) ||
RIGHT(LOWER(lastname), 1) || LENGTH(firstname) || LENGTH(lastname) || UPPER(company_name)) pass   FROM temp1