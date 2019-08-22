# from EmoPy.src.fermodel import FERModel
# from EmoPy.src.directory_data_loader import DirectoryDataLoader
# from EmoPy.src.data_generator import DataGenerator
# from EmoPy.src.neuralnets import ConvolutionalNN
#
# from pkg_resources import resource_filename,resource_exists
#
# validation_split = 0.15
#
# target_dimensions = (64, 64)
# channels = 1
# verbose = True
#
# print('--------------- Convolutional Model -------------------')
# print('Loading data...')
# #directory_path = resource_filename('EmoPy.examples', 'image_data/sample_image_directory')
# directory_path = 'D:\Degree\Final project\cohn-kanade-formated'
# data_loader = DirectoryDataLoader(datapath=directory_path, validation_split=validation_split, time_delay=True)
# dataset = data_loader.load_data()
#
# if verbose:
#     dataset.print_data_details()
#
# print('Preparing training/testing data...')
# train_images, train_labels = dataset.get_training_data()
# train_gen = DataGenerator().fit(train_images, train_labels)
# test_images, test_labels = dataset.get_test_data()
# test_gen = DataGenerator().fit(test_images, test_labels)
#
# print('Training net...')
# model = ConvolutionalNN(target_dimensions, channels, dataset.get_emotion_index_map(), verbose=True)
# model.fit_generator(train_gen.generate(target_dimensions, batch_size=5),
#                     test_gen.generate(target_dimensions, batch_size=5),
#                     epochs=5)
#
# # Save model configuration
# model.export_model('output/conv2d_model.json','output/conv2d_weights.h5',"output/conv2d_emotion_map.json", emotion_map)


from EmoPy.src.data_generator import DataGenerator
from EmoPy.src.directory_data_loader import DirectoryDataLoader
from EmoPy.src.neuralnets import TimeDelayConvNN
from pkg_resources import resource_filename
import numpy

validation_split = 0.25

target_dimensions = (128, 128)
target_dimensions2 = (490, 640)
channels = 1
verbose = True

print('--------------- Time-Delay Convolutional Model -------------------')
print('Loading data...')
directory_path = resource_filename('EmoPy.examples', "image_data/sample_image_series_directory")
directory_path = r'D:\Degree\Final project\cohn-kanade-formated'
data_loader = DirectoryDataLoader(datapath=directory_path,
                                  validation_split=validation_split,
                                  time_delay=10,
                                  target_dimension=target_dimensions2)
dataset = data_loader.load_data()

if verbose:
    dataset.print_data_details()

print('Preparing training/testing data...')
train_images, train_labels = dataset.get_training_data()
train_gen = DataGenerator(time_delay=dataset.get_time_delay()).fit(train_images, train_labels)
test_images, test_labels = dataset.get_test_data()
test_gen = DataGenerator(time_delay=dataset.get_time_delay()).fit(test_images, test_labels)

print('Training net...')
model = TimeDelayConvNN(target_dimensions, channels, emotion_map=dataset.get_emotion_index_map(), time_delay=dataset.get_time_delay())
model.fit_generator(train_gen.generate(target_dimensions, batch_size=10),
                    test_gen.generate(target_dimensions, batch_size=10),
                    epochs=5)

# Save model configuration
#model.export_model('output/time_delay_model.json','output/time_delay_weights.h5',"output/time_delay_emotion_map.json", emotion_map)

model.model.save('output/time_delay_weights.h5')
