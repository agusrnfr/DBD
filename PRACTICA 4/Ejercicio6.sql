/* Ejercicio 6:
Técnico (codTec, nombre, especialidad) // técnicos
Repuesto (codRep, nombre, stock, precio) // repuestos
RepuestoReparacion (nroReparac, codRep, cantidad, precio) //repuestos utilizados en
reparaciones.
Reparación (nroReparac, codTec, precio_total, fecha) //reparaciones realizadas. */
/* 1. Listar todos los repuestos, informando el nombre, stock y precio. Ordenar el
resultado por precio. */

SELECT nombre, stock, precio
FROM Repuesto
ORDER BY precio

/* 2. Listar nombre, stock, precio de repuesto que participaron en reparaciones durante
2019 y además no participaron en reparaciones del técnico ‘José Gonzalez’. */

SELECT DISTINCT r.nombre, r.stock, r.precio
FROM Repuesto r INNER JOIN RepuestoReparacion rr ON (r.codRep = rr.codRep)
    INNER JOIN Reparacion repa ON (rr.nroReparac = repa.nroReparac)
WHERE repa.fecha BETWEEN "01/01/2019" AND "31/12/2019"
EXCEPT (
    SELECT r.nombre, r.stock, r.precio
    FROM Repuesto r INNER JOIN RepuestoReparacion rr ON (r.codRep = rr.codRep)
    INNER JOIN Reparacion repa ON (rr.nroReparac = repa.nroReparac)
    INNER JOIN Tecnico tec ON (repa.codTec = tec.codTec)
    WHERE tec.nombre = "Jose Gonzalez"
)

/* 3. Listar el nombre, especialidad de técnicos que no participaron en ninguna
reparación. Ordenar por nombre ascendentemente. */

SELECT t.nombre, t.especialidad
FROM Tecnico t
WHERE NOT EXIST (
    SELECT *
    FROM Reparacion repa 
    WHERE (t.codTec = repa.codTec)
)
ORDER BY t.nombre

/* 4. Listar el nombre, especialidad de técnicos solo participaron en reparaciones durante
2018. */

SELECT DISTINCT t.nombre, t.especialidad
FROM Tecnico t INNER JOIN Reparacion repa (t.codTec = repa.codTec)
WHERE repa.fecha BETWEEN "01/01/2018" AND "31/12/2018" 
EXCEPT (
    SELECT t.nombre, t.especialidad
    FROM Tecnico t INNER JOIN Reparacion repa (t.codTec = repa.codTec)
    WHERE NOT(repa.fecha BETWEEN "01/01/2018" AND "31/12/2018")
)

/* 5. Listar para cada repuesto nombre, stock y cantidad de técnicos distintos que lo
utilizaron. Si un repuesto no participó en alguna reparación igual debe aparecer en
dicho listado. */

SELECT r.nombre, r.stock, COUNT(DISTINCT repa.codTec) as Cantidad
FROM Repuesto r LEFT JOIN RepuestoReparacion rr ON (r.codRep = rr.codRep)
    INNER JOIN Reparacion repa ON (rr.nroReparac = repa.nroReparac)
GROUP BY r.codRep, r.nombre, r.stock

/* 6. Listar nombre y especialidad del técnico con mayor cantidad de reparaciones
realizadas y el técnico con menor cantidad de reparaciones. */

SELECT t.nombre, t.especialidad
FROM Tecnico t INNER JOIN Reparacion repa (t.codTec = repa.codTec)
GROUP BY t.codTec, t.nombre, t.especialidad 
HAVING COUNT(*) >=ALL(
    SELECT COUNT(*)
    FROM Reparacion repa
    GROUP BY repa.codTec
)

SELECT t.nombre, t.especialidad
FROM Tecnico t INNER JOIN Reparacion repa (t.codTec = repa.codTec)
GROUP BY t.codTec, t.nombre, t.especialidad 
HAVING COUNT(*) <=ALL(
    SELECT COUNT(*)
    FROM Reparacion repa
    GROUP BY repa.codTec
)
/* 7. Listar nombre, stock y precio de todos los repuestos con stock mayor a 0 y que
dicho repuesto no haya estado en reparaciones con precio_total superior a 10000. */

SELECT r.nombre, r.stock, r.precio
FROM Repuesto r
WHERE r.stock > 0 AND NOT IN (
    SELECT rr.codRep
    FROM RepuestoReparacion rr
    WHERE rr.precio > 10000
)

/* 8. Proyectar precio, fecha y precio total de aquellas reparaciones donde se utilizó algún
repuesto con precio en el momento de la reparación mayor a $1000 y menor a
$5000. */

SELECT rr.precio, r.fecha, r.precio_total
FROM Reparacion r INNER JOIN RepuestoReparacion rr ON (r.nroReparac = rr.nroReparac)
WHERE (rr.precio > 1000 AND rr.precio < 5000)

/* 9. Listar nombre, stock y precio de repuestos que hayan sido utilizados en todas las
reparaciones */

--si a todas los repuestoreparacion le saco en las que fueron utilizadas por el respuesto y me da vacio --> significa que se uso en todas

SELECT r.nombre, r.stock, r.precio
FROM Repuesto r
WHERE NOT EXIST (
    SELECT rr.codRep
    FROM RepuestoReparacion rr
    EXCEPT (
        SELECT r2.codRep
        FROM Repuesto r2, RepuestoReparacion rr2
        WHERE (r2.codRep = rr2.codRep) AND (r2.codRep = r.codRep)
    )
)

/* 10. Listar fecha, técnico y precio total de aquellas reparaciones que necesitaron al
menos 10 repuestos distintos. */

SELECT r.fecha, t.nombre, r.precio_total
FROM Reparacion r INNER JOIN Tecnico t (r.codTec = t.codTec)
    INNER JOIN RepuestoReparacion rr (r.nroReparac = rr.nroReparac)
GROUP BY r.nroReparac, r.fecha, t.nombre, r.precio_total
HAVING COUNT(*) >= 10