from shutil import copyfile
from os import listdir
from os.path import isfile, join

# terminal_fxt_dir = r"C:\Users\rotem\AppData\Roaming\MetaQuotes\Terminal\69BF702D67C2383E9452CBB67E7EB371\tester\history"
#
# symbol = "GBPCAD"
#
# filtered_files = [f for f in listdir(terminal_fxt_dir) if isfile(join(terminal_fxt_dir, f)) and f.startswith(symbol)]
#
# for file_name in filtered_files:
#     dst_file_name = "x" + file_name
#
#     src_path = join(terminal_fxt_dir, file_name)
#     dst_path = join(terminal_fxt_dir, dst_file_name)
#
#     copyfile(src_path, dst_path)
#
#     print(f"successfully copied {src_path} to {dst_path}")
#
#
input_location = 'D:\Degree\Final project\cohn-kanade'
output_location = 'D:\Degree\Final project\cohn-kanade-formated'

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

        label_and_current_path = join(label_dir, current_dir_name)

        if not os.path.isdir(label_and_current_path):

            if len(os.listdir(join(current_dir_path, label))) >= min_timeseries:

                os.makedirs(label_and_current_path)
                copy_tree(join(current_dir_path, label), label_and_current_path)
            else:
                arrr += 1



print(str(arrr))
