
Ex 1 — Sou mitjà d'un departament

DELIMITER $$
CREATE PROCEDURE obtenir_sou_mitja_departament(IN p_codi_dept INT, OUT p_sou_mitja DECIMAL(10,2))
BEGIN
    SELECT AVG(sou) INTO p_sou_mitja
    FROM empleats
    WHERE codi_dept = p_codi_dept;
END$$
DELIMITER ;

-- Ús:
CALL obtenir_sou_mitja_departament(1, @mitja);
SELECT @mitja;

Ex 2 — Afegir un nou empleat

DELIMITER $$
CREATE PROCEDURE afegir_empleat(
    IN p_nom      VARCHAR(15),
    IN p_sou      DECIMAL(10,2),
    IN p_codi_dept INT,
    IN p_codi_proj INT
)
BEGIN
    DECLARE v_dept_ok INT DEFAULT 0;
    DECLARE v_proj_ok INT DEFAULT 0;

    SELECT COUNT(*) INTO v_dept_ok FROM departaments WHERE codi_dept = p_codi_dept;
    SELECT COUNT(*) INTO v_proj_ok FROM projectes    WHERE codi_proj = p_codi_proj;

    IF v_dept_ok = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Departament no vàlid';
    ELSEIF p_codi_proj IS NOT NULL AND v_proj_ok = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Projecte no vàlid';
    ELSE
        INSERT INTO empleats (nom_emp, sou, codi_dept, codi_proj)
        VALUES (p_nom, p_sou, p_codi_dept, p_codi_proj);
    END IF;
END$$
DELIMITER ;

-- Ús:
CALL afegir_empleat('Anna', 22000, 2, 1);

Ex 3 — Actualitzar sou d'un empleat

DELIMITER $$
CREATE PROCEDURE actualitzar_sou_empleat(IN p_codi_emp INT, IN p_nou_sou DECIMAL(10,2))
BEGIN
    DECLARE v_existeix INT DEFAULT 0;

    SELECT COUNT(*) INTO v_existeix FROM empleats WHERE codi_emp = p_codi_emp;

    IF v_existeix = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Empleat no existeix';
    ELSE
        UPDATE empleats SET sou = p_nou_sou WHERE codi_emp = p_codi_emp;
    END IF;
END$$
DELIMITER ;

-- Ús:
CALL actualitzar_sou_empleat(1, 25000);

Ex 4 — Canviar empleat de departament i projecte

DELIMITER $$
CREATE PROCEDURE canviar_departament_projecte(
    IN p_codi_emp  INT,
    IN p_codi_dept INT,
    IN p_codi_proj INT
)
BEGIN
    DECLARE v_emp_ok  INT DEFAULT 0;
    DECLARE v_dept_ok INT DEFAULT 0;
    DECLARE v_proj_ok INT DEFAULT 0;

    SELECT COUNT(*) INTO v_emp_ok  FROM empleats     WHERE codi_emp  = p_codi_emp;
    SELECT COUNT(*) INTO v_dept_ok FROM departaments WHERE codi_dept = p_codi_dept;
    SELECT COUNT(*) INTO v_proj_ok FROM projectes    WHERE codi_proj = p_codi_proj;

    IF v_emp_ok = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Empleat no existeix';
    ELSEIF v_dept_ok = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Departament no vàlid';
    ELSEIF p_codi_proj IS NOT NULL AND v_proj_ok = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Projecte no vàlid';
    ELSE
        UPDATE empleats
        SET   codi_dept = p_codi_dept,
              codi_proj = p_codi_proj
        WHERE codi_emp  = p_codi_emp;
    END IF;
END$$
DELIMITER ;

-- Ús:
CALL canviar_departament_projecte(1, 3, 2);

