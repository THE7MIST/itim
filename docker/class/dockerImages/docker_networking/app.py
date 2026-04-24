import mysql.connector

conn = mysql.connector.connect(
    host="mysql-db",   # wrong in Docker
    user="root",
    password="root",
    database="school"
)

cursor = conn.cursor()

cursor.execute("CREATE TABLE IF NOT EXISTS students (name VARCHAR(50), age INT)")
cursor.execute("INSERT INTO students VALUES ('Alice', 20)")

conn.commit()

print("Inserted!")

cursor.close()
conn.close()
