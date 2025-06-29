from flask import Flask, render_template, request, redirect, url_for
import qrcode
import sqlite3
import os
from datetime import datetime

app = Flask(__name__)
DB_NAME = 'tickets.db'

def init_db():
    with sqlite3.connect(DB_NAME) as conn:
        cursor = conn.cursor()
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS tickets (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                code TEXT UNIQUE,
                scanned_at TEXT
            )
        """)
        conn.commit()

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/generate', methods=['POST'])
def generate():
    name = request.form['name']
    event = request.form['event']
    code = f"{name}_{event}_{datetime.now().strftime('%Y%m%d%H%M%S')}"
    img = qrcode.make(code)
    path = f"static/qr_codes"
    os.makedirs(path, exist_ok=True)
    img_path = f"{path}/{code}.png"
    img.save(img_path)
    return render_template('index.html', qr_code=img_path, code=code)

@app.route('/scan', methods=['GET', 'POST'])
def scan():
    if request.method == 'POST':
        scanned_code = request.form['scanned_code']
        with sqlite3.connect(DB_NAME) as conn:
            cursor = conn.cursor()
            cursor.execute("SELECT * FROM tickets WHERE code = ?", (scanned_code,))
            exists = cursor.fetchone()
            if exists:
                return render_template('scan_result.html', message="❌ Ticket déjà scanné", code=scanned_code)
            cursor.execute("INSERT INTO tickets (code, scanned_at) VALUES (?, ?)", (scanned_code, datetime.now().isoformat()))
            conn.commit()
        return render_template('scan_result.html', message="✅ Ticket valide et enregistré", code=scanned_code)
    return redirect(url_for('index'))

@app.route('/admin')
def admin_dashboard():
    with sqlite3.connect(DB_NAME) as conn:
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM tickets")
        tickets = cursor.fetchall()
    return render_template('admin_dashboard.html', tickets=tickets)

@app.route('/mobile-scan')
def mobile_scan():
    return render_template('mobile_scan.html')

if __name__ == '__main__':
    init_db()
    app.run(debug=True)