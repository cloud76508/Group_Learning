# -*- coding: utf-8 -*-
"""
Created on Sat Mar 27 11:53:25 2021

@author: ASUS
"""

import numpy as np
import experiment_single_digit_cnn as exp
import experiment_single_digit_cnn_GL as exp_GL
#import experiment_single_digit_cnn_GL_MV as exp_GL

train_error =  np.zeros([10, 5])
test_error =  np.zeros([10, 5])

gs_list = [15,18,21,24,27]

for j in range(len(gs_list)):
#for j in range(1):
    for i in range(10):
       [train_error[i,j], test_error[i,j]] = exp_GL.cnn_GL_experiment(gs_list[j])
       #[train_error[i,j], test_error[i,j]] = exp.cnn_experiment()