/* Ejercicio 7:
Banda(codigoB, nombreBanda, genero_musical, año_creacion)
Integrante (DNI, nombre, apellido,dirección,email, fecha_nacimiento,codigoB(fk))
Escenario(nroEscenario, nombre _ escenario, ubicación,cubierto, m2, descripción)
Recital(fecha,hora,nroEscenario, codigoB (fk))
 */
/*  1. Listar DNI, nombre, apellido,dirección y email de integrantes nacidos entre 1980 y 1990 y
hayan realizado algún recital durante 2018. */

SELECT i.DNI, i.nombre, i.apellido, i.direccion
FROM Integrante i
WHERE i.fecha_nacimiento BETWEEN "01/01/1980" AND "31/12/1990" AND i.DNI IN (
    SELECT i.DNI
    FROM Recital r INNER JOIN Banda b ON (r.codiboB = b.codigoB)
        INNER JOIN Integrante i ON (b.codigoB = i.codigoB)
    WHERE r.fecha BETWEEN "01/01/2018" AND "31/12/2018"
)

/* 2. Reportar nombre, género musical y año de creación de bandas que hayan realizado
recitales durante 2018, pero no hayan tocado durante 2017 . */

SELECT b.nombreBanda, b.genero_musical, b.año_creacion
FROM Banda b INNER JOIN Recital r ON (b.codigoB = r.codigoB)
WHERE r.fecha BETWEEN "01/01/2018" AND "31/12/2018"
EXCEPT(
    SELECT b.nombreBanda, b.genero_musical, b.año_creacion
    FROM Banda b INNER JOIN Recital r ON (b.codigoB = r.codigoB)
    WHERE r.fecha BETWEEN "01/01/2017" AND "31/12/2017"
)

/* 3. Listar el cronograma de recitales del dia 04/12/2018. Se deberá listar: nombre de la banda
que ejecutará el recital, fecha, hora, y el nombre y ubicación del escenario correspondiente. */

SELECT b.nombre, r.fecha, r.hora, e.nombre_escenario, e.ubicación
FROM Recital r INNER JOIN Banda b ON (r.codigoB = b.codigoB)
    INNER JOIN Escenario e ON (r.nroEscenario = e.nroEscenario)
WHERE r.fecha = "04/12/2018"

/* 4. Listar DNI, nombre, apellido,email de integrantes que hayan tocado en el escenario con
nombre ‘Gustavo Cerati’ y en el escenario con nombre ‘Carlos Gardel’. */

SELECT i.DNI, i.nombre, i.apellido, i.email
FROM Recital r INNER JOIN Integrante i ON (r.codigoB = i.codigoB)
    INNER JOIN Escenario e ON (r.nroEscenario = e.nroEscenario)
WHERE e.nombre_escenario = "Gustavo Cerati"
INTERSECT(
    SELECT i.DNI, i.nombre, i.apellido, i.email
    FROM Recital r INNER JOIN Integrante i ON (r.codigoB = i.codigoB)
        INNER JOIN Escenario e ON (r.nroEscenario = e.nroEscenario)
    WHERE e.nombre_escenario = "Carlos Gardel"
) 

/* 5. Reportar nombre, género musical y año de creación de bandas que tengan más de 8
integrantes. */

SELECT b.nombreBanda, b.genero_musical, b.año_creacion
FROM Banda b INNER JOIN Integrante i ON (b.codigoB = i.codigoB)
GROUP BY b.codigoB, b.nombreBanda, b.genero_musical, b.año_creacion
HAVING COUNT(*) > 8

/* 6. Listar nombre de escenario, ubicación y descripción de escenarios que solo tuvieron
recitales con género musical rock and roll. Ordenar por nombre de escenario */

SELECT e.nombre_escenario, e.ubicación, e.descripción
FROM Escenario e INNER JOIN Recital r ON (e.nroEscenario = r.nroEscenario)
    INNER JOIN Banda b ON (r.codigoB = b.codigoB)
WHERE b.genero_musical = "rock and roll" 
EXCEPT (
    SELECT e.nombre_escenario, e.ubicación, e.descripción
    FROM Escenario e INNER JOIN Recital r ON (e.nroEscenario = r.nroEscenario)
        INNER JOIN Banda b ON (r.codigoB = b.codigoB)
    WHERE b.genero_musical <> "rock and roll"
)
ORDER BY e.nombre_escenario

/* 7. Listar nombre, género musical y año de creación de bandas que hayan realizado recitales
en escenarios cubiertos durante 2018.// cubierto es true, false según corresponda */

SELECT b.nombreBanda, b.genero_musical, b.año_creacion
FROM Escenario e INNER JOIN Recital r ON (e.nroEscenario = r.nroEscenario)
    INNER JOIN Banda b ON (r.codigoB = b.codigoB)
WHERE (e.cubierto = true) AND (r.fecha BETWEEN "01/01/2018" AND "31/12/2018") 

/* 8. Reportar para cada escenario, nombre del escenario y cantidad de recitales durante 2018. */

--SI NO MENCIONA TENER EN CUENTA A LOS QUE NO TUVIERON --> NO TENERLOS

SELECT e.nombre_escenario, COUNT(*) as Cantidad
FROM Escenario e LEFT JOIN Recital r ON (e.nroEscenario = r.nroEscenario)
WHERE (r.fecha BETWEEN "01/01/2018" AND "31/12/2018")
GROUP BY e.nroEscenario, e.nombre_escenario

/* 9. Modificar el nombre de la banda ‘Mempis la Blusera’ a: ‘Memphis la Blusera’. */

UPDATE Banda SET nombreBanda="Memphis la Blusera" WHERE nombreBanda = "Mempis la Blusera"