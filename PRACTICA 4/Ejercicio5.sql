/* Ejercicio 5:
Localidad(CodigoPostal, nombreL, descripcion, #habitantes)
Arbol(nroArbol, especie, años, calle, nro, codigoPostal(fk))
Podador(DNI, nombre, apellido, telefono,fnac,codigoPostalVive(fk))
Poda(codPoda,fecha, DNI(fk),nroArbol(fk)) */
/* 1. Listar especie, años, calle, nro. y localidad de árboles podados por el podador ‘Juan Perez’ y
por el podador ‘Jose Garcia’. */



--Solucion 1

SELECT DISTINCT a.especie, a.años, a.calle, a.nro, l.nombreL
FROM Arbol a INNER JOIN Localidad l ON (a.codigoPostal = l.CodigoPostal)
    INNER JOIN Poda po ON (a.nroArbol = po.nroArbol)
    INNER JOIN Podador p ON (po.DNI = p.DNI)
WHERE (p.nombre = "Juan" AND p.apellido = "Perez") AND a.nroArbol IN (
    SELECT a.nroArbol
    FROM ARBOL a INNER JOIN Poda po ON (a.nroArbol = po.nroArbol)
        INNER JOIN Podador p ON (po.DNI = p.DNI)
    WHERE p.nombre = "Jose" AND p.apellido = "Garcia"
    ) 

--Solucion 2

(SELECT DISTINCT a.especie, a.años, a.calle, a.nro, l.nombreL
FROM Arbol a INNER JOIN Localidad l ON (a.codigoPostal = l.CodigoPostal)
    INNER JOIN Poda po ON (a.nroArbol = po.nroArbol)
    INNER JOIN Podador p ON (po.DNI = p.DNI)
WHERE p.nombre = "Juan" AND p.apellido = "Perez")
INTERSECT(
    SELECT DISTINCT a.especie, a.años, a.calle, a.nro, l.nombreL
    FROM Arbol a INNER JOIN Localidad l ON (a.codigoPostal = l.CodigoPostal)
        INNER JOIN Poda po ON (a.nroArbol = po.nroArbol)
        INNER JOIN Podador p ON (po.DNI = p.DNI)
    WHERE p.nombre = "Jose" AND p.apellido = "Garcia"
)

/* 2. Reportar DNI, nombre, apellido, fnac y localidad donde viven podadores que tengan podas
durante 2018. */

SELECT DISTINCT p.DNI, p.nombre, p.apellido, p.fnac, l.nombreL
FROM Podador p INNER JOIN Poda po (p.DNI = po.DNI)
    INNER JOIN Localidad l (p.codigoPostal = l.CodigoPostal)
WHERE po.fecha BETWEEN "01/01/2018" AND "31/12/2018"

/* 3. Listar especie, años, calle, nro y localidad de árboles que no fueron podados nunca */

--Solucion 1

SELECT a.especie, a.años, a.calle, a.nro, l.nombreL
FROM Arbol a INNER JOIN Localidad l ON (a.codigoPostal = l.CodigoPostal)
WHERE a.nroArbol NOT IN (
    SELECT a.nroArbol
    FROM Arbol a INNER JOIN Poda po (a.nroArbol = po.nroArbol)
)

--Solucion 2

SELECT a.especie, a.años, a.calle, a.nro, l.nombreL
FROM Arbol a INNER JOIN Localidad l ON (a.codigoPostal = l.CodigoPostal)
    LEFT JOIN Poda po ON (a.nroArbol = po.nroArbol)
WHERE po.nroArbol IS NULL

--Solucion 3

SELECT a.especie, a.años, a.calle, a.nro, l.nombreL
FROM Arbol a INNER JOIN Localidad l ON (a.codigoPostal = l.CodigoPostal)
WHERE NOT EXIST (
    SELECT *
    FROM Poda p 
    WHERE (p.nroArbol = a.nroArbol)
)

/* 4. Reportar especie, años,calle, nro y localidad de árboles que fueron podados durante 2017 y
no fueron podados durante 2018. */

SELECT a.especie, a.años, a.calle, a.nro, l.nombreL
FROM Arbol a INNER JOIN Localidad l ON (a.codigoPostal = l.CodigoPostal)
    INNER JOIN Poda po ON (a.nroArbol = po.nroArbol)
WHERE (po.fecha BETWEEN "01/01/2017" AND "31/12/2017") AND a.nroArbol NOT IN(
    SELECT a.nroArbol
    FROM ARBOL a INNER JOIN Poda po ON (a.nroArbol = po.nroArbol)
    WHERE po.fecha BETWEEN "01/01/2018" AND "31/12/2018"
) 

-- MISMA SOLUCION 2 QUE PUNTO 1

--Solucion 3

SELECT a.especie, a.años, a.calle, a.nro, l.nombreL
FROM Arbol a INNER JOIN Localidad l ON (a.codigoPostal = l.CodigoPostal)
    INNER JOIN Poda po ON (a.nroArbol = po.nroArbol)
WHERE (po.fecha BETWEEN "01/01/2017" AND "31/12/2017")
EXCEPT (
    SELECT a.especie, a.años, a.calle, a.nro, l.nombreL
    FROM ARBOL a INNER JOIN Localidad l ON (a.codigoPostal = l.CodigoPostal)
        INNER JOIN Poda po ON (a.nroArbol = po.nroArbol)
    WHERE po.fecha BETWEEN "01/01/2018" AND "31/12/2018") 

/* 5. Reportar DNI, nombre, apellido, fnac y localidad donde viven podadores con apellido
terminado con el string ‘ata’ y que el podador tenga al menos una poda durante 2018.
Ordenar por apellido y nombre. */


SELECT p.DNI, p.nombre, p.apellido, p.fnac, l.nombreL
FROM Podador p INNER JOIN Localidad l (p.codigoPostal = l.CodigoPostal)
WHERE (p.apellido LIKE "%ata") AND p.DNI IN (
    SELECT po.DNI
    FROM Poda po
    WHERE po.fecha BETWEEN "01/01/2018" AND "31/12/2018"
)
ORDER BY p.nombre,p.apellido

/* 6. Listar DNI, apellido, nombre, teléfono y fecha de nacimiento de podadores que solo podaron
árboles de especie ‘Coníferas’. */


SELECT p.DNI, p.nombre, p.apellido, p.telefono, p.fnac
FROM Podador p INNER JOIN Poda po ON (p.DNI = po.DNI)
    INNER JOIN Arbol a ON (po.nroArbol = a.nroArbol)
WHERE a.especie = "Coniferas" 
EXCEPT (
    SELECT p.DNI, p.nombre, p.apellido, p.telefono, p.fnac
    FROM Podador p INNER JOIN Poda po ON (p.DNI = po.DNI)
        INNER JOIN Arbol a ON (po.nroArbol = a.nroArbol)
        WHERE NOT (a.especie = "Coniferas")
)


/* 7. Listar especie de árboles que se encuentren en la localidad de ‘La Plata’ y también en la
localidad de ‘Salta’. */

SELECT a.especie
FROM Arbol a INNER JOIN Localidad l ON (a.codigoPostal = l.CodigoPostal)
WHERE l.nombreL = "La Plata"
INTERSECT 
(SELECT a.especie
FROM Arbol a INNER JOIN Localidad l ON (a.codigoPostal = l.CodigoPostal)
WHERE l.nombreL = "Salta")

/* 8. Eliminar el podador con DNI: 22234566. */

DELETE FROM Poda WHERE DNI="22234566"
DELETE FROM Podador WHERE DNI="22234566"

/* 9. Reportar nombre, descripción y cantidad de habitantes de localidades que tengan menos de
100 árboles. */

--En group by pongo codigoPostal porque pueden haber localidades con mismo nombre.

SELECT l.nombreL, l.descripcion, l.habitantes
FROM Arbol a INNER JOIN Localidad l ON (a.codigoPostal = l.CodigoPostal)
GROUP BY l.CodigoPostal, l.nombreL, l.descripcion, l.habitantes
HAVING COUNT(*) < 100