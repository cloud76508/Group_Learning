# -*- coding: utf-8 -*-
"""
Created on Wed Jun  3 17:56:27 2020

@author: User
"""

from __future__ import absolute_import, division, print_function, unicode_literals

# Install TensorFlow

import tensorflow as tf

mnist = tf.keras.datasets.mnist


model = tf.keras.models.Sequential([
  tf.keras.layers.Flatten(input_shape=(784, 800)),
  tf.keras.layers.Dense(20, activation='relu'),
  tf.keras.layers.Dropout(0.2),
  tf.keras.layers.Dense(2, activation='softmax')
])

model.compile(optimizer='adam',
              loss='sparse_categorical_crossentropy',
              metrics=['accuracy'])

model.fit(x_train, y_train, epochs=5)

model.evaluate(x_test,  y_test, verbose=2)