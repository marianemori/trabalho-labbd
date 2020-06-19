-- 1. Consulta dos imóveis que não foram fiscalizados, ordenados pela cidade
select id_imovel, cidade
from imovel
except 
(select f.id_imovel, cidade
from fiscaliza f join imovel i
on i.id_imovel = f.id_imovel
)
order by cidade

-- 2. Consulta dos imóveis localizados em São Paulo que foram colocados a venda
select i.id_imovel, i.cidade
from imovel i join contrato c
on i.id_imovel = c.imovel_id
where i.cidade = 'São Paulo' and transacao = 'venda'

-- 3. Consulta dos funcionarios que fizeram fiscalização no ano 2020
select func.nome as funcionario, fisc.data_fisc as data_fiscalizacao
from funcionario func join fiscaliza fisc
on fisc.funcionario = func.cpf
where (extract(year from fisc.data_fisc) = '2020')

-- 4. Consulta dos bairros que mais houveram contratos, ordenado pela quantidade
select bairro, count(id_contrato) as quantidade
from contrato join imovel
on imovel_id = id_imovel
group by bairro
order by quantidade desc limit 3

-- 5. Consulta do ganho total da imobiliária com os contratos de 2019
select sum(valor_imobiliaria) as valor_total
from imovel i join contrato c
on i.id_imovel = c.imovel_id
where (extract(year from c.data_trans) = '2019')

-- 6. Consulta de todos os clientes que compraram uma casa
select cliente.nome as clientes, casa.descricao as descricao_imovel
from cliente join contrato
on cliente.cpf = contrato.cliente
join casa 
on contrato.imovel_id = casa.id_imovel
where contrato.transacao = 'compra'

-- 7. Consulta do funcionário que mais recebeu a maior comissão
select f.nome as funcionario, max(comissao)
from funcionario f join contrato c
on f.cpf = c.funcionario
group by f.nome limit 1

--8. Consulta dos apartamentos que estão no primeiro andar e estão em condomínio com portaria 24h
select a.id_imovel as apartamento, c.nome as condominio
from apartamento a join condominio c
on a.id_cond = c.id_cond
where a.andar = 1 and portaria = true

-- 9. Consulta da média dos valores dos imoveis que foram construidos em 2014
select TRUNC(avg(valor_real),2) as media
from imovel
where (extract(year from data_construcao) = '2014')

-- 10. Consulta dos imóveis localizados em Campo Grande que são mais baratos, por ordem crescente de preço
select id_imovel as imovel, valor_real as preco
from imovel
where cidade = 'Campo Grande'
order by preco
