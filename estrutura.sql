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
	id_imovel integer UNIQUE NOT NULL,
	estado_atual varchar(20) NOT NULL,
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
	id_imovel integer NOT NULL,
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
	academia boolean NOT NULL,
	valor_condominio decimal NOT NULL
);

CREATE TABLE apartamento(
	id_imovel integer NOT NULL,
	qtd_quartos integer NOT NULL,
	qtd_suites integer,
	qtd_salaestar integer NOT NULL, 
	qtd_salajantar integer, 
	num_vagas integer NOT NULL,
	armario boolean NOT NULL,
	descricao varchar(100),
	andar integer NOT NULL,
	id_cond integer NOT NULL
	);

CREATE TABLE comercial(
	id_imovel integer NOT NULL,
	qtd_banheiros integer NOT NULL,
	qtd_comodos integer NOT NULL
	);

CREATE TABLE terreno(
	id_imovel integer NOT NULL,
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
	id_contrato integer UNIQUE NOT NULL,
	comissao decimal NOT NULL,
	data_trans date NOT NULL,
	forma_pag varchar(100) NOT NULL,
	funcionario varchar(11) NOT NULL,
	imovel_id integer NOT NULL,
	fiador varchar(100),
	indicacoes varchar(100),
	transacao varchar(50) NOT NULL,
	cliente varchar(11) NOT NULL                     
);

CREATE TABLE fiscaliza(
	situacao varchar(200) NOT NULL,
	data_fisc date NOT NULL,
	funcionario varchar(11) NOT NULL,
	id_imovel integer NOT NULL
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
    ADD CONSTRAINT apt_condominio FOREIGN KEY (id_cond) REFERENCES condominio(id_cond);

ALTER TABLE contrato
    ADD CONSTRAINT cliente FOREIGN KEY (cliente) REFERENCES cliente(cpf);

ALTER TABLE contrato
    ADD CONSTRAINT funcionario_contrato FOREIGN KEY (funcionario) REFERENCES funcionario(cpf);

ALTER TABLE contrato
    ADD CONSTRAINT imovel_contrato FOREIGN KEY (imovel_id) REFERENCES imovel(id_imovel);

ALTER TABLE fiscaliza
    ADD CONSTRAINT fiscaliza_funcionario FOREIGN KEY (funcionario) REFERENCES funcionario(cpf);

ALTER TABLE fiscaliza
    ADD CONSTRAINT fiscaliza_imovel FOREIGN KEY (id_imovel) REFERENCES imovel(id_imovel);

ALTER TABLE casa
    ADD CONSTRAINT imovel_casa FOREIGN KEY (id_imovel) REFERENCES imovel(id_imovel);

ALTER TABLE apartamento
    ADD CONSTRAINT imovel_apt FOREIGN KEY (id_imovel) REFERENCES imovel(id_imovel);

ALTER TABLE comercial
    ADD CONSTRAINT imovel_comercial FOREIGN KEY (id_imovel) REFERENCES imovel(id_imovel);

ALTER TABLE terreno
    ADD CONSTRAINT imovel_terreno FOREIGN KEY (id_imovel) REFERENCES imovel(id_imovel);

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

--------------- Inserções ----------------------
             -- Cliente ---
insert into cliente (cpf, nome, telefone, sexo, estado_civil, profissao, rua, numero, bairro, cidade, estado, comprador, locatario, proprietario, email) values ('12345678912', 'cleyton', '1199999999', 'M', 'Solteiro', 'Professor', 'dua lipa', 20, 'nostalgia', 'Rio de janeiro', 'RJ', false, true, false, 'cleytinho@hotmail.com' );
insert into cliente (cpf, nome, telefone, sexo, estado_civil, profissao, rua, numero, bairro, cidade, estado, comprador, locatario, proprietario, email) values ('00987765213', 'Ana carolina', '1188888888', 'F', 'Casada', 'Cantora', 'Lady gaga', 32, 'Chromatica', 'Natal', 'RN', true, false, false, 'anacarolinda@hotmail.com');
insert into cliente (cpf, nome, telefone, sexo, estado_civil, profissao, rua, numero, bairro, cidade, estado, comprador, locatario, proprietario, email) values ('93989182938', 'Robson', '1177777777', 'M', 'Casado', 'Engenheiro Civil', 'Doja Cat', 27, 'Amalia', 'São paulo', 'São Paulo', true, false, false, 'robsonmuitopegadorele@hotmail.com');
insert into cliente (cpf, nome, telefone, sexo, estado_civil, profissao, rua, numero, bairro, cidade, estado, comprador, locatario, proprietario, email) values ('88888888888', 'Martinho', '7399999999', 'M', 'Casado', 'Medico', 'Anitta', 85, 'kisses', 'palmas', 'TO', false, false, true, 'martin@hotmail.com');
insert into cliente (cpf, nome, telefone, sexo, estado_civil, profissao, rua, numero, bairro, cidade, estado, comprador, locatario, proprietario, email) values ('21234567893', 'Juliano', '739876542', 'M', 'Solteiro', 'Agente da shield', 'beyonce', 65, 'lemonade', 'joinville', 'SC', false, false, true, 'julinho@hotmail.com');
insert into cliente (cpf, nome, telefone, sexo, estado_civil, profissao, rua, numero, bairro, cidade, estado, comprador, locatario, proprietario, email) values ('54328901234', 'Jurema', '886543234', 'F', 'Solteira', 'Vingadora', 'Pablo vittar', 20, '111', 'vitória', 'ES', false, false, true, 'xureminha@hotmail.com');
insert into cliente (cpf, nome, telefone, sexo, estado_civil, profissao, rua, numero, bairro, cidade, estado, comprador, locatario, proprietario, email) values ('34569876546', 'Natalia', '1166666666', 'F', 'Casada', 'Engenheira Aeronáutica', 'Carlie XCX', 77, 'Charli', 'porto alegre', 'RS', true, false, false, 'natimaravilhosa@hotmail.com');
insert into cliente (cpf, nome, telefone, sexo, estado_civil, profissao, rua, numero, bairro, cidade, estado, comprador, locatario, proprietario, email) values ('23456098765', 'Samira closa', '1122222222', 'F', 'Solteira', 'Empresária', 'Gloria groove', 53, 'Alegoria', 'Recife', 'PE', false, true, false, 'closecertoprovale@hotmail.com');
insert into cliente (cpf, nome, telefone, sexo, estado_civil, profissao, rua, numero, bairro, cidade, estado, comprador, locatario, proprietario, email) values ('56982345651', 'Carter', '1111111111', 'F', 'Casada', 'Diretora da Shield', 'Aretuza lovi', 45, 'Mercadinho', 'Porto de galinhas', 'PE', false, true, false, 'agentecarter@hotmail.com');
insert into cliente (cpf, nome, telefone, sexo, estado_civil, profissao, rua, numero, bairro, cidade, estado, comprador, locatario, proprietario, email) values ('76272126162', 'Marquinhos', '5555555555', 'M', 'Solteiro', 'Desenvolvedor', 'Ariana Grande', 56, 'Thank u, next', 'salvador', 'BA', false, false, true, 'marquinholittlemonster@hotmail.com');


            --Funcionario---

insert into funcionario (cpf, cargo, nome, tel_contato, tel_celular, data_ingresso, salario_liquido, usuario, senha, rua, numero, bairro, cidade, estado) values ('77777888888', 'Gerente', 'Cher', '1165738787', '11999881111', '1960-06-20', 15000, 'APrimeiraDiva', 'ninguemmesubstitui', 'Sam Smith', 80, 'im ready', 'são paulo', 'SP');
insert into funcionario (cpf, cargo, nome, tel_contato, tel_celular, data_ingresso, salario_liquido, usuario, senha, rua, numero, bairro, cidade, estado) values ('66663333221', 'Vendedor', 'Madonna', '1170707070', '11970707070', '1990-06-01', 5000, 'MotherDasMaricona', 'ArrasoMuito', 'Miley Cyrus', 02, 'she is comming', 'são paulo', 'SP');
insert into funcionario (cpf, cargo, nome, tel_contato, tel_celular, data_ingresso, salario_liquido, usuario, senha, rua, numero, bairro, cidade, estado) values ('99999955555', 'Vendedor', 'Britney', '1140028922', '11969692424', '1997-07-16', 5000, 'LanceiAfarofa', 'donadaforadoseculo21', 'katy perry', 24, 'witness', 'são paulo', 'SP');

			-- Imovel ---
insert into imovel (id_imovel, estado_atual, foto, data_construcao, area, valor_real, valor_imobiliaria, data_disp, rua, numero, bairro, cidade, estado) values (11, 'Excelente', '0101010101', '2010-12-12', 23, 900000, 15000, '2012-01-20', 'alice', 10, 'chromatica', 'itacare', 'BA');
insert into imovel (id_imovel, estado_atual, foto, data_construcao, area, valor_real, valor_imobiliaria, data_disp, rua, numero, bairro, cidade, estado) values (12, 'Bom', '0101010101', '2015-10-01', 130, 400000, 10000, '2017-02-02', 'free woman', 5, 'chromatica', 'itacare', 'BA');
insert into imovel (id_imovel, estado_atual, foto, data_construcao, area, valor_real, valor_imobiliaria, data_disp, rua, numero, bairro, cidade, estado) values (13, 'Bom', '0101010101', '2014-06-07', 150, 350000, 10000, '2014-12-12', 'ouro', 24, '111', 'guaruja', 'SP');
insert into imovel (id_imovel, estado_atual, foto, data_construcao, area, valor_real, valor_imobiliaria, data_disp, rua, numero, bairro, cidade, estado) values (14, 'Bom', '0101010101', '2011-10-10', 100, 350000, 10000, '2012-01-01', 'rajadão', 2, '111', 'guaruja', 'SP' );
insert into imovel (id_imovel, estado_atual, foto, data_construcao, area, valor_real, valor_imobiliaria, data_disp, rua, numero, bairro, cidade, estado) values (15, 'Regular', '0101010101', '2012-12-01', 120, 400000, 150000, '2013-02-05', 'physical', 55, 'nostalgia', 'vitoria', 'ES');
insert into imovel (id_imovel, estado_atual, foto, data_construcao, area, valor_real, valor_imobiliaria, data_disp, rua, numero, bairro, cidade, estado) values (21, true, '0101010101', '2019-01-01', 120, 500000, 20000, '2020-02-02', 'bad romance', 456, 'fame monster', 'recife', 'PE');
insert into imovel (id_imovel, estado_atual, foto, data_construcao, area, valor_real, valor_imobiliaria, data_disp, rua, numero, bairro, cidade, estado) values (22, true, '0101010101', '2015-01-01', 150, 800000, 20000, '2017-02-02', 'bad romance', 456, 'fame monster', 'recife', 'PE');
insert into imovel (id_imovel, estado_atual, foto, data_construcao, area, valor_real, valor_imobiliaria, data_disp, rua, numero, bairro, cidade, estado) values (23, true, '0101010101', '2014-01-01', 76, 400000, 20000, '2015-02-02', 'guy', 23, 'artpop', 'Natal', 'RN');
insert into imovel (id_imovel, estado_atual, foto, data_construcao, area, valor_real, valor_imobiliaria, data_disp, rua, numero, bairro, cidade, estado) values (24, true, '0101010101', '2013-01-01', 97, 450000, 20000, '2015-02-02', 'guy', 23, 'artpop', 'Natal', 'RN');
insert into imovel (id_imovel, estado_atual, foto, data_construcao, area, valor_real, valor_imobiliaria, data_disp, rua, numero, bairro, cidade, estado) values (25, true, '0101010101', '2012-01-01', 85, 400000, 20000, '2014-02-02', 'buzina', 65, 'não para não', 'Campo Grande', 'MS');
insert into imovel (id_imovel, estado_atual, foto, data_construcao, area, valor_real, valor_imobiliaria, data_disp, rua, numero, bairro, cidade, estado) values (31, true, '0101010101', '2015-01-01', 50, 200000, 10000, '2016-02-02', 'immortal', 1124, 'fallen', 'São Paulo', 'SP');
insert into imovel (id_imovel, estado_atual, foto, data_construcao, area, valor_real, valor_imobiliaria, data_disp, rua, numero, bairro, cidade, estado) values (32, true, '0101010101', '2013-01-01', 35, 150000, 10000, '2014-02-02', 'broken', 2134, 'seether', 'Cuiaba', 'MT');
insert into imovel (id_imovel, estado_atual, foto, data_construcao, area, valor_real, valor_imobiliaria, data_disp, rua, numero, bairro, cidade, estado) values (33, true, '0101010101', '2014-01-01', 35, 150000, 10000, '2015-02-02', 'good enough', 4567, 'the open door', 'Cuiaba', 'MT');
insert into imovel (id_imovel, estado_atual, foto, data_construcao, area, valor_real, valor_imobiliaria, data_disp, rua, numero, bairro, cidade, estado) values (34, true, '0101010101', '2016-01-01', 80, 300000, 10000, '2017-02-02', 'Lithium', 7654, 'fallen', 'São Paulo', 'SP');
insert into imovel (id_imovel, estado_atual, foto, data_construcao, area, valor_real, valor_imobiliaria, data_disp, rua, numero, bairro, cidade, estado) values (35, true, '0101010101', '2018-01-01', 80, 300000, 10000, '2019-02-02', 'juicy', 8976, 'Hot Pink', 'Campo Grande', 'MS');
insert into imovel (id_imovel, estado_atual, foto, data_construcao, area, valor_real, valor_imobiliaria, data_disp, rua, numero, bairro, cidade, estado) values (36, true, '0101010101', '2010-01-01', 60, 250000, 10000, '2012-02-02', 'Rules', 7623, 'Hot Pink', 'Campo Grande', 'MS');
insert into imovel (id_imovel, estado_atual, foto, data_construcao, area, valor_real, valor_imobiliaria, data_disp, rua, numero, bairro, cidade, estado) values (41, true, '0101010101', '2013-01-01', 100, 100000, 10000, '2014-02-02', 'supalonely', 50, 'benee', 'Ibirataia', 'BA');
insert into imovel (id_imovel, estado_atual, foto, data_construcao, area, valor_real, valor_imobiliaria, data_disp, rua, numero, bairro, cidade, estado) values (42, true, '0101010101', '2014-01-01', 105, 50000, 10000, '2015-02-02', 'Glitter', 876, 'benee', 'Ibirataia', 'BA');
insert into imovel (id_imovel, estado_atual, foto, data_construcao, area, valor_real, valor_imobiliaria, data_disp, rua, numero, bairro, cidade, estado) values (43, true, '0101010101', '2012-01-01', 135, 60000, 10000, '2013-02-02', 'Rare', 678, 'Rare', 'Ipiau', 'BA');
insert into imovel (id_imovel, estado_atual, foto, data_construcao, area, valor_real, valor_imobiliaria, data_disp, rua, numero, bairro, cidade, estado) values (44, true, '0101010101', '2012-02-02', 153, 150000, 10000, '2013-02-02', 'Black Widow', 90, 'Reclassified', 'Vinhedos', 'SP');
insert into imovel (id_imovel, estado_atual, foto, data_construcao, area, valor_real, valor_imobiliaria, data_disp, rua, numero, bairro, cidade, estado) values (45, true, '0101010101', '2015-10-10', 108, 160000, 10000, '2016-03-03', 'lola', 23, 'wicked lips', 'Jundiai', 'SP');

			--casa ---
insert into casa(id_imovel, qtd_quartos, qtd_suites, qtd_salaestar, qtd_salajantar, num_vagas, armario, descricao) values (11, 3, 1, 2, 1, 9, true, 'casa bem localizada, no bloco wonderland');
insert into casa(id_imovel, qtd_quartos, qtd_suites, qtd_salaestar, qtd_salajantar, num_vagas, armario, descricao) values (12, 2, 1, 1, 1, 2, true, 'armarios nos quartos e sala.');
insert into casa(id_imovel, qtd_quartos, qtd_suites, qtd_salaestar, qtd_salajantar, num_vagas, armario, descricao) values (13, 2, 3, 1, 1, 4, true, 'revestida de vibro, estilo industrial');
insert into casa(id_imovel, qtd_quartos, qtd_suites, qtd_salaestar, qtd_salajantar, num_vagas, armario, descricao) values (14, 2, 2, 1, 1, 3, true, 'Casa necessita de pintura, tem estilo gótico.');
insert into casa(id_imovel, qtd_quartos, qtd_suites, qtd_salaestar, qtd_salajantar, num_vagas, armario, descricao) values (15, 2, 3, 1, 1, 3, true, 'Estilo escandinavo, a beira-mar.');

           --Condominio ---
insert into condominio(id_cond, nome, portaria, academia, valor_condominio) values (1, 'Little Monsters', true, true, 650);
insert into condominio(id_cond, nome, portaria, academia, valor_condominio) values (2, 'Fallen', true, true, 950);
insert into condominio(id_cond, nome, portaria, academia, valor_condominio) values (3, 'Poker face', true, true, 550);

			-- Apartamento ---
insert into apartamento(id_imovel, qtd_quartos, qtd_suites, qtd_salaestar, qtd_salajantar, num_vagas, armario, descricao, andar, id_cond) values (21, 1, 1, 1, 1, 1, true, 'possível fazer modificações', 9, 1);
insert into apartamento(id_imovel, qtd_quartos, qtd_suites, qtd_salaestar, qtd_salajantar, num_vagas, armario, descricao, andar, id_cond) values (22, 1, 1, 1, 1, 1, true, 'possível fazer modificações', 15, 1);
insert into apartamento(id_imovel, qtd_quartos, qtd_suites, qtd_salaestar, qtd_salajantar, num_vagas, armario, descricao, andar, id_cond) values (23, 1, 2, 1, 1, 1, true, 'possível fazer modificações', 1, 2);
insert into apartamento(id_imovel, qtd_quartos, qtd_suites, qtd_salaestar, qtd_salajantar, num_vagas, armario, descricao, andar, id_cond) values (24, 1, 2, 1, 1, 1, true, 'possível fazer modificações', 10, 2);
insert into apartamento(id_imovel, qtd_quartos, qtd_suites, qtd_salaestar, qtd_salajantar, num_vagas, armario, descricao, andar, id_cond) values (25, 2, 1, 1, 1, 1, true, 'possível fazer modificações', 5, 3);

 			--comercial ---
insert into comercial (id_imovel, qtd_banheiros, qtd_comodos) values (31, 2, 1);
insert into comercial (id_imovel, qtd_banheiros, qtd_comodos) values (32, 2, 1);
insert into comercial (id_imovel, qtd_banheiros, qtd_comodos) values (33, 2, 1);
insert into comercial (id_imovel, qtd_banheiros, qtd_comodos) values (34, 2, 4);
insert into comercial (id_imovel, qtd_banheiros, qtd_comodos) values (35, 2, 4);
insert into comercial (id_imovel, qtd_banheiros, qtd_comodos) values (36, 2, 2);

 			--terreno ---
insert into terreno (id_imovel, largura, comprimento, declive) values (41, 20, 5, 0);
insert into terreno (id_imovel, largura, comprimento, declive) values (42, 15, 7, 0);
insert into terreno (id_imovel, largura, comprimento, declive) values (43, 27, 5, 0);
insert into terreno (id_imovel, largura, comprimento, declive) values (44, 17, 9, 0);
insert into terreno (id_imovel, largura, comprimento, declive) values (45, 18, 6, 0);

             -- Contrato ---
insert into contrato (id_contrato, comissao, data_trans, forma_pag, funcionario, imovel_id, fiador, indicacoes, transacao, cliente) values (1111111, 1000.0, '2012-02-12', 'Cheque', '77777888888', 11, 'Demi Lovato', 'Kendall e Kyle', 'aluguel', '12345678912');
insert into contrato (id_contrato, comissao, data_trans, forma_pag, funcionario, imovel_id, transacao, cliente) values (22222222, 500.0, '2015-11-02', 'Boleto', '77777888888', 12, 'compra', '00987765213');
insert into contrato (id_contrato, comissao, data_trans, forma_pag, funcionario, imovel_id, fiador, indicacoes, transacao, cliente) values (33333333, 800.0, '2019-02-02', 'Transferencia', '66663333221', 21,'Kim', 'North e Psalm West' , 'aluguel', '23456098765');
insert into contrato (id_contrato, comissao, data_trans, forma_pag, funcionario, imovel_id, fiador, indicacoes, transacao, cliente) values (44444444, 1000.0, '2019-02-02', 'Transferencia', '66663333221', 22, 'Lana', 'Ariana e Miley', 'aluguel', '54328901234');
insert into contrato (id_contrato, comissao, data_trans, forma_pag, funcionario, imovel_id, transacao, cliente) values (55555555, 2000.0, '2015-05-05', 'Cheque', '99999955555', 23, 'compra', '93989182938');
insert into contrato (id_contrato, comissao, data_trans, forma_pag, funcionario, imovel_id, transacao, cliente) values (66666666, 1000.0, '2015-01-01', 'Depósito', '77777888888', 31, 'venda', '76272126162');

        -- Fiscaliza ---
insert into fiscaliza (situacao, data_fisc, funcionario, id_imovel) values ('Regular', '2015-10-01', '77777888888', 12);        
insert into fiscaliza (situacao, data_fisc, funcionario, id_imovel) values ('Bom', '2016-01-05', '99999955555', 34);
insert into fiscaliza (situacao, data_fisc, funcionario, id_imovel) values ('Bom', '2020-02-02', '99999955555', 21);								  
----------------------------------------------------------------------------------------
