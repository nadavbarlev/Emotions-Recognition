import cv2
import numpy as np
import dlib
from imutils import face_utils
from imutils.face_utils import FaceAligner
from keras.models import load_model
import time
import os
import numpy as np
import matplotlib.pyplot as plt
import pickle
from tensorflow.keras import applications
from tensorflow.keras.layers import  Flatten
from keras.models import load_model
from tensorflow.keras.models import Model
from keras.preprocessing import image
from PIL import Image
from skimage import transform


def get_image_size():
    img = cv2.imread('dataset/0/100.jpg', 0)
    return img.shape


#model = load_model('cnn_model_keras.h5')
model = load_model('_mini_XCEPTION.106-0.65.hdf5')
# testImagePath = r'D:\Degree\emojify-master-roro\new_dataset\4\20190615_122523_001.jpg'
testImagePath = r'D:\Degree\emojify-master-roro\new_dataset\2\20190615_121445_004.jpg'
# testImagePath = r'D:\Degree\emojify-master-roro\new_dataset\3\20190615_122425_001.jpg'
# testImagePath = r'D:\Degree\emojify-master-roro\new_dataset\4\20190615_122523_001.jpg'
image_size = (224, 224, 3)
image_size = (48, 48, 1)


def load(filename):
    np_image = Image.open(filename)
    np_image = np.array(np_image).astype('float32')/255
    np_image = transform.resize(np_image, image_size)
    np_image = np_image*255
    np_image = np.expand_dims(np_image, axis=0)

    return np_image


testImage = load(testImagePath)
features = model.predict(testImage)
print(f"Prediciton is - {np.argmax(features)}")
