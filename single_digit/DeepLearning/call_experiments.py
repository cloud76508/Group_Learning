# -*- coding: utf-8 -*-
"""
Created on Sat Mar 27 11:53:25 2021

@author: HHC
"""

import numpy as np
import experiment_single_digit_cnn as exp
import cnn_MNIST as cnn_MNIST
#import experiment_single_digit_cnn_test as exp
import experiment_single_digit_cnn_GL as exp_GL
#import experiment_single_digit_cnn_GL_MV as exp_GL
import load_mat_single_digit as load_data

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
for j in range(5):
    for i in range(10):
       [x_train, y_train, x_val, y_val, x_test, y_test] = load_data.load_data(2)
       #[train_error[i,j], test_error[i,j]] = exp_GL.cnn_GL_experiment(gs_list[j])
       [train_error[i,j], test_error[i,j]] = exp.cnn_experiment(x_train, y_train, x_test, y_test)
       
       [opt_para,val_error]=cnn_MNIST.cv(x_train, y_train, x_val, y_val,LR)
       [train_error_op[i,j], test_error_op[i,j]] = cnn_MNIST.exp(x_train, y_train, x_test, y_test,opt_para)
       
np.mean(test_error[:,0])
np.mean(test_error_op[:,0])