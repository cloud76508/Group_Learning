# -*- coding: utf-8 -*-
"""
Created on Wed Jun  3 14:16:20 2020

@author: User
"""

from os.path import dirname, join as pjoin
import scipy.io as sio
from os import listdir
import numpy as np

posi_data_dir = str('C:\\Users\\User\\Desktop\\digit_segment\\small_matrix\\positive')
posi_data_list = listdir(posi_data_dir)

neg_data_dir = str('C:\\Users\\User\\Desktop\\digit_segment\\small_matrix\\negative')
neg_data_list = listdir(neg_data_dir)

# generat training data
x_train = np.zeros(shape=(10,784,16))
for n in range(5): 
    mat_fname = pjoin(posi_data_dir, posi_data_list[n]) 
    mat_contents = sio.loadmat(mat_fname)
    temp = mat_contents['segment']
    x_train[n] = temp
for n in range(5):
    mat_fname = pjoin(neg_data_dir, neg_data_list[n]) 
    mat_contents = sio.loadmat(mat_fname)
    temp = mat_contents['segment']
    x_train[n+5] = temp

y_train = np.zeros(shape=(10,1))
for n in range(5):
    y_train[n] = 1

# generate test data    
x_test = np.zeros(shape=(1000,784,16))
for n in range(500): 
    mat_fname = pjoin(posi_data_dir, posi_data_list[n+100]) 
    mat_contents = sio.loadmat(mat_fname)
    temp = mat_contents['segment']
    x_test[n] = temp
for n in range(500):
    mat_fname = pjoin(neg_data_dir, neg_data_list[n+100]) 
    mat_contents = sio.loadmat(mat_fname)
    temp = mat_contents['segment']
    x_test[n+500] = temp

y_test = np.zeros(shape=(1000,1))
for n in range(500):
    y_test[n] = 1

