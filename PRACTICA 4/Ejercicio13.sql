/* Ejercicio 13-
Modelo Físico
Club(IdClub,nombreClub,ciudad)
Complejo(IdComplejo,nombreComplejo, IdClub(fk))
Cancha(IdCancha,nombreCancha,IdComplejo(fk))
Entrenador(IdEntrenador, nombreEntrenador,fechaNacimiento, direccion)
Entrenamiento(IdEntrenamiento, fecha, IdEntrenador(fk), IdCancha(fk)) */
/* 1- Listar nombre, fecha nacimiento y dirección de entrenadores que hayan tenido
entrenamientos durante 2020. */

SELECT e.nombreEntrenador, e.fechaNacimiento, e.direccion
FROM Entrenador e INNER JOIN Entrenamiento en ON (e.IdEntrenador = en.IdEntrenador)
WHERE (en.fecha BETWEEN "01/01/2020" AND "31/12/2020")

/* 2- Listar para cada cancha del complejo “Complejo 1” , la cantidad de entrenamientos que se
realizaron durante el 2019. Informar nombre de la cancha y cantidad de entrenamientos. */

SELECT c.nombreCancha, COUNT(*) As Cantidad de entrenamientos
FROM Complejo c INNER JOIN Cancha ch ON (c.IdComplejo = ch.IdComplejo)
    LEFT JOIN Entrenamiento e ON (ch.IdCancha = e.IdCancha)
WHERE c.nombreComplejo = "Complejo 1" AND (e.fecha BETWEEN "01/01/2019" AND "31/12/2019")
GROUP BY c.IdCancha, c.nombreCancha

/* 3- Listar los complejos donde haya realizado entrenamientos el entrenador “Jorge Gonzalez”.
Informar nombre de complejo, ordenar el resultado de manera ascendente. */

--Pueden haber complejos que se llamen igual

SELECT DISTINCT c.nombreComplejo
FROM Complejo c INNER JOIN Cancha ch ON (c.IdComplejo = ch.IdComplejo)
    INNER JOIN Entrenamiento e ON (ch.IdCancha = e.IdCancha)
    INNER JOIN Entrenador en ON (ch.IdEntrenador = en.IdEntrenador)
WHERE en.nombreEntrenador = "Jorge Gonzalez"
ORDER BY c.nombreComplejo

/* 4- Listar nombre , fecha de nacimiento y dirección de entrenadores que hayan entrenado en
la cancha “Cancha 1” y en la Cancha “Cancha 2”. */

SELECT en.nombreEntrenador, en.fechaNacimiento, en.direccion
FROM Cancha ch INNER JOIN Entrenamiento e ON (ch.IdCancha = e.IdCancha)
    INNER JOIN Entrenador en ON (ch.IdEntrenador = en.IdEntrenador)
WHERE ch.nombreCancha = "Cancha 1"
INTERSECT (
    SELECT en.nombreEntrenador, en.fechaNacimiento, en.direccion
    FROM Cancha ch INNER JOIN Entrenamiento e ON (ch.IdCancha = e.IdCancha)
        INNER JOIN Entrenador en ON (ch.IdEntrenador = en.IdEntrenador)
    WHERE ch.nombreCancha = "Cancha 2"
)

/* 5- Listar todos los clubes en los que entrena el entrenador “Marcos Perez”. Informar nombre
del club y ciudad. */


SELECT nombreClub, ciudad
FROM Club INNER JOIN Complejo c ON (Club.IdClub = c.IdClub)
    INNER JOIN Cancha ch ON (c.IdComplejo = ch.IdComplejo)
    INNER JOIN Entrenamiento e ON (ch.IdCancha = e.IdCancha)
    INNER JOIN Entrenador en ON (ch.IdEntrenador = en.IdEntrenador)
WHERE en.nombreEntrenador = "Marcos Perez"

/* 6- Eliminar los entrenamientos del entrenador ‘Juan Perez’. */

DELETE FROM Entrenamiento WHERE IdEntrenador IN (
    SELECT e.IdEntrenador
    FROM Entrenamiento e INNER JOIN Entrenador en ON (e.IdEntrenador = en.IdEntrenador)
    WHERE en.nombreEntrenador="Juan Perez"
)

