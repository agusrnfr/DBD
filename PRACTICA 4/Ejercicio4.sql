/* Ejercicio 4:
PERSONA = (DNI, Apellido, Nombre, Fecha_Nacimiento, Estado_Civil, Genero)
ALUMNO = (DNI, Legajo, Año_Ingreso)
PROFESOR = (DNI, Matricula, Nro_Expediente)
TITULO = (Cod_Titulo, Nombre, Descripción)
TITULO-PROFESOR = (Cod_Titulo, DNI, Fecha)
CURSO = (Cod_Curso, Nombre, Descripción, Fecha_Creacion, Duracion)
ALUMNO-CURSO = (DNI, Cod_Curso, Año, Desempeño, Calificación)
PROFESOR-CURSO = (DNI, Cod_Curso, Fecha_Desde, Fecha_Hasta) */
/* 1. Listar DNI, legajo y apellido y nombre de todos los alumnos que tegan año ingreso
inferior a 2014. */

SELECT a.DNI, a.Legajo, p.apellido
FROM ALUMNO a INNER JOIN PERSONA p ON (a.DNI = p.DNI)
WHERE (a.Año_Ingreso < 2014)

/* 2. Listar DNI, matricula, apellido y nombre de los profesores que dictan cursos que tengan
más 100 horas de duración. Ordenar por DNI */

SELECT p.DNI, p.Matricula, per.Apellido, per.Nombre
FROM PROFESOR p INNER JOIN PERSONA per ON (p.DNI = per.DNI)
    INNER JOIN PROFESOR-CURSO pc ON(p.DNI = pc.DNI)
    INNER JOIN CURSO c ON (pc.Cod_Curso = c.Cod_Curso)
WHERE c.Duracion > 100
ORDER BY p.DNI

/* 3. Listar el DNI, Apellido, Nombre, Género y Fecha de nacimiento de los alumnos inscriptos
al curso con nombre “Diseño de Bases de Datos” en 2019. */

SELECT p.DNI, p.Apellido, p.Nombre, p.Genero, p.Fecha_Nacimiento
FROM PERSONA p
WHERE p.DNI IS (
    SELECT ac.DNI
    FROM ALUMNO-CURSO ac INNER JOIN Curso c ON (ac.Cod_Curso = c.Cod_Curso)
    WHERE (c.nombre = "Diseño de Bases de Datos") AND (ac.Año = "2019")
)

/* 4. Listar el DNI, Apellido, Nombre y Calificación de aquellos alumnos que obtuvieron una
calificación superior a 9 en los cursos que dicta el profesor “Juan Garcia”. Dicho listado
deberá estar ordenado por Apellido. */

SELECT a.DNI, p.Apellido, p.Nombre, ac.Calificación
FROM ALUMNO a INNER JOIN PERSONA p ON (a.DNI = p.DNI)
    INNER JOIN ALUMNO-CURSO ac ON (a.DNI = ac.DNI)
    INNER JOIN PROFESOR-CURSO pc ON (ac.Cod_Curso = pc.Cod_Curso)
    INNER JOIN Profesor prof ON (pc.DNI = prof.DNI)
    INNER JOIN Persona p2 ON (prof.DNI = p2.DNI)
WHERE (ac.Calificacion > 9) AND (p2.Nombre = "Juan") AND (p2.Apellido = "Garcia")
ORDER BY p.Apellido

-- Podria omitir a profesor y que sea directamente 
/*
SELECT a.DNI, p.Apellido, p.Nombre, ac.Calificación
FROM ALUMNO a INNER JOIN PERSONA p ON (a.DNI = p.DNI)
    INNER JOIN ALUMNO-CURSO ac ON (a.DNI = ac.DNI)
    INNER JOIN PROFESOR-CURSO pc ON (ac.Cod_Curso = pc.Cod_Curso)
    INNER JOIN Persona p2 ON (pc.DNI = p2.DNI)
WHERE (ac.Calificacion > 9) AND (p2.Nombre = "Juan") AND (p2.Apellido = "Garcia")
ORDER BY p.Apellido
*/

/* 5. Listar el DNI, Apellido, Nombre y Matrícula de aquellos profesores que posean más de 3
títulos. Dicho listado deberá estar ordenado por Apellido y Nombre. */

SELECT p.DNI, per.Apellido, per.Nombre, p.Matricula
FROM PROFESOR p INNER JOIN PERSONA per ON (p.DNI = per.DNI) 
    INNER JOIN TITULO-PROFESOR tp ON (per.DNI = tp.DNI)
GROUP BY p.DNI, per.Apellido, per.Nombre, p.Matricula
HAVING COUNT (*) > 3 
ORDER BY per.Apellido, per.Nombre

/* 6. Listar el DNI, Apellido, Nombre, Cantidad de horas y Promedio de horas que dicta cada
profesor. La cantidad de horas se calcula como la suma de la duración de todos los
cursos que dicta. */

SELECT p.DNI, per.Apellido, per.Nombre, SUM (c.Duracion), AVG (c.Duracion)
FROM PROFESOR p INNER JOIN PERSONA per ON (p.DNI = per.DNI)
    LEFT JOIN PROFESOR-CURSO pc ON(p.DNI = pc.DNI)
    LEFT JOIN CURSO c ON (pc.Cod_Curso = c.Cod_Curso)
GROUP BY p.DNI, per.Apellido, per.Nombre

/* 7. Listar Nombre, Descripción del curso que posea más alumnos inscriptos y del que posea
menos alumnos inscriptos durante 2019. */

--Los listo juntos o separados?

(SELECT c.Nombre, c.Descripción
FROM CURSO c INNER JOIN ALUMNO-CURSO ac ON (c.Cod_Curso = ac.Cod_Curso)
WHERE ac.Año = "2019"
GROUP BY c.Cod_Curso, c.Nombre, c.Descripción
HAVING COUNT(*) >= ALL (
    SELECT COUNT (*)
    FROM ALUMNO-CURSO ac
    WHERE ac.Año = "2019"
    GROUP BY ac.Cod_Curso
)
)
UNION
(SELECT c.Nombre, c.Descripción
FROM CURSO c INNER JOIN ALUMNO-CURSO ac ON (c.Cod_Curso = ac.Cod_Curso)
WHERE ac.Año = "2019"
GROUP BY c.Cod_Curso, c.Nombre, c.Descripción
HAVING COUNT(*) <= ALL (
    SELECT COUNT (*)
    FROM ALUMNO-CURSO ac
    WHERE ac.Año = "2019"
    GROUP BY ac.Cod_Curso
)
)

/* 8. Listar el DNI, Apellido, Nombre, Legajo de alumnos que realizaron cursos con nombre
conteniendo el string ‘BD’ durante 2018 pero no realizaron ningún curso durante 2019. */

SELECT a.DNI, p.Apellido, p.Nombre, a.Legajo
FROM ALUMNO a INNER JOIN PERSONA p ON (a.DNI = p.DNI)
    INNER JOIN ALUMNO-CURSO ac ON (p.DNI = ac.DNI)
    INNER JOIN CURSO c ON (ac.Cod_Curso = c.Cod_Curso)
WHERE (c.Nombre LIKE "%BD%") AND (ac.Año = "2018")
EXCEPT (
    SELECT a.DNI, p.Apellido, p.Nombre, a.Legajo
    FROM ALUMNO a INNER JOIN PERSONA p ON (a.DNI = p.DNI)
    INNER JOIN ALUMNO-CURSO ac ON (p.DNI = ac.DNI)
    WHERE (ac.Año = "2019")
)

/* 9. Agregar un profesor con los datos que prefiera y agregarle el título con código: 25. */

INSERT INTO PERSONA (DNI, Apellido, Nombre, Fecha_Nacimiento, Estado_Civil, Genero) 
VALUES ("44124642", "Diaz", "Pepe", "21/04/2002", "Soltero", "Masculino")

INSERT INTO PROFESOR (DNI, Matricula, Nro_Expediente) 
VALUES ("44124642", "123", "123")

INSERT INTO TITULO-PROFESOR (Cod_Titulo, DNI, Fecha) 
VALUES (25,"44124642","22/10/2022")

/* 10. Modificar el estado civil del alumno cuyo legajo es ‘2020/09’, el nuevo estado civil es
divorciado. */

UPDATE PERSONA SET Estado_Civil="divorciado" WHERE DNI IN (SELECT a.DNI FROM ALUMNO a WHERE a.Legajo="2020/09")

/* 11. Dar de baja el alumno con DNI 30568989. Realizar todas las bajas necesarias para no
dejar el conjunto de relaciones en estado inconsistente.
 */
--Asumo que un alumno no puede ser profesor.

 DELETE FROM ALUMNO-CURSO WHERE DNI="30568989"
 DELETE FROM ALUMNO WHERE DNI="30568989"
 DELETE FROM PERSONA WHERE DNI="30568989"