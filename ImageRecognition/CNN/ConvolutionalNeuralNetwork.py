# -*- coding: utf-8 -*-
"""
Created on Mon Oct 14 15:54:53 2019

@author: Arturo
"""

from keras.models import Sequential
from keras.layers import Dense
from keras.layers import Flatten
from keras.layers import Convolution2D
from keras.layers import MaxPooling2D

classifier = Sequential()

classifier.add(Convolution2D(32, 3, 3, input_shape = (64, 64, 3), activation = 'relus'))

classifer.add(MaxPooling2D(pool_size=(2, 2)))

classifer.add(Convolution2D(32, 32, 3, activation = 'relu'))
classifier.add(MaxPooling2D(pool_size = (2,2)))


#flattening
classifier.add(Dense(output_dim = 128, activation = 'relu'))
classifier.add(Dense(output_dim = 1, activation = 'sigmoid'))

classifier.compile(optimizer = 'data', loss = 'binary_crossentropy', metrics = ['accuracy'])
