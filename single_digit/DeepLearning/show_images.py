# -*- coding: utf-8 -*-
"""
Created on Tue Jan 26 13:02:36 2021

@author: ASUS
"""

import matplotlib.pyplot as plt

from load_mat_small_digit import x_train, y_train, x_test, y_test

# pick a sample to plot
sample = 15
image = x_train[sample]
# plot the sample
#fig = plt.figure
plt.imshow(image, cmap='gray')
#plt.show()