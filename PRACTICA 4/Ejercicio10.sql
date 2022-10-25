/* 10 Dadas las siguientes relaciones
Vehiculo = (patente, modelo, marca, peso, km)
Camion = (patente, largo, max_toneladas, cant_ruedas, tiene_acoplado)
Auto = (patente, es_electrico, tipo_motor)
Service = (fecha, patente, km_service, observaciones, monto)
Parte = (cod_parte, nombre, precio_parte)
Service_Parte = (fecha, patente, cod_parte, precio) */
/* 1. Listar todos los datos de aquellos camiones que tengan entre 4 y 8 ruedas, y que hayan realizado algún
service en los últimos 365 días. Ordenar por patente, modelo y marca. */

SELECT v.patente, v.modelo, v.marca, v.peso, v.km
FROM Camion c INNER JOIN Vehiculo v ON (c.patente = v.patente)
    INNER JOIN Service s ON (c.patente = s.patente)
WHERE (c.cant_ruedas BETWEEN 4 AND 8) AND (s.fecha BETWEEN "25/10/2021" AND "25/10/2021")

/* 2. Listar los autos que hayan realizado el service “cambio de aceite” antes de los 13.000 km o hayan realizado el
service “inspección general” que incluya la parte “filtro de combustible”. */

SELECT a.patente, a.es_electrico, a.tipo_motor
FROM Auto a INNER JOIN Service s ON (a.patente = s.patente)
WHERE (s.km_service < 13000) AND (s.observaciones LIKE "%cambio de aceite%")
UNION (
    SELECT a.patente, a.es_electrico, a.tipo_motor
    FROM Auto a INNER JOIN Service s ON (a.patente = s.patente)
        INNER JOIN Service_Parte sp ON (s.patente = sp.patente ) and (s.fecha = sp.fecha)
        INNER JOIN Parte p ON (sp.cod_parte = p.cod_parte)
    WHERE (s.observaciones LIKE "%inspección general%") AND (p.nombre = "filtro de combustible") 
)

/* 3. Listar nombre y precio de todas las partes que aparezcan en más de 30 service que hayan salido (partes) más
de $4.000. */

SELECT p.nombre, p.precio_parte
FROM Parte p INNER JOIN Service_Parte sp ON(p.cod_parte = sp.cod_parte)
WHERE p.precio_parte > 4000
GROUP BY p.cod_parte, p.nombre, p.precio_parte
HAVING COUNT(*) > 30

/* 4. Dar de baja todos los camiones con más de 250.000 km. */

DELETE FROM Service_Parte WHERE patente IN (
    SELECT c.patente
    FROM Camion c INNER JOIN Vehiculo v ON (c.patente = v.patente)
    WHERE v.km > 250000
)

DELETE FROM Service WHERE patente IN (
    SELECT c.patente
    FROM Camion c INNER JOIN Vehiculo v ON (c.patente = v.patente)
    WHERE v.km > 250000
)

DELETE FROM Vehiculo WHERE patente IN (
    SELECT c.patente
    FROM Camion c INNER JOIN Vehiculo v ON (c.patente = v.patente)
    WHERE v.km > 250000
)

DELETE FROM Camion WHERE v.km > 250000

/* 5. Listar el nombre y precio de aquellas partes que figuren en todos los service realizados en el corriente año. */

--CONSULTAR

SELECT p.nombre, p.precio_parte
FROM Parte p 
WHERE NOT EXIST (
    SELECT s.fecha, s.patente
    FROM Service s
    EXCEPT (
        SELECT s2.fecha, s2.patente
        FROM Service2 s2 INNER JOIN Service_Parte sp ON (s2.fecha = sp.fecha) AND (s2.patente = sp.patente)
        WHERE (sp.cod_parte = p.cod_parte) AND (sp.fecha BETWEEN "01/01/2022" AND "31/12/2022")
    )
)

/* 6. Listar todos los autos cuyo tipo de motor sea eléctrico. Mostrar información de patente, modelo , marca y peso. */

SELECT a.es_electrico, a.tipo_motor, v.modelo, v.marca, v.peso
FROM Auto a INNER JOIN Vehiculo v ON (a.patente = v.patente) 
WHERE a.es_electrico = true

/* 7. Dar de alta una parte, cuyo nombre sea “Aleron” y precio $6400. */

INSERT INTO Parte (nombre, precio_parte) VALUES ("Aleron",6400)

/* 8. Dar de baja todos los services que se realizaron al auto con patente ‘AWA564’. */

DELETE FROM Service_Parte WHERE patente"‘AWA564"
DELETE FROM Service WHERE patente ="AWA564"

/* 9. Listar todos los vehículos que hayan tenido services durante el 2018. */

SELECT *
FROM Vehiculo v INNER Service s ON (v.patente = s.patente)
WHERE (s.fecha BETWEEN "01/01/2018" AND "31/12/2018")
