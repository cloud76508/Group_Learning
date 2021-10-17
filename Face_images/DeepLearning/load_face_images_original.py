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
#posi_data_dir = str('C:\\Users\\ASUS\\Desktop\\images\\yaleB07')
#posi_data_dir = str('C:\\Users\\ASUS\\Desktop\\images\\yaleB30')
#posi_data_dir = str('C:\\Users\\ASUS\\Desktop\\images\\yaleB09')
posi_data_dir = str('C:\\Users\\ASUS\\Desktop\\images\\yaleB17')
posi_data_list = listdir(posi_data_dir)
randNum1 = np.random.permutation(len(posi_data_list))

#neg_data_dir = str('C:\\Users\\User\\Desktop\\digit_segment\\small_matrix\\negative')
#neg_data_dir = str('C:\\Users\\ASUS\\Desktop\\images\\yaleB19')
#neg_data_dir = str('C:\\Users\\ASUS\\Desktop\\images\\yaleB25')
#neg_data_dir = str('C:\\Users\\ASUS\\Desktop\\images\\yaleB21')
neg_data_dir = str('C:\\Users\\ASUS\\Desktop\\images\\yaleB35')
neg_data_list = listdir(neg_data_dir)
randNum2 = np.random.permutation(len(neg_data_list))

k = 2 #k times of training data

# generat training data
x_train = np.zeros(shape=(10*k,160,160))
for n in range(5*k): 
    mat_fname = pjoin(posi_data_dir, posi_data_list[randNum1[n]]) 
    mat_contents = sio.loadmat(mat_fname)
    temp = mat_contents['fimage']
    x_train[n] = temp
for n in range(5*k):
    mat_fname = pjoin(neg_data_dir, neg_data_list[randNum2[n]]) 
    mat_contents = sio.loadmat(mat_fname)
    temp = mat_contents['fimage']
    x_train[n+5*k] = temp

y_train = np.zeros(shape=(10*k,1))
for n in range(5*k):
    y_train[n] = 1

# generate test data    
x_test = np.zeros(shape=(88,160,160))
i=0
for n in range(20,63,1): 
    mat_fname = pjoin(posi_data_dir, posi_data_list[randNum1[n]]) 
    mat_contents = sio.loadmat(mat_fname)
    temp = mat_contents['fimage']
    x_test[i] = temp
    i=i+1
i=0
for n in range(20,63,1):
    mat_fname = pjoin(neg_data_dir, neg_data_list[randNum2[n]]) 
    mat_contents = sio.loadmat(mat_fname)
    temp = mat_contents['fimage']
    x_test[i+24] = temp #the 24 should be 44?
    i=i+1

y_test = np.zeros(shape=(88,1))
for n in range(44):
    y_test[n] = 1

