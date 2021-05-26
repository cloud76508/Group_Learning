# -*- coding: utf-8 -*-
"""
Created on Mon Jan 13 14:57:04 2020

@author: User
"""

import tensorflow as tf
import numpy as np
from tensorflow.keras.layers import Dense, Flatten, Conv2D, MaxPool2D
from tensorflow.keras import Model

from load_mat_small_digit import x_train, y_train, x_test, y_test


#show digit images
#import matplotlib.pyplot as plt
#sample = 15
#image = x_train[sample]
#plt.imshow(image, cmap='gray')

#mnist = tf.keras.datasets.mnist
#(x_train, y_train), (x_test, y_test) = mnist.load_data()
#x_train, x_test = x_train / 255.0, x_test / 255.0

gs = 112 # group size
n_pos = 10
n_neg = 10
n_pos_tst = 100
n_neg_tst = 100
def GoupData(x_train, gs, n_pos, n_neg):
    #GL data preprocessing
    gn = int(x_train.shape[1]/gs)*int(x_train.shape[2]/gs) #number of small groups
    rn = int(x_train.shape[1]/gs)
    cn = int(x_train.shape[2]/gs)
    #data_temp = np.zeros(shape=(x_train.shape[0], gs, gs*gn,1))
    data_GL = np.zeros(shape=(x_train.shape[0]*gn, gs, gs))
    for i in range(x_train.shape[0]):
        for j in range(gn):
            data_GL[i*gn+j] = x_train[i][int(j/cn)*gs:(int(j/cn)+1)*gs,(j%rn)*gs:(j%rn+1)*gs]
    label_GL = np.concatenate((np.ones([n_pos*gn,1]),np.zeros([n_neg*gn,1])), axis = 0)
    return (data_GL, label_GL, gn)

def GoupData_FP(x_train, gs, n_pos, n_neg):
    #GL data preprocessing
    if np.mod(gs,28) == 0:
        rn_delete = int(np.ceil(gs/28)-1)
    else:
        rn_delete = int(np.ceil(gs/28))
    cn_delete = rn_delete
    #data_temp = np.zeros(shape=(x_train.shape[0], gs, gs*gn,1))
    data_GL = np.zeros(shape=(x_train.shape[0]*(8-rn_delete)*(8-cn_delete), gs, gs))
    for i in range(x_train.shape[0]):
        for j in range(8-rn_delete):
            for q in range(8-cn_delete): 
                data_GL[i*(8-rn_delete)*(8-cn_delete)+(8-cn_delete)*j+q] = x_train[i][j*28:j*28+gs,q*28:q*28+gs]
    label_GL = np.concatenate((np.ones([n_pos*(8-rn_delete)*(8-cn_delete),1]),np.zeros([n_neg*(8-rn_delete)*(8-cn_delete),1])), axis = 0)
    return (data_GL, label_GL, (8-rn_delete)*(8-cn_delete))
    

[x_train, y_train, gn] = GoupData_FP(x_train, gs, n_pos, n_neg)
[x_test, y_test, gn] = GoupData_FP(x_test, gs, n_pos_tst, n_neg_tst)


## Add a channels dimension
x_train = x_train[..., tf.newaxis]
x_test = x_test[..., tf.newaxis]

train_ds = tf.data.Dataset.from_tensor_slices(
    (x_train, y_train)).shuffle(320).batch(4)


test_ds = tf.data.Dataset.from_tensor_slices((x_test, y_test)).batch(4)

class MyModel(Model):
  def __init__(self):
    super(MyModel, self).__init__()
    self.conv1 = Conv2D(32, 3, activation='relu') # used in the tutorials
    #self.conv1 = Conv2D(32, 5, (5,5), activation='relu') # for test
    #self.pooling = MaxPool2D() # for test
    self.flatten = Flatten()
    self.d1 = Dense(128, activation='relu')
    self.d2 = Dense(2)
    
  def call(self, x):
    x = self.conv1(x)
    x = self.pooling(x) # for test
    x = self.flatten(x)
    x = self.d1(x)
    return self.d2(x)

# Create an instance of the model
model = MyModel()

loss_object = tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True)

optimizer = tf.keras.optimizers.Adam()

train_loss = tf.keras.metrics.Mean(name='train_loss')
train_accuracy = tf.keras.metrics.SparseCategoricalAccuracy(name='train_accuracy')

test_loss = tf.keras.metrics.Mean(name='test_loss')
test_accuracy = tf.keras.metrics.SparseCategoricalAccuracy(name='test_accuracy')

@tf.function
def train_step(images, labels):
  with tf.GradientTape() as tape:
    # training=True is only needed if there are layers with different
    # behavior during training versus inference (e.g. Dropout).
    predictions = model(images, training=True)
    loss = loss_object(labels, predictions)
  gradients = tape.gradient(loss, model.trainable_variables)
  optimizer.apply_gradients(zip(gradients, model.trainable_variables))

  train_loss(loss)
  train_accuracy(labels, predictions)
  
@tf.function
def test_step(images, labels):
  # training=False is only needed if there are layers with different
  # behavior during training versus inference (e.g. Dropout).
  predictions = model(images, training=False)
  t_loss = loss_object(labels, predictions)

  test_loss(t_loss)
  test_accuracy(labels, predictions)


EPOCHS = 5

for epoch in range(EPOCHS):
  # Reset the metrics at the start of the next epoch
  train_loss.reset_states()
  train_accuracy.reset_states()
  test_loss.reset_states()
  test_accuracy.reset_states()

  for images, labels in train_ds:
    train_step(images, labels)

  for test_images, test_labels in test_ds:
    test_step(test_images, test_labels)

  template = 'Epoch {}, Loss: {}, Accuracy: {}, Test Loss: {}, Test Accuracy: {}'
  print(template.format(epoch + 1,
                        train_loss.result(),
                        train_accuracy.result() * 100,
                        test_loss.result(),
                        test_accuracy.result() * 100))

y_pre_train = model(x_train).numpy() 

output_train = np.zeros([y_pre_train.shape[0],1])
for n in range(y_pre_train.shape[0]):
    if y_pre_train[n,0] > y_pre_train[n,1]:
        output_train[n,0] = -y_pre_train[n,0]
    else:
        output_train[n,0] = y_pre_train[n,1]

mean_train = np.zeros([int(output_train.shape[0]/gn),1])
for n in range(int(output_train.shape[0]/gn)):
    mean_train[n,0] = np.mean(output_train[n*gn:(n+1)*gn])

#threshold = (np.mean(mean_train[0:n_pos]) + np.mean(mean_train[n_pos:n_pos+n_neg]))/2
#threshold = (np.min(mean_train[0:n_pos]) + np.max(mean_train[n_pos:n_pos+n_neg]))/2
    
val_perf = np.zeros([11,11]) 
for n in range(11):
    for m in range(11):
        if np.quantile(mean_train[0:n_pos],n/10) > np.quantile(mean_train[n_pos:n_pos+n_neg],(10-m)/10):
            val_thr = (np.quantile(mean_train[0:n_pos],n/10) + np.quantile(mean_train[n_pos:n_pos+n_neg],(10-m)/10))/2
            val_ss = sum(mean_train[0:n_pos,0]>val_thr)/n_pos
            val_sp = sum(mean_train[n_pos:n_pos+n_neg,0]<val_thr)/n_neg
            val_perf[n,m] =  val_ss + val_sp
        else:
            val_perf[n,m] = 0

max_index = np.argmax(val_perf)
n_max = int(np.floor(max_index/11))
if max_index == 0:
    m_max = 0
elif np.mod(max_index,11) == 0:
    m_max = 11-1
else:
    m_max = np.mod(max_index,11)-1
        
threshold = (np.quantile(mean_train[0:n_pos],n_max/10) + np.quantile(mean_train[n_pos:n_pos+n_neg],(10-m_max)/10))/2

ss_train = sum(mean_train[0:n_pos,0]>threshold)/n_pos
sp_train = sum(mean_train[n_pos:n_pos+n_neg,0]<threshold)/n_neg

print(ss_train)
print(sp_train)

y_pre = model(x_test).numpy()

output_test = np.zeros([y_pre.shape[0],1])
for n in range(y_pre.shape[0]):
    if y_pre[n,0] > y_pre[n,1]:
        output_test[n,0] = -y_pre[n,0]
    else:
        output_test[n,0] = y_pre[n,1]
        
mean_test = np.zeros([int(output_test.shape[0]/gn),1])
for n in range(int(output_test.shape[0]/gn)):
    mean_test[n,0] = np.mean(output_test[n*gn:(n+1)*gn])

number_samples_class = int(mean_test.shape[0]/2)
    
ss = sum(mean_test[0:number_samples_class,0]>threshold)/number_samples_class
sp = sum(mean_test[number_samples_class:number_samples_class*2,0]<threshold)/number_samples_class

#ss = sum(mean_test[:500,0]>0)/500
#sp = sum(mean_test[500:1000,0]<0)/500

print(ss)
print(sp)
