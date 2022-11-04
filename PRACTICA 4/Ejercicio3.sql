/* 3:
Club=(codigoClub, nombre, anioFundacion, codigoCiudad(FK))
Ciudad=(codigoCiudad, nombre)
Estadio=(codigoEstadio, codigoClub(FK), nombre, direccion)
Jugador=(DNI, nombre, apellido, edad, codigoCiudad(FK))
ClubJugador(codigoClub, DNI, desde, hasta) */
/* 1. Reportar nombre y anioFundacion de aquellos clubes de la ciudad de La Plata que no
poseen estadio. */

--CONSULTAR

SELECT c.nombre, c.anioFundacion
FROM Club c 
    LEFT JOIN Estadio e ON (c.codigoClub = e.codigoClub)
    INNER JOIN Ciudad ciu ON (c.codigoCiudad = ciu.codigoCiudad)
WHERE ciu.nombre = "La Plata" and e.codigoEstadio IS NULL

/* 2. Listar nombre de los clubes que no hayan tenido ni tengan jugadores de la ciudad de
Berisso. */

SELECT c.nombre
FROM Club c INNER JOIN ClubJugador cj ON (c.codigoClub = cj.codigoClub)
WHERE cj.DNI NOT IN (
    SELECT j.DNI
    FROM Jugador j INNER JOIN Ciudad c ON (j.codigoCiudad = c.codigoCiudad)
    WHERE (c.nombre = "Berisso")
)
/* 3. Mostrar DNI, nombre y apellido de aquellos jugadores que jugaron o juegan en el club
Gimnasia y Esgrima La PLata. */

--Solucion 1

SELECT j.DNI, j.nombre, j.apellido 
FROM Jugador j INNER JOIN ClubJugador cj ON (j.DNI = cj.DNI)
WHERE cj.codigoClub IN (
    SELECT c.codigoClub
    FROM Club c
    WHERE (c.nombre = "Gimnasia y Esgrima La Plata")
)

--Solucion 2

SELECT j.DNI, j.nombre, j.apellido 
FROM Jugador j INNER JOIN ClubJugador cj ON (j.DNI = cj.DNI) 
    INNER JOIN Club c ON (c.codigoClub = cj.codigoClub)
WHERE (c.nombre = "Gimnasia y Esgrima La Plata")

/* 4. Mostrar DNI, nombre y apellido de aquellos jugadores que tengan más de 29 años y
hayan jugado o juegan en algún club de la ciudad de Córdoba. */

--Solucion 1

SELECT j.DNI, j.nombre, j.apellido 
FROM Jugador j
WHERE j.edad > 29 AND j.DNI IN (
    SELECT cj.DNI
    FROM ClubJugador cj INNER JOIN Club c ON (cj.codigoClub = c.codigoClub)
    WHERE c.codigoCiudad IN (
        SELECT c.codigoCiudad
        FROM Ciudad c
        WHERE c.nombre = "Cordoba"
    )
)

--Solucion 2

SELECT j.DNI, j.nombre, j.apellido 
FROM Jugador j INNER JOIN ClubJugador cj ON (j.DNI = cj.DNI)
    INNER JOIN Club c ON (cj.codigoClub = c.codigoClub)
    INNER JOIN Ciudad ciu ON (c.codigoCiudad = ciu.codigoCiudad)
WHERE j.edad > 29 AND ciu.nombre = "Cordoba"

/* 5. Mostrar para cada club, nombre de club y la edad promedio de los jugadores que juegan
actualmente en cada uno. */

SELECT c.nombre, AVG(j.edad) as Promedio
FROM Club c LEFT JOIN ClubJugador cj ON (c.codigoClub = cj.codigoClub)
    INNER JOIN Jugador j ON (cj.DNI = j.DNI)
WHERE cj.hasta IS NULL
GROUP BY c.codigoClub, c.nombre

/* 6. Listar para cada jugador: nombre, apellido, edad y cantidad de clubes diferentes en los
que jugó. (incluido el actual) */

SELECT j.nombre, j.apellido, j.edad, COUNT(*) as Cantidad
FROM Jugador j INNER JOIN ClubJugador cj ON (j.DNI = cj.DNI)
GROUP BY j.DNI, j.nombre, j.apellido, j.edad

/* 7. Mostrar el nombre de los clubes que nunca hayan tenido jugadores de la ciudad de Mar
del Plata. */

SELECT c.nombre
FROM Club c INNER JOIN ClubJugador cj ON (c.codigoClub = cj.codigoClub)
WHERE cj.DNI NOT IN (
    SELECT j.DNI
    FROM Jugador j INNER JOIN Ciudad c ON (j.codigoCiudad = c.codigoCiudad)
    WHERE (c.nombre = "Mar del Plata")
)

/* 8. Reportar el nombre y apellido de aquellos jugadores que hayan jugado en todos los
clubes. */


SELECT j.nombre, j.apellido
FROM Jugador j
WHERE j.DNI IN (
    SELECT cj.DNI
    FROM ClubJugador cj
    WHERE NOT EXIST (
        SELECT c.codigoClub
        FROM Club c
        EXCEPT (
            SELECT cj2.codigoClub
            FROM ClubJugador cj2, Club c2 
            WHERE (cj2.codigoClub = c2.codigoClub) AND (cj.DNI = cj2.DNI)
        )
    )
)

-- 

SELECT j.nombre, j.apellido
FROM Jugador j
WHERE NOT EXIST (
    SELECT *
    FROM Club c 
    WHERE NOT EXIST (
        SELECT *
        FROM ClubJugador cj 
        WHERE (cj.codigoClub = c.codigoClub) AND (cj.DNI = j.DNI)
    )
)

/* 9. Agregar con codigoClub 1234 el club “Estrella de Berisso” que se fundó en 1921 y que
pertenece a la ciudad de Berisso. Puede asumir que el codigoClub 1234 no existe en la
tabla Club.
 */

 INSERT INTO Club (codigoClub, nombre, anioFundacion, codigoCiudad(FK))
 VALUES (1234,"Estrella de Berisso","1921",(
    SELECT c.codigoCiudad
    FROM Ciudad 
    WHERE Ciudad.nombre = "Berisso"
    )
 )