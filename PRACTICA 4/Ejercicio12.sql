/* Ejercicio 12 -
Modelo Físico
Barberia = (codBarberia, razon_social, direccion, telefono)
Cliente = (nroCliente,DNI, nombYAp, direccionC, fechaNacimiento, celular)
Barbero = (codEmpleado,DNIB, nombYApB, direccionB, telefonoContacto, mail)
Atencion = (codEmpleado,Fecha,hora,codBarberia(fk), nroCliente(fk),descTratamiento, valor)
 */
/*  1. Listar DNI, nombYAp, direccionC, fechaNacimiento y celular de clientes que no tengan
atención durante 2020. */

SELECT c.DNI, c.nombYAp, c.direccionC, c.fechaNacimiento, c.celular
FROM Cliente c 
WHERE c.nroCliente NOT IN (
    SELECT a.nroCliente
    FROM Atencion a
    WHERE (a.fecha BETWEEN "01/01/2018" AND "31/12/2018")
)

/* 2. Listar para cada barbero cantidad de atenciones que realizaron durante 2018. Listar
DNIB, nombYApB, direccionB, telefonoContacto, mail y cantidad de atenciones. */

SELECT b.DNIB, b.nombYApB, b.direccionB, b.telefonoContacto, b.mail, COUNT(*) as Atenciones
FROM Barbero b LEFT JOIN Atencion a ON(b.codEmpleado = a.codEmpleado)
WHERE a.fecha BETWEEN "01/01/2018" AND "31/12/2018"
GROUP BY b.codEmpleado, b.DNIB, b.nombYApB, b.direccionB, b.telefonoContacto, b.mail

/* 3. Listar razón social, dirección y teléfono de barberias que tengan atenciones para el
cliente con DNI:22283566 . Ordenar por razón social y dirección ascendente. */

SELECT b.razon_social, b.direccion, b.telefono
FROM Barberia b INNER JOIN Atencion a ON (b.codBarberia = a.codBarberia)
    INNER JOIN Cliente c ON (a.nroCliente = c.nroCliente)
WHERE c.DNI ="22283566"
ORDER BY b.razon_social, b.direccion

/* 4. Listar DNIB, nombYApB, direccionB, telefonoContacto y mail de barberos que tengan
atenciones con valor superior a 5000. */

SELECT b.DNIB, b.nombYApB, b.direccionB, b.telefonoContacto, b.mail
FROM Barbero b LEFT JOIN Atencion a ON(b.codEmpleado = a.codEmpleado)
WHERE a.valor > 5000

/* 5. Listar DNI, nombYAp, direccionC, fechaNacimiento y celular de clientes que tengan
atenciones en la barbería con razón social: ‘Corta barba’ y también se hayan atendido
en la barbería con razón social: ‘Barberia Barbara’. */

SELECT c.DNI, c.nombYAp, c.direccionC, c.fechaNacimiento, c.celular
FROM Cliente c INNER JOIN Atencion a ON (c.nroCliente = a.nroCliente)
    INNER JOIN Barberia b ON (a.codBarberia = b.codBarberia)
WHERE b.razon_social = "Corta barba"
INTERSECT (
    SELECT c.DNI, c.nombYAp, c.direccionC, c.fechaNacimiento, c.celular
    FROM Cliente c INNER JOIN Atencion a ON (c.nroCliente = a.nroCliente)
     INNER JOIN Barberia b ON (a.codBarberia = b.codBarberia)
    WHERE b.razon_social = "Barberia Barbara"
)

/* 6. Eliminar el cliente con DNI: 22222222. */

DELETE FROM Atencion WHERE nroCliente IN (
    SELECT c.nroCliente
    FROM Cliente c
    WHERE dni="22222222"
)
DELETE FROM Cliente WHERE dni="22222222";
