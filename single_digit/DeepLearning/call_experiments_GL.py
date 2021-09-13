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
import cnn_MNIST_GL as cnn_MNIST_GL
#import experiment_single_digit_cnn_GL_MV as exp_GL
import load_mat_single_digit as load_data

trn_error =  np.zeros([10, 1])
tst_error =  np.zeros([10, 1])
trn_error_GL_AD =  np.zeros([10, 5])
tst_error_GL_AD =  np.zeros([10, 5])
trn_error_GL_MV =  np.zeros([10, 5])
tst_error_GL_MV =  np.zeros([10, 5])

#gs_list = [18,21,24,27]
gs_list = [15,18,21,24,27]
#gs_list = [25]

#LR = [0.1,0.01,0.001,0.0001,0.00001]
LR = [0.001,0.0008,0.0006,0.0004,0.0002]
#LR = [0.001]

#for j in range(len(gs_list)):
for i in range(10):
    [x_trn, y_trn, x_val, y_val, x_tst, y_tst] = load_data.load_data(2)
   
    [opt_para,val_error]=cnn_MNIST.cv(x_trn, y_trn, x_val, y_val,LR)
    [trn_error[i,0], tst_error[i,0]] = cnn_MNIST.exp(x_trn, y_trn, x_tst, y_tst,opt_para)
    
    n_pos_trn = int(x_trn.shape[0]/2)
    n_neg_trn = int(x_trn.shape[0]/2)
    n_pos_val = int(x_val.shape[0]/2)
    n_neg_val = int(x_val.shape[0]/2)
    n_pos_tst = int(x_tst.shape[0]/2)
    n_neg_tst = int(x_tst.shape[0]/2)
    
    for j in range(5):
        [x_trn_GL, y_trn_GL, gn_trn] = cnn_MNIST_GL.GoupData(x_trn, gs_list[j], n_pos_trn, n_neg_trn)
        [x_val_GL, y_val_GL, gn_val] = cnn_MNIST_GL.GoupData(x_val, gs_list[j], n_pos_val, n_neg_val)
        [x_tst_GL, y_tst_GL, gn_tst] = cnn_MNIST_GL.GoupData(x_tst, gs_list[j], n_pos_tst, n_neg_tst)
        
        [opt_para,val_error]=cnn_MNIST_GL.cv(x_trn_GL, y_trn_GL, x_val_GL, y_val_GL,LR)
        
        [temp1, temp2, y_pre_trn_GL, y_pre_val_GL] = cnn_MNIST_GL.exp(x_trn_GL, y_trn_GL, x_val_GL, y_val_GL,opt_para)
        [temp1, temp2, y_pre_trn_GL, y_pre_tst_GL] = cnn_MNIST_GL.exp(x_trn_GL, y_trn_GL, x_tst_GL, y_tst_GL,opt_para)
        
        [trn_error_GL_AD[i,j], tst_error_GL_AD[i,j]] = cnn_MNIST_GL.post_adapt(y_pre_val_GL,n_pos_val,n_neg_val,gn_val, y_pre_tst_GL)
        [trn_error_GL_MV[i,j], tst_error_GL_MV[i,j]] = cnn_MNIST_GL.post_MV(y_pre_val_GL,n_pos_val,n_neg_val,gn_val, y_pre_tst_GL)
        