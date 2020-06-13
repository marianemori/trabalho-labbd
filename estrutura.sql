-- Database: pgwvkazw

-- DROP DATABASE pgwvkazw;

-- Database criado no Elephant, usando o pgAdmin
CREATE DATABASE pgwvkazw
    WITH 
    OWNER = pgwvkazw
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

-- SCHEMA: imobiliaria
-- DROP SCHEMA "imobiliaria" ;
CREATE SCHEMA "imobiliaria"
    AUTHORIZATION pgwvkazw;

SET search_path TO "imobiliaria";

CREATE TABLE imovel(
	id_imovel integer NOT NULL,
	tipo_imovel varchar(30) NOT NULL,
	status boolean NOT NULL,
	foto varchar(50) NOT NULL,
	data_construcao date NOT NULL,
	area numeric,
	valor_real decimal NOT NULL,
	valor_imobiliaria decimal NOT NULL, 
	data_disp date NOT NULL, 
	rua varchar(30) NOT NULL,
	numero integer NOT NULL,
	bairro varchar(20) NOT NULL,
	cidade varchar(30) NOT NULL,
	estado varchar(30) NOT NULL
	);

CREATE TABLE casa(
	id_casa integer NOT NULL,
	qtd_quartos integer NOT NULL,
	qtd_suites integer,
	qtd_salaestar integer NOT NULL, 
	qtd_salajantar integer, 
	num_vagas integer NOT NULL,
	armario boolean NOT NULL,
	descricao varchar(100)
	);

CREATE TABLE apartamento(
	id_apt integer NOT NULL,
	qtd_quartos integer NOT NULL,
	qtd_suites integer,
	qtd_salaestar integer NOT NULL, 
	qtd_salajantar integer, 
	num_vagas integer NOT NULL,
	armario boolean NOT NULL,
	descricao varchar(100),
	andar integer NOT NULL,
	valor_condominio decimal NOT NULL,
	portaria boolean NOT NULL
	);

CREATE TABLE comercial(
	id_comerc integer NOT NULL,
	qtd_banheiros integer NOT NULL,
	qtd_comodos integer NOT NULL
	);

CREATE TABLE terreno(
	id_terreno integer NOT NULL,
	largura decimal NOT NULL,
	comprimento decimal NOT NULL,
	declive varchar(8) NOT NULL
	);

CREATE TABLE cliente(
    id_cliente integer NOT NULL,
	cpf varchar(11) NOT NULL,
	nome varchar(40) NOT NULL,
	telefone varchar(15) NOT NULL,
	sexo char NOT NULL,
	estado_civil varchar(30) NOT NULL,
	profissao varchar(40) NOT NULL,
	rua varchar(30) NOT NULL,
	numero integer NOT NULL,
	bairro varchar(20) NOT NULL,
	cidade varchar(30) NOT NULL,
	estado varchar(30) NOT NULL,
	CONSTRAINT empregado_sexo_check CHECK ((sexo = ANY (ARRAY['F'::bpchar, 'M'::bpchar])))
	);

CREATE TABLE funcionario(
    id_func integer NOT NULL,
	cpf varchar(11) NOT NULL,
	id_cargo integer NOT NULL,
	nome varchar(40) NOT NULL,
	tel_contato varchar(15) NOT NULL,
	tel_celular varchar(15),
	data_ingresso date NOT NULL,
	salario_liquido decimal NOT NULL,
	usuario varchar(50) NOT NULL,
	senha varchar(128) NOT NULL,
	rua varchar(30) NOT NULL,
	numero integer NOT NULL,
	bairro varchar(20) NOT NULL,
	cidade varchar(30) NOT NULL,
	estado varchar(30)NOT NULL
	);

CREATE TABLE cargo(
	id integer NOT NULL,
	nome varchar(40) NOT NULL,
	salario decimal NOT NULL
	);

CREATE TABLE forma_pagamento(
	id_pagar integer NOT NULL,
	forma varchar(40) NOT NULL
	);

CREATE TABLE contrato(
	id_contrato integer NOT NULL,
	comissao decimal NOT NULL,
	data_trans date NOT NULL,
	forma_pag varchar(40) NOT NULL,
	funcionario integer NOT NULL,
	imovel_id integer NOT NULL
	);

CREATE TABLE aluga(
	id_aluguel integer NOT NULL,
	cliente_cpf varchar(11) NOT NULL,
	data date NOT NULL,
	contrato integer NOT NULL,
	fiador varchar(100) NOT NULL,
	indicacao varchar(100) NOT NULL
	);

CREATE TABLE compra(
	id_compra integer NOT NULL,
	cliente_cpf varchar(11) NOT NULL,
	data date NOT NULL,
	contrato integer NOT NULL
	);

CREATE TABLE pertence(
	id_pertence integer NOT NULL,
	cliente_cpf varchar(11) NOT NULL,
	imovel integer NOT NULL
	);
