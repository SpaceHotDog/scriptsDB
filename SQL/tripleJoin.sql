/*
This query performs two JOIN operations with 3 tables.
The U, N, and NU are table aliases.
*/

SELECT U.nombre, N.numero
  FROM CMP_Usuario U
  JOIN CMP_NumeroUsuario NU ON U.id = NU.id_usuario
  JOIN CMP_Numeros N ON N.id = NU.id_numero
ORDER BY U.id
