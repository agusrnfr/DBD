/* Ejercicio 11 -
Modelo físico
Box = (nroBox,m2, ubicación, capacidad, ocupacion) //ocupación es un numérico indicando
cantidad de mascotas en el box actualmente, capacidad es una descripción.
Mascota = (codMascota,nombre, edad, raza, peso, telefonoContacto)
Veterinario = (matricula, CUIT, nombYAp, direccion, telefono)
Supervision = (codMascota,nroBox, fechaEntra, fechaSale?, matricula(fk),
descripcionEstadia) //fechaSale tiene valor null si la mascota está actualmente en el box */
/* 1. Listar para cada veterinario cantidad de supervisiones realizadas con fecha de salida
(fechaSale) durante enero de 2020. Indicar matricula, CUIT, nombre y apellido,
dirección, teléfono y cantidad de supervisiones. */

SELECT v.matricula, v.CUIT, v.nombYAp, v.direccion, v.telefono, COUNT(*) as Cantidad supervisiones
FROM Veterinario v INNER JOIN Supervision s ON (v.matricula = s.matricula)
WHERE (s.fechaSale BETWEEN "01/01/2020" AND "31/01/2020")
GROUP BY v.matricula, v.CUIT, v.nombYAp, v.direccion, v.telefono

/* 2. Listar CUIT, matricula, nombre, apellido,dirección y teléfono de veterinarios que no
tengan mascotas bajo supervisión actualmente. */

SELECT v.matricula, v.CUIT, v.nombYAp, v.direccion, v.telefono
FROM Veterinario v
WHERE v.matricula NOT IN (
    SELECT s.matricula
    FROM Supervision s
    WHERE s.fechaSale IS NULL
)

/* 3. Listar nombre, edad, raza, peso y teléfono de contacto de mascotas fueron atendidas
por el veterinario ‘Oscar Lopez’. Ordenar por nombre y raza de manera ascendente. */

SELECT m.nombre, m.edad, m.raza, m.peso, m.telefonoContacto
FROM Veterinario v INNER JOIN Supervision s ON (v.matricula = s.matricula)
    INNER JOIN Mascota m ON (s.codMascota = m.codMascota)
WHERE v.nombYAp = "Oscar Lopez"
ORDER BY m.nombre, m.raza

/* 4. Modificar nombre y apellido al veterinario con matricula: ‘MP 10000’, deberá
llamarse: ‘Pablo Lopez’. */

UPDATE Veterinario SET nombYAp= "Pablo Lopez" WHERE matricula=MP 10000’

/* 5. Listar nombre, edad, raza, peso de mascotas que tengan supervisiones con el
veterinario con matricula : ‘MP 1000’ y con el veterinario con matricula: ‘MN 4545’. */

SELECT m.nombre, m.edad, m.raza, m.peso
FROM Supervision s INNER JOIN Mascota m ON (s.codMascota = m.codMascota)
WHERE s.matricula = "MP 1000"
INTERSECT (
    SELECT m.nombre, m.edad, m.raza, m.peso
    FROM Supervision s INNER JOIN Mascota m ON (s.codMascota = m.codMascota)
    WHERE s.matricula = "MN 4545"
)

/* 6. Listar nroBox, m2, ubicación, capacidad y nombre de mascota para supervisiones con
fecha de entrada (fechaEntra) durante 2020. */

SELECT b.nroBox, b.m2, b.ubicación, b.capacidad, m.nombre
FROM Supervision s INNER JOIN Mascota m ON (s.codMascota = m.codMascota)
    INNER JOIN Box b ON(s.nroBox = b.nroBox)
WHERE (s.fechaEntra BETWEEN "01/01/2020" AND "31/12/2020")
