import os

# new_names_mapping = {
#     'Anger': 0,
#     'Contempt': 1,
#     'Disgust': 2,
#     'Fear': 3,
#     'Happiness': 4,
#     'Sadness': 5,
#     'Surprise': 6
# }


new_names_mapping = {
    'Anger': 0,
    'Disgust': 1,
    'Happiness': 2,
    'Sadness': 3,
    'Surprise': 4
}


rootdir = 'new_dataset'

for subdir, dirs, files in os.walk(rootdir):
    for dir in dirs:
        if dir in new_names_mapping:
            os.rename(os.path.join(rootdir, dir), os.path.join(rootdir, str(new_names_mapping[dir])))
