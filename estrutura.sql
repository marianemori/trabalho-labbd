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

CREATE TABLE casa(
	id_casa integer SERIAL NOT NULL,
	estado_atual boolean NOT NULL,
	foto bytea NOT NULL,  --armazena os bytes da foto
	data_construcao date NOT NULL,
	area numeric,
	valor_real decimal NOT NULL,
	valor_imobiliaria decimal NOT NULL, 
	data_disp date NOT NULL, 
	rua varchar(30) NOT NULL,
	numero integer NOT NULL,
	bairro varchar(20) NOT NULL,
	cidade varchar(30) NOT NULL,
	estado varchar(30) NOT NULL,
	qtd_quartos integer NOT NULL,
	qtd_suites integer,
	qtd_salaestar integer NOT NULL, 
	qtd_salajantar integer, 
	num_vagas integer NOT NULL,
	armario boolean NOT NULL,
	descricao varchar(100)
	);

CREATE TABLE apartamento(
	id_apt integer SERIAL NOT NULL, -
	estado_atual boolean NOT NULL,
	foto bytea NOT NULL,  --armazena os bytes da foto
	data_construcao date NOT NULL,
	area numeric,
	valor_real decimal NOT NULL,
	valor_imobiliaria decimal NOT NULL, 
	data_disp date NOT NULL, 
	rua varchar(30) NOT NULL,
	numero integer NOT NULL,
	bairro varchar(20) NOT NULL,
	cidade varchar(30) NOT NULL,
	estado varchar(30) NOT NULL,
	qtd_quartos integer NOT NULL,
	qtd_suites integer,
	qtd_salaestar integer NOT NULL, 
	qtd_salajantar integer, 
	num_vagas integer NOT NULL,
	armario boolean NOT NULL,
	descricao varchar(100),
	andar integer NOT NULL,
	valor_condominio decimal NOT NULL
	);

CREATE TABLE comercial(
	id_comerc integer SERIAL NOT NULL, -
	estado_atual boolean NOT NULL,
	foto bytea NOT NULL,  --armazena os bytes da foto
	data_construcao date NOT NULL,
	area numeric,
	valor_real decimal NOT NULL,
	valor_imobiliaria decimal NOT NULL, 
	data_disp date NOT NULL, 
	rua varchar(30) NOT NULL,
	numero integer NOT NULL,
	bairro varchar(20) NOT NULL,
	cidade varchar(30) NOT NULL,
	estado varchar(30) NOT NULL,
	qtd_banheiros integer NOT NULL,
	qtd_comodos integer NOT NULL
	);

CREATE TABLE terreno(
	id_terreno integer SERIAL NOT NULL, -
	estado_atual boolean NOT NULL,
	foto bytea NOT NULL,  --armazena os bytes da foto
	data_construcao date NOT NULL,
	area numeric,
	valor_real decimal NOT NULL,
	valor_imobiliaria decimal NOT NULL, 
	data_disp date NOT NULL, 
	rua varchar(30) NOT NULL,
	numero integer NOT NULL,
	bairro varchar(20) NOT NULL,
	cidade varchar(30) NOT NULL,
	estado varchar(30) NOT NULL,
	largura decimal NOT NULL,
	comprimento decimal NOT NULL,
	declive varchar(8) NOT NULL
	);

CREATE TABLE cliente(
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
	comprador BOOLEAN NOT NULL,
	locatario BOOLEAN NOT NULL,
	proprietario boolean NOT NULL,
	email varchar(100) NOT NULL,
	CONSTRAINT empregado_sexo_check CHECK ((sexo = ANY (ARRAY['F'::bpchar, 'M'::bpchar])))
	);

CREATE TABLE funcionario(
	cpf varchar(11) NOT NULL,
	cargo varchar(100) NOT NULL,
	nome varchar(50) NOT NULL,
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

CREATE TABLE RealizaContrato(
	num_contrato integer NOT NULL,
	comissao decimal NOT NULL,
	data_trans date NOT NULL,
	forma_pag integer NOT NULL,
	fiador varchar(100), -- pelo menos um e somente aluguel
	indicacoes varchar(100), -- confirmar como fazer, pelo menos 2 e somento aluguel
	tipo_transacao varchar(100) NOT NULL
	id_casa integer,
	id_comercial integer,
	id_terreno integer,
	id_apartamento integer,
	cpf_funcionario varchar(11) NOT NULL,
	cpf_ClienteDono varchar(11) NOT NULL,
	cpf_ClienteInteressado varchar(11) NOT NULL --esse é o cara que pode ser comprador ou locatário
);

CREATE TABLE fiscaliza(
	situacao varchar(200) NOT NULL,
	data date NOT NULL,
	id_casa integer,
	id_comercial integer,
	id_terreno integer,
	id_apartamento integer
);


--- INSERINDO CHAVES PRIMARIAS --- 

ALTER TABLE casa
	ADD CONSTRAINT casa_pkey PRIMARY KEY (id_casa);

ALTER TABLE apartamento
	ADD CONSTRAINT apartamento_pkey PRIMARY KEY (id_apt);

ALTER TABLE comercial
	ADD CONSTRAINT comercial_pkey PRIMARY KEY (id_comerc);

ALTER TABLE terreno
	ADD CONSTRAINT terreno_pkey PRIMARY KEY (id_terreno);

ALTER TABLE cliente
	ADD CONSTRAINT cliente_pkey PRIMARY KEY (cpf);

ALTER TABLE funcionario
	ADD CONSTRAINT func_pkey PRIMARY KEY (cpf);

ALTER TABLE contrato
	ADD CONSTRAINT contrato_pkey PRIMARY KEY (num_contrato);

ALTER TABLE fiscaliza
	ADD CONSTRAINT fiscaliza_pkey PRIMARY KEY id_fiscaliza);

--- CHAVES ESTRANGEIRAS ---

ALTER TABLE fiscaliza
    ADD CONSTRAINT fiscaliza_funcionario FOREIGN KEY (funcionario) REFERENCES funcionario(cpf);

ALTER TABLE fiscaliza
    ADD CONSTRAINT fiscaliza_imovel FOREIGN KEY (imovel) REFERENCES imovel(id_imovel);

ALTER TABLE contrato
    ADD CONSTRAINT pagamento_contrato FOREIGN KEY (forma_pag) REFERENCES forma_pagamento(id_pagar);

ALTER TABLE contrato
    ADD CONSTRAINT funcionario_contrato FOREIGN KEY (funcionario) REFERENCES funcionario(cpf);

ALTER TABLE contrato
    ADD CONSTRAINT imovel_contrato FOREIGN KEY (imovel_id) REFERENCES imovel(id_imovel);

--foreign key ATRIBUTO EXISTENTE references TABELA(VARIAVEL DA TABELA)