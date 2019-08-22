from keras.models import load_model
import coremltools

# output_labels = ['Anger','Disgust','Happiness','Sadness','Surprise']
output_labels = ["angry", "disgust", "scared", "happy", "sad", "surprised", "neutral"]

#model = load_model(r"D:\Degree\Emotion-recognition-master\models\_mini_XCEPTION.102-0.66.hdf5")

your_model = coremltools.converters.caffe.convert("D:\Degree\VGG_S_rgb\EmotiW_VGG_S.caffemodel",
                                                  class_labels=output_labels)

#output_labels = ['Anger','Contempt','Disgust','Fear','Happiness','Sadness','Surprise']
# your_model = coremltools.converters.keras.convert(model=model,
#                                                   input_names=['image'],
#                                                   output_names=['output'],
#                                                   class_labels=output_labels,
#                                                   image_input_names='image')

# Not Required Just For Understanding
# your_model.author = 'your name'
# your_model.short_description = 'Digit Recognition with MNIST'
# your_model.input_description['image'] = 'Takes as input an image of a handwritten digit'
# your_model.output_description['output'] = 'Prediction of Digit

your_model.save('convmodel.mlmodel')
