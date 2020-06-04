DROP TABLE IF EXISTS users;
CREATE TABLE users(
	created_at VARCHAR(50),
    updated_at VARCHAR(50)
);

INSERT INTO users ( created_at, updated_at)
VALUES ('2.06.2020 17:30', '3.06.2020 18:00');

ALTER TABLE users MODIFY created_at DATETIME;
ALTER TABLE users MODIFY updated_at DATETIME;

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products(
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	products_name VARCHAR(55),
    `value` INT
);	

SELECT `value`,
	IF (`value` != 0,
		ORDER BY `value`,
		SELECT `value`)
FROM storehouses_products;

SELECT * FROM users WHERE mounth LIKE 'may' AND 'august';

SELECT AVG(*) FROM users;


	







 
    
	







