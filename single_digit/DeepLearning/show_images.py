# -*- coding: utf-8 -*-
"""
Created on Tue Jan 26 13:02:36 2021

@author: ASUS
"""

import matplotlib.pyplot as plt

import load_mat_single_digit as load_data
[x_train, y_train, x_val, y_val, x_test, y_test] = load_data.load_data(2)

# pick a sample to plot
sample = 5
image = x_train[sample]
# plot the sample
#fig = plt.figure
plt.imshow(image, cmap='gray')
#plt.show()