# -*- coding: utf-8 -*-
"""
Created on Mon Jan 13 14:57:04 2020
    
@author: User

"""
    
#if __name__ == '__main__':
    # test1.py executed as script
    # do something
#    exp()

    #gs = 20 # group size
#    n_pos = int(x_train.shape[0]/2)
#    n_neg = int(x_train.shape[0]/2)
#    n_pos_tst = int(x_test.shape[0]/2)
#    n_neg_tst = int(x_test.shape[0]/2)
#    
#    [x_train, y_train, gn] = GoupData(x_train, gs, n_pos, n_neg)
#    [x_test, y_test, gn] = GoupData(x_test, gs, n_pos_tst, n_neg_tst)

def GoupData(data, gs, n_pos, n_neg):
    import numpy as np
    sw = 30
    #GL data preprocessing
    rn = int(np.ceil((160-gs)/sw))
    cn = rn
    #data_temp = np.zeros(shape=(x_train.shape[0], gs, gs*gn,1))
    data_GL = np.zeros(shape=(int(data.shape[0]*rn*cn), gs, gs))
    k = 0
    for i in range(data.shape[0]):
        for j in range(rn):
            for q in range(cn): 
                data_GL[k] = data[i][(j*sw):(j*sw+gs),q*sw:(q*sw+gs)]
                k = k+1
    label_GL = np.concatenate((np.ones([n_pos*cn*rn,1]),np.zeros([n_neg*cn*rn,1])), axis = 0)
    return (data_GL, label_GL, cn*rn)


def exp(x_train, y_train, x_test, y_test,lr):
    import tensorflow as tf
    from tensorflow.keras.layers import Dense, Flatten, Conv2D, MaxPool2D
    from tensorflow.keras import Model
    #from load_mat_single_digit import x_train, y_train, x_test, y_test
    

    #mnist = tf.keras.datasets.mnist

    #(x_train, y_train), (x_test, y_test) = mnist.load_data()
    #x_train, x_test = x_train / 255.0, x_test / 255.0

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

    loss_object = tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True) #used in the tutorial
    
    optimizer = tf.keras.optimizers.Adam(learning_rate=lr)

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
    ss_train = sum(y_pre_train[0:int(y_pre_train.shape[0]/2),0]<y_pre_train[0:int(y_pre_train.shape[0]/2),1])/int(y_pre_train.shape[0]/2)
    sp_train = sum(y_pre_train[int(y_pre_train.shape[0]/2):y_pre_train.shape[0],0]>y_pre_train[int(y_pre_train.shape[0]/2):y_pre_train.shape[0],1])/int(y_pre_train.shape[0]/2)

    train_error = 1-(ss_train+sp_train)/2

    y_pre = model(x_test).numpy()
    #ss = sum(y_pre[:500,0]<y_pre[0:500,1])/500
    #sp = sum(y_pre[500:1000,0]>y_pre[500:1000,1])/500
    ss = sum(y_pre[0:int(y_pre.shape[0]/2),0]<y_pre[0:int(y_pre.shape[0]/2),1])/int(y_pre.shape[0]/2)
    sp = sum(y_pre[int(y_pre.shape[0]/2):y_pre.shape[0],0]>y_pre[int(y_pre.shape[0]/2):y_pre.shape[0],1])/int(y_pre.shape[0]/2)
  
    error = 1-(ss+sp)/2
    return(train_error, error, y_pre_train, y_pre)

def cv(x_train, y_train, x_val, y_val,para):
    import numpy as np
    validation_error = np.zeros([1, len(para)]) 
    for n in range(len(para)):
        [train_error,val_error, y_pre_train, y_pre_val] = exp(x_train, y_train, x_val, y_val, para[n])
        validation_error[0,n] =  val_error
    
    opt_index = np.where(validation_error == validation_error.min())
    opt_para = para[opt_index[1][-1]]
    return(opt_para,validation_error)

def post_adapt(y_pre_train,n_pos,n_neg,gn, y_pre):
    import numpy as np
    
    output_train = np.zeros([y_pre_train.shape[0],1])
    for n in range(y_pre_train.shape[0]):
        if y_pre_train[n,0] > y_pre_train[n,1]:
            output_train[n,0] = y_pre_train[n,0]
        else:
            output_train[n,0] = y_pre_train[n,1]
    
    mean_train = np.zeros([int(output_train.shape[0]/gn),1])
    for n in range(int(output_train.shape[0]/gn)):
        mean_train[n,0] = np.mean(output_train[n*gn:(n+1)*gn])
    
    #threshold = (np.mean(mean_train[0:n_pos]) + np.mean(mean_train[n_pos:n_pos+n_neg]))/2
    #threshold = (np.min(mean_train[0:n_pos]) + np.max(mean_train[n_pos:n_pos+n_neg]))/2
    #threshold = (np.median(mean_train[0:n_pos]) + np.median(mean_train[n_pos:n_pos+n_neg]))/2  #the one for digits
    #threshold = (np.mean(mean_train[0:n_pos]) + np.mean(mean_train[n_pos:n_pos+n_neg]))/2
    threshold = 0;
    
    ss_train = sum(mean_train[0:n_pos,0]>threshold)/n_pos
    sp_train = sum(mean_train[n_pos:n_pos+n_neg,0]<threshold)/n_neg
    
    train_error = 1-(ss_train+sp_train)/2
    
    output_test = np.zeros([y_pre.shape[0],1])
    for n in range(y_pre.shape[0]):
        if y_pre[n,0] > y_pre[n,1]:
            output_test[n,0] = -abs(y_pre[n,0])
        else:
            output_test[n,0] = abs(y_pre[n,1])
            
    mean_test = np.zeros([int(output_test.shape[0]/gn),1])
    for n in range(int(output_test.shape[0]/gn)):
        mean_test[n,0] = np.mean(output_test[n*gn:(n+1)*gn])
    
    number_samples_class = int(mean_test.shape[0]/2)
        
    ss = sum(mean_test[0:number_samples_class,0]>threshold)/number_samples_class
    sp = sum(mean_test[number_samples_class:number_samples_class*2,0]<threshold)/number_samples_class

    error = 1-(ss+sp)/2   
    
    return(train_error, error)

def post_MV(y_pre_train,n_pos,n_neg,gn, y_pre):
    import numpy as np
    
    output_train = np.zeros([y_pre_train.shape[0],1])
    for n in range(y_pre_train.shape[0]):
        if y_pre_train[n,0] > y_pre_train[n,1]:
            output_train[n,0] = -y_pre_train[n,0]
        else:
            output_train[n,0] = y_pre_train[n,1]
    
    pred_train = np.zeros([int(output_train.shape[0]/gn),1])
    for n in range(int(output_train.shape[0]/gn)):
        if sum(output_train[n*gn:(n+1)*gn] > 0) > (gn/2):
            pred_train[n,0] = 1
        elif sum(output_train[n*gn:(n+1)*gn] > 0) == (gn/2):
            pred_train[n,0] = np.random.permutation(2)[0]
        else:
            pred_train[n,0] = 0
           
    ss_train = sum(pred_train[0:n_pos,0] == 1)/n_pos
    sp_train = sum(pred_train[n_pos:n_pos+n_neg,0]==0)/n_neg
    
    train_error = 1-(ss_train+sp_train)/2
    
    output_test = np.zeros([y_pre.shape[0],1])
    for n in range(y_pre.shape[0]):
        if y_pre[n,0] > y_pre[n,1]:
            output_test[n,0] = -y_pre[n,0]
        else:
            output_test[n,0] = y_pre[n,1]
            
    pred_test = np.zeros([int(output_test.shape[0]/gn),1])
    for n in range(int(output_test.shape[0]/gn)):
        if sum(output_test[n*gn:(n+1)*gn] > 0) > (gn/2):
            pred_test[n,0] = 1
        elif sum(output_test[n*gn:(n+1)*gn] > 0) == (gn/2):
            pred_test[n,0] = np.random.permutation(2)[0]
        else:
            pred_test[n,0] = 0
        
    number_samples_class = int(pred_test.shape[0]/2)
        
    ss = sum(pred_test[0:number_samples_class,0]==1)/number_samples_class
    sp = sum(pred_test[number_samples_class:number_samples_class*2,0]==0)/number_samples_class
    
    error = 1-(ss+sp)/2
    
    return(train_error, error)