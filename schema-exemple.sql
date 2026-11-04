-- ---------------------------------------------------------------------------
-- schema-exemple.sql
--
-- ATENCIO: aquest NO es l'esquema original de l'exercici de classe.
-- Es una reconstruccio feta a partir de les taules i columnes que fan servir
-- les rutines de procedures.sql i functions.sql, perque el repositori es pugui
-- executar i provar. Les mides de les columnes son les que declaren les
-- mateixes rutines (VARCHAR(15) per al nom, VARCHAR(18) per al departament).
--
-- Serveix per demostrar el codi, no per documentar el disseny de la base.
-- ---------------------------------------------------------------------------

DROP DATABASE IF EXISTS empleats_db;
CREATE DATABASE empleats_db
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;
USE empleats_db;

CREATE TABLE departaments (
    codi_dept INT PRIMARY KEY,
    nom_dept  VARCHAR(18) NOT NULL,
    seu       VARCHAR(30)
);

CREATE TABLE projectes (
    codi_proj  INT PRIMARY KEY,
    nom_proj   VARCHAR(30) NOT NULL,
    pressupost DECIMAL(10,2) NOT NULL,
    CONSTRAINT chk_pressupost_positiu CHECK (pressupost >= 0)
);

CREATE TABLE empleats (
    codi_emp  INT PRIMARY KEY AUTO_INCREMENT,
    nom_emp   VARCHAR(15) NOT NULL,
    sou       DECIMAL(10,2) NOT NULL,
    codi_dept INT NOT NULL,
    codi_proj INT NULL,
    CONSTRAINT chk_sou_positiu CHECK (sou >= 0),
    CONSTRAINT fk_emp_dept FOREIGN KEY (codi_dept) REFERENCES departaments(codi_dept),
    CONSTRAINT fk_emp_proj FOREIGN KEY (codi_proj) REFERENCES projectes(codi_proj)
);

-- Dades minimies per poder provar les crides dels exercicis.
INSERT INTO departaments (codi_dept, nom_dept, seu) VALUES
  (1, 'Informatica',  'Tarragona'),
  (2, 'Administracio','Tarragona'),
  (3, 'Produccio',    'Reus');

INSERT INTO projectes (codi_proj, nom_proj, pressupost) VALUES
  (1, 'Migracio al cloud',  45000.00),
  (2, 'Nova intranet',      25000.00),
  (3, 'Auditoria interna',  30000.00);

INSERT INTO empleats (nom_emp, sou, codi_dept, codi_proj) VALUES
  ('Laura',  60000.00, 1, 1),
  ('Marta',  28000.00, 2, 2),
  ('Jordi',  19500.00, 3, 1),
  ('Anna',   22000.00, 2, 1);
