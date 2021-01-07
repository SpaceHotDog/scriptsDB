import mysql.connector
import time

mydb = mysql.connector.connect(
    host="",
    user="",
    passwd="",
    database=""
)

mycursor = mydb.cursor()

mycursor.execute(
    "CREATE TABLE nrolocalidad ( id INT AUTO_INCREMENT PRIMARY KEY, nrolocalidad VARCHAR(255))")
mycursor.execute(
    "CREATE TABLE nroprovincia ( id INT AUTO_INCREMENT PRIMARY KEY, nroprovincia VARCHAR(255))")
mycursor.execute(
    "CREATE TABLE empresa ( id INT AUTO_INCREMENT PRIMARY KEY, empresa VARCHAR(15))")

mycursor.execute(
    "CREATE TABLE celulares ( id INT AUTO_INCREMENT PRIMARY KEY, tipodoc VARCHAR(20), nrodoc INT, nombrecompleto VARCHAR(100), \
            nombre VARCHAR(100), apellido VARCHAR(100), nrocliente VARCHAR(15), empresa_id INT, linea VARCHAR(15), otrotel VARCHAR(50), \
            domicilio VARCHAR(100), cp VARCHAR(100), domilocalidad VARCHAR(100), domiprovincia VARCHAR(100), prefijo VARCHAR(10), \
                localidad_id INT, provincia_id INT, nrosinprefijo VARCHAR(10), \
                FOREIGN KEY(localidad_id) REFERENCES nrolocalidad(Id), FOREIGN KEY(provincia_id) REFERENCES nroprovincia(Id), \
                FOREIGN KEY(empresa_id) REFERENCES empresa(Id) )")

mycursor.execute("CREATE INDEX nrodoc_index ON celulares(nrodoc);")


mycursor.execute("SELECT COUNT(*) FROM datos")
vueltas1 = mycursor.fetchone()[0] / 2
offset1 = 0

localidades = []
provincias = []
empresas = []
count1 = 0
count2 = 0
count3 = 0
count4 = 0


for a in range(int(vueltas1 + 1)):
    print("\nVuelta: " + str(a) + " de la tabla datos\n")
    mycursor2 = mydb.cursor()

    mycursor2.execute("SELECT * FROM datos LIMIT 2 OFFSET " + str(offset1))
    offset1 += 2

    myresult = mycursor2.fetchall()

    for x in myresult:
        localidadInsert = None
        matchLocalidades = False
        provinciasInsert = None
        matchProvincias = False
        empresasInsert = None
        matchEmpresas = False

        nrolocalidad = x[16].upper()
        nroprovincia = x[17].upper()
        empresaU = x[7].upper()
        domilocalidad = x[12].upper()
        domiprovincia = x[13].upper()
        domilocalidad = domilocalidad.replace('Ã©', 'E', 5)
        domilocalidad = domilocalidad.replace('Ã³', 'O', 5)
        domilocalidad = domilocalidad.replace('Ã¡', 'A', 5)
        domilocalidad = domilocalidad.replace('Ã±', 'Ñ', 5)
        domilocalidad = domilocalidad.replace('Ã­', 'I', 5)
        domilocalidad = domilocalidad.replace('Ãº', 'U', 5)

        domiprovincia = domiprovincia.replace('Ã©', 'E', 5)
        domiprovincia = domiprovincia.replace('Ã³', 'O', 5)
        domiprovincia = domiprovincia.replace('Ã¡', 'A', 5)
        domiprovincia = domiprovincia.replace('Ã±', 'Ñ', 5)
        domiprovincia = domiprovincia.replace('Ã­', 'I', 5)
        domiprovincia = domiprovincia.replace('Ãº', 'U', 5)

        if len(localidades) != 0:
            for localidad in localidades:
                if nrolocalidad in localidad:
                    localidadInsert = localidad[nrolocalidad]
                    matchLocalidades = True

            if matchLocalidades == False:
                sql1 = "INSERT INTO nrolocalidad (nrolocalidad) VALUES(%s)"
                val1 = (nrolocalidad,)
                mycursor2.execute(sql1, val1)
                mydb.commit()
                localidades.append({nrolocalidad: mycursor2.lastrowid})
                localidadInsert = mycursor2.lastrowid
        else:
            sql1 = "INSERT INTO nrolocalidad (nrolocalidad) VALUES(%s)"
            val1 = (nrolocalidad,)
            mycursor2.execute(sql1, val1)
            mydb.commit()
            localidades.append({nrolocalidad: mycursor2.lastrowid})
            localidadInsert = mycursor2.lastrowid

        if len(provincias) != 0:
            for provincia in provincias:
                if nroprovincia in provincia:
                    provinciasInsert = provincia[nroprovincia]
                    matchProvincias = True

            if matchProvincias == False:
                sql2 = "INSERT INTO nroprovincia (nroprovincia) VALUES(%s)"
                val2 = (nroprovincia,)
                mycursor2.execute(sql2, val2)
                mydb.commit()
                provincias.append({nroprovincia: mycursor2.lastrowid})
                provinciasInsert = mycursor2.lastrowid
        else:
            sql2 = "INSERT INTO nroprovincia (nroprovincia) VALUES(%s)"
            val2 = (nroprovincia,)
            mycursor2.execute(sql2, val2)
            mydb.commit()
            provincias.append({nroprovincia: mycursor2.lastrowid})
            provinciasInsert = mycursor2.lastrowid

        if len(empresas) != 0:
            for empresa in empresas:
                if empresaU in empresa:
                    empresasInsert = empresa[empresaU]
                    matchEmpresas = True

            if matchEmpresas == False:
                sql3 = "INSERT INTO empresa (empresa) VALUES(%s)"
                val3 = (empresaU,)
                mycursor2.execute(sql3, val3)
                mydb.commit()
                empresas.append({empresaU: mycursor2.lastrowid})
                empresasInsert = mycursor2.lastrowid
        else:
            sql3 = "INSERT INTO empresa (empresa) VALUES(%s)"
            val3 = (empresaU,)
            mycursor2.execute(sql3, val3)
            mydb.commit()
            empresas.append({empresaU: mycursor2.lastrowid})
            empresasInsert = mycursor2.lastrowid

        sql = "INSERT INTO celulares (tipodoc, nrodoc, nombrecompleto, nombre, apellido, nrocliente, empresa_id, \
            linea, otrotel, domicilio, cp, domilocalidad, domiprovincia, prefijo, nrosinprefijo, localidad_id, provincia_id ) VALUES (%s ,%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"

        val = (x[1], x[2], x[3], x[4], x[5], x[6], int(empresasInsert), x[8],
               x[9], x[10], x[11], domilocalidad, domiprovincia, x[14], x[15], int(localidadInsert), int(provinciasInsert))

        mycursor.execute(sql, val)
        mydb.commit()
        count1 += 1
        print("Registro insertado: " + str(count1) + " de la tabla datos")


print("\nDuermo 1 min para que descanse la BD\n")
time.sleep(60)

mycursor.execute("SELECT COUNT(*) FROM datos2")
vueltas2 = mycursor.fetchone()[0] / 2
offset2 = 0


for a in range(int(vueltas2 + 1)):
    print("\nVuelta: " + str(a) + " de la tabla datos2\n")
    mycursor2 = mydb.cursor()

    mycursor2.execute("SELECT * FROM datos2 LIMIT 2 OFFSET " + str(offset2))
    offset2 += 2

    myresult = mycursor2.fetchall()

    for x in myresult:
        localidadInsert = None
        matchLocalidades = False
        provinciasInsert = None
        matchProvincias = False
        empresasInsert = None
        matchEmpresas = False

        nrolocalidad = x[16].upper()
        nroprovincia = x[17].upper()
        empresaU = x[7].upper()
        domilocalidad = x[12].upper()
        domiprovincia = x[13].upper()
        domilocalidad = domilocalidad.replace('Ã©', 'E', 5)
        domilocalidad = domilocalidad.replace('Ã³', 'O', 5)
        domilocalidad = domilocalidad.replace('Ã¡', 'A', 5)
        domilocalidad = domilocalidad.replace('Ã±', 'Ñ', 5)
        domilocalidad = domilocalidad.replace('Ã­', 'I', 5)
        domilocalidad = domilocalidad.replace('Ãº', 'U', 5)

        domiprovincia = domiprovincia.replace('Ã©', 'E', 5)
        domiprovincia = domiprovincia.replace('Ã³', 'O', 5)
        domiprovincia = domiprovincia.replace('Ã¡', 'A', 5)
        domiprovincia = domiprovincia.replace('Ã±', 'Ñ', 5)
        domiprovincia = domiprovincia.replace('Ã­', 'I', 5)
        domiprovincia = domiprovincia.replace('Ãº', 'U', 5)

        if len(localidades) != 0:
            for localidad in localidades:
                if nrolocalidad in localidad:
                    localidadInsert = localidad[nrolocalidad]
                    matchLocalidades = True

            if matchLocalidades == False:
                sql1 = "INSERT INTO nrolocalidad (nrolocalidad) VALUES(%s)"
                val1 = (nrolocalidad,)
                mycursor2.execute(sql1, val1)
                mydb.commit()
                localidades.append({nrolocalidad: mycursor2.lastrowid})
                localidadInsert = mycursor2.lastrowid
        else:
            sql1 = "INSERT INTO nrolocalidad (nrolocalidad) VALUES(%s)"
            val1 = (nrolocalidad,)
            mycursor2.execute(sql1, val1)
            mydb.commit()
            localidades.append({nrolocalidad: mycursor2.lastrowid})
            localidadInsert = mycursor2.lastrowid

        if len(provincias) != 0:
            for provincia in provincias:
                if nroprovincia in provincia:
                    provinciasInsert = provincia[nroprovincia]
                    matchProvincias = True

            if matchProvincias == False:
                sql2 = "INSERT INTO nroprovincia (nroprovincia) VALUES(%s)"
                val2 = (nroprovincia,)
                mycursor2.execute(sql2, val2)
                mydb.commit()
                provincias.append({nroprovincia: mycursor2.lastrowid})
                provinciasInsert = mycursor2.lastrowid
        else:
            sql2 = "INSERT INTO nroprovincia (nroprovincia) VALUES(%s)"
            val2 = (nroprovincia,)
            mycursor2.execute(sql2, val2)
            mydb.commit()
            provincias.append({nroprovincia: mycursor2.lastrowid})
            provinciasInsert = mycursor2.lastrowid

        if len(empresas) != 0:
            for empresa in empresas:
                if empresaU in empresa:
                    empresasInsert = empresa[empresaU]
                    matchEmpresas = True

            if matchEmpresas == False:
                sql3 = "INSERT INTO empresa (empresa) VALUES(%s)"
                val3 = (empresaU,)
                mycursor2.execute(sql3, val3)
                mydb.commit()
                empresas.append({empresaU: mycursor2.lastrowid})
                empresasInsert = mycursor2.lastrowid
        else:
            sql3 = "INSERT INTO empresa (empresa) VALUES(%s)"
            val3 = (empresaU,)
            mycursor2.execute(sql3, val3)
            mydb.commit()
            empresas.append({empresaU: mycursor2.lastrowid})
            empresasInsert = mycursor2.lastrowid

        sql = "INSERT INTO celulares (tipodoc, nrodoc, nombrecompleto, nombre, apellido, nrocliente, empresa_id, \
            linea, otrotel, domicilio, cp, domilocalidad, domiprovincia, prefijo, nrosinprefijo, localidad_id, provincia_id ) VALUES (%s ,%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"

        val = (x[1], x[2], x[3], x[4], x[5], x[6], int(empresasInsert), x[8],
               x[9], x[10], x[11], domilocalidad, domiprovincia, x[14], x[15], int(localidadInsert), int(provinciasInsert))

        mycursor.execute(sql, val)
        mydb.commit()
        count2 += 1
        print("Registro insertado: " + str(count2) + " de la tabla datos2")


print("\nDuermo 1 min para que descanse la BD\n")
time.sleep(60)

mycursor.execute("SELECT COUNT(*) FROM datos3")
vueltas3 = mycursor.fetchone()[0] / 2
offset3 = 0


for a in range(int(vueltas3 + 1)):
    print("\nVuelta: " + str(a) + " de la tabla datos3\n")
    mycursor2 = mydb.cursor()

    mycursor2.execute("SELECT * FROM datos3 LIMIT 2 OFFSET " + str(offset3))
    offset3 += 2

    myresult = mycursor2.fetchall()

    for x in myresult:
        localidadInsert = None
        matchLocalidades = False
        provinciasInsert = None
        matchProvincias = False
        empresasInsert = None
        matchEmpresas = False

        empresaU = x[7].upper()
        domilocalidad = x[12].upper()
        domiprovincia = x[13].upper()
        domilocalidad = domilocalidad.replace('Ã©', 'E', 5)
        domilocalidad = domilocalidad.replace('Ã³', 'O', 5)
        domilocalidad = domilocalidad.replace('Ã¡', 'A', 5)
        domilocalidad = domilocalidad.replace('Ã±', 'Ñ', 5)
        domilocalidad = domilocalidad.replace('Ã­', 'I', 5)
        domilocalidad = domilocalidad.replace('Ãº', 'U', 5)

        domiprovincia = domiprovincia.replace('Ã©', 'E', 5)
        domiprovincia = domiprovincia.replace('Ã³', 'O', 5)
        domiprovincia = domiprovincia.replace('Ã¡', 'A', 5)
        domiprovincia = domiprovincia.replace('Ã±', 'Ñ', 5)
        domiprovincia = domiprovincia.replace('Ã­', 'I', 5)
        domiprovincia = domiprovincia.replace('Ãº', 'U', 5)

        nrolocalidad = domilocalidad
        nroprovincia = domiprovincia

        if len(localidades) != 0:
            for localidad in localidades:
                if nrolocalidad in localidad:
                    localidadInsert = localidad[nrolocalidad]
                    matchLocalidades = True

            if matchLocalidades == False:
                sql1 = "INSERT INTO nrolocalidad (nrolocalidad) VALUES(%s)"
                val1 = (nrolocalidad,)
                mycursor2.execute(sql1, val1)
                mydb.commit()
                localidades.append({nrolocalidad: mycursor2.lastrowid})
                localidadInsert = mycursor2.lastrowid
        else:
            sql1 = "INSERT INTO nrolocalidad (nrolocalidad) VALUES(%s)"
            val1 = (nrolocalidad,)
            mycursor2.execute(sql1, val1)
            mydb.commit()
            localidades.append({nrolocalidad: mycursor2.lastrowid})
            localidadInsert = mycursor2.lastrowid

        if len(provincias) != 0:
            for provincia in provincias:
                if nroprovincia in provincia:
                    provinciasInsert = provincia[nroprovincia]
                    matchProvincias = True

            if matchProvincias == False:
                sql2 = "INSERT INTO nroprovincia (nroprovincia) VALUES(%s)"
                val2 = (nroprovincia,)
                mycursor2.execute(sql2, val2)
                mydb.commit()
                provincias.append({nroprovincia: mycursor2.lastrowid})
                provinciasInsert = mycursor2.lastrowid
        else:
            sql2 = "INSERT INTO nroprovincia (nroprovincia) VALUES(%s)"
            val2 = (nroprovincia,)
            mycursor2.execute(sql2, val2)
            mydb.commit()
            provincias.append({nroprovincia: mycursor2.lastrowid})
            provinciasInsert = mycursor2.lastrowid

        if len(empresas) != 0:
            for empresa in empresas:
                if empresaU in empresa:
                    empresasInsert = empresa[empresaU]
                    matchEmpresas = True

            if matchEmpresas == False:
                sql3 = "INSERT INTO empresa (empresa) VALUES(%s)"
                val3 = (empresaU,)
                mycursor2.execute(sql3, val3)
                mydb.commit()
                empresas.append({empresaU: mycursor2.lastrowid})
                empresasInsert = mycursor2.lastrowid
        else:
            sql3 = "INSERT INTO empresa (empresa) VALUES(%s)"
            val3 = (empresaU,)
            mycursor2.execute(sql3, val3)
            mydb.commit()
            empresas.append({empresaU: mycursor2.lastrowid})
            empresasInsert = mycursor2.lastrowid

        sql = "INSERT INTO celulares (tipodoc, nrodoc, nombrecompleto, nombre, apellido, nrocliente, empresa_id, \
            linea, otrotel, domicilio, cp, domilocalidad, domiprovincia, prefijo, nrosinprefijo, localidad_id, provincia_id ) VALUES (%s ,%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"

        val = (x[1], x[2], x[3], x[4], x[5], x[6], int(empresasInsert), x[8],
               x[9], x[10], x[11], domilocalidad, domiprovincia, x[14], x[15], int(localidadInsert), int(provinciasInsert))

        mycursor.execute(sql, val)
        mydb.commit()
        count3 += 1
        print("Registro insertado: " + str(count3) + " de la tabla datos3")


print("\nDuermo 1 min para que descanse la BD\n")
time.sleep(60)

mycursor.execute("SELECT COUNT(*) FROM datos4")
vueltas4 = mycursor.fetchone()[0] / 2
offset4 = 0


for a in range(int(vueltas4 + 1)):
    print("\nVuelta: " + str(a) + " de la tabla datos4\n")
    mycursor2 = mydb.cursor()

    mycursor2.execute("SELECT * FROM datos4 LIMIT 2 OFFSET " + str(offset4))
    offset4 += 2

    myresult = mycursor2.fetchall()

    for x in myresult:
        localidadInsert = None
        matchLocalidades = False
        provinciasInsert = None
        matchProvincias = False
        empresasInsert = None
        matchEmpresas = False

        empresaU = x[7].upper()
        domilocalidad = x[12].upper()
        domiprovincia = x[13].upper()
        domilocalidad = domilocalidad.replace('Ã©', 'E', 5)
        domilocalidad = domilocalidad.replace('Ã³', 'O', 5)
        domilocalidad = domilocalidad.replace('Ã¡', 'A', 5)
        domilocalidad = domilocalidad.replace('Ã±', 'Ñ', 5)
        domilocalidad = domilocalidad.replace('Ã­', 'I', 5)
        domilocalidad = domilocalidad.replace('Ãº', 'U', 5)

        domiprovincia = domiprovincia.replace('Ã©', 'E', 5)
        domiprovincia = domiprovincia.replace('Ã³', 'O', 5)
        domiprovincia = domiprovincia.replace('Ã¡', 'A', 5)
        domiprovincia = domiprovincia.replace('Ã±', 'Ñ', 5)
        domiprovincia = domiprovincia.replace('Ã­', 'I', 5)
        domiprovincia = domiprovincia.replace('Ãº', 'U', 5)

        nrolocalidad = domilocalidad
        nroprovincia = domiprovincia

        if len(localidades) != 0:
            for localidad in localidades:
                if nrolocalidad in localidad:
                    localidadInsert = localidad[nrolocalidad]
                    matchLocalidades = True

            if matchLocalidades == False:
                sql1 = "INSERT INTO nrolocalidad (nrolocalidad) VALUES(%s)"
                val1 = (nrolocalidad,)
                mycursor2.execute(sql1, val1)
                mydb.commit()
                localidades.append({nrolocalidad: mycursor2.lastrowid})
                localidadInsert = mycursor2.lastrowid
        else:
            sql1 = "INSERT INTO nrolocalidad (nrolocalidad) VALUES(%s)"
            val1 = (nrolocalidad,)
            mycursor2.execute(sql1, val1)
            mydb.commit()
            localidades.append({nrolocalidad: mycursor2.lastrowid})
            localidadInsert = mycursor2.lastrowid

        if len(provincias) != 0:
            for provincia in provincias:
                if nroprovincia in provincia:
                    provinciasInsert = provincia[nroprovincia]
                    matchProvincias = True

            if matchProvincias == False:
                sql2 = "INSERT INTO nroprovincia (nroprovincia) VALUES(%s)"
                val2 = (nroprovincia,)
                mycursor2.execute(sql2, val2)
                mydb.commit()
                provincias.append({nroprovincia: mycursor2.lastrowid})
                provinciasInsert = mycursor2.lastrowid
        else:
            sql2 = "INSERT INTO nroprovincia (nroprovincia) VALUES(%s)"
            val2 = (nroprovincia,)
            mycursor2.execute(sql2, val2)
            mydb.commit()
            provincias.append({nroprovincia: mycursor2.lastrowid})
            provinciasInsert = mycursor2.lastrowid

        if len(empresas) != 0:
            for empresa in empresas:
                if empresaU in empresa:
                    empresasInsert = empresa[empresaU]
                    matchEmpresas = True

            if matchEmpresas == False:
                sql3 = "INSERT INTO empresa (empresa) VALUES(%s)"
                val3 = (empresaU,)
                mycursor2.execute(sql3, val3)
                mydb.commit()
                empresas.append({empresaU: mycursor2.lastrowid})
                empresasInsert = mycursor2.lastrowid
        else:
            sql3 = "INSERT INTO empresa (empresa) VALUES(%s)"
            val3 = (empresaU,)
            mycursor2.execute(sql3, val3)
            mydb.commit()
            empresas.append({empresaU: mycursor2.lastrowid})
            empresasInsert = mycursor2.lastrowid

        sql = "INSERT INTO celulares (tipodoc, nrodoc, nombrecompleto, nombre, apellido, nrocliente, empresa_id, \
            linea, otrotel, domicilio, cp, domilocalidad, domiprovincia, prefijo, nrosinprefijo, localidad_id, provincia_id ) VALUES (%s ,%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"

        val = (x[1], x[2], x[3], x[4], x[5], x[6], int(empresasInsert), x[8],
               x[9], x[10], x[11], domilocalidad, domiprovincia, x[14], x[15], int(localidadInsert), int(provinciasInsert))

        mycursor.execute(sql, val)
        mydb.commit()
        count4 += 1
        print("Registro insertado: " + str(count4) + " de la tabla datos4")
