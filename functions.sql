
Ex 1 — Percentatge de pressupost d'un projecte

DELIMITER $$
CREATE FUNCTION percentatge_pressupost(p_codi_proj INT)
RETURNS DECIMAL(5,2)
DETERMINISTIC READS SQL DATA
BEGIN
    DECLARE v_pressupost       DECIMAL(10,2);
    DECLARE v_pressupost_total DECIMAL(10,2);

    SELECT pressupost        INTO v_pressupost       FROM projectes WHERE codi_proj = p_codi_proj;
    SELECT SUM(pressupost)  INTO v_pressupost_total FROM projectes;

    RETURN (v_pressupost / v_pressupost_total) * 100;
END$$
DELIMITER ;

-- Ús:
SELECT percentatge_pressupost(1);

Ex 2 — Millor pagat d'un projecte

DELIMITER $$
CREATE FUNCTION millor_pagats_proj(p_codi_proj INT)
RETURNS VARCHAR(15)
DETERMINISTIC READS SQL DATA
BEGIN
    DECLARE v_nom VARCHAR(15);

    SELECT nom_emp INTO v_nom
    FROM empleats
    WHERE codi_proj = p_codi_proj
    ORDER BY sou DESC
    LIMIT 1;

    IF v_nom IS NULL THEN
        RETURN 'Sense empleats';
    END IF;

    RETURN v_nom;
END$$
DELIMITER ;

-- Ús:
SELECT millor_pagats_proj(2);

Ex 3 — Nom del departament d'un empleat

DELIMITER $$
CREATE FUNCTION nom_departament_emp(p_codi_emp INT)
RETURNS VARCHAR(18)
DETERMINISTIC READS SQL DATA
BEGIN
    DECLARE v_nom_dept VARCHAR(18);

    SELECT d.nom_dept INTO v_nom_dept
    FROM empleats e
    JOIN departaments d ON e.codi_dept = d.codi_dept
    WHERE e.codi_emp = p_codi_emp;

    RETURN IFNULL(v_nom_dept, 'Sense departament');
END$$
DELIMITER ;

-- Ús:
SELECT nom_departament_emp(1);

Ex 4 — Sou net d'un empleat

DELIMITER $$
CREATE FUNCTION calcular_sou_net(p_codi_emp INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC READS SQL DATA
BEGIN
    DECLARE v_sou       DECIMAL(10,2);
    DECLARE v_retencio  DECIMAL(4,2);

    SELECT sou INTO v_sou FROM empleats WHERE codi_emp = p_codi_emp;

    IF    v_sou < 20000                        THEN SET v_retencio = 0.18;
    ELSEIF v_sou BETWEEN 20000 AND 30000     THEN SET v_retencio = 0.25;
    ELSE                                              SET v_retencio = 0.30;
    END IF;

    RETURN v_sou * (1 - v_retencio);
END$$
DELIMITER ;

-- Ús:
SELECT calcular_sou_net(1);

Ex 5 — Classificació d'un empleat per sou

DELIMITER $$
CREATE FUNCTION classificacio_sou(p_codi_emp INT)
RETURNS VARCHAR(10)
DETERMINISTIC READS SQL DATA
BEGIN
    DECLARE v_sou DECIMAL(10,2);

    SELECT sou INTO v_sou FROM empleats WHERE codi_emp = p_codi_emp;

    RETURN CASE
        WHEN v_sou < 18000                       THEN 'Baix'
        WHEN v_sou BETWEEN 18000 AND 28000      THEN 'Mitjà'
        WHEN v_sou BETWEEN 28001 AND 40000      THEN 'Alt'
        ELSE                                            'Directiu'
    END;
END$$
DELIMITER ;

-- Ús:
SELECT classificacio_sou(7); -- Laura, 60000 → Directiu


