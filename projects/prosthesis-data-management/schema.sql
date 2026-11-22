-- Prosthesis Data Management System
-- Relational schema reconstructed from the coursework data model.

CREATE TABLE medico (
  medico_id INT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  morada VARCHAR(200),
  data_nascimento DATE,
  numero_telefone VARCHAR(30),
  sexo VARCHAR(30),
  email VARCHAR(150)
);

CREATE TABLE paciente (
  paciente_id INT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  morada VARCHAR(200),
  data_nascimento DATE,
  numero_telefone VARCHAR(30),
  sexo VARCHAR(30),
  email VARCHAR(200)
);

CREATE TABLE laboratorio (
  laboratorio_id INT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  morada VARCHAR(200),
  numero_telefone VARCHAR(30)
);

CREATE TABLE tecnico (
  profissional_id INT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  morada VARCHAR(200),
  data_nascimento DATE,
  numero_telefone VARCHAR(30),
  sexo VARCHAR(30),
  email VARCHAR(200),
  laboratorio_id INT,
  FOREIGN KEY (laboratorio_id) REFERENCES laboratorio(laboratorio_id)
);

CREATE TABLE problema_medico (
  problema_id INT PRIMARY KEY,
  doenca VARCHAR(100) NOT NULL,
  medico_id INT,
  FOREIGN KEY (medico_id) REFERENCES medico(medico_id)
);

CREATE TABLE equipamentos_medicos (
  equipamento_id INT PRIMARY KEY,
  tipo VARCHAR(45),
  data_fabrico DATE,
  tecnico_manutencao VARCHAR(100),
  marca VARCHAR(100),
  data_proxima_manutencao DATE
);

CREATE TABLE protese (
  protese_id INT PRIMARY KEY,
  tipo VARCHAR(100) NOT NULL,
  data_fabrico DATE,
  data_instalacao DATE,
  material VARCHAR(200),
  laboratorio_id INT,
  paciente_id INT,
  problema_id INT,
  FOREIGN KEY (laboratorio_id) REFERENCES laboratorio(laboratorio_id),
  FOREIGN KEY (paciente_id) REFERENCES paciente(paciente_id),
  FOREIGN KEY (problema_id) REFERENCES problema_medico(problema_id)
);

CREATE TABLE exames (
  exames_id INT PRIMARY KEY,
  tipo VARCHAR(50),
  data DATE,
  nome_profissional VARCHAR(100),
  paciente_id INT,
  laboratorio_id INT,
  medico_id INT,
  FOREIGN KEY (paciente_id) REFERENCES paciente(paciente_id),
  FOREIGN KEY (laboratorio_id) REFERENCES laboratorio(laboratorio_id),
  FOREIGN KEY (medico_id) REFERENCES medico(medico_id)
);

CREATE TABLE consulta (
  consulta_id INT PRIMARY KEY,
  profissional_id INT,
  paciente_id INT,
  data DATE,
  numero INT,
  medico_id INT,
  FOREIGN KEY (profissional_id) REFERENCES tecnico(profissional_id),
  FOREIGN KEY (paciente_id) REFERENCES paciente(paciente_id),
  FOREIGN KEY (medico_id) REFERENCES medico(medico_id)
);

CREATE TABLE protese_tecnico (
  protese_tecnico_id INT PRIMARY KEY,
  protese_id INT NOT NULL,
  profissional_id INT NOT NULL,
  FOREIGN KEY (protese_id) REFERENCES protese(protese_id),
  FOREIGN KEY (profissional_id) REFERENCES tecnico(profissional_id)
);

CREATE TABLE tecnico_equipamento (
  tecnico_equipamento_id INT PRIMARY KEY,
  equipamento_id INT NOT NULL,
  profissional_id INT NOT NULL,
  FOREIGN KEY (equipamento_id) REFERENCES equipamentos_medicos(equipamento_id),
  FOREIGN KEY (profissional_id) REFERENCES tecnico(profissional_id)
);

CREATE TABLE paciente_problema (
  paciente_problema_id INT PRIMARY KEY,
  paciente_id INT NOT NULL,
  problema_medico_id INT NOT NULL,
  FOREIGN KEY (paciente_id) REFERENCES paciente(paciente_id),
  FOREIGN KEY (problema_medico_id) REFERENCES problema_medico(problema_id)
);
