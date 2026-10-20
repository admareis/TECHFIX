--ativa as chaves estrangeiras do SQLITE -- 
PRAGMA foreign_keys;

CREATE TABLE cargo (
id INTEGER PRIMARY KEY AUTOINCREMENT,
nome_cargo TEXT NOT NULL COLLATE NOCASE UNIQUE,
status INTEGER NOT NULL DEFAULT 1
) STRICT;

CREATE TABLE funcionario (
id INTEGER PRIMARY KEY AUTOINCREMENT,
nome_funcionario TEXT NOT NULL COLLATE NOCASE,
id_cargo INTEGER NOT NULL,
status INTEGER NOT NULL DEFAULT 1,
data_cadastro TEXT NOT NULL DEFAULT (DATETIME ('now', 'localtime')),
FOREIGN KEY (id_cargo) REFERENCES cargo(id) ON UPDATE CASCADE ON DELETE CASCADE,
UNIQUE (id, id_cargo)
) STRICT;

INSERT INTO cargo (nome_cargo) VALUES ('GERENTE'), ('ATENDENTE'), ('TÉCNICO');

-- Inserts para 3 Técnicos (id_cargo = 1)
INSERT INTO funcionario (nome_funcionario, id_cargo) VALUES ('Carlos Silva', 1);
INSERT INTO funcionario (nome_funcionario, id_cargo) VALUES ('Mariana Oliveira', 1);
INSERT INTO funcionario (nome_funcionario, id_cargo) VALUES ('Lucas Santos', 1);

-- Inserts para 2 Atendentes (id_cargo = 2)
INSERT INTO funcionario (nome_funcionario, id_cargo) VALUES ('Beatriz Souza', 2);
INSERT INTO funcionario (nome_funcionario, id_cargo) VALUES ('Gabriel Costa', 2);

-- Insert para 1 Gerente (id_cargo = 3)
INSERT INTO funcionario (nome_funcionario, id_cargo) VALUES ('Ana Paula Ferreira', 3);

CREATE TABLE cliente (
id INTEGER PRIMARY KEY AUTOINCREMENT,
nome_cliente TEXT NOT NULL COLLATE NOCASE,
telefone INTEGER NOT NULL,
email TEXT NOT NULL UNIQUE,
status INTEGER NOT NULL DEFAULT 1,
id_funcionario INTEGER NOT NULL,
id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo=1 OR id_funcionario_cargo=2), -- O CHECK AVALIA SE O USUARIO INSERIDO TEM O ID DE CARGO DEFINIDO NA TABELA DE FUNCIONARIO PERMITIDO -- 
data_cadastro TEXT NOT NULL DEFAULT (DATETIME ('now', 'localtime')),
FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario(id, id_cargo)
) STRICT;

INSERT INTO cliente (nome_cliente, email, telefone, id_funcionario, id_funcionario_cargo) 
VALUES ('João','email@email.com', '11999999999', 4, 2);

CREATE TABLE categorias (
id INTEGER PRIMARY KEY AUTOINCREMENT,
nome_categorias TEXT NOT NULL COLLATE NOCASE UNIQUE,
id_funcionario INTEGER NOT NULL,
id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo=1), -- O CHECK AVALIA SE O USUARIO INSERIDO TEM O ID DE CARGO DEFINIDO NA TABELA DE FUNCIONARIO PERMITIDO -- 
status INTEGER NOT NULL DEFAULT 1,
data_cadastro TEXT NOT NULL DEFAULT (DATETIME ('now', 'localtime')),
FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario(id, id_cargo)
)STRICT;

CREATE TABLE servico (
id INTEGER PRIMARY KEY AUTOINCREMENT,
nome_servico TEXT NOT NULL COLLATE NOCASE UNIQUE,
id_categorias INTEGER NOT NULL,
preco_base INTEGER NOT NULL,
horas_servico REAL NOT NULL,
status INTEGER NOT NULL DEFAULT 1,
id_funcionario INTEGER NOT NULL,
id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo=1 OR id_funcionario_cargo=2), -- O CHECK AVALIA SE O USUARIO INSERIDO TEM O ID DE CARGO DEFINIDO NA TABELA DE FUNCIONARIO PERMITIDO -- 
data_cadastro TEXT NOT NULL DEFAULT (DATETIME ('now', 'localtime')),
FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario(id, id_cargo),
FOREIGN KEY (id_categorias) REFERENCES categorias(id)
)STRICT;

INSERT INTO categorias (nome_categorias, id_funcionario, id_funcionario_cargo) 
VALUES ('celulares', 1, (SELECT id_cargo FROM funcionario WHERE id=1));

INSERT INTO servico (nome_servico, id_categorias, preco_base, horas_servico, id_funcionario, id_funcionario_cargo) VALUES
('Formatação e Instalação de Sistema Operacional', (SELECT id FROM categorias WHERE nome_categorias = 'informática'), 12000, 2.0, 1, 1),
('Limpeza Interna e Troca de Pasta Térmica', (SELECT id FROM categorias WHERE nome_categorias = 'informática'), 15000, 1.5, 1, 1),
('Upgrade de Hardware (RAM/SSD)', (SELECT id FROM categorias WHERE nome_categorias = 'informática'), 8000, 1.0, 1, 1),
('Remoção de Vírus e Malwares', (SELECT id FROM categorias WHERE nome_categorias = 'informática'), 10000, 1.5, 1, 1),
('Troca de Tela de Notebook', (SELECT id FROM categorias WHERE nome_categorias = 'informática'), 18000, 1.5, 1, 1),
('Troca de Display/Frontal de Celular', (SELECT id FROM categorias WHERE nome_categorias = 'celulares'), 15000, 1.0, 1, 1),
('Troca de Bateria de Smartphone', (SELECT id FROM categorias WHERE nome_categorias = 'celulares'), 9000, 0.5, 1, 1),
('Desoxidação após Contato com Líquido', (SELECT id FROM categorias WHERE nome_categorias = 'celulares'), 20000, 3.0, 1, 1),
('Reparo em Conector de Carga (Micro USB / Type-C)', (SELECT id FROM categorias WHERE nome_categorias = 'celulares'), 11000, 1.5, 1, 1),
('Troca de Barra de LED de Smart TV', (SELECT id FROM categorias WHERE nome_categorias = 'smart tvs'), 35000, 3.0, 1, 1),
('Reparo na Placa Principal de Smart TV', (SELECT id FROM categorias WHERE nome_categorias = 'smart tvs'), 28000, 2.5, 1, 1),
('Conserto de Fonte de Alimentação Interna (TV)', (SELECT id FROM categorias WHERE nome_categorias = 'smart tvs'), 22000, 2.0, 1, 1),
('Configuração de Rede e Roteador Wi-Fi', (SELECT id FROM categorias WHERE nome_categorias = 'redes'), 9000, 1.0, 1, 1),
('Higienização e Troca de Metal Líquido / Pasta Térmica (Console)', (SELECT id FROM categorias WHERE nome_categorias = 'videogames'), 22000, 2.0, 1, 1),
('Reparo de Drift em Analógico de Controle (Joy-Con / DualSense / Xbox)', (SELECT id FROM categorias WHERE nome_categorias = 'videogames'), 8000, 1.0, 1, 1),
('Substituição de HDMI / Conector de Vídeo (Console)', (SELECT id FROM categorias WHERE nome_categorias = 'videogames'), 25000, 2.5, 1, 1),
('Troca de Bateria de Caixa de Som Portátil (Bluetooth)', (SELECT id FROM categorias WHERE nome_categorias = 'áudio'), 12000, 1.5, 1, 1),
('Troca de Almofadas / Reparo de Cabo de Headset Gamer', (SELECT id FROM categorias WHERE nome_categorias = 'áudio'), 7000, 1.0, 1, 1),
('Recuperação de Dados de HD / SSD / Pendrive Danificado', (SELECT id FROM categorias WHERE nome_categorias = 'recuperação de dados'), 30000, 4.0, 1, 1),
('Rebaling / Reparo de BGA em Placa Mãe ou Placa de Vídeo', (SELECT id FROM categorias WHERE nome_categorias = 'eletrônica avançada'), 45000, 5.0, 1, 1),
('Gravação e Reprogramação de BIOS Eprom (Notebook / Desktop)', (SELECT id FROM categorias WHERE nome_categorias = 'eletrônica avançada'), 16000, 2.0, 1, 1),
('Troca de Vidro Traseiro de Smartphone a Laser / Manual', (SELECT id FROM categorias WHERE nome_categorias = 'celulares'), 18000, 2.5, 1, 1),
('Reparo e Solda de Conector Jack P2/P10 de Mesa de Som ou Amplificador', (SELECT id FROM categorias WHERE nome_categorias = 'áudio'), 9500, 1.0, 1, 1);

INSERT OR IGNORE INTO categorias (nome_categorias, id_funcionario, id_funcionario_cargo)
VALUES 
('computadores', '1', (SELECT id_cargo FROM funcionario f WHERE id=1)),
('celulares', '1', (SELECT id_cargo FROM funcionario f WHERE id=1)),
('smart tvs', '1', (SELECT id_cargo FROM funcionario f WHERE id=1)),
('redes', '1', (SELECT id_cargo FROM funcionario f WHERE id=1)),
('videogames', '1', (SELECT id_cargo FROM funcionario f WHERE id=1)),
('áudio', '1', (SELECT id_cargo FROM funcionario f WHERE id=1)),
('recuperação de dados', '1', (SELECT id_cargo FROM funcionario f WHERE id=1)),
('eletrônica avançada', '1', (SELECT id_cargo FROM funcionario f WHERE id=1)),
('informática', '1', (SELECT id_cargo FROM funcionario f WHERE id=1)),
('insumos', '1', (SELECT id_cargo FROM funcionario f WHERE id=1)),
('acessórios', '1', (SELECT id_cargo FROM funcionario f WHERE id=1)),
('telas', '1', (SELECT id_cargo FROM funcionario f WHERE id=1)),
('baterias', '1', (SELECT id_cargo FROM funcionario f WHERE id=1)),
('componentes', '1', (SELECT id_cargo FROM funcionario f WHERE id=1)),
('carcaças', '1', (SELECT id_cargo FROM funcionario f WHERE id=1)),
('tvs', '1', (SELECT id_cargo FROM funcionario f WHERE id=1));

CREATE TABLE pecas (
id INTEGER PRIMARY KEY AUTOINCREMENT,
nome_pecas TEXT NOT NULL COLLATE NOCASE UNIQUE,
id_categorias INTEGER NOT NULL,
preco_venda INTEGER NOT NULL, 
estoque_atual INTEGER NOT NULL, 
status INTEGER NOT NULL DEFAULT 1,
id_funcionario INTEGER NOT NULL,
id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo=1),
data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario(id, id_cargo),
FOREIGN KEY (id_categorias) REFERENCES categorias(id)
) STRICT;

INSERT INTO pecas (nome_pecas, id_categorias, preco_venda, estoque_atual, id_funcionario, id_funcionario_cargo) VALUES
-- Informática / Computadores
('SSD NVMe 512GB M.2', (SELECT id FROM categorias WHERE nome_categorias = 'informática'), 26000, 15, 1, 1),
('SSD SATA III 480GB 2.5"', (SELECT id FROM categorias WHERE nome_categorias = 'informática'), 21000, 20, 1, 1),
('Memória RAM DDR4 8GB 2666MHz (Notebook)', (SELECT id FROM categorias WHERE nome_categorias = 'informática'), 17000, 12, 1, 1),
('Memória RAM DDR4 16GB 3200MHz (Desktop)', (SELECT id FROM categorias WHERE nome_categorias = 'informática'), 32000, 8, 1, 1),
('Pasta Térmica de Alta Performance (Bisnaga 4g)', (SELECT id FROM categorias WHERE nome_categorias = 'insumos'), 6000, 25, 1, 1),
('Fonte ATX 500W 80 Plus Bronze', (SELECT id FROM categorias WHERE nome_categorias = 'informática'), 34000, 6, 1, 1),
('Bateria Célula Moeda CR2032 (Cartela c/ 5)', (SELECT id FROM categorias WHERE nome_categorias = 'insumos'), 2500, 30, 1, 1),
('Cooler para Processador Socket Universal', (SELECT id FROM categorias WHERE nome_categorias = 'informática'), 9500, 10, 1, 1),
('Cabo SATA III 6Gbps 50cm', (SELECT id FROM categorias WHERE nome_categorias = 'acessórios'), 1500, 50, 1, 1),
('Tela LED 15.6" Slim 30 Pinos Full HD', (SELECT id FROM categorias WHERE nome_categorias = 'telas'), 48000, 5, 1, 1),
-- Smartphones / Celulares
('Display Frontal Completo iPhone 11', (SELECT id FROM categorias WHERE nome_categorias = 'telas'), 35000, 4, 1, 1),
('Display Frontal Completo Samsung Galaxy A54', (SELECT id FROM categorias WHERE nome_categorias = 'telas'), 31000, 6, 1, 1),
('Display Frontal Completo Motorola Moto G84', (SELECT id FROM categorias WHERE nome_categorias = 'telas'), 28000, 5, 1, 1),
('Bateria Compatível iPhone 11 (3110mAh)', (SELECT id FROM categorias WHERE nome_categorias = 'baterias'), 16000, 8, 1, 1),
('Bateria Compatível Samsung Galaxy A32', (SELECT id FROM categorias WHERE nome_categorias = 'baterias'), 13000, 7, 1, 1),
('Bateria Compatível Moto G30', (SELECT id FROM categorias WHERE nome_categorias = 'baterias'), 12000, 6, 1, 1),
('Conector de Carga Type-C Universal (Unidade)', (SELECT id FROM categorias WHERE nome_categorias = 'componentes'), 2000, 100, 1, 1),
('Conector de Carga Micro USB V8', (SELECT id FROM categorias WHERE nome_categorias = 'componentes'), 1500, 100, 1, 1),
('Flex de Carga e Microfone Moto G9 Play', (SELECT id FROM categorias WHERE nome_categorias = 'componentes'), 5500, 10, 1, 1),
('Tampa Traseira de Vidro iPhone 12', (SELECT id FROM categorias WHERE nome_categorias = 'carcaças'), 11000, 4, 1, 1),
('Câmera Traseira Principal Redmi Note 11', (SELECT id FROM categorias WHERE nome_categorias = 'componentes'), 14000, 3, 1, 1),
('Alto-Falante Auricular Universal', (SELECT id FROM categorias WHERE nome_categorias = 'componentes'), 2500, 40, 1, 1),
-- Smart TVs
('Barra de LED TV Samsung 50" (Kit com 3 barras)', (SELECT id FROM categorias WHERE nome_categorias = 'tvs'), 23000, 4, 1, 1),
('Barra de LED TV LG 43" (Kit com 3 barras)', (SELECT id FROM categorias WHERE nome_categorias = 'tvs'), 19500, 5, 1, 1),
('Placa Fonte TV Samsung UN50TU8000', (SELECT id FROM categorias WHERE nome_categorias = 'tvs'), 31000, 2, 1, 1),
('Placa Principal TV LG 43UP7500', (SELECT id FROM categorias WHERE nome_categorias = 'tvs'), 42000, 2, 1, 1),
('Cabo Flat T-Con para Display TV 55"', (SELECT id FROM categorias WHERE nome_categorias = 'tvs'), 6500, 8, 1, 1),
('Receptor Infravermelho para Controle Remoto TV', (SELECT id FROM categorias WHERE nome_categorias = 'componentes'), 2000, 15, 1, 1),
-- Insumos e Componentes Genéricos
('Solda em Fio Sn60/Pb40 0.8mm (Carretel 500g)', (SELECT id FROM categorias WHERE nome_categorias = 'insumos'), 15000, 3, 1, 1),
('Álcool Isopropílico 99.8% 1 Litro', (SELECT id FROM categorias WHERE nome_categorias = 'insumos'), 4500, 12, 1, 1),
('Fita Kapton Térmica 10mm x 33m', (SELECT id FROM categorias WHERE nome_categorias = 'insumos'), 3000, 15, 1, 1),
('Fita Dupla Face Fixação de Telas (3mm x 50m)', (SELECT id FROM categorias WHERE nome_categorias = 'insumos'), 3500, 10, 1, 1),
('Fusível de Louça 5A 250V (Pacote c/ 10)', (SELECT id FROM categorias WHERE nome_categorias = 'componentes'), 1800, 20, 1, 1),
('Capacitor Eletrolítico 1000uF x 25V', (SELECT id FROM categorias WHERE nome_categorias = 'componentes'), 500, 150, 1, 1);

SELECT * FROM pecas WHERE preco_venda >= 10000;

CREATE VIEW vw_preco_venda_maior_100 AS
SELECT id, nome_pecas,preco_venda, estoque_atual
FROM pecas WHERE preco_venda >= 10000;

SELECT * FROM vw_preco_venda_maior_100;

CREATE TABLE forma_pagamento (
id INTEGER PRIMARY KEY AUTOINCREMENT,
nome_forma_pagamento TEXT NOT NULL COLLATE NOCASE UNIQUE,
id_funcionario INTEGER NOT NULL,
id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo=1),
data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
status INTEGER NOT NULL DEFAULT 1, 
FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario(id, id_cargo)
)STRICT;

INSERT INTO forma_pagamento (nome_forma_pagamento, id_funcionario, id_funcionario_cargo) VALUES 
('Dinheiro', 1, 1),
('Cartão de Crédito', 1, 1),
('Cartão de Débito', 1, 1),
('Pix', 1, 1),
('Boleto Bancário', 1, 1),
('Transferência Bancária (TED/DOC)', 1, 1);

CREATE TABLE situacao (
id INTEGER PRIMARY KEY AUTOINCREMENT,
nome_situacao TEXT NOT NULL COLLATE NOCASE UNIQUE,
status INTEGER NOT NULL DEFAULT 1
)STRICT;

INSERT OR IGNORE INTO situacao (nome_situacao) VALUES 
('Aberto'),
('Em Diagnóstico'),
('Orçamento Aprovado'),
('Em Reparo'),
('Pronto'),
('Entregue'),
('Cancelado'),
('Uso em Reparo'),
('Descarte por Defeito/Avaria');

CREATE TABLE ordem (
id INTEGER PRIMARY KEY AUTOINCREMENT,
id_equipamento INTEGER NOT NULL,
id_funcionario_abertura INTEGER NOT NULL,
id_funcionario_cargo_abertura INTEGER NOT NULL CHECK (id_funcionario_cargo_abertura = 1 OR id_funcionario_cargo_abertura = 2), -- Assumindo 1 para gerente
defeito_relatado TEXT NOT NULL COLLATE NOCASE,
defeito_constatado TEXT COLLATE NOCASE,
data_abertura TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
id_situacao_atual INTEGER NOT NULL,
data_fechamento TEXT,
valor_total INTEGER,
id_forma_pagamento INTEGER NOT NULL,
id_tecnico INTEGER NOT NULL,
id_tecnico_cargo INTEGER NOT NULL CHECK (id_tecnico_cargo = 3),
FOREIGN KEY (id_equipamento) REFERENCES equipamento(id),
FOREIGN KEY (id_funcionario_abertura, id_funcionario_cargo_abertura) REFERENCES funcionario(id, id_cargo),
FOREIGN KEY (id_situacao_atual) REFERENCES situacao(id),
FOREIGN KEY (id_forma_pagamento) REFERENCES forma_pagamento(id),
FOREIGN KEY (id_tecnico, id_tecnico_cargo) REFERENCES funcionario(id, id_cargo)
) STRICT;

INSERT INTO ordem (id_equipamento, id_funcionario_abertura, id_funcionario_cargo_abertura, defeito_relatado, defeito_constatado, id_situacao_atual, valor_total, id_forma_pagamento, id_tecnico, id_tecnico_cargo) VALUES 
-- Ordem 1: iPhone 13 (Equipamento 1) - Finalizada (Entregue = 6)
(1, 5, 2, 'Tela trincada após queda', 'Display LCD e Touch danificados', 6, 37500, 2, 6, 3),

-- Ordem 2: Notebook Dell (Equipamento 2) - Em Reparo (Em Reparo = 4)
(2, 5, 2, 'Notebook muito lento', 'HD Mecânico defeituoso e pouca RAM', 4, 55000, 1, 6, 3);

CREATE TABLE ordem_peca (
id INTEGER PRIMARY KEY AUTOINCREMENT,
id_ordem INTEGER NOT NULL, 
id_peca INTEGER NOT NULL, 
quantidade INTEGER NOT NULL, 
valor_unitario INTEGER NOT NULL,
data_situacao TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
FOREIGN KEY (id_ordem) REFERENCES ordem(id),
FOREIGN KEY (id_peca) REFERENCES pecas(id)
) STRICT;

CREATE TABLE ordem_situacao (
id INTEGER PRIMARY KEY AUTOINCREMENT,
id_ordem INTEGER NOT NULL,
id_nome_situacao INTEGER NOT NULL,
id_funcionario INTEGER NOT NULL,
data_situacao TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
FOREIGN KEY (id_ordem) REFERENCES ordem(id),
FOREIGN KEY (id_nome_situacao) REFERENCES situacao(id),
FOREIGN KEY (id_funcionario) REFERENCES funcionario(id)
) STRICT;

CREATE TABLE ordem_servico (
id INTEGER PRIMARY KEY AUTOINCREMENT,
id_ordem INTEGER NOT NULL,
id_servico INTEGER NOT NULL,
valor_unitario INTEGER NOT NULL,
quantidade_servico INTEGER NOT NULL,
data_execucao TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
FOREIGN KEY (id_ordem) REFERENCES ordem(id),
FOREIGN KEY (id_servico) REFERENCES servico(id)
) STRICT;

CREATE TABLE marca (
id INTEGER PRIMARY KEY AUTOINCREMENT,
nome_marca TEXT NOT NULL COLLATE NOCASE UNIQUE,
id_funcionario INTEGER NOT NULL,
id_funcionario_cargo INTEGER NOT NULL,
status INTEGER NOT NULL DEFAULT 1,
data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime'))
);

INSERT INTO marca (nome_marca, id_funcionario, id_funcionario_cargo) VALUES 
('Apple', 1, 1),
('Samsung', 1, 1),
('Dell', 1, 1),
('Lenovo', 1, 1),
('HP', 1, 1),
('Asus', 1, 1),
('Xiaomi', 1, 1);

CREATE TABLE modelo (
id INTEGER PRIMARY KEY AUTOINCREMENT,
nome_modelo TEXT NOT NULL COLLATE NOCASE UNIQUE,
id_funcionario INTEGER NOT NULL,
id_funcionario_cargo INTEGER NOT NULL,
status INTEGER NOT NULL DEFAULT 1,
data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime'))
);

INSERT INTO modelo (nome_modelo, id_funcionario, id_funcionario_cargo) VALUES 
('iPhone 13', 1, 1),
('Galaxy S23', 1, 1),
('Inspiron 15', 1, 1),
('ThinkPad X1', 1, 1),
('Pavilion 14', 1, 1),
('Redmi Note 12', 1, 1);

CREATE TABLE tipo (
id INTEGER PRIMARY KEY AUTOINCREMENT,
nome_tipo TEXT NOT NULL COLLATE NOCASE UNIQUE,
id_funcionario INTEGER NOT NULL,
id_funcionario_cargo INTEGER NOT NULL,
status INTEGER NOT NULL DEFAULT 1,
data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime'))
);

INSERT INTO tipo (nome_tipo, id_funcionario, id_funcionario_cargo) VALUES 
('Smartphone', 1, 1),
('Notebook', 1, 1),
('Desktop', 1, 1),
('Tablet', 1, 1),
('Monitor', 1, 1),
('Impressora', 1, 1);

CREATE TABLE equipamento (
id INTEGER PRIMARY KEY AUTOINCREMENT,
serial_number TEXT NOT NULL,
imei TEXT COLLATE NOCASE UNIQUE,
id_cliente INTEGER NOT NULL,
id_funcionario INTEGER NOT NULL, 
id_funcionario_cargo INTEGER NOT NULL,
id_modelo INTEGER NOT NULL, 
id_marca INTEGER NOT NULL, 
id_tipo INTEGER NOT NULL,
data_cadastro TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
status INTEGER NOT NULL DEFAULT 1,
FOREIGN KEY (id_cliente) REFERENCES cliente(id),
FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario(id, id_cargo),
FOREIGN KEY (id_modelo) REFERENCES modelo(id),
FOREIGN KEY (id_marca) REFERENCES marca(id),
FOREIGN KEY (id_tipo) REFERENCES tipo(id)
)STRICT;

INSERT INTO equipamento (serial_number, imei, id_cliente, id_funcionario, id_funcionario_cargo, id_modelo, id_marca, id_tipo) VALUES 
('SN-APP-998877', '351234567890123', 1, 4, 2, 1, 1, 1), -- iPhone 13 / Apple / Smartphone
('SN-DELL-554433', NULL, 1, 4, 2, 3, 3, 2),             -- Inspiron 15 / Dell / Notebook
('SN-SAMSUNG-112', '359876543210987', 1, 4, 2, 2, 2, 1);  -- Galaxy S23 / Samsung / Smartphone

INSERT INTO servico (nome_servico, id_categorias, preco_base, horas_servico, id_funcionario, id_funcionario_cargo) VALUES
('Instalação de Pacote Office / Softwares Básicos', (SELECT id FROM categorias WHERE nome_categorias = 'informática'), 5000, 1.0, 1, 1),
('Troca de Teclado Interno de Notebook', (SELECT id FROM categorias WHERE nome_categorias = 'informática'), 12000, 1.5, 1, 1),
('Aplicação de Película Protetora (Vidro/Cerâmica)', (SELECT id FROM categorias WHERE nome_categorias = 'acessórios'), 2500, 0.3, 1, 1),
('Backup de Dados Preventivo (Até 500GB)', (SELECT id FROM categorias WHERE nome_categorias = 'informática'), 8000, 2.0, 1, 1);


