from keras import models
from preprocessor import Preprocessor


class EmotionDetector(object):

    CNN_MODEL = 'model.hdf5'

    def __init__(self):
        self.cnn_model = models.load_model(self.CNN_MODEL)
        self.preprocessor = Preprocessor()

    def detect_emotion(self, image):
        processed_image = self.preprocessor.preprocess(image)
        prediction = self.cnn_model.predict(processed_image)
        probabilities = prediction[0]
        predicted_emotion = list(probabilities).index(max(probabilities))
        return predicted_emotion
