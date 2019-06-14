# Group_Learning
1. folder name: digit
Contians all scripts related to the experiments in the IJCNN paper ('Group Learning for High-Dimensional Sparse Data') as follows:
1. segmentation: generate digit segments (positive segments: 720 even digits & 80 digit '1', negative segments: 800 even digits)
2. featureExtraction: downsample each individual digit in segments from 28*28 to 14*14 and use the downsampling data as the new feature
3. loadData: split data as training, validation, and test
4. Experiment: predictive model estimation using training and validation data and predict the test data. (please save the whole work space manually)
5. postProcessing: group learning for the results of prediction i.e., generating prediction for each digit segment. 
