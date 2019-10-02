import csv
import mysql.connector

mydb = mysql.connector.connect(
    host="",
    user="",
    passwd="",
    database=""
)

with open('/tmp/BaseDNI.csv') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    line_count = 0
    countTotal = 0
    dnis = []
    f = open("Result.csv", "w")
    f.write("DNI,Numero,Nombre Completo\n")

    for row in csv_reader:
        line_count += 1
        countTotal += 1
        dnis.append(int(row[0]))
        if line_count == 1000:
            # print(dnis)
            dnis2 = dnis
            dnis = str(dnis)
            dnis = dnis.replace('[', '(')
            dnis = dnis.replace(']', ')')

            mycursor = mydb.cursor()
            mycursor.execute(
                "SELECT * FROM celulares where nrodoc in " + str(dnis))
            myresult = mycursor.fetchall()

            for x in dnis2:
                for item in myresult:
                    if x == int(item[2]):
                        f.write(str(x) + ',' +
                                str(item[8] + ',' + str(item[3]) + '\n'))

            dnis = []
            line_count = 0

        if countTotal == 408651:
            dnis2 = dnis
            dnis = str(dnis)
            dnis = dnis.replace('[', '(')
            dnis = dnis.replace(']', ')')
            mycursor = mydb.cursor()
            mycursor.execute(
                "SELECT * FROM celulares where nrodoc in " + str(dnis))
            myresult = mycursor.fetchall()

            for x in dnis2:
                for item in myresult:
                    if x == int(item[2]):
                        f.write(str(x) + ',' +
                                str(item[8] + ',' + str(item[3]) + '\n'))

            dnis = []

csv_file.close()
