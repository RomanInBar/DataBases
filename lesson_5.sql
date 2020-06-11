

-- Task_2

select * from products
union
select * from catalogs
on id_products = id_catalogs;*/


-- Task_3

drop database if exists passengers;
create database passengers;
use passengers;


drop table if exists flights;
create table flights(
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT unique,  
	`from` varchar(100),
	`to` varchar(100),
	primary key (id)
);

insert into flights (`from`, `to`)
	values 
	('moscow', 'omsk'),
	('novgorod', 'kazan'),
	('irkutsk', 'moscow'),
	('omsk', 'irkutsk'),
	('moscow', 'kazan');

drop table if exists cities;
create table cities(
	`label` varchar(55) unique, 
	`name` varchar(55) 
);

alter table passengers.cities convert to character set utf8
collate utf8_general_ci;

insert into cities
	values 
	('Moscow', 'Москва'),
	('Irkutsk', 'Иркутск'),
	('novgorod', 'Новгород'),
	('kazan', 'Казань'),
	('omsk', 'Омск');

select id, 
(select `name` from cities where `label` = `from`) as `from`,
(select `name` from cities where `label` = `to`) as `to`
from flights;