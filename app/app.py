from flask import Flask
import mysql.connector
import os

app = Flask(__name__)

def get_db_connection():
    port_str = os.environ.get("DB_PORT", "3306")
    port = int(port_str) if port_str and port_str.strip() else 3306

    return mysql.connector.connect(
        host=os.environ.get("DB_HOST", "db"),
        user=os.environ.get("DB_USER", "root"),
        password=os.environ.get("DB_PASSWORD", "password"),
        database=os.environ.get("DB_NAME", "appdb"),
        port=port
    )

@app.route("/")
def index():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("CREATE TABLE IF NOT EXISTS visits (id INT AUTO_INCREMENT PRIMARY KEY, ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP)")
    cursor.execute("INSERT INTO visits () VALUES ()")
    conn.commit()
    cursor.execute("SELECT COUNT(*) FROM visits")
    count = cursor.fetchone()[0]
    conn.close()
    return f"<h1>Hello from Docker + Jenkins + Terraform!</h1><p>Page visits: {count}</p>"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
