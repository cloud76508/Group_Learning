# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

# TensorFlow and tf.keras
import tensorflow as tf
from tensorflow import keras
import numpy as np
mnist = keras.datasets.mnist

(x_train, y_train),(x_test, y_test) = mnist.load_data()
x_train, x_test = x_train / 255.0, x_test / 255.0


x1_train = x_train[y_train==0]
x1_train = x1_train[0:10] #
x2_train = x_train[y_train==2]
x2_train = x2_train[0:10] #
x_train = np.concatenate([x1_train, x2_train])
y1_train = y_train[y_train==0]
y1_train = y1_train[0:10] #
y2_train = y_train[y_train==2]
y2_train = y2_train - 1
y2_train = y2_train[0:10] #
y_train = np.concatenate([y1_train, y2_train])

x1_test = x_test[y_test==0]
x2_test = x_test[y_test==2]
x_test = np.concatenate([x1_test, x2_test])
y1_test = y_test[y_test==0]
y2_test = y_test[y_test==2]
y2_test = y2_test - 1
y_test = np.concatenate([y1_test, y2_test])


model = tf.keras.models.Sequential([
  tf.keras.layers.Flatten(input_shape=(28, 28)),
  tf.keras.layers.Dense(128, activation='relu'),
  tf.keras.layers.Dropout(0.2),
  tf.keras.layers.Dense(2)
])

predictions = model(x_train[:1]).numpy()
predictions

tf.nn.softmax(predictions).numpy()

loss_fn = tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True)
#loss_fn = tf.keras.losses.BinaryCrossentropy()

loss_fn(y_train[:1], predictions).numpy()

model.compile(optimizer='adam',
              loss=loss_fn,
              metrics=['accuracy'])

model.fit(x_train, y_train, epochs=5)

model.evaluate(x_test,  y_test, verbose=2)

probability_model = tf.keras.Sequential([
  model,
  tf.keras.layers.Softmax()
])

probability_model(x_test[:5])