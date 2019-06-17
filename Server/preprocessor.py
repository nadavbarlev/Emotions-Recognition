import cv2
import numpy as np
from keras.preprocessing.image import img_to_array


class Preprocessor(object):

    IMAGE_WIDTH = 64
    IMAGE_HEIGHT = 64

    def preprocess(self, image):
        image = cv2.imdecode(image, cv2.COLOR_BGR2BGRA)
        image = cv2.resize(image, (self.IMAGE_HEIGHT, self.IMAGE_WIDTH))
        image = image.astype("float") / 255.0
        image = img_to_array(image)
        image = np.expand_dims(image, axis=0)

        return image
