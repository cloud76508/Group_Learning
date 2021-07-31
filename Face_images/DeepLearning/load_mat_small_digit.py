# -*- coding: utf-8 -*-
"""
Created on Wed Jun  3 14:16:20 2020

@author: User
"""

from os.path import dirname, join as pjoin
import scipy.io as sio
from os import listdir
import numpy as np

#posi_data_dir = str('C:\\Users\\User\\Desktop\\digit_segment\\small_matrix\\positive')
posi_data_dir = str('C:\\Users\\ASUS\\Desktop\\digit\\positive')
posi_data_list = listdir(posi_data_dir)

#neg_data_dir = str('C:\\Users\\User\\Desktop\\digit_segment\\small_matrix\\negative')
neg_data_dir = str('C:\\Users\\ASUS\\Desktop\\digit\\negative')
neg_data_list = listdir(neg_data_dir)

k = 1 #k times of training data

# generat training data
x_train = np.zeros(shape=(20*k,224,224))
for n in range(10*k): 
    mat_fname = pjoin(posi_data_dir, posi_data_list[n]) 
    mat_contents = sio.loadmat(mat_fname)
    temp = mat_contents['segment']
    x_train[n] = temp
for n in range(10*k):
    mat_fname = pjoin(neg_data_dir, neg_data_list[n]) 
    mat_contents = sio.loadmat(mat_fname)
    temp = mat_contents['segment']
    x_train[n+10*k] = temp

y_train = np.zeros(shape=(20*k,1))
for n in range(10*k):
    y_train[n] = 1

# generate test data    
x_test = np.zeros(shape=(200,224,224))
for n in range(100): 
    mat_fname = pjoin(posi_data_dir, posi_data_list[n+100]) 
    mat_contents = sio.loadmat(mat_fname)
    temp = mat_contents['segment']
    x_test[n] = temp
for n in range(100):
    mat_fname = pjoin(neg_data_dir, neg_data_list[n+100]) 
    mat_contents = sio.loadmat(mat_fname)
    temp = mat_contents['segment']
    x_test[n+100] = temp

y_test = np.zeros(shape=(200,1))
for n in range(100):
    y_test[n] = 1

