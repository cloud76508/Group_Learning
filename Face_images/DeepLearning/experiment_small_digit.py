# -*- coding: utf-8 -*-
"""
Created on Mon Jan 13 15:02:43 2020

@author: User
"""

from __future__ import absolute_import, division, print_function, unicode_literals
import tensorflow as tf

from load_mat_single_digit import x_train, y_train, x_test, y_test

# from https://www.tensorflow.org/tutorials/quickstart/beginner
model = tf.keras.models.Sequential([
  tf.keras.layers.Flatten(input_shape=(28, 28)),
  tf.keras.layers.Dense(128, activation='relu'),
  tf.keras.layers.Dropout(0.2),
  tf.keras.layers.Dense(10)
])

model.compile(optimizer='adam',
              loss='sparse_categorical_crossentropy',
              metrics=['accuracy'])


model.fit(x_train, y_train, epochs=5)

model.evaluate(x_test,  y_test, verbose=2)

prediction = model.predict(x_test)

ss = sum(prediction[:500,0]<prediction[0:500,1])/500
sp = sum(prediction[501:1000,0]>prediction[501:1000,1])/500
print((ss+sp)/2)