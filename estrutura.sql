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
	id_imovel integer SERIAL NOT NULL,
	estado_atual boolean NOT NULL,
	foto bytea NOT NULL,
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
	qtd_quartos integer NOT NULL,
	qtd_suites integer,
	qtd_salaestar integer NOT NULL, 
	qtd_salajantar integer, 
	num_vagas integer NOT NULL,
	armario boolean NOT NULL,
	descricao varchar(100)
	)INHERITS(imovel);

CREATE TABLE condominio(
	id_cond integer NOT NULL,
	nome varchar(40) NOT NULL,
	portaria boolean NOT NULL,
	academia boolean NOT NULL,
	valor_condominio decimal NOT NULL,
	)

CREATE TABLE apartamento(
	qtd_quartos integer NOT NULL,
	qtd_suites integer,
	qtd_salaestar integer NOT NULL, 
	qtd_salajantar integer, 
	num_vagas integer NOT NULL,
	armario boolean NOT NULL,
	descricao varchar(100),
	andar integer NOT NULL,
	condominio integer NOT NULL
	)INHERITS(imovel);

CREATE TABLE comercial(
	qtd_banheiros integer NOT NULL,
	qtd_comodos integer NOT NULL,
	)INHERITS(imovel);

CREATE TABLE terreno(
	largura decimal NOT NULL,
	comprimento decimal NOT NULL,
	declive varchar(8) NOT NULL
)INHERITS(imovel);

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
	comprador BOOLEAN,
	locatario BOOLEAN,
	proprietario BOOLEAN,
	email varchar(100) NOT NULL,
	CONSTRAINT empregado_sexo_check CHECK ((sexo = ANY (ARRAY['F'::bpchar, 'M'::bpchar])))
	);

CREATE TABLE funcionario(
	cpf varchar(11) NOT NULL,
	cargo varchar(100) NOT NULL,
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

CREATE TABLE contrato(
	id_contrato integer SERIAL NOT NULL,
	comissao decimal NOT NULL,
	data_trans date NOT NULL,
	forma_pag varchar(100) NOT NULL,
	funcionario varchar(11) NOT NULL,
	imovel_id integer NOT NULL,
	fiador varchar(100),
	indicacoes varchar(100),
	transacao varchar(50) NOT NULL,
	id_cliente integer NOT NULL
);

CREATE TABLE fiscaliza(
	situacao varchar(200) NOT NULL,
	data_fisc date NOT NULL,
	funcionario varchar(11) NOT NULL,
	imovel integer NOT NULL
	);


--- INSERINDO CHAVES PRIMARIAS ---------
ALTER TABLE imovel
	ADD CONSTRAINT imovel_pkey PRIMARY KEY (id_imovel);

ALTER TABLE condominio
	ADD CONSTRAINT condominio_pkey PRIMARY KEY (id_cond);

ALTER TABLE cliente
	ADD CONSTRAINT cliente_pkey PRIMARY KEY (cpf);

ALTER TABLE funcionario
	ADD CONSTRAINT func_pkey PRIMARY KEY (cpf);

ALTER TABLE contrato
	ADD CONSTRAINT contrato_pkey PRIMARY KEY (id_contrato);

ALTER TABLE fiscaliza
	ADD CONSTRAINT fiscaliza_pkey PRIMARY KEY (data_fisc);

-----  INSERINDO CHAVES ESTRANGEIRAS --------------

ALTER TABLE apartamento
    ADD CONSTRAINT apt_condominio FOREIGN KEY (condominio) REFERENCES condominio(id_cond);

ALTER TABLE contrato
    ADD CONSTRAINT cliente_contrato FOREIGN KEY (cliente) REFERENCES cliente(cpf);

ALTER TABLE contrato
    ADD CONSTRAINT funcionario_contrato FOREIGN KEY (funcionario) REFERENCES funcionario(cpf);

ALTER TABLE contrato
    ADD CONSTRAINT imovel_contrato FOREIGN KEY (imovel_id) REFERENCES imovel(id_imovel);

ALTER TABLE fiscaliza
    ADD CONSTRAINT fiscaliza_funcionario FOREIGN KEY (funcionario) REFERENCES funcionario(cpf);

ALTER TABLE fiscaliza
    ADD CONSTRAINT fiscaliza_imovel FOREIGN KEY (imovel) REFERENCES imovel(id_imovel);

---- Trigger histórico -----------

create or replace function copiar_para_histórico() RETURN TRIGGER AS $$
	BEGIN
		INSERT INTO Historico(new.id_contrato, new.comissao, new.data_trans, new.forma_pag, new.funcionario, new.imovel_id, new.fiado, new.indicacoes, new.transacao, new.id_cliente)
		return NEW
	END;
$$ language 'plpgsql';

create trigger copiar_contrato
before insert or update on contrato
for each ROWexecute procedure copiar_para_histórico()

-----------------------------------------------------------------