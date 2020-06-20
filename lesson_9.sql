
-------------------------------------------- ����������, ����������, ������������� --------------------------------------------  


/*� ���� ������ shop � sample ������������ ���� � �� �� �������, ������� ���� ������. 
����������� ������ id = 1 �� ������� shop.users � ������� sample.users. 
����������� ����������:*/

start transaction;
insert into sample.users
(select * from shop.users where id=1);
commit;

/*�������� �������������, ������� ������� �������� name �������� ������� �� ������� products 
� ��������������� �������� �������� name �� ������� catalogs:*/
					

create or replace view `any_view` as 
select products.name, catalogs.name
from products, catalogs
where products.id = catalogs.products_id;

select * from `any_view`;



-------------------------------------------- �������� ��������� � �������, �������� --------------------------------------------



/*�������� �������� ������� hello(), ������� ����� ���������� �����������, � ����������� �� �������� ������� �����.
� 6:00 �� 12:00 ������� ������ ���������� ����� "������ ����", � 12:00 �� 18:00 ������� ������ ���������� ����� "������ ����",
� 18:00 �� 00:00 � "������ �����", � 00:00 �� 6:00 � "������ ����".*/

drop function if exists hello;
delimiter //
create function hello()
begin
	case
		when current_time() between '6:00' and '12:00' then
		select '������ ����';
		when current_time() between '12:00' and '18:00' then 
		select '������ ����';
		when current_time() between '18:00' and '00:00' then 
		select '������ �����';
		when current_time() between '00:00' and '6:00' then 
		select '������ ����';
	end case;
end//

delimiter ;
call hello();

/*� ������� products ���� ��� ��������� ����: name � ��������� ������ � description � ��� ���������. 
��������� ����������� ����� ����� ��� ���� �� ���. ��������, ����� ��� ���� ��������� �������������� �������� NULL �����������. 
��������� ��������, ��������� ����, ����� ���� �� ���� ����� ��� ��� ���� ���� ���������. 
��� ������� ��������� ����� NULL-�������� ���������� �������� ��������.*/

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

/*(�� �������) �������� �������� ������� ��� ���������� ������������� ����� ���������. 
������� ��������� ���������� ������������������ � ������� ����� ����� ����� ���� ���������� �����. 
����� ������� FIBONACCI(10) ������ ���������� ����� 55.*/

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



-------------------------------------------- ����������������� MySQL: -------------------------------------------- 



/*�������� ���� ������������� ������� ����� ������ � ���� ������ shop. 
������� ������������ shop_read ������ ���� �������� ������ ������� �� ������ ������, 
������� ������������ shop � ����� �������� � �������� ���� ������ shop.*/


grant select on shop.* to 'shop_read'@'localhost' identified with user_1 by 'password_1';
grant all on shop.* to 'shop'@'localhost' identified with admin by 'admin';


/*����� ������� ������� accounts ���������� ��� ������� id, name, password, ���������� ��������� ����, ��� ������������ � ��� ������. 
�������� ������������� username ������� accounts, ��������������� ������ � ������� id � name. 
�������� ������������ user_read, ������� �� �� ���� ������� � ������� accounts, ������, ��� �� ��������� ������ �� ������������� username.*/

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





