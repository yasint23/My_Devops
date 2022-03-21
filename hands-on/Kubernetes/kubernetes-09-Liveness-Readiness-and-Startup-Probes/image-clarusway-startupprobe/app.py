from flask import Flask, Response
import time

app = Flask(__name__)

start = time.time()

@app.route('/')
def home():
    return "Welcome to Clarusway Kubernetes Lesson"

@app.route("/healthz")
def health_check():
    end = time.time()
    duration = end - start
    if duration > 60:
        return Response("{'lesson':'k8s'}", status=200)

if __name__== '__main__':
    app.run(host="0.0.0.0", port=80)