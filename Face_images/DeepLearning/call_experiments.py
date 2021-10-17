# -*- coding: utf-8 -*-
"""
Created on Sat Mar 27 11:53:25 2021

@author: HHC
"""

import numpy as np
import experiment_face_images_cnn as exp
import cnn_FI as cnn_FI
import load_face_images as load_data

train_error =  np.zeros([10, 5])
test_error =  np.zeros([10, 5])
train_error_op =  np.zeros([10, 5])
test_error_op =  np.zeros([10, 5])

#gs_list = [18,21,24,27]
gs_list = [15,18,21,24,27]
#gs_list = [25]

#LR = [0.1,0.01,0.001,0.0001,0.00001]
LR = [0.001,0.0008,0.0006,0.0004,0.0002]

#for j in range(len(gs_list)):
for j in range(1):
    for i in range(10):
       [x_train, y_train, x_val, y_val, x_test, y_test] = load_data.load_data(2)
       [train_error[i,j], test_error[i,j]] = exp.cnn_experiment(x_train, y_train, x_test, y_test)
       
       #[opt_para,val_error]=cnn_FI.cv(x_train, y_train, x_val, y_val,LR)
       #[train_error_op[i,j], test_error_op[i,j]] = cnn_FI.exp(x_train, y_train, x_test, y_test,opt_para)
       
np.mean(test_error[:,0])
np.mean(test_error_op[:,0])