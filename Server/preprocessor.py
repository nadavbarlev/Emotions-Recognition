import cv2
import dlib
import numpy as np
import imutils.contours
from imutils import face_utils
from imutils.face_utils import FaceAligner


class Preprocessor(object):

    SHAPE_PREDICTOR = "shape_predictor_68_face_landmarks.dat"
    IMAGE_WIDTH = 100
    IMAGE_HEIGHT = 100

    def __init__(self):
        self.face_detector = dlib.get_frontal_face_detector()
        self.shape_predictor = dlib.shape_predictor(self.SHAPE_PREDICTOR)
        self.face_aligner = FaceAligner(self.shape_predictor, desiredFaceWidth=250)  # TODO: see if face width is necessary

    def preprocess(self, image):
        image = cv2.flip(image, 1)
        gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
        face = self.face_detector(gray_image)[0]
        shape = face_utils.shape_to_np(self.shape_predictor(image, face))
        mask = self._get_mask(shape, image)
        masked_gray_image = cv2.bitwise_and(gray_image, mask)
        aligned_mask = self.face_aligner.align(mask, gray_image, face)
        aligned_face = self.face_aligner.align(masked_gray_image, gray_image, face)
        (x0, y0, x1, y1) = self._get_bounding_rectangle(aligned_mask)
        aligned_face = aligned_face[y0:y1, x0:x1]
        aligned_face = cv2.resize(aligned_face, (100, 100))

        image = cv2.resize(aligned_face, (self.IMAGE_WIDTH, self.IMAGE_HEIGHT))
        image = np.array(image, dtype=np.float32)
        image = np.reshape(image, (1, self.IMAGE_WIDTH, self.IMAGE_HEIGHT, 1))
        return image

    def _get_mask(self, shape, image):
        height, width, channels = image.shape
        mask = np.zeros((height, width), dtype=np.uint8)

        right_eye = (36, 37, 38, 39, 40, 41)
        left_eye = (42, 43, 44, 45, 46, 47)
        mouth = (48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59)
        nose = (27, 31, 33, 35)
        left_eyebrow = (17, 18, 19, 20, 21)
        right_eyebrow = (22, 24, 25, 26, 26)

        right_eye_center = self._get_center(shape, *right_eye)
        right_eye_radius = self._get_largest_distance(shape, right_eye_center, *right_eye)
        mask = cv2.circle(mask, right_eye_center, right_eye_radius, 255, -1)

        left_eye_center = self._get_center(shape, *left_eye)
        left_eye_radius = self._get_largest_distance(shape, left_eye_center, *left_eye)
        mask = cv2.circle(mask, left_eye_center, left_eye_radius, 255, -1)

        mouth_center = self._get_center(shape, *mouth)
        mouth_radius = self._get_largest_distance(shape, mouth_center, *mouth)
        mask = cv2.circle(mask, mouth_center, mouth_radius, 255, -1)

        mask = cv2.fillPoly(mask, [np.array([shape[point] for point in left_eyebrow])], 255)
        mask = cv2.fillPoly(mask, [np.array([shape[point] for point in right_eyebrow])], 255)
        mask = cv2.fillPoly(mask, [np.array([shape[point] for point in nose])], 255)
        return mask

    def _get_center(self, shape, *points):
        num_of_points = len(points)
        x, y = 0, 0
        for point in points:
            x += shape[point][0]
            y += shape[point][1]
        center = (int(x / num_of_points), int(y / num_of_points))
        return center

    def _get_largest_distance(self, shape, fixed_point, *other_points):
        largest_distance = 0
        for point in other_points:
            dist = self._get_euclidean_distance(fixed_point, shape[point])
            if dist > largest_distance:
                largest_distance = dist
        return largest_distance

    def _get_euclidean_distance(self, a, b):
        dist = 0
        if len(a) == len(b):
            for i in range(len(a)):
                dist += (a[i] - b[i]) ** 2
            dist = np.sqrt(dist)
        return int(dist)

    def _get_bounding_rectangle(self, image):
        contours = cv2.findContours(image.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[1]
        bounding_boxes = imutils.contours.sort_contours(contours, method='left-to-right')[1]

        x0, y0 = bounding_boxes[0][0], bounding_boxes[0][1]
        x1, y1 = 0, 0
        for i, (x, y, w, h) in enumerate(bounding_boxes):
            if i == 0:
                continue
            if x + w > x1:
                x1 = x + w
            if y + h > y1:
                y1 = y + h
        return x0, y0, x1, y1
