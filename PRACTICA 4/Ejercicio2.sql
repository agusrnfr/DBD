/* Ejercicio 2
AGENCIA (RAZON_SOCIAL, dirección, telef, e-mail)
CIUDAD (CODIGOPOSTAL, nombreCiudad, añoCreación)
CLIENTE (DNI, nombre, apellido, teléfono, dirección)
VIAJE( FECHA,HORA,DNI, cpOrigen(fk), cpDestino(fk), razon_social(fk), descripcion)
//cpOrigen y cpDestino corresponden a la ciudades origen y destino del viaje */

/* 1. Listar razón social, dirección y teléfono de agencias que realizaron viajes desde la ciudad de
‘La Plata’ (ciudad origen) y que el cliente tenga apellido ‘Roma’. Ordenar por razón social y
luego por teléfono. */


SELECT a.RAZON_SOCIAL, a.direccion, a.telef
FROM VIAJE v 
    INNER JOIN AGENCIA a ON (v.razon_social = a.razon_social)
    INNER JOIN Cliente c ON (v.DNI = c.DNI)
WHERE (c.apellido = "Roma") AND (v.RAZON_SOCIAL IN (
    SELECT v.RAZON_SOCIAL
    FROM VIAJE v INNER JOIN CIUDAD c ON(v.cpOrigen = c.CODIGOPOSTAL)
    WHERE c.nombreCiudad = "La Plata"
))
ORDER BY v.RAZON_SOCIAL, v.telef

/* 2. Listar fecha, hora, datos personales del cliente, ciudad origen y destino de viajes realizados
en enero de 2019 donde la descripción del viaje contenga el String ‘demorado’. */

SELECT v.fecha, v.hora, c.DNI, c.nombre, c.apellido, c.telefono, c.direccion, ori.nombre, dest.nombre
FROM VIAJE v 
    INNER JOIN Cliente c ON (v.DNI = c.DNI)
    INNER JOIN Ciudad ori ON (v.cpOrigen = ori.CODIGOPOSTAL)
    INNER JOIN Ciudad dest ON (v.cpDestino = dest.CODIGOPOSTAL)
WHERE (v.fecha BETWEEN "01/01/2019" and "31/01/2019") and (v.descripcion LIKE "%demorado%")

/* 3. Reportar información de agencias que realizaron viajes durante 2019 o que tengan dirección
de mail que termine con ‘@jmail.com’. */

SELECT a.RAZON_SOCIAL, a.direccion, a.telef, a.email
FROM AGENCIA a INNER JOIN VIAJE v (a.RAZON_SOCIAL = v.RAZON_SOCIAL)
WHERE (a.email LIKE "%@jmail.com") OR (v.fecha BETWEEN "01/01/2019" and "31/12/2019")

/* 4. Listar datos personales de clientes que viajaron solo con destino a la ciudad de ‘Coronel
Brandsen’ */


SELECT c.DNI, c.nombre, c.apellido, c.telefono, c.direccion
FROM Cliente c INNER JOIN Viaje v ON (c.DNI = v.DNI)
    INNER JOIN Ciudad ciu ON(v.cpDestino = ciu.CODIGOPOSTAL)
WHERE ciu.nombreCiudad = "Coronel Brandsen" 
EXCEPT (
    SELECT c.DNI, c.nombre, c.apellido, c.telefono, c.direccion
    FROM Cliente c INNER JOIN Viaje v ON (c.DNI = v.DNI)
        INNER JOIN Ciudad ciu ON(v.cpDestino = ciu.CODIGOPOSTAL)
    WHERE NOT (ciu.nombreCiudad = "Coronel Brandsen")
)

/* 5. Informar cantidad de viajes de la agencia con razón social ‘TAXI Y’ realizados a ‘Villa Elisa’. */

SELECT COUNT(*) as "Cantidad de Viajes"
FROM AGENCIA a 
    INNER JOIN VIAJE v (a.RAZON_SOCIAL = v.RAZON_SOCIAL)
    INNER JOIN Ciudad c (v.cpDestino = c.CODIGOPOSTAL)
WHERE a.RAZON_SOCIAL = "TAXI Y" and c.nombreCiudad = "Villa Elisa"

/* 6. Listar nombre, apellido, dirección y teléfono de clientes que viajaron con todas las agencias. */


SELECT c.nombre, c.apellido, c.direccion, c.telefono
FROM Cliente c
WHERE c.DNI IN (
    SELECT v.DNI
    FROM Viaje v
    WHERE NOT EXIST (
        SELECT a.RAZON_SOCIAL
        FROM AGENCIA a
        EXCEPT (
            SELECT v2.RAZON_SOCIAL
            FROM VIAJE v2, AGENCIA a2
            WHERE (v2.RAZON_SOCIAL = a2.RAZON_SOCIAL) AND (v.DNI = v2.DNI)
        )
    )
)

--
SELECT c.nombre, c.apellido, c.direccion, c.telefono
FROM Cliente c
WHERE NOT EXIST (
    SELECT *
    FROM Agencia a
    WHERE NOT EXIST (
        SELECT *
        FROM Viaje v 
        WHERE (a.razon_social = v.razon_social) AND (v.DNI = c.DNI)
    )
)


/* 7. Modificar el cliente con DNI: 38495444 actualizando el teléfono a: 221-4400897. */

UPDATE CLIENTE SET telefono="221-4400897" WHERE DNI="38495444"

/* 8. Listar razon_social, dirección y teléfono de la/s agencias que tengan mayor cantidad de
viajes realizados. */

SELECT a.RAZON_SOCIAL, a.direccion, a.telef
FROM AGENCIA a INNER JOIN VIAJE v ON (a.RAZON_SOCIAL = v.RAZON_SOCIAL)
GROUP BY v.RAZON_SOCIAL, v.direccion, v.telef
HAVING COUNT(*) >= ALL (
    SELECT COUNT(*)
    FROM VIAJE v
    GROUP BY v.RAZON_SOCIAL
)

/* 9. Reportar nombre, apellido, dirección y teléfono de clientes con al menos 10 viajes. */

SELECT c.nombre, c.apellido, c.telefono
FROM CLIENTE c INNER JOIN VIAJE v ON (c.DNI = v.DNI)
GROUP BY c.nombre, c.apellido, c.telefono
HAVING COUNT(*) >= 10


/* 10. Borrar al cliente con DNI 40325692. */

DELETE FROM VIAJE WHERE DNI="40325692"
DELETE FROM CLIENTE WHERE DNI="40325692"