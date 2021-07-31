# -*- coding: utf-8 -*-
"""
Created on Mon Jan 13 14:57:04 2020
    
@author: User

"""
    
if __name__ == '__main__':
    # test1.py executed as script
    # do something
    cnn_experiment()

def cnn_GL_experiment(gs):
    import tensorflow as tf
    import numpy as np
    from tensorflow.keras.layers import Dense, Flatten, Conv2D, MaxPool2D
    from tensorflow.keras import Model
    
    from load_mat_single_digit import x_train, y_train, x_test, y_test
    
    #x_test = x_test[:100]
    #y_test = y_test[:100]
    
    #show digit images
    #import matplotlib.pyplot as plt
    #sample = 15
    #image = x_train[sample]
    #plt.imshow(image, cmap='gray')
        
    
    #mnist = tf.keras.datasets.mnist
    #(x_train, y_train), (x_test, y_test) = mnist.load_data()
    #x_train, x_test = x_train / 255.0, x_test / 255.0
    
    #gs = 20 # group size
    n_pos = 5
    n_neg = 5
    n_pos_tst = 500
    n_neg_tst = 500
    def GoupData(x_train, gs, n_pos, n_neg):
        #GL data preprocessing
        rn = 28-gs+1
        cn = rn
        #data_temp = np.zeros(shape=(x_train.shape[0], gs, gs*gn,1))
        data_GL = np.zeros(shape=(x_train.shape[0]*rn*cn, gs, gs))
        k = 0
        for i in range(x_train.shape[0]):
            for j in range(rn):
                for q in range(cn): 
                    data_GL[k] = x_train[i][j:(j+gs),q:(q+gs)]
                    k = k+1
        label_GL = np.concatenate((np.ones([n_pos*cn*rn,1]),np.zeros([n_neg*cn*rn,1])), axis = 0)
        return (data_GL, label_GL, cn*rn)
    
    [x_train, y_train, gn] = GoupData(x_train, gs, n_pos, n_neg)
    [x_test, y_test, gn] = GoupData(x_test, gs, n_pos_tst, n_neg_tst)
    
    
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
        #x = self.pooling(x) # for test
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
    threshold = (np.median(mean_train[0:n_pos]) + np.median(mean_train[n_pos:n_pos+n_neg]))/2
    
    ss_train = sum(mean_train[0:n_pos,0]>threshold)/n_pos
    sp_train = sum(mean_train[n_pos:n_pos+n_neg,0]<threshold)/n_neg
    
    train_error = 1-(ss_train+sp_train)/2
      
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
    
    error = 1-(ss+sp)/2
    
    return(train_error, error)
