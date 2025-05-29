-- Query 1

-- Receita, leads, conversão e ticket médio mês a mês
-- Colunas: mês, leads, vendas, receita(k, R$), conversão (%), ticket médio(k, R$)

-- subquery
with leads as(
select
	date_trunc('month', visit_page_date)::date as visit_page_month,
	count(*) as visit_page_count
from sales.funnel
group by visit_page_month
order by visit_page_month
	),
-- subquery
-- transformar a coluna visit_page_date(visita ao site), em uma coluna com as visitas por mês, e em sequencia contar quantas visitas teve por mês em cada ano dessa tabela



	payments as (
select
	date_trunc('month', fun.paid_date)::date as paid_month,
	count(fun.paid_date) as paid_count,
	sum(pro.price * (1+fun.discount)) as receita

from sales.funnel as fun
left join sales.products as pro
	on fun.product_id = pro.product_id
where fun.paid_date is not null
group by paid_month
order by paid_month
)
-- subquery
-- transformar a coluna de data de pagamento, em uma coluna com os pagamentos por mês, e em sequencia contar quantos pagamentos teve por mês em cada ano dessa tabela
-- fazer o calculo da receita usando os dados de preço de todos os produtos, multiplicado por 1 + disconto de todos os produtos e os transformar em uma coluna chamada (receita)
-- left join para junta a coluna onde tem as informações dos produtos e as informações referentes as compras, desses produtos. Unidos pelo id do produto
-- Acontecendo apenas se a coluna de pagamentos não for nula
-- agrupar por mês



select
	leads.visit_page_month as "mês",
	leads.visit_page_count as "leads",
	payments.paid_count as "vendas",
	(payments.receita/1000) as "receita",
	(payments.paid_count::float/leads.visit_page_count::float) as "conversão",
	(payments.receita/payments.paid_count/1000) as "ticket medio"
	

from leads
left join payments
	on leads.visit_page_month = paid_month

-- Left join para juntar as duas subquerys, através do mês, que foram transformadas a partir da data de ambas as subquerys
-- Select para selecionar e unificar as em uma única tabela, as colunas que filtramos nas subquerys anteriormente
-- Feito também o calculo das receitas, conversão e do ticket medio


---------------------------------------------------------------------------------------------------------------------------

-- query 2 
-- Estados que mais venderam


Select	
	'Brazil' as país,
	cus.state as estado,
	count(fun.paid_date) as "vendas"
	

from sales.funnel as fun left join sales.customers as cus
	on fun.customer_id = cus.customer_id
where paid_date between '2021-08-01' and '2021-08-31'
group by país, estado
order by "vendas" desc

------------------------------------------------------------------------------------------------------------------------------

-- query 3
-- marcas que mais venderam no mês


select
	pro.brand as marca,
	count(fun.paid_date) as "vendas"

from sales.funnel as fun left join sales.products as pro
	on fun.product_id = pro.product_id
where paid_date between '2021-08-01' and '2021-08-31'
group by marca
order by "vendas" desc

------------------------------------------------------------------------------------------------------------------------------------

-- query 4
-- lojas que mais venderam


select
	sto.store_name as store,
	count(fun.paid_date) as "vendas"
	
from sales.funnel as fun left join sales.stores as sto
	on fun.store_id = sto.store_id
where paid_date between '2021-08-01' and '2021-08-31'
group by store
order by "vendas" desc

-------------------------------------------------------------------------------------------------------------------------------------------

-- query 5
-- dias da semana com maior número de visitas ao site

select 
	extract('dow' from visit_page_date) as dia_semana,
	case 
		when extract('dow' from visit_page_date) = 0 then 'domingo'
		when extract('dow' from visit_page_date) = 1 then 'segunda'
		when extract('dow' from visit_page_date) = 2 then 'terça'
		when extract('dow' from visit_page_date) = 3 then 'quarta'
		when extract('dow' from visit_page_date) = 4 then 'quinta'
		when extract('dow' from visit_page_date) = 5 then 'sexta'
		when extract('dow' from visit_page_date) = 6 then 'sabado'
		else null end as "dia da semana",
	count(*) as visitas

from sales.funnel
where visit_page_date between '2021-08-01' and '2021-08-31'
group by dia_semana
order by dia_semana



