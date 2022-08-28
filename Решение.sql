--������� 1
--������� � �������:
--  * ��� ������������
--  * ���������� ����������� � ��
--  * ���������� ����������� � ������� "�"
--  * ���������� ����������� � ������� ��������
--  * ������������ �� �� ������������
--  1. + ������������� �� (����� ������������, ������� ��: ������� ����������)
--  2. + ��� �������������, � ������� 0 �����������.
--
-- ������� ���� �� �������� SQLite

--1
select distinct �����������, 
		count (��������) '���������� ����������� � ��', 
		sum(case when grade='A' then 1 else 0 end) '���������� ����������� � ������� "�"', 
		sum(case when grade not in ('A') then 1 else 0 end) '���������� ����������� � ������� ��������', 
		max(��������) '������������ �� �� ������������' 
	from 
		(select d.id,d.name as '�����������',m.user_id,s.salary '��������',u.name,u.grade from department d 
		left join mtm m on d.id = m.department_id 
		left join salary s on s.user_id = m.user_id
		left join "user" u on u.id = s.user_id) 
		group by ����������� 
		order by max(��������) desc, �����������;

--2
select distinct �����������, 
		count (��������) '���������� ����������� � ��', 
		sum(case when grade='A' then 1 else 0 end) '���������� ����������� � ������� "�"', 
		sum(case when grade not in ('A') then 1 else 0 end) '���������� ����������� � ������� ��������', 
		max(��������) '������������ �� �� ������������' 
from 
		(select d.id,
			d.name as '�����������',
			m.user_id,
			s.salary '��������',
			u.name,u.grade 
		from department d 
		left join mtm m on d.id = m.department_id 
		left join salary s on s.user_id = m.user_id
		left join "user" u on u.id = s.user_id 
		where m.department_id is NULL) 
		group by �����������; 
	
-- ������� 2
-- ������� � �������
--  * ��� ����������
--  * ����� ����������
--  * �������� ����������
--  * ���������� �������������, � ������� �������� ���������
--
--  1. ������������� �� (����� ����������, ���������� ������������� �� ��������)
--  2. + ������������� �� ������, �������:
--   * ���������� ����������� � ���� �������
--   * ���������� ����������� c ���� �������, ������� �������� ����� ��� � ����� ������������
--   * ������� �� ����������� � ���� �������

--1
select u.name '���',
		u.grade '�����', 
		s.salary '��������',
		count(m.department_id) '����������_�������������' 
from "user" u 
join salary s on u.id =s.user_id 
join mtm m on m.user_id=u.id 
GROUP by u.id 
order by ���,����������_�������������;

--2
select u.grade '�����',
		count(grade) '���������� �����������', 
		sum(case when C_dep_id>1 then 1 else 0 end) '���������� ����������� � ����� ��� 1 ������������',
		AVG(s.salary) '������� ��'  
from (select m.user_id, 
			count(m.department_id) C_dep_id
			from mtm m 
			GROUP by m.user_id) c_n 
left join "user" u on c_n.user_id=u.id 
left join salary s on c_n.user_id =s.user_id 
group by u.grade; 
	

