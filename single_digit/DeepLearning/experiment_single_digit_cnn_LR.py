# -*- coding: utf-8 -*-
"""
Created on Mon Jan 13 14:57:04 2020

@author: User
"""
if __name__ == '__main__':
    # test1.py executed as script
    # do something
    cnn_experiment_LR()

def cnn_experiment_LR(var):
    import tensorflow as tf
    from tensorflow.keras.layers import Dense, Flatten, Conv2D, MaxPool2D
    from tensorflow.keras import Model
    from load_mat_single_digit import x_train, y_train, x_test, y_test
    

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

    loss_object = tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True)

    optimizer = tf.keras.optimizers.Adam(learning_rate=var)

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
    ss = sum(y_pre[:500,0]<y_pre[0:500,1])/500
    sp = sum(y_pre[500:1000,0]>y_pre[500:1000,1])/500
    error = 1-(ss+sp)/2
    return(train_error, error)