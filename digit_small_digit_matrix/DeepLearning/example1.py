# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

# TensorFlow and tf.keras
import tensorflow as tf
from tensorflow import keras
mnist = keras.datasets.mnist

(x_train, y_train),(x_test, y_test) = mnist.load_data()
x_train, x_test = x_train / 255.0, x_test / 255.0