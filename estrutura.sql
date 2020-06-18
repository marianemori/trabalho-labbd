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

CREATE TABLE condominio(
	id_cond integer NOT NULL,
	nome varchar(40) NOT NULL,
	portaria boolean NOT NULL,
	academia boolean NOT NULL
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
	condominio integer NOT NULL
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
	forma_pag integer NOT NULL,
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

CREATE TABLE fiscaliza(
	id_fiscaliza integer NOT NULL,
	situacao varchar(200) NOT NULL,
	data date NOT NULL,
	funcionario varchar(11) NOT NULL,
	imovel integer NOT NULL
	);

ALTER TABLE imovel
	ADD CONSTRAINT imovel_pkey PRIMARY KEY (id_imovel);

ALTER TABLE casa
	ADD CONSTRAINT casa_pkey PRIMARY KEY (id_casa);

ALTER TABLE condominio
	ADD CONSTRAINT condominio_pkey PRIMARY KEY (id_cond);

ALTER TABLE apartamento
	ADD CONSTRAINT apartamento_pkey PRIMARY KEY (id_apt);

ALTER TABLE comercial
	ADD CONSTRAINT comercial_pkey PRIMARY KEY (id_comerc);

ALTER TABLE terreno
	ADD CONSTRAINT terreno_pkey PRIMARY KEY (id_terreno);

ALTER TABLE cliente
	ADD CONSTRAINT cliente_pkey PRIMARY KEY (cpf);

ALTER TABLE funcionario
	ADD CONSTRAINT func_pkey PRIMARY KEY (id_func);

ALTER TABLE cargo
	ADD CONSTRAINT cargo_pkey PRIMARY KEY (id);

ALTER TABLE forma_pagamento
	ADD CONSTRAINT pagamento_pkey PRIMARY KEY (id_pagar);

ALTER TABLE contrato
	ADD CONSTRAINT contrato_pkey PRIMARY KEY (id_contrato);

ALTER TABLE aluga
	ADD CONSTRAINT aluga_pkey PRIMARY KEY (id_aluguel);

ALTER TABLE pertence
	ADD CONSTRAINT pertence_pkey PRIMARY KEY (id_pertence);

ALTER TABLE fiscaliza
	ADD CONSTRAINT fiscaliza_pkey PRIMARY KEY id_fiscaliza);

ALTER TABLE imovel
    ADD CONSTRAINT imovel_casa FOREIGN KEY (id_imovel) REFERENCES casa(id_casa);

ALTER TABLE imovel
    ADD CONSTRAINT imovel_apt FOREIGN KEY (id_imovel) REFERENCES apartamento(id_apt);

ALTER TABLE imovel
    ADD CONSTRAINT imovel_comercial FOREIGN KEY (id_imovel) REFERENCES comercial(id_comerc);

ALTER TABLE imovel
    ADD CONSTRAINT imovel_terreno FOREIGN KEY (id_imovel) REFERENCES terreno(id_terreno);

ALTER TABLE apartamento
    ADD CONSTRAINT apt_condominio FOREIGN KEY (condominio) REFERENCES condominio(id_cond);

ALTER TABLE funcionario
    ADD CONSTRAINT cargo_func FOREIGN KEY (id_cargo) REFERENCES cargo(id);

ALTER TABLE contrato
    ADD CONSTRAINT pagamento_contrato FOREIGN KEY (forma_pag) REFERENCES forma_pagamento(id_pagar);

ALTER TABLE contrato
    ADD CONSTRAINT funcionario_contrato FOREIGN KEY (funcionario) REFERENCES funcionario(id_func);

ALTER TABLE contrato
    ADD CONSTRAINT imovel_contrato FOREIGN KEY (imovel_id) REFERENCES imovel(id_imovel);

ALTER TABLE aluga
    ADD CONSTRAINT aluguel_contrato FOREIGN KEY (contrato) REFERENCES contrato(id_contrato);

ALTER TABLE aluga
    ADD CONSTRAINT aluguel_cliente FOREIGN KEY (cliente_cpf) REFERENCES cliente(cpf);

ALTER TABLE compra
    ADD CONSTRAINT compra_cliente FOREIGN KEY (cliente_cpf) REFERENCES cliente(cpf);

ALTER TABLE compra
    ADD CONSTRAINT compra_contrato FOREIGN KEY (contrato) REFERENCES contrato(id_contrato);

ALTER TABLE pertence
    ADD CONSTRAINT pertence_cliente FOREIGN KEY (cliente_cpf) REFERENCES cliente(cpf);

ALTER TABLE pertence
    ADD CONSTRAINT pertence_imovel FOREIGN KEY (imovel) REFERENCES imovel(id_imovel);

ALTER TABLE fiscaliza
    ADD CONSTRAINT fiscaliza_funcionario FOREIGN KEY (funcionario) REFERENCES funcionario(cpf);

ALTER TABLE fiscaliza
    ADD CONSTRAINT fiscaliza_imovel FOREIGN KEY (imovel) REFERENCES imovel(id_imovel);