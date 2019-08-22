# from EmoPy.src.fermodel import FERModel
# from EmoPy.src.directory_data_loader import DirectoryDataLoader
# from EmoPy.src.data_generator import DataGenerator
# from EmoPy.src.neuralnets import ConvolutionalNN
# from EmoPy.src.neuralnets import TransferLearningNN
#
#
# from pkg_resources import resource_filename,resource_exists
#
# validation_split = 0.15
#
# #target_dimensions = (64, 64)
# target_dimensions2 = (490, 640)
# target_dimensions = target_dimensions2
# model_name = 'inception_v3'
#
# channels = 1
# verbose = True
#
# print('--------------- Convolutional Model -------------------')
# print('Loading data...')
# # directory_path = resource_filename('EmoPy.examples','image_data/sample_image_directory')
# directory_path = r'C:\Users\localadmin\Desktop\final_proj\cohn-kanade-images2'
#
# data_loader = DirectoryDataLoader(datapath=directory_path,
#                                   validation_split=validation_split,
#                                   target_dimension=target_dimensions2)
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
# # model = ConvolutionalNN(target_dimensions, channels, dataset.get_emotion_index_map(), verbose=True)
# # model.fit_generator(train_gen.generate(target_dimensions, batch_size=5),
# #                     test_gen.generate(target_dimensions, batch_size=5),
# #                     epochs=5)
#
#
# print('Training net...')
# model = TransferLearningNN(model_name=model_name, emotion_map=dataset.get_emotion_index_map())
#
# print('Training model...')
# model.fit_generator(train_gen.generate(target_dimensions, 10),
#                     test_gen.generate(target_dimensions, 10),
#                     epochs=10)
#
# # Save model configuration
# model.model.save("output/transfermodel.h5")

from EmoPy.src.csv_data_loader import CSVDataLoader
from EmoPy.src.neuralnets import TransferLearningNN
from EmoPy.src.data_generator import DataGenerator
from EmoPy.src.directory_data_loader import DirectoryDataLoader

from pkg_resources import resource_filename

from keras import backend as K

K.set_image_data_format("channels_last")

validation_split = 0.15
verbose = True
model_name = 'inception_v3'

target_dimensions = (128, 128)
target_dimensions2 = (490, 640)

#directory_path = r'C:\Users\localadmin\Desktop\final_proj\cohn-kanade-images2'
directory_path =  r'D:\Degree\Final project\cohn-kanade-formated2'

data_loader = DirectoryDataLoader(datapath=directory_path,
                                  validation_split=validation_split,
                                  target_dimension=target_dimensions2,
                                  out_channels=3)
dataset = data_loader.load_data()




if verbose:
    dataset.print_data_details()

print('Creating training/testing data...')
train_images, train_labels = dataset.get_training_data()
train_gen = DataGenerator().fit(train_images, train_labels)
test_images, test_labels = dataset.get_test_data()
test_gen = DataGenerator().fit(test_images, test_labels)

print('Initializing neural network with InceptionV3 base model...')
model = TransferLearningNN(model_name=model_name, emotion_map=dataset.get_emotion_index_map())

print('Training model...')
model.fit_generator(train_gen.generate(target_dimensions, 10),
                    test_gen.generate(target_dimensions, 10),
                    epochs=10)
