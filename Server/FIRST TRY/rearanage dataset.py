from shutil import copyfile
from os import listdir
from os.path import isfile, join

input_location = 'D:\Degree\Final project\cohn-kanade'
output_location = 'D:\Degree\Final project\cohn-kanade-formated2'

min_timeseries = 10
arrr = 0

import os
from distutils.dir_util import copy_tree

filtered_dirs = [f for f in listdir(input_location) if os.path.isdir(join(input_location, f))]

for current_dir_name in filtered_dirs:

    current_dir_path = join(input_location, current_dir_name)

    filtered_labels = [f for f in listdir(current_dir_path) if os.path.isdir(join(current_dir_path, f))]

    for label in filtered_labels:

        label_dir = join(output_location, label)

        if not os.path.isdir(label_dir):
            os.makedirs(label_dir)

        if len(os.listdir(join(current_dir_path, label))) >= min_timeseries:

            copy_tree(join(current_dir_path, label), label_dir)
        else:
            arrr += 1

        #label_and_current_path = join(label_dir, current_dir_name)
        label_and_current_path = label_dir

        # if not os.path.isdir(label_and_current_path):
        #
        #     if len(os.listdir(join(current_dir_path, label))) >= min_timeseries:
        #
        #         os.makedirs(label_and_current_path)
        #         copy_tree(join(current_dir_path, label), label_and_current_path)
        #     else:
        #         arrr += 1


print(str(arrr))
