/*
Задание выполнялось используя сервис https://sqlize.online/sql/oracle23/. Oracle 21 на этом ресурсе работал не стабильно, поэтому использовал Oracle 23.
*/

/*
1. Подготовьте DDL-скрипты создания объектов для приведённой модели: создание таблиц,
первичных, уникальных, внешних ключей и т.д.
2. Заполните таблицы примерами из скрипта, приведенного в конце этого документа.
3. Подготовьте скрипты заполнения таблиц тестовыми данными, достаточными для
выполнения заданий ниже.
*/

create table clients (
	ID NUMBER(10) PRIMARY KEY NOT NULL,
	NAME VARCHAR2(1000) NOT NULL,
	PLACE_OF_BIRTH VARCHAR2(1000) NOT NULL,
	DATE_OF_BIRTH DATE NOT NULL,
--	DATE_OF_BIRTH DATE NOT NULL CHECK (DATE_OF_BIRTH > '01-Jan-1900'),
	ADDRESS VARCHAR2(1000) NOT NULL,
	PASSPORT VARCHAR2(100) UNIQUE NOT NULL
--	CONSTRAINT clients_chk_DATE_OF_BIRTH CHECK (DATE_OF_BIRTH > '01-Jan-1900'),
	);
insert into clients values (1, 'Сидоров Иван Петрович', 'Россия, Московская облать, г. Пушкин',
to_date('01.01.2001','DD.MM.YYYY'), 'Россия, Московская облать, г. Пушкин, ул. Грибоедова, д. 5', '2222 555555, выдан
ОВД г. Пушкин, 10.01.2015');
insert into clients values (2, 'Иванов Петр Сидорович', 'Россия, Московская облать, г. Клин',
to_date('01.01.2001','DD.MM.YYYY'), 'Россия, Московская облать, г. Клин, ул. Мясникова, д. 3', '4444 666666, выдан ОВД г.
Клин, 10.01.2015');
insert into clients values (3, 'Петров Сиодр Иванович', 'Россия, Московская облать, г. Балашиха',
to_date('01.01.2001','DD.MM.YYYY'), 'Россия, Московская облать, г. Балашиха, ул. Пушкина, д. 7', '4444 666666, выдан ОВД
г. Клин, 10.01.2015');
insert into clients values (4, 'ХХХ ХХХ ХХХ', 'Россия, Московская облать, г. Балашиха',
to_date('01.01.2001','DD.MM.YYYY'), 'Россия, Московская облать, г. Балашиха, ул. Пушкина, д. 7', '4454 666666, выдан ОВД
г. Клин, 10.01.2015');
insert into clients values (5, 'Овечкин Александр Михайлович', 'Россия, Московская облать, г. Балашиха',
to_date('17.10.1985','DD.MM.YYYY'), 'Россия, Московская облать, г. Москва, ул. Хоккейная, д. 1', '1234 123456, выдан ОВД
г. Москва, 17.10.2011');

---------------------------------------------------------------------------------------------

create table tarifs (
	ID NUMBER(10) PRIMARY KEY NOT NULL,
	NAME VARCHAR2(100) NOT NULL,
	COST NUMBER(10,2)
	);

insert into tarifs values (1,'Тариф за выдачу кредита', 10);
insert into tarifs values (2,'Тариф за открытие счета', 10);
insert into tarifs values (3,'Тариф за обслуживание карты', 10);

---------------------------------------------------------------------------------------------

create table productype (
	ID NUMBER(10) PRIMARY KEY NOT NULL,
	NAME VARCHAR2(100) unique NOT NULL,
	BEGIN_DATE DATE NOT NULL,
	END_DATE DATE,
	TARIF_REF NUMBER(10) NOT NULL,
	CONSTRAINT END_DATE_CHECK CHECK (END_DATE >= BEGIN_DATE),
	FOREIGN KEY (TARIF_REF) REFERENCES tarifs (ID)
	);
/*
create or replace trigger aftinsttest
    after insert on productype
    for each row
begin
    insert into tarifs (NAME) values(:new.NAME);
end aftinsttest;
ALTER TRIGGER aftinsttest ENABLE;
*/
insert into productype values (1, 'КРЕДИТ', to_date('01.01.2018','DD.MM.YYYY'), null, 1);
insert into productype values (2, 'ДЕПОЗИТ', to_date('01.01.2018','DD.MM.YYYY'), null, 2);
insert into productype values (3, 'КАРТА', to_date('01.01.2018','DD.MM.YYYY'), null, 3);

---------------------------------------------------------------------------------------------

create table products (
	ID NUMBER(10) PRIMARY KEY NOT NULL,
	PRODUCT_TYPE_ID NUMBER(10) NOT NULL,
	NAME VARCHAR2(100) NOT NULL,
	CLIENT_REF NUMBER(10) NOT NULL,
	OPEN_DATE DATE NOT NULL,
--	OPEN_DATE DATE NOT NULL CHECK (OPEN_DATE > '01-Jan-1900'),
	CLOSE_DATE DATE,
	CONSTRAINT CLOSE_DATE_CHECK CHECK (CLOSE_DATE >= OPEN_DATE),
	FOREIGN KEY (CLIENT_REF) REFERENCES clients (ID),
	FOREIGN KEY (PRODUCT_TYPE_ID) REFERENCES productype (ID)
	);

insert into products values (1, 1, 'Кредитный договор с Сидоровым И.П.', 1, to_date('01.06.2015','DD.MM.YYYY'), null);
insert into products values (2, 2, 'Депозитный договор с Ивановым П.С.', 2, to_date('01.08.2017','DD.MM.YYYY'), null);
insert into products values (3, 3, 'Карточный договор с Петровым С.И.', 3, to_date('01.08.2017','DD.MM.YYYY'), null);
insert into products values (4, 1, 'Кредитный договор с ХХХ Х.Х.', 4, to_date('01.06.2015','DD.MM.YYYY'), null);
insert into products values (5, 1, 'Кредитный договор с Овечкиным А.М.', 5, to_date('01.06.2015','DD.MM.YYYY'), null);

--for task 4
insert into products values (6, 2, 'Депозитный договор с Сидоровым И.П.', 1, to_date('01.06.2014','DD.MM.YYYY'), null);
insert into products values (7, 1, 'Кредитный договор с Ивановым П.С.', 2, to_date('01.08.2017','DD.MM.YYYY'), to_date('01.08.2018','DD.MM.YYYY'));

---------------------------------------------------------------------------------------------

create table accounts (
	ID NUMBER(10) PRIMARY KEY NOT NULL,
	NAME VARCHAR2(100) NOT NULL,
	SALDO NUMBER (10,2) NOT NULL,
	CLIENT_REF NUMBER(10) NOT NULL,
	OPEN_DATE DATE NOT NULL,
--	OPEN_DATE DATE NOT NULL CHECK (OPEN_DATE > '01-Jan-1900'),
	CLOSE_DATE DATE,
	PRODUCT_REF NUMBER(10) NOT NULL,
	ACC_NUM VARCHAR2(25) NOT NULL,
	CONSTRAINT ACC_CLOSE_DATE_CHECK CHECK (CLOSE_DATE >= OPEN_DATE),
	FOREIGN KEY (CLIENT_REF) REFERENCES clients (ID),
	FOREIGN KEY (PRODUCT_REF) REFERENCES products (ID)
	);

insert into accounts values (1, 'Кредитный счет для Сидоровым И.П.', -2000, 1, to_date('01.06.2015','DD.MM.YYYY'), null, 1, '45502810401020000022');
insert into accounts values (2, 'Депозитный счет для Ивановым П.С.', 6000, 2, to_date('01.08.2017','DD.MM.YYYY'), null, 2, '42301810400000000001');
insert into accounts values (3, 'Карточный счет для Петровым С.И.', 8000, 3, to_date('01.08.2017','DD.MM.YYYY'), null, 3, '40817810700000000001');
--insert into accounts values (4, 'Кредитный счет для Сидоровым И.П.', -2222, 1, to_date('01.07.2015','DD.MM.YYYY'), null, 1, '45502810401020000023');
insert into accounts values (4, 'Кредитный счет1 для ХХХ Х.Х.', 4444, 4, to_date('01.07.2015','DD.MM.YYYY'), null, 4, '45502810401020000055');
insert into accounts values (5, 'Кредитный счет2 для ХХХ Х.Х.', 0, 4, to_date('01.07.2015','DD.MM.YYYY'), null, 4, '45502810401020000088');
insert into accounts values (6, 'Кредитный счет для Овечкиным А.М.', 0, 5, to_date('01.07.2015','DD.MM.YYYY'), null, 5, '11111111111111111111');

--for task 4
insert into accounts values (7, 'Депозитный счет для Сидоровым И.П.', 0, 1, to_date('01.06.2014','DD.MM.YYYY'), null, 2, '45502810401020000044');
insert into accounts values (8, 'Кредитный счет для Ивановым П.С.', 0, 2, to_date('01.08.2017','DD.MM.YYYY'), to_date('01.08.2018','DD.MM.YYYY'), 1, '42301810400000000044');

---------------------------------------------------------------------------------------------

--create sequence rec_seq start with 1 increment by 1;

create table records (
	ID NUMBER(10) generated always as identity (start with 1 increment by 1) PRIMARY KEY NOT NULL,
	DT NUMBER (1) NOT NULL,
	SUM NUMBER(10,2) NOT NULL,
	ACC_REF NUMBER(10) NOT NULL,
	OPER_DATE DATE NOT NULL,
	FOREIGN KEY (ACC_REF) REFERENCES accounts (ID)
	);

insert into records (DT, SUM, ACC_REF, OPER_DATE) values (1, 5000, 1, to_date('01.06.2015','DD.MM.YYYY'));
insert into records (DT, SUM, ACC_REF, OPER_DATE) values (0, 1000, 1, to_date('01.07.2015','DD.MM.YYYY'));
insert into records (DT, SUM, ACC_REF, OPER_DATE) values (0, 2000, 1, to_date('01.08.2015','DD.MM.YYYY'));
insert into records (DT, SUM, ACC_REF, OPER_DATE) values (0, 3000, 1, to_date('01.09.2015','DD.MM.YYYY'));
insert into records (DT, SUM, ACC_REF, OPER_DATE) values (1, 5000, 1, to_date('01.10.2015','DD.MM.YYYY'));
insert into records (DT, SUM, ACC_REF, OPER_DATE) values (0, 3000, 1, to_date('01.10.2015','DD.MM.YYYY'));
insert into records (DT, SUM, ACC_REF, OPER_DATE) values (0, 10000, 2, to_date('01.08.2017','DD.MM.YYYY'));
insert into records (DT, SUM, ACC_REF, OPER_DATE) values (1, 1000, 2, to_date('05.08.2017','DD.MM.YYYY'));
insert into records (DT, SUM, ACC_REF, OPER_DATE) values (1, 2000, 2, to_date('21.09.2017','DD.MM.YYYY'));
insert into records (DT, SUM, ACC_REF, OPER_DATE) values (1, 5000, 2, to_date('24.10.2017','DD.MM.YYYY'));
insert into records (DT, SUM, ACC_REF, OPER_DATE) values (0, 6000, 2, to_date('26.11.2017','DD.MM.YYYY'));
insert into records (DT, SUM, ACC_REF, OPER_DATE) values (0, 120000, 3, to_date('08.09.2017','DD.MM.YYYY'));
insert into records (DT, SUM, ACC_REF, OPER_DATE) values (1, 1000, 3, to_date('05.10.2017','DD.MM.YYYY'));
insert into records (DT, SUM, ACC_REF, OPER_DATE) values (1, 2000, 3, to_date('21.10.2017','DD.MM.YYYY'));
insert into records (DT, SUM, ACC_REF, OPER_DATE) values (1, 5000, 3, to_date('24.10.2017','DD.MM.YYYY'));
insert into records (DT, SUM, ACC_REF, OPER_DATE) values (1, 5000, 4, to_date('21.10.2017','DD.MM.YYYY'));
insert into records (DT, SUM, ACC_REF, OPER_DATE) values (0, 5000, 4, to_date('24.10.2017','DD.MM.YYYY'));
insert into records (DT, SUM, ACC_REF, OPER_DATE) values (1, 5000, 4, to_date('24.10.2017','DD.MM.YYYY'));
insert into records (DT, SUM, ACC_REF, OPER_DATE) values (1, 4000, 6, to_date('24.10.2017','DD.MM.YYYY'));
insert into records (DT, SUM, ACC_REF, OPER_DATE) values (0, 4000, 6, to_date('24.11.2017','DD.MM.YYYY'));

--for task 5
insert into records (DT, SUM, ACC_REF, OPER_DATE) values (1, 5555, 1, to_date('01.10.2015','DD.MM.YYYY'));
insert into records (DT, SUM, ACC_REF, OPER_DATE) values (0, 5555, 1, to_date('01.10.2015','DD.MM.YYYY'));
insert into records (DT, SUM, ACC_REF, OPER_DATE) values (1, 5555, 2, to_date('01.10.2015','DD.MM.YYYY'));
insert into records (DT, SUM, ACC_REF, OPER_DATE) values (0, 5555, 2, to_date('01.10.2015','DD.MM.YYYY'));
insert into records (DT, SUM, ACC_REF, OPER_DATE) values (1, 5555, 3, to_date('01.10.2015','DD.MM.YYYY'));
insert into records (DT, SUM, ACC_REF, OPER_DATE) values (0, 5555, 3, to_date('01.10.2015','DD.MM.YYYY'));

--for task 6
insert into records (DT, SUM, ACC_REF, OPER_DATE) values (1, 6666, 1, to_date('01.03.2025','DD.MM.YYYY'));
insert into records (DT, SUM, ACC_REF, OPER_DATE) values (0, 6666, 1, to_date('01.03.2025','DD.MM.YYYY'));
insert into records (DT, SUM, ACC_REF, OPER_DATE) values (1, 6666, 2, to_date('01.03.2025','DD.MM.YYYY'));
insert into records (DT, SUM, ACC_REF, OPER_DATE) values (0, 6666, 2, to_date('01.03.2025','DD.MM.YYYY'));
insert into records (DT, SUM, ACC_REF, OPER_DATE) values (1, 6666, 3, to_date('01.03.2025','DD.MM.YYYY'));
insert into records (DT, SUM, ACC_REF, OPER_DATE) values (0, 6666, 3, to_date('01.03.2025','DD.MM.YYYY'));

---------------------------------------------------------------------------------------------

SELECT * from clients;
SELECT * FROM tarifs;
SELECT * from productype;
SELECT * from products;
SELECT * from accounts;
SELECT * from records;

---------------------------------------------------------------------------------------------
/*4. Сформируйте выборку, которая содержит все счета, относящиеся к продуктам типа
ДЕПОЗИТ, принадлежащих клиентам, у которых нет открытых продуктов типа КРЕДИТ.*/
select * from accounts
where CLIENT_REF not in (
    select CLIENT_REF from accounts where (PRODUCT_REF = 1 and CLOSE_DATE is null) --проверка в счетах
    union all 
    select CLIENT_REF from products where (PRODUCT_TYPE_ID = 1 and CLOSE_DATE is null) ----проверка в продуктах
) 
and PRODUCT_REF = 2
order by CLIENT_REF, PRODUCT_REF;

---------------------------------------------------------------------------------------------
/*5. Сформируйте выборку, которая выведет сумму движений по счетам (дебетовые и
кредитовые) в рамках одного произвольного дня, в разрезе типа продукта.*/
-- с общим результатом - all_prod
with cte as(
    select coalesce(TO_CHAR(DT), 'total') as DTT,
           coalesce(TO_CHAR(ACC_REF), 'all_acc') as ACC_REFF,
           sum(SUM) as agg
	from records
	where OPER_DATE = to_date('01.10.2015','DD.MM.YYYY')
	group by rollup(DT, ACC_REF)
)
select distinct coalesce(productype.NAME, 'all_prod') as PROD_NAME, 
                DT_0.agg as SUM_DT_0, 
                DT_1.agg as SUM_DT_1, 
                (NVL(DT_0.agg, 0) - NVL(DT_1.agg, 0)) as RESULT 
                from cte
left join cte DT_0
	on cte.ACC_REFF = DT_0.ACC_REFF and DT_0.DTT = '0'
left join cte DT_1
	on cte.ACC_REFF = DT_1.ACC_REFF and DT_1.DTT = '1'
left join accounts on TO_CHAR(accounts.ID) = cte.ACC_REFF
left join products on products.ID = PRODUCT_REF
left join productype on productype.ID = PRODUCT_TYPE_ID;

-- без общего результата
with cte as (
    select DT, ACC_REF, sum(SUM) as agg from records
	where OPER_DATE = to_date('01.10.2015','DD.MM.YYYY')
	group by rollup(DT, ACC_REF)
)
select distinct productype.NAME as PROD_NAME, 
                DT_0.agg as SUM_DT_0, 
                DT_1.agg as SUM_DT_1, 
                (NVL(DT_0.agg, 0) - NVL(DT_1.agg, 0)) as RESULT 
                from cte
left join cte DT_0
	on cte.ACC_REF = DT_0.ACC_REF and DT_0.DT = 0
left join cte DT_1
	on cte.ACC_REF = DT_1.ACC_REF and DT_1.DT = 1
join accounts on accounts.ID = cte.ACC_REF
join products on products.ID = PRODUCT_REF
join productype on productype.ID = PRODUCT_TYPE_ID;

---------------------------------------------------------------------------------------------
/*6. Сформируйте выборку, в которую попадут клиенты, у которых были операции по счетам за
прошедший месяц от текущей даты. Выведите клиента и сумму дебетовых операций за
день в разрезе даты.*/

select clients.NAME, DT, OPER_DATE, OPER_SUM from (
    select DT, ACC_REF, OPER_DATE, sum(SUM) as OPER_SUM from records
    left join accounts on accounts.ID = ACC_REF
    group by DT, ACC_REF, OPER_DATE
), clients
where ACC_REF = clients.ID and DT = 1 and ((CURRENT_DATE - oper_date) <= 30);

---------------------------------------------------------------------------------------------
/*7. В результате сбоя в базе данных разъехалась информация между остатками и операциями
по счетам. Напишите нормализацию (процедуру выравнивающую данные), которая
найдет такие счета и восстановит остатки по счету.*/
/*
create table temp (ID NUMBER(10) NOT NULL, amount NUMBER(10,2) );
insert into temp values (1, 55);
insert into temp values (2, 66);
insert into temp values (3, 77);
insert into temp values (4, 88);

UPDATE accounts
SET saldo = temp.amount from temp where accounts.ID = temp.ID;
select * from accounts;
*/
UPDATE accounts
SET SALDO = SAL from (
    select ACC_REF as AR, AGG_DT_O, AGG_DT_1, (NVL(AGG_DT_O, 0) - NVL(AGG_DT_1, 0)) as SAL from (
        (select DT, ACC_REF, sum(SUM) as AGG_DT_O from records where DT = 0
    	group by ACC_REF, dt)
        full join 
        (select DT, ACC_REF, sum(SUM) as AGG_DT_1 from records where DT = 1
	    group by ACC_REF, dt)
    using (ACC_REF)
    )
)
where accounts.ID = AR;
select * from accounts;

---------------------------------------------------------------------------------------------
/*8. Сформируйте выборку, которая содержит информацию о клиентах, которые полностью
погасили кредит, но при этом не закрыли продукт.*/

select * from clients where clients.ID IN (
    select CLIENT_REF from accounts where PRODUCT_REF IN (
        select products.ID from products where PRODUCT_TYPE_ID = 1
    ) 
    and accounts.ID IN (
        select ACC_REF from (
            select ACC_REF, count(DT) as CNT_DT_1 from records 
            where DT = 1 
            group by ACC_REF
        )
        where CNT_DT_1 > 1));

---------------------------------------------------------------------------------------------
/*9. Закройте продукты (установите дату закрытия равную текущей) типа КРЕДИТ, у которых
произошло полное погашение, но при этом не было повторной выдачи.*/

update products
set CLOSE_DATE = CURRENT_DATE where ID in (
    select * from (
        select products.ID from accounts
        join
        products on products.ID = PRODUCT_REF
            where SALDO = 0 and accounts.CLOSE_DATE is null
            and products.CLOSE_DATE is null and PRODUCT_TYPE_ID = 1
    )
    except (
        select products.ID from accounts
        right join
        products on products.ID = PRODUCT_REF
        where SALDO < 0 and accounts.CLOSE_DATE is null
        and products.CLOSE_DATE is null and PRODUCT_TYPE_ID = 1
    )
);
select * from products;

update accounts
set CLOSE_DATE = CURRENT_DATE where ID in (
    select accounts.ID from accounts
    join
    products on products.ID = PRODUCT_REF
    where SALDO = 0 and accounts.CLOSE_DATE is null
    and (products.CLOSE_DATE is null or products.CLOSE_DATE = CURRENT_DATE)
    and PRODUCT_TYPE_ID = 1
);
select * from accounts;

---------------------------------------------------------------------------------------------
/*10. Закройте возможность открытия (установите дату окончания действия) для типов
продуктов, по счетам продуктов которых, не было движений более одного месяца.*/

delete from records where OPER_DATE = to_date('01.03.2025','DD.MM.YYYY') and (ACC_REF = 1 or ACC_REF = 3);

update productype
set END_DATE = CURRENT_DATE where ID in (
    select distinct PRODUCT_TYPE_ID from (
        select max(OPER_DATE) as LAST_OPER_DATE, ACC_REF from records 
        group by ACC_REF
    )
    join accounts on ACC_REF = accounts.ID
    join products on products.ID = PRODUCT_REF
    where (CURRENT_DATE - LAST_OPER_DATE) > 30
);
select * from productype;

---------------------------------------------------------------------------------------------
/*11. В модель данных добавьте сумму договора по продукту. Заполните поле для всех
продуктов суммой максимальной дебетовой операции по счету для продукта типа
КРЕДИТ, и суммой максимальной кредитовой операции по счету продукта для продукта
типа ДЕПОЗИТ или КАРТА.*/

alter table products add PROD_SUM NUMBER(10,2);

UPDATE products SET products.PROD_SUM = SUM from (
    with cte1 as (
        select distinct ID, DT, SUM from (
            select productype.ID, records.DT, records.SUM,
                rank() over (partition by productype.ID
                order by records.SUM DESC
                ) AS r
            FROM (
            records
            join accounts on accounts.ID = records.ACC_REF
            join products on products.ID = accounts.PRODUCT_REF
            join productype on productype.ID = products.PRODUCT_TYPE_ID
            )
        )
        WHERE r = 1
        ORDER BY SUM DESC
    ),
    cte2 as (
        select ID, SUM from cte1 where (ID = 2 or ID = 3) and DT = 0 and rownum = 1
        union
        select ID, SUM from cte1 where ID = 1 and DT = 1 and rownum = 1
    ),
    cte3 as (
        select * from cte2
        union
        select ID, (select SUM from cte2 where ID != 1) as SUM 
        from cte1 where ID not in (select ID from cte2) and rownum = 1
    )
select * from cte3) MAX_OPER_SUM 
where products.PRODUCT_TYPE_ID = MAX_OPER_SUM.ID;

select * from products;

---------------------------------------------------------------------------------------------

/*
РЕЗУЛЬТАТЫ
Задания 1, 2, 3.
|----|------------------------------|----------------------------------------|---------------|------------------------------------------------------------|----------------------------|
| ID | NAME                         | PLACE_OF_BIRTH                         | DATE_OF_BIRTH | ADDRESS                                                    | PASSPORT                   |
|----|------------------------------|----------------------------------------|---------------|------------------------------------------------------------|----------------------------|
| 1  | Сидоров Иван Петрович        | Россия, Московская облать, г. Пушкин   | 01-JAN-01     | Россия, Московская облать, г. Пушкин, ул. Грибоедова, д. 5 | 2222 555555, выдан         |
|    |                              |                                        |               |                                                            | ОВД г. Пушкин, 10.01.2015  |
| 2  | Иванов Петр Сидорович        | Россия, Московская облать, г. Клин     | 01-JAN-01     | Россия, Московская облать, г. Клин, ул. Мясникова, д. 3    | 4444 666666, выдан ОВД г.  |
|    |                              |                                        |               |                                                            | Клин, 10.01.2015           |
| 3  | Петров Сиодр Иванович        | Россия, Московская облать, г. Балашиха | 01-JAN-01     | Россия, Московская облать, г. Балашиха, ул. Пушкина, д. 7  | 4444 666666, выдан ОВД     |
|    |                              |                                        |               |                                                            | г. Клин, 10.01.2015        |
| 4  | ХХХ ХХХ ХХХ                  | Россия, Московская облать, г. Балашиха | 01-JAN-01     | Россия, Московская облать, г. Балашиха, ул. Пушкина, д. 7  | 4454 666666, выдан ОВД     |
|    |                              |                                        |               |                                                            | г. Клин, 10.01.2015        |
| 5  | Овечкин Александр Михайлович | Россия, Московская облать, г. Балашиха | 17-OCT-85     | Россия, Московская облать, г. Москва, ул. Хоккейная, д. 1  | 1234 123456, выдан ОВД     |
|    |                              |                                        |               |                                                            | г. Москва, 17.10.2011      |

|----|-----------------------------|------|
| ID | NAME                        | COST |
|----|-----------------------------|------|
| 1  | Тариф за выдачу кредита     | 10   |
| 2  | Тариф за открытие счета     | 10   |
| 3  | Тариф за обслуживание карты | 10   |

|----|---------|------------|----------|-----------|
| ID | NAME    | BEGIN_DATE | END_DATE | TARIF_REF |
|----|---------|------------|----------|-----------|
| 1  | КРЕДИТ  | 01-JAN-18  | [null]   | 1         |
| 2  | ДЕПОЗИТ | 01-JAN-18  | [null]   | 2         |
| 3  | КАРТА   | 01-JAN-18  | [null]   | 3         |

|----|-----------------|-------------------------------------|------------|-----------|------------|
| ID | PRODUCT_TYPE_ID | NAME                                | CLIENT_REF | OPEN_DATE | CLOSE_DATE |
|----|-----------------|-------------------------------------|------------|-----------|------------|
| 1  | 1               | Кредитный договор с Сидоровым И.П.  | 1          | 01-JUN-15 | [null]     |
| 2  | 2               | Депозитный договор с Ивановым П.С.  | 2          | 01-AUG-17 | [null]     |
| 3  | 3               | Карточный договор с Петровым С.И.   | 3          | 01-AUG-17 | [null]     |
| 4  | 1               | Кредитный договор с ХХХ Х.Х.        | 4          | 01-JUN-15 | [null]     |
| 5  | 1               | Кредитный договор с Овечкиным А.М.  | 5          | 01-JUN-15 | [null]     |
| 6  | 2               | Депозитный договор с Сидоровым И.П. | 1          | 01-JUN-14 | [null]     |
| 7  | 1               | Кредитный договор с Ивановым П.С.   | 2          | 01-AUG-17 | 01-AUG-18  |

|----|------------------------------------|-------|------------|-----------|------------|-------------|----------------------|
| ID | NAME                               | SALDO | CLIENT_REF | OPEN_DATE | CLOSE_DATE | PRODUCT_REF | ACC_NUM              |
|----|------------------------------------|-------|------------|-----------|------------|-------------|----------------------|
| 1  | Кредитный счет для Сидоровым И.П.  | -2000 | 1          | 01-JUN-15 | [null]     | 1           | 45502810401020000022 |
| 2  | Депозитный счет для Ивановым П.С.  | 6000  | 2          | 01-AUG-17 | [null]     | 2           | 42301810400000000001 |
| 3  | Карточный счет для Петровым С.И.   | 8000  | 3          | 01-AUG-17 | [null]     | 3           | 40817810700000000001 |
| 4  | Кредитный счет1 для ХХХ Х.Х.       | 4444  | 4          | 01-JUL-15 | [null]     | 4           | 45502810401020000055 |
| 5  | Кредитный счет2 для ХХХ Х.Х.       | 0     | 4          | 01-JUL-15 | [null]     | 4           | 45502810401020000088 |
| 6  | Кредитный счет для Овечкиным А.М.  | 0     | 5          | 01-JUL-15 | [null]     | 5           | 11111111111111111111 |
| 7  | Депозитный счет для Сидоровым И.П. | 0     | 1          | 01-JUN-14 | [null]     | 2           | 45502810401020000044 |
| 8  | Кредитный счет для Ивановым П.С.   | 0     | 2          | 01-AUG-17 | 01-AUG-18  | 1           | 42301810400000000044 |

|----|----|--------|---------|-----------|
| ID | DT | SUM    | ACC_REF | OPER_DATE |
|----|----|--------|---------|-----------|
| 1  | 1  | 5000   | 1       | 01-JUN-15 |
| 2  | 0  | 1000   | 1       | 01-JUL-15 |
| 3  | 0  | 2000   | 1       | 01-AUG-15 |
| 4  | 0  | 3000   | 1       | 01-SEP-15 |
| 5  | 1  | 5000   | 1       | 01-OCT-15 |
| 6  | 0  | 3000   | 1       | 01-OCT-15 |
| 7  | 0  | 10000  | 2       | 01-AUG-17 |
| 8  | 1  | 1000   | 2       | 05-AUG-17 |
| 9  | 1  | 2000   | 2       | 21-SEP-17 |
| 10 | 1  | 5000   | 2       | 24-OCT-17 |
| 11 | 0  | 6000   | 2       | 26-NOV-17 |
| 12 | 0  | 120000 | 3       | 08-SEP-17 |
| 13 | 1  | 1000   | 3       | 05-OCT-17 |
| 14 | 1  | 2000   | 3       | 21-OCT-17 |
| 15 | 1  | 5000   | 3       | 24-OCT-17 |
| 16 | 1  | 5000   | 4       | 21-OCT-17 |
| 17 | 0  | 5000   | 4       | 24-OCT-17 |
| 18 | 1  | 5000   | 4       | 24-OCT-17 |
| 19 | 1  | 4000   | 6       | 24-OCT-17 |
| 20 | 0  | 4000   | 6       | 24-NOV-17 |
| 21 | 1  | 5555   | 1       | 01-OCT-15 |
| 22 | 0  | 5555   | 1       | 01-OCT-15 |
| 23 | 1  | 5555   | 2       | 01-OCT-15 |
| 24 | 0  | 5555   | 2       | 01-OCT-15 |
| 25 | 1  | 5555   | 3       | 01-OCT-15 |
| 26 | 0  | 5555   | 3       | 01-OCT-15 |
| 27 | 1  | 6666   | 1       | 01-MAR-25 |
| 28 | 0  | 6666   | 1       | 01-MAR-25 |
| 29 | 1  | 6666   | 2       | 01-MAR-25 |
| 30 | 0  | 6666   | 2       | 01-MAR-25 |
| 31 | 1  | 6666   | 3       | 01-MAR-25 |
| 32 | 0  | 6666   | 3       | 01-MAR-25 |

---------------------------------------------------------------------------------------------
Задание 4

|----|-----------------------------------|-------|------------|-----------|------------|-------------|----------------------|
| ID | NAME                              | SALDO | CLIENT_REF | OPEN_DATE | CLOSE_DATE | PRODUCT_REF | ACC_NUM              |
|----|-----------------------------------|-------|------------|-----------|------------|-------------|----------------------|
| 2  | Депозитный счет для Ивановым П.С. | 6000  | 2          | 01-AUG-17 | [null]     | 2           | 42301810400000000001 |


---------------------------------------------------------------------------------------------
Задание 5

|-----------|----------|----------|--------|
| PROD_NAME | SUM_DT_0 | SUM_DT_1 | RESULT |
|-----------|----------|----------|--------|
| КРЕДИТ    | 8555     | 10555    | -2000  |
| ДЕПОЗИТ   | 5555     | 5555     | 0      |
| КАРТА     | 5555     | 5555     | 0      |
| all_prod  | 19665    | 21665    | -2000  |

|-----------|----------|----------|--------|
| PROD_NAME | SUM_DT_0 | SUM_DT_1 | RESULT |
|-----------|----------|----------|--------|
| КРЕДИТ    | 8555     | 10555    | -2000  |
| ДЕПОЗИТ   | 5555     | 5555     | 0      |
| КАРТА     | 5555     | 5555     | 0      |

---------------------------------------------------------------------------------------------
Задание 6

|-----------------------|----|-----------|----------|
| NAME                  | DT | OPER_DATE | OPER_SUM |
|-----------------------|----|-----------|----------|
| Сидоров Иван Петрович | 1  | 01-MAR-25 | 6666     |
| Иванов Петр Сидорович | 1  | 01-MAR-25 | 6666     |
| Петров Сиодр Иванович | 1  | 01-MAR-25 | 6666     |

---------------------------------------------------------------------------------------------
Задание 7

|----|------------------------------------|--------|------------|-----------|------------|-------------|----------------------|
| ID | NAME                               | SALDO  | CLIENT_REF | OPEN_DATE | CLOSE_DATE | PRODUCT_REF | ACC_NUM              |
|----|------------------------------------|--------|------------|-----------|------------|-------------|----------------------|
| 1  | Кредитный счет для Сидоровым И.П.  | -1000  | 1          | 01-JUN-15 | [null]     | 1           | 45502810401020000022 |
| 2  | Депозитный счет для Ивановым П.С.  | 8000   | 2          | 01-AUG-17 | [null]     | 2           | 42301810400000000001 |
| 3  | Карточный счет для Петровым С.И.   | 112000 | 3          | 01-AUG-17 | [null]     | 3           | 40817810700000000001 |
| 4  | Кредитный счет1 для ХХХ Х.Х.       | -5000  | 4          | 01-JUL-15 | [null]     | 4           | 45502810401020000055 |
| 5  | Кредитный счет2 для ХХХ Х.Х.       | 0      | 4          | 01-JUL-15 | [null]     | 4           | 45502810401020000088 |
| 6  | Кредитный счет для Овечкиным А.М.  | 0      | 5          | 01-JUL-15 | [null]     | 5           | 11111111111111111111 |
| 7  | Депозитный счет для Сидоровым И.П. | 0      | 1          | 01-JUN-14 | [null]     | 2           | 45502810401020000044 |
| 8  | Кредитный счет для Ивановым П.С.   | 0      | 2          | 01-AUG-17 | 01-AUG-18  | 1           | 42301810400000000044 |

---------------------------------------------------------------------------------------------
Задание 8

|----|-----------------------|----------------------------------------|---------------|------------------------------------------------------------|----------------------------|
| ID | NAME                  | PLACE_OF_BIRTH                         | DATE_OF_BIRTH | ADDRESS                                                    | PASSPORT                   |
|----|-----------------------|----------------------------------------|---------------|------------------------------------------------------------|----------------------------|
| 1  | Сидоров Иван Петрович | Россия, Московская облать, г. Пушкин   | 01-JAN-01     | Россия, Московская облать, г. Пушкин, ул. Грибоедова, д. 5 | 2222 555555, выдан         |
|    |                       |                                        |               |                                                            | ОВД г. Пушкин, 10.01.2015  |
| 4  | ХХХ ХХХ ХХХ           | Россия, Московская облать, г. Балашиха | 01-JAN-01     | Россия, Московская облать, г. Балашиха, ул. Пушкина, д. 7  | 4454 666666, выдан ОВД     |
|    |                       |                                        |               |                                                            | г. Клин, 10.01.2015        |

---------------------------------------------------------------------------------------------
Задание 9

|----|-----------------|-------------------------------------|------------|-----------|------------|
| ID | PRODUCT_TYPE_ID | NAME                                | CLIENT_REF | OPEN_DATE | CLOSE_DATE |
|----|-----------------|-------------------------------------|------------|-----------|------------|
| 1  | 1               | Кредитный договор с Сидоровым И.П.  | 1          | 01-JUN-15 | [null]     |
| 2  | 2               | Депозитный договор с Ивановым П.С.  | 2          | 01-AUG-17 | [null]     |
| 3  | 3               | Карточный договор с Петровым С.И.   | 3          | 01-AUG-17 | [null]     |
| 4  | 1               | Кредитный договор с ХХХ Х.Х.        | 4          | 01-JUN-15 | [null]     |
| 5  | 1               | Кредитный договор с Овечкиным А.М.  | 5          | 01-JUN-15 | 13-MAR-25  |
| 6  | 2               | Депозитный договор с Сидоровым И.П. | 1          | 01-JUN-14 | [null]     |
| 7  | 1               | Кредитный договор с Ивановым П.С.   | 2          | 01-AUG-17 | 01-AUG-18  |


|----|------------------------------------|--------|------------|-----------|------------|-------------|----------------------|
| ID | NAME                               | SALDO  | CLIENT_REF | OPEN_DATE | CLOSE_DATE | PRODUCT_REF | ACC_NUM              |
|----|------------------------------------|--------|------------|-----------|------------|-------------|----------------------|
| 1  | Кредитный счет для Сидоровым И.П.  | -1000  | 1          | 01-JUN-15 | [null]     | 1           | 45502810401020000022 |
| 2  | Депозитный счет для Ивановым П.С.  | 8000   | 2          | 01-AUG-17 | [null]     | 2           | 42301810400000000001 |
| 3  | Карточный счет для Петровым С.И.   | 112000 | 3          | 01-AUG-17 | [null]     | 3           | 40817810700000000001 |
| 4  | Кредитный счет1 для ХХХ Х.Х.       | -5000  | 4          | 01-JUL-15 | [null]     | 4           | 45502810401020000055 |
| 5  | Кредитный счет2 для ХХХ Х.Х.       | 0      | 4          | 01-JUL-15 | 13-MAR-25  | 4           | 45502810401020000088 |
| 6  | Кредитный счет для Овечкиным А.М.  | 0      | 5          | 01-JUL-15 | 13-MAR-25  | 5           | 11111111111111111111 |
| 7  | Депозитный счет для Сидоровым И.П. | 0      | 1          | 01-JUN-14 | [null]     | 2           | 45502810401020000044 |
| 8  | Кредитный счет для Ивановым П.С.   | 0      | 2          | 01-AUG-17 | 01-AUG-18  | 1           | 42301810400000000044 |

---------------------------------------------------------------------------------------------
Задание 10

|----|---------|------------|-----------|-----------|
| ID | NAME    | BEGIN_DATE | END_DATE  | TARIF_REF |
|----|---------|------------|-----------|-----------|
| 1  | КРЕДИТ  | 01-JAN-18  | 13-MAR-25 | 1         |
| 2  | ДЕПОЗИТ | 01-JAN-18  | [null]    | 2         |
| 3  | КАРТА   | 01-JAN-18  | 13-MAR-25 | 3         |

---------------------------------------------------------------------------------------------
Задание 11

|----|-----------------|-------------------------------------|------------|-----------|------------|----------|
| ID | PRODUCT_TYPE_ID | NAME                                | CLIENT_REF | OPEN_DATE | CLOSE_DATE | PROD_SUM |
|----|-----------------|-------------------------------------|------------|-----------|------------|----------|
| 1  | 1               | Кредитный договор с Сидоровым И.П.  | 1          | 01-JUN-15 | [null]     | 5555     |
| 2  | 2               | Депозитный договор с Ивановым П.С.  | 2          | 01-AUG-17 | [null]     | 120000   |
| 3  | 3               | Карточный договор с Петровым С.И.   | 3          | 01-AUG-17 | [null]     | 120000   |
| 4  | 1               | Кредитный договор с ХХХ Х.Х.        | 4          | 01-JUN-15 | [null]     | 5555     |
| 5  | 1               | Кредитный договор с Овечкиным А.М.  | 5          | 01-JUN-15 | 13-MAR-25  | 5555     |
| 6  | 2               | Депозитный договор с Сидоровым И.П. | 1          | 01-JUN-14 | [null]     | 120000   |
| 7  | 1               | Кредитный договор с Ивановым П.С.   | 2          | 01-AUG-17 | 01-AUG-18  | 5555     |


*/
