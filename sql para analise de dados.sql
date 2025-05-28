-- SELECT -- 

-- SELEÇÃO DE UMA COLUNA DE UMA TABELA

select email
from sales.customers

-- SELEÇÃO DE MAIS DE UMA COLUNA DE UMA TABELA

select email, firt_name, last_name
from sales.customers

-- SELEÇÃO DE TODAS AS COLUNAS DE UMA TABELA

select *
from sales.customers

-------------------------------------------------------------

-- DISTINCT


-- SELEÇÃO DE UMA COLUNA SEM DISTINCT

select brand
from sales.products

-- SELEÇÃO DE UMA COLUNA COM DISTINCT

select distinct brand
from sales.products

-- SELEÇÃO DE MAIS DE UMA COLUNAS COM DISTINCT

select distinct brand, model_year
from sales.products

---------------------------------------------------------------

-- WHERE

-- FILTRO COM CONDIÇÃO UNICA

select email, state
from sales.customers
where = 'SC'


-- FILTRO COM MAIS DE UMA CONDIÇÃO

select email, state
from sales.customers
where state = 'SC' or state = 'MS'

-- FILTRO DE CONDIÇÃO COM DATA

select email, state, birth_date
from sales.customers
where (state = 'SC' or state = 'MS') and birth_date < '1991-12-28'

---------------------------------------------------------------------

-- ORDER BY

-- ORDENAÇÃO DE VALORES NUMERICOS

select *
from sales.products
order by price desc


-- ORDERNAÇÃO DE TEXTO

select distinct state
from sales.customers
order by state


--------------------------------------------------------------------


-- LIMIT

-- SELEÇÃO DAS PRIMEIRAS LINHAS USANDO LIMIT

select *
from sales.funnel
limit 10


-- SELEÇÃO DAS N PRIMEIRAS LINHAS USANDO LIMIT e ORDER BY

select *
from sales.products
order by price desc
limit 10



--------------------------------------------------------------------
-- DESAFIO (EXERCICIOS)

-- (Exercício 1) Selecione os nomes de cidade distintas que existem no estado de
-- Minas Gerais em ordem alfabética (dados da tabela sales.customers)

select distinct city
from sales.customers
where state = 'MG'
order by city


---- (Exercício 2) Selecione o visit_id das 10 compras mais recentes efetuadas
-- (dados da tabela sales.funnel)

select visit_id
from sales.funnel
order by paid_date desc
limit 10

-- (Exercício 3) Selecione todos os dados dos 10 clientes com maior score nascidos
-- após 01/01/2000 (dados da tabela sales.customers)

select *
from sales.customers
where birth_date > '01/01/2000'
order by score desc
limit 10


-------------------------------------------------------------------------------------------

-- CRIAÇÃO DE COLUNA CALCULADA, IDADE DO CLIENTE


select email, birth_date, (current_date - birth_date) / 365 as "idade"
from sales.customers


-- LISTE OS 10 CLIENTES MAIS NOVOS DA TABELA CUSTOMERS

select email, birth_date, (current_date - birth_date) / 365 as "idade"
from sales.customers
order by "idade"


-- CRIE UMA COLUNA "NOME_COMPLETO", CONTENDO O NOME COMPLETO DO C4LIENTE

select first_name || ' ' || last_name as "Nome completo"
from sales.customers


---------------------------------------------------------------------------------------------------

-- CRIE UMA COLUNA QUE RETORNE TRUE SEMPRE QUE UM CLIENTE FOR CLT

select customer_id, first_name, professional_status, (professional_status = 'clt') as cliente_clt
from sales.customers

---------------------------------------------------------------------------------------------------

-- USO DO COMANDO BETWEEN, SELECIONE VEICULOS QUE CUSTAM ENTRE 100K E 200K NA TABELA PRODUCTS

select *
from sales.products
where price between 10000 and 20000


-- USO DO COMANDO NOT, SELECIONE VEICULOS QUE CUSTAM ABAIXO DE 100K OU ACIMA DE 200K

select *
from sales.products
where price not between 100000 and 200000

-- USO DO COMANDO IN, SELECIONE OS PRODUTOS QUE SEJAM DA MARCA HONDA, TOYOTA OU RENAULT

select *
from sales.products
where brand in ('HONDA', 'TOYOTA', 'RENAULT')

-- USO DO COMANDO LIKE(MATCHS IMPERFEITOS), SELECIONE OS PROMEIROS NOMES DISTINTOS DA TABELA CUSTOMERS QUE COMEÇAM COM AS INICIAS ANA

select distinct first_name
from sales.customers
where first_name like 'ANA%'	

-- USO DO COMANDO ILIKE (IGNORA LETRAS MAIUSCULAS E MINUSCULAS), SELECIONE OS PRIMERIOS NOMES DISTINTOS COM INICIAS 'ANA'

select distinct first_name
from sales.customers
where first_name ilike 'ANA%'

-- USO DO COMANDO IS NULL, SELECIONAR APENAS AS LINHAS QUE CONTEM NULO NO CAMPO 'POPULATION' NA TABELA

select *
from temp_tables.regions
where population is null

------------------------------------------------------------------------------------------------------------------------------

-- DESAFIO

-- Calcule quantos salários mínimos ganha cada cliente da tabela 
-- sales.customers. Selecione as colunas de: email, income e a coluna calculada "salários mínimos"
-- Considere o salário mínimo igual à R$1200

select email, income, (income / 1200) as "Salario_minimo"
from sales.customers


-- Na query anterior acrescente uma coluna informando TRUE se o cliente
-- ganha acima de 5 salários mínimos e FALSE se ganha 4 salários ou menos.
-- Chame a nova coluna de "acima de 4 salários"

select email, income, (income / 1200) as "Salario_minimo", ((income/ 1200) > 4) as  "acima_de_4_salarios"

from sales.customers



-- (Na query anterior filtre apenas os clientes que ganham entre
-- 4 e 5 salários mínimos. Utilize o comando BETWEEN

select email, income, (income/ 1200) as "salario_minimo", ((income / 1200)> 4) as "acima_de_4 salarios"
from sales.customers
where ((income)/1200) between 4 and 5



-- Selecine o email, cidade e estado dos clientes que moram no estado de 
-- Minas Gerais e Mato Grosso.

select email, city, state
from sales.customers 
where state in ('MG', 'MT')


-- Selecine o email, cidade e estado dos clientes que não 
-- moram no estado de São Paulo.

select email,city, state
from sales.customers
where state not in = 'SP'

-- Selecine os nomes das cidade que começam com a letra Z.
-- Dados da tabela temp_table.regions


select city
from temp_table.regions
where city ilike 'Z%'



----------------------------------------------------------------------------------------


-- FUNÇÕES AGREGAGADAS


-- CONTAGEM DE TODAS AS LINHAS DE UMA TABELA

select count(*)
from sales.funnel


-- CONTAGEM DAS LINHAS DE UMA COLUNA

select count (paid_date)
from sales.funnel


-- CONTAGEM DISTINTA DE UMA COLUNA

select count(distinct product_id)
from sales.funnel
where visit_page_date between '2021-01-01' and '2021-01-31'


-- CALCULE O PREÇO MINIMO, MAXIMO E MÉDIO DA TABELA PRODUCTS

select min(price), max(price), avg(price)
from sale.products


-- INFORME QUAL É O VEICULO MAIS CARO DA TABELA PRODUCTS

select max(price)  from sales.products


select * 
from sales.products
where price = (select max (price) from sales.products)


--------------------------------------------------------------------------------

-- GROUP BY
-- CONTAGEM AGRUPADA DE UMA COLUNA

select state, count(*) as contagem
from sales.customers
group by state
order by contagem desc

-- CONTAGEM AGRUPADA DE VÁRIAS COLUNAS

select state, professional_status, count(*) as contagem
from sales.customers
group by state, professional_status
order by state, contagem desc


-- SELEÇÃO DE VALORES DISTINTOS

select state
from sales.customers
group by state


-----------------------------------------------------------------------------------------------

--HAVING
-- SELEÇÃO COM FILTRO HAVINg

select state, count(*)
from sales.customers
group by state
having count(*) > 100



----------------------------------------------------------------------------------------------------

-- DESAFIO

-- CONTE QUANTOS CLIENTES DA TABELA SALES.CUSTOMERS TEM MENOS DE 30 ANOS 

select ((current_date - birth_date) / 360 ) as idade, count(*)
from sales.customers
where (current_date - birth_date) / 360 <= 30
group by idade


-- Informe a idade do cliente mais velho e mais novo da tabela sales.customers

select max((current_date - birth_date) / 360), min((current_date - birth_date) / 360)
from sales.customers


--Selecione todas as informações do cliente mais rico da tabela sales.customers
-- (possívelmente a resposta contém mais de um cliente)

select *
from sales.customers
where income = (select max(income) from sales.customers)


-- conte quantos veículos de cada marca tem registrado na tabela sales.products
-- Ordene o resultado pelo nome da marca


select brand, count(*)
from sales.products
group by brand
order by brand


-- Conte quantos veículos existem registrados na tabela sales.products
-- por marca e ano do modelo. Ordene pela nome da marca e pelo ano do veículo

select brand, model_year, count(*)
from sales.products
group by brand, model_year
order by brand, model_year


-- Conte quantos veículos de cada marca tem registrado na tabela sales.products
-- e mostre apenas as marcas que contém mais de 10 veículos registrados

select brand, count(*)
from sales.products
group by brand
having count(*) > 10

--------------------------------------------------------------------------------------------------

-- JOIN

-- UTILIZE O LEFT JOIN PARA FAZER JOIN ENTE AS TABELAS



select t1.cpf, t1.name, t2.state
from temp_tables.tabela_1 as t1 left join temp_tables.tabela_2 as t2
on t1.cpf = t2.cpf

-- UTILIZE INNER JOIN

select t1.cpf, t1.name, t2.state
from temp_tables.tabela_1 as t1 inner join temp_tables.tabela_2 as t2
on t1.cpf = t2.cpf


-- UTILIZE RIGHT JOIN

select t2.cpf, t1.name, t2.state
from temp_tables.tabela as t1 right join temp_tables.tabela_2 as t2
on t1.cpf = t2.cpf


-- UTILIZE FULL JOIN 

select t2.cpf, t1.name, t2.state
from temp_tables.tabela_1 as t1 full join temp_tables.tabela_2 as t2
on t1.cpf = t2.cpf

---------------------------------------------------------------------------------------

-- IDENTIFIQUE QUAL É O ESTATUS PROFISSIONAL MAIS FRENQUENTE NOS CLIENTES QUE COMPRARAM AUTOMOVEIS NO SITE

select cus.professional_status, count(fun.paid_date) as pagamentos
from sales.funnel as fun left join sales.customers as cus
on fun.customer_id = cus.customer_id
group by cus.professional_status
order by pagamentos desc

-- IDENTIFIQUE QUAL É O GENERO MAIS FREQUENTE NOS CLIENTES QUE COMPRARAM AUTOMOVEIS NO SITE

select ibge.gender, count(fun.paid_date)
from sales.funnel as fun left join sales.customers as cus
	on fun.customer_id = cus.customer_id
left join temp_tables.ibge_genders as ibge
	on lower(cus.first_name) = ibge.first_name
group by ibge.gender


-- IDENTIFIQUE DE QUAIS REGIOES SÃO OS CLIENTES QUE MAIS VISITAM O SITE

select reg.region, count(fun.visit_page_date) as visitas
from sales.funnel as fun left join sales.customers as cus
	on fun.customer_id = cus.customer_id
left join temp_tables.regions as reg
	on lower(cus.city) = lower(reg.city) and lower(cus.state) = lower(reg.state)
group by reg.region
order by visitas desc

-----------------------------------------------------------------------------------------------------------------------------------

-- DESAFIO

-- Identifique quais as marcas de veículo mais visitada na tabela sales.funnel

select pro.brand, count(*) as visitas
from sales.funnel as fun left join sales.products as pro
on lower(fun.product_id) = lower(pro.product_id)
group by brand
order by visitas desc

-- Identifique quais as lojas de veículo mais visitadas na tabela sales.funnel

select sto.store_name, count (*) as visitas
from sales.funnel as fun left join sales.stores as sto
on lower(fun.store_id) =  lower(sto.store_id)
group by sto.store_name
order by visitas desc


-- Identifique quantos clientes moram em cada tamanho de cidade (o porte da cidade
-- consta na coluna "size" da tabela temp_tables.regions)

select reg.size, count(*) as moradores
from sales.funnel as fun right join sales.customers as cus
on lower(cus.customer_id) = lower(cus.customer_id)
right join temp_tables.regions as reg
on lower(cus.city) = lower(reg.city)
group by reg.size



----------------------------------------------------------------------------------------------------------

-- UNION	
-- união simples de duas tabelas

select * from sales.products
union all
select * from temp_tables.products_2



-------------------------------------------------------------------------------------------------------------

-- SUBQUERY

-- subquery no where
-- informe qual é o veiculo mais barato da tabela products

select * from sales.products
where price = menor_preco

select min(price) = from sales.products

select * from sales.products
where price = (select min(price) from sales.products)

-- subquery com with

with tabela as (

select professional_status, (current_date - birth_date) / 365 as idade
from sales.customers
)


select professional_status, avg(idade) as idade_media
from tabela
group by professional_status




-- subquery no from



select professional_status, avg(idade) as idade_media
from (
	select 
		professional_status, 
		(current_date - birth_date) / 365 as idade
		from sales.customers
) as tabela
group by professional_status



-- subquery no select

select
	fun.visit_id,
	fun.visit_page_date,
	sto.store_name,
	(
		select count(*)
		from sales.funnel as fun2
		where fun2.visit_page_date <= fun.visit_page_date
			and fun2.store_id = fun.store_id
	) as visitas_acumuladas


from sales.funnel as fun
left join sales.stores as sto
	on fun.store.id = sto.store_id
order by sto.store_name, fun.visit_page_date

--------------------------------------------------------------------------------------------------

-- analise de recorrencia dos leads

with primeira_visita as (
	select customer_id, min(visit_page_date) as visita_1
	from sales.funnel 
	group by customer_id

)

select visit_page_date, (fun.visit_page_date <> primeira_visita.visita_1) as lead_recorrente, count(*)
from sales.funnel as fun
left join primeira_visita
	on fun.customer_id = primeira_visita.customer_id
group by fun.visit_page_date, lead_recorrente
order by fun.visit_page_date desc, lead_recorrente


-- analise do preço versus o preço medio

with preco_medio as (

	select brand, avg(price) as preco_medio_da_marca
	from sales.products
	group by brand

)

select fun.visit_id,
	fun.visit_page_date,
	pro.brand,
	(pro.price *(1+fun.discount)) as preco_final,
	preco_medio.preco_medio_da_marca,
	(pro.price *(1+fun.discount)) - preco_medio.preco_medio_da_marca as preco_vs_media


from sales.funnel as fun
left join  sales.products as pro
	on fun.product_id = pro.product_id
left join preco_medio
	on pro.brand = preco_medio.brand


------------------------------------------------------------------------------------------------------

-- DESAFIO

--Crie uma coluna calculada com o número de visitas realizadas por cada
-- cliente da tabela sales.customers 

with visitas as (
	select customer_id, count(*) as n_visitas
	from sales.funnel
	group by customer_id

)
select cus.*, n_visitas
from sales.funnel as fun left join sales.customers as cus
	on fun.customer_id = cus.customer_id
left join visitas as visi
	on fun.customer_id = visi.customer_id


-- versão correta

with numero_de_visitas as (

	select customer_id, count(*) as n_visitas
	from sales.funnel
	group by customer_id

)

select
	cus.*,
	n_visitas

from sales.customers as cus
left join numero_de_visitas as ndv
	on cus.customer_id = ndv.customer_id
	
---------------------------------------------------------------------------------------------------------------------


-- conversão de texto em data

select '21-10-01'::date - '2021-02-01'::date

-- conversão de texto em numero

select '100':: numeric - '10'::numeric

-- conversão de número em texto

select replace(112122::text, '1', 'A')

-- conversão de texto em data

select cast('2021-10-01' as date) - cast('2021-02-01' as date)

-----------------------------------------------------------------------------------------------------------------------------

-- agrupamento com case when

with faixa_de_renda as (

	select
		income,
		case
				when income < 5000 then '0-5000'
				when income >= 5000 and income < 10000 then '5000-10000'
				when income >=10000 and income < 15000 then '10000-15000'
				else '15000+'
				end as faixa_renda
	from sales.customers
)

select faixa_renda, count(*)
from faixa_de_renda
group by faixa_renda


-- tratamento de dados nulos com coalesce



select *, 
	coalesce (population, (select avg(population)from temp_tables.regions )) as populacao_ajustada

		
--------------------------------------------------------------------------------------------------------

-- tratamento de texto

select upper ('São Paulo') = 'SÃO PAULO'

select lower ('São paulo') = 'são paulo'

select trim ('SÃO PAULO            ') = 'SÃO PAULO'

select replace('SAO PAULO','SAO', 'SÃO') = 'SÃO PAULO'


-- tratamento de dadas

-- soma de datas interval

select current_date + 10

select (current_date + interval '10 weeks')::date

-- truncagem de datas

select visit_page_date, count(*)
from sales.funnel
group by visit_page_date
order by visit_page_date desc


select date_trunc('year', visit_page_date)::date as visit_page_month,
	count(*)
from sales.funnel
group by visit_page_month


-- extração de unidades de uma data utilizando extract

select
	'2021-01-30'::data
	extract ('dow' from '2022:01:30':: date)


select
	extract ('dow' from visit_page_date) as dias_da_semana,
	count(*)
from sales.funnel
group by dia_da_semana
order by dia_da_semana

-- diferençã entre dados com operador de subtração

select (current_date - '2018-01-01')


----------------------------------------------------------------------------------------------------------------

-- crie função chamada datediff para calcular a difenrença entre

CREATE FUNCTION datediff(unidade VARCHAR, data_inicial DATE, data_final DATE)
RETURNS INTEGER
LANGUAGE SQL
AS $$
    SELECT
        CASE
            WHEN unidade IN ('d', 'day', 'days') THEN (data_final - data_inicial)
            WHEN unidade IN ('w', 'week', 'weeks') THEN (data_final - data_inicial) / 7
            WHEN unidade IN ('m', 'month', 'months') THEN (data_final - data_inicial) / 30
            WHEN unidade IN ('y', 'year', 'years') THEN (data_final - data_inicial) / 365
        END
$$;



select datediff('day','2021-02-04', current_date)

-- delete a função datediff

drop function datediff

----------------------------------------------------------------------------------------------------------------

-- criação de tabela a partir de uma query

select 
	customer_id, datediff('years', birth_date, current_date) idade_cliente
	into temp_tables.customer_age
from sales.customers

select *
from temp_tables.customers_age


-- criação de uma tabela a partir do zero

select distinct professional_status
from sales.customers

create table temp_tables.profissoes (	
	professional_status varchar,
	status_profissional varchar


)

insert into temp_tables.profissoes
(professional_status, status_profissional)

values
()

-- deleção de tabelas

drop table temp_tables.profissoes

----------------------------------------------------------------------------------------------------------

-- inserção de linhas

insert into temp_tables.profissoes 
(professional_status, status_profissional)

values
('unemployed', 'desempregado(a)')
('trainee', 'estagiario')

-- atualização de linhas

update temp_tables.profissoes
set professional_status = 'intern'
where status_profissional = 'estagiario'

-- deleção de linhas

delete from temp_tables.profissoes
where status_profissional = ' desempregado'
or status_profissional = 'estagiario'


--------------------------------------------------------------------------------------------------------------

-- inserção de colunas

alter table sales.customers
add customer_age int

update sales.customers
set customer_age = datediff('years', birth_date, current_date)
where true

select * from sales.customers limit 10


-- alteração do tipo da coluna

alter table sales.customers
alter column customer_age type varchar

-- alteração do nome da coluna

alter table sales.customers
rename column customer_age to age

-- deleção de coluna

alter table sales.customers
drop column age

