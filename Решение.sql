--Задание 1
--Вывести в таблице:
--  * имя департамента
--  * количество сотрудников с ЗП
--  * количество сотрудников с грейдом "А"
--  * количество сотрудников с другими грейдами
--  * максимальную ЗП по департаменту
--  1. + Отсортировать по (Имени департамента, размеру ЗП: двойнай сортировка)
--  2. + Для департаментов, в которых 0 сотрудников.
--
-- Решение ниже на диалекте SQLite

--1
select distinct Департамент, 
		count (Зарплата) 'Количество сотрудников с ЗП', 
		sum(case when grade='A' then 1 else 0 end) 'Количество сотрудников с грейдом "А"', 
		sum(case when grade not in ('A') then 1 else 0 end) 'Количество сотрудников с другими грейдами', 
		max(Зарплата) 'Максимальная ЗП по департаменту' 
	from 
		(select d.id,d.name as 'Департамент',m.user_id,s.salary 'Зарплата',u.name,u.grade from department d 
		left join mtm m on d.id = m.department_id 
		left join salary s on s.user_id = m.user_id
		left join "user" u on u.id = s.user_id) 
		group by Департамент 
		order by max(Зарплата) desc, Департамент;

--2
select distinct Департамент, 
		count (Зарплата) 'Количество сотрудников с ЗП', 
		sum(case when grade='A' then 1 else 0 end) 'Количество сотрудников с грейдом "А"', 
		sum(case when grade not in ('A') then 1 else 0 end) 'Количество сотрудников с другими грейдами', 
		max(Зарплата) 'Максимальная ЗП по департаменту' 
from 
		(select d.id,
			d.name as 'Департамент',
			m.user_id,
			s.salary 'Зарплата',
			u.name,u.grade 
		from department d 
		left join mtm m on d.id = m.department_id 
		left join salary s on s.user_id = m.user_id
		left join "user" u on u.id = s.user_id 
		where m.department_id is NULL) 
		group by Департамент; 
	
-- Задание 2
-- Вывести в таблице
--  * имя сотрудника
--  * грейд сотрудника
--  * зарплата сотрудника
--  * количество департаментов, в которых числится сотрудник
--
--  1. Отсортировать по (Имени сотрудника, количеству департаментов по убыванию)
--  2. + Сгруппировать по грейду, вывести:
--   * Количество сотрудником с этим грейдом
--   * Количество сотрудников c этим грейдом, которые числятся более чем в одном департаменте
--   * среднюю ЗП сотрудников с этим грейдом

--1
select u.name 'Имя',
		u.grade 'Грейд', 
		s.salary 'Зарплата',
		count(m.department_id) 'Количество_департаментов' 
from "user" u 
join salary s on u.id =s.user_id 
join mtm m on m.user_id=u.id 
GROUP by u.id 
order by Имя,Количество_департаментов;

--2
select u.grade 'Грейд',
		count(grade) 'Количество сотрудников', 
		sum(case when C_dep_id>1 then 1 else 0 end) 'Количество сотрудников в более чем 1 департаменте',
		AVG(s.salary) 'Средняя ЗП'  
from (select m.user_id, 
			count(m.department_id) C_dep_id
			from mtm m 
			GROUP by m.user_id) c_n 
left join "user" u on c_n.user_id=u.id 
left join salary s on c_n.user_id =s.user_id 
group by u.grade; 
	

