/* Ejercicio 14 -
Modelo Físico
Cine (idCine, nombreC, direccion)
Sala (nroSala, nombreS, descripción, capacidad,idCine(fk))
Pelicula (idPeli, nombre, descripción, genero)
Funcion (nroFuncion, nroSala(fk), idPeli(fk), fecha, hora, ocupación)//ocupación indica cantidad de
espectadores de la función */
/* 1- Listar nombre, descripción y género de películas con funciones durante 2020. */

SELECT p.nombre, p.descripción, p.genero
FROM Pelicula p INNER JOIN Funcion f ON (p.idPeli = f.idPeli)
WHERE f.fecha BETWEEN "01/01/2020" AND "31/12/2020"

/* 2- Listar para cada Sala cantidad de espectadores que asistieron durante 2020. Indicar
nombre de la sala, nombre del cine y total de espectadores. */

SELECT s.nombreS, c.nombreC, SUM(f.ocupación) as Total espectadores
FROM Sala s INNER JOIN Cine c ON (s.idCine = c.idCine)
    INNER JOIN Funcion f ON (s.nroSala = f.nroSala)
WHERE f.fecha BETWEEN "01/01/2020" AND "31/12/2020"
GROUP BY s.nroSala, c.nombreC

/* 3- Listar nombre de cine y dirección para los cines que tienen o tuvieron función para la
película ‘Relic’. Ordenar por nombre de Cine y dirección desc. */

SELECT c.nombreC, c.direccion
FROM Sala s INNER JOIN Cine c ON (s.idCine = c.idCine)
    INNER JOIN Funcion f ON (s.nroSala = f.nroSala)
    INNER JOIN Pelicula p ON (f.idPeli = p.idPeli)
WHERE p.nombre = "Relic"
ORDER BY c.nombreC, c.direccion DESC 

/* 4- Listar nombre ,descripción y género de películas que tienen función en la sala con nombre
‘Sala Lola Membrives’ o tienen función en el cine con nombre ‘Gran Rex’. */

SELECT p.nombre, p.descripción, p.genero
FROM Pelicula p INNER JOIN Funcion f ON (p.idPeli = f.idPeli)
    INNER JOIN Sala s ON (f.nroSala = s.nroSala)
    INNER JOIN Cine c ON (s.idCine = c.idCine)
WHERE s.nombreS = "Sala Lola Membrives" OR c.nombreC="Gran Rex"

/* 5- Listar nombre del cine y dirección de cines que tengan salas con capacidad superior a los
300 espectadores. */

SELECT c.nombreC, c.direccion
FROM Sala s INNER JOIN Cine c ON (s.idCine = c.idCine)
WHERE s.capacidad > 300

/* 6- Agregar un cine con nombre cine ‘Cine Ricardo Darin’, dirección: ‘calle 2 nro 1900, La
Plata’ e idCine: 5000, asuma que no existe dicho id. */

INSERT INTO Cine (idCine, nombreC, direccion) VALUES (5000, "Cine Ricardo Darin","calle 2 nro 1900")
