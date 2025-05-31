-- query 1
-- Gênero dos leads

select
	case 
		when ibge.gender = 'male' then 'homem'
		when ibge.gender = 'female' then 'mulheres'
		end as "gênero",
	count(*) as "leads"

from sales.customers as cus left join temp_tables.ibge_genders as ibge
	on lower(cus.first_name) = lower(ibge.first_name)
group by ibge.gender

-- query 2
-- Status profissional dos leads

select
	case 
		when professional_status = 'freelancer' then 'freelancer'
		when professional_status = 'retired' then 'aposentado'
		when professional_status = 'clt' then 'clt'
		when professional_status = 'self_employed' then 'autônomo'
		when professional_status = 'other' then 'outro'
		when professional_status = 'businessman' then 'empresário'
		when professional_status = 'civil_servant' then 'funcionário público'
		when professional_status = 'student' then 'estudante'
		end as "status profissional",
	ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM sales.customers), 2) AS "leads (%)"

from sales.customers
group by professional_status
order by "leads (%)" desc

-- query 3
-- faixa etária dos leads

select 
	case
		when datediff('years', birth_date, current_date) < 20 then '0-20'
		when datediff('years', birth_date, current_date) < 40 then '20-40'
		when datediff('years', birth_date, current_date) < 60 then '40-60'
		when datediff('years', birth_date, current_date) < 80 then '60-80'
		else '80+'
		end as "faixa etária",
		round(100.0 * count(*)/ (select count(*) from sales.customers),2) as "leads (%)"
		
from sales.customers
group by "faixa etária"
order by "leads (%)" desc

-- query 4
-- faixa salarial dos leads

select 
	case
		when income < 5000 then '0-5000'
		when income < 10000 then '5000-10000'
		when income < 15000 then '10000-15000'
		when income < 20000 then '15000-20000'
		else '20000+'
		end as "faixa salarial",
		round(100.0 * count(*)/ (select count(*) from sales.customers),2) as "leads (%)",
	case
		when income < 5000 then 1
		when income < 10000 then 2
		when income < 15000 then 3
		when income < 20000 then 4
		else 5
		end as "ordem"
		
from sales.customers
group by "faixa salarial", "ordem"
order by "ordem" desc

-- query 5
-- Classificação dos veículos visitados
-- Regra de negócio : Veículos novos tem até 2 anos e seminos acima de 2 anos

with
	classificao as (
	select
		fun.visit_page_date,
		pro.model_year,
		extract('year' from visit_page_date) - pro.model_year::int as idade_veiculo,
		case
			when (extract('year' from visit_page_date) - pro.model_year::int) <= 2 then 'novo'
			else 'seminovo'
			end as "classificação do veículo"
	
	from sales.funnel as fun
	left join sales.products as pro
		on fun.product_id = pro.product_id
)

select 
	"classificação do veículo",
	count(*) as "veiculos visitados"
from classificao
group by "classificação do veículo"

-- query 6
-- Idade dos veículos visitados

with
	faixa_de_idade as (
	select
		fun.visit_page_date,
		pro.model_year,
		extract('year' from visit_page_date) - pro.model_year::int as idade_veiculo,
		case
			when (extract('year' from visit_page_date) - pro.model_year::int) <= 2 then 'até 2 anos'
			when (extract('year' from visit_page_date) - pro.model_year::int) <= 4 then 'de 2 à 4 anos'
			when (extract('year' from visit_page_date) - pro.model_year::int) <= 6 then 'de 4 à 6 anos'
			when (extract('year' from visit_page_date) - pro.model_year::int) <= 8 then 'de 6 à 8 anos'
			when (extract('year' from visit_page_date) - pro.model_year::int) <= 10 then 'de 8 à 10 anos'
			else 'acima de 10 anos'
			end as "idade do veículo",
		case
			when (extract('year' from visit_page_date) - pro.model_year::int) <= 2 then 1
			when (extract('year' from visit_page_date) - pro.model_year::int) <= 4 then 2
			when (extract('year' from visit_page_date) - pro.model_year::int) <= 6 then 3
			when (extract('year' from visit_page_date) - pro.model_year::int) <= 8 then 4
			when (extract('year' from visit_page_date) - pro.model_year::int) <= 10 then 5
			else 6
			end as "ordem"
	
	from sales.funnel as fun
	left join sales.products as pro
		on fun.product_id = pro.product_id
)

select 
	"idade do veículo",
	count(*)::float/(select count(*) from sales.funnel) as "veiculos visitados (%)",
	ordem
from faixa_de_idade
group by "idade do veículo", ordem
order by ordem


-- query 7
-- Veículos mais visitados por marca

select
	pro.brand,
	pro.model,
	count(*) as "visitas (#)"

from sales.funnel as fun left join sales.products as pro
	on fun.product_id = pro.product_id
group by pro.brand, pro.model
order by pro.brand, pro.model, "visitas (#)"