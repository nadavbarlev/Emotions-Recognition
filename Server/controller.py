from flask import Flask, request
import numpy as np
import base64
from emotion_detector import EmotionDetector

app = Flask(__name__)


@app.route("/v1/detect", methods=['POST'])
def detect_emotion():
    base64_image = request.form['base64_image']
    image_array = np.fromstring(base64.b64decode(base64_image), np.uint8)
    return str(EmotionDetector().detect_emotion(image_array))
