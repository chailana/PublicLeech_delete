# app.py
import os
from flask import Flask

app = Flask(__name__)

# Get the port from the environment variable or default to 5000
port = int(os.environ.get("PORT", 5000))

@app.route('/')
def hello():
    return "Hello, World!"

if __name__ == '__main__':
    print(f"Starting app on port {port}")
    app.run(host='0.0.0.0', port=port)
