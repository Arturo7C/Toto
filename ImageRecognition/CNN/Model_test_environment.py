# -*- coding: utf-8 -*-
"""
Created on Mon Oct 14 18:40:37 2019

@author: Arturo
"""

#testing the new model
# load weights into new model
import numpy as np
from keras.models import Sequential
from keras.layers import Dense
from keras.layers import Flatten
from keras.layers import Convolution2D
from keras.layers import MaxPooling2D
from keras.preprocessing.image import ImageDataGenerator
from keras.preprocessing import image
from keras.models import model_from_json

# load json and create model
json_file = open('model.json', 'r')
loaded_model_json = json_file.read()
json_file.close()
loaded_model = model_from_json(loaded_model_json)
# load weights into new model
loaded_model.load_weights("model.h5")
print("Loaded model from disk")
 
# evaluate loaded model on test data
loaded_model.compile(loss='binary_crossentropy', optimizer='rmsprop', metrics=['accuracy'])
#score = loaded_model.evaluate(X, Y, verbose=0)
#print("%s: %.2f%%" % (loaded_model.metrics_names[1], score[1]*100))


test_image = image.load_img('dataset/random_cat.jpg', target_size = (64, 64))
test_image = image.img_to_array(test_image)
test_image = np.expand_dims(test_image, axis = 0)
#score = (loaded_model.evaluate(test_image, verbose = 0))
results = loaded_model.predict(test_image)
#training_set.class_indices

if results[0][0] >= 0.5:
    prediction = 'doggo'
else:
    prediction = 'cat'
    
print(prediction)
#print("%s: %.2f%%" % (loaded_model.metrics_names[1], score[1]*100))