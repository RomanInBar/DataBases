
-------------------------------------------- Транзакции, переменные, представления --------------------------------------------  


/*В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. 
Используйте транзакции:*/

start transaction;
insert into sample.users
(select * from shop.users where id=1);
commit;

/*Создайте представление, которое выводит название name товарной позиции из таблицы products 
и соответствующее название каталога name из таблицы catalogs:*/
					

create or replace view `any_view` as 
select products.name, catalogs.name
from products, catalogs
where products.id = catalogs.products_id;

select * from `any_view`;



-------------------------------------------- Хранимые процедуры и функции, триггеры --------------------------------------------



/*Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток.
С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день",
с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".*/

drop function if exists hello;
delimiter //
create function hello()
begin
	case
		when current_time() between '6:00' and '12:00' then
		select 'Доброе утро';
		when current_time() between '12:00' and '18:00' then 
		select 'Добрый день';
		when current_time() between '18:00' and '00:00' then 
		select 'Добрый вечер';
		when current_time() between '00:00' and '6:00' then 
		select 'Доброй ночи';
	end case;
end//

delimiter ;
call hello();

/*В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
При попытке присвоить полям NULL-значение необходимо отменить операцию.*/

drop trigger if exists `not_null`;
delimiter //
create trigger `not_null` before insert on `product`
for each row
begin
	if new.name = null then 
		set new.name = 'no value';
	end if;
	if new.description = null then
		set new.description = 'no value';
	end if;
	if new.name = null and new description = null then 
		signal sqlstate '45000' set message_text = "Can't be without values";
	end if;
end //
delimiter ;

/*(по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. 
Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел. 
Вызов функции FIBONACCI(10) должен возвращать число 55.*/

drop database if exists fibonacci;
create database fibonacci;
use fibonacci



delimiter //
create function Fibonacci(n int)
returns int not deterministic 
begin
	declare i int default 0;
	declare fib1 int default 1;
	declare fib2 int default 1;
	declare fib_sum int;
	while i < (n - 2) do 
		 set fib_sum = (fib1 + fib2); 
		 set fib1 = fib2;
		 set fib2 = fib_sum; 
		 set i = (i + 1);
	end while;
	return (fib2);
end
delimiter ;

select Fibonacci(10);



-------------------------------------------- Администрирование MySQL: -------------------------------------------- 



/*Создайте двух пользователей которые имеют доступ к базе данных shop. 
Первому пользователю shop_read должны быть доступны только запросы на чтение данных, 
второму пользователю shop — любые операции в пределах базы данных shop.*/


grant select on shop.* to 'shop_read'@'localhost' identified with user_1 by 'password_1';
grant all on shop.* to 'shop'@'localhost' identified with admin by 'admin';


/*Пусть имеется таблица accounts содержащая три столбца id, name, password, содержащие первичный ключ, имя пользователя и его пароль. 
Создайте представление username таблицы accounts, предоставляющий доступ к столбца id и name. 
Создайте пользователя user_read, который бы не имел доступа к таблице accounts, однако, мог бы извлекать записи из представления username.*/

drop database if exists users;
create database users;
use users;

drop table if exists accounts;
create table accounts(
	id SERIAL primary key,
	name varchar(45) not null,
	`password` varchar(55) unique not null 
);

create or replace view username as
select id, name 
from accounts;

grant usage, select on users.username to 'user'@'localhost' identified with username by 'password_1';





