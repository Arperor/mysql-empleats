# mysql-empleats

Rutines emmagatzemades de MySQL sobre una base de dades de plantilla
(`empleats`, `departaments`, `projectes`). És un exercici de **Gestió de bases de
dades** (CFGS ASIX, mòdul 0372) del curs 2025-26.

El que hi ha no és un `SELECT * FROM`: són nou rutines amb validació de debò.

## Què fa

**Cinc procediments** (`procedures.sql`):

| Procediment | Què fa |
|---|---|
| `obtenir_sou_mitja_departament` | Calcula la mitjana salarial d'un departament i la torna en un paràmetre de sortida |
| `afegir_empleat` | Insereix un empleat comprovant abans que el departament i el projecte existeixin |
| `actualitzar_sou_empleat` | Canvia el sou si l'empleat existeix |
| `canviar_departament_projecte` | Mou un empleat de departament i projecte amb les tres validacions |
| | |

**Cinc funcions** (`functions.sql`):

| Funció | Què fa |
|---|---|
| `percentatge_pressupost` | Pes d'un projecte sobre el pressupost total |
| `millor_pagats_proj` | Nom del millor pagat d'un projecte, amb `LIMIT 1` |
| `nom_departament_emp` | Nom del departament d'un empleat, amb `JOIN` i `IFNULL` |
| `calcular_sou_net` | Sou net amb tres trams de retenció |
| `classificacio_sou` | Classifica l'empleat per tram salarial amb `CASE` |

## Detalls que valen la pena

- **Els errors es llancen, no s'amaguen.** Quan el departament o el projecte no
  existeixen, la rutina fa `SIGNAL SQLSTATE '45000'` amb un missatge concret. La
  inserció no arriba a fer-se.
- **Es comprova abans d'escriure.** Cada rutina compta files amb `COUNT(*)` i
  decideix amb `IF` / `ELSEIF`. No es confia que la clau forana ho aturi tot,
  perquè el que es vol és un error llegible i no un `1452`.
- **`DELIMITER $$`** és imprescindible: sense canviar el delimitador, el client de
  MySQL talla la rutina al primer `;` del cos.

## Com es prova

```bash
mysql -u root -p < schema-exemple.sql
mysql -u root -p < procedures.sql
mysql -u root -p < functions.sql
```

Les crides d'exemple són al final de cada fitxer, després de `-- Ús:`.

## Sobre `schema-exemple.sql`

**No és l'esquema original de classe.** És una reconstrucció feta a partir de les
columnes i les taules que fan servir les rutines, perquè el repositori es pugui
executar i provar. Serveix per demostrar el codi, no per documentar el disseny
de la base de dades.

## Autor

Pere Brau Martínez · ASIX C1A
