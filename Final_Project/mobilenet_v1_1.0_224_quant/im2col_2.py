import os
import sys
import numpy as np
import tensorflow as tf
import time
import matplotlib.pyplot as plt

from PIL import Image
from glob import glob

import utils
'''
MobileNet is a general architecture and can be used for multiple use cases.
Depending on the use case, it can use different input layer size and different
head (for example: embeddings, localization and classification).
As described in https://arxiv.org/abs/1704.04861.
  MobileNets: Efficient Convolutional Neural Networks for
    Mobile Vision Applications
  Andrew G. Howard, Menglong Zhu, Bo Chen, Dmitry Kalenichenko, Weijun Wang,
    Tobias Weyand, Marco Andreetto, Hartwig Adam
100% Mobilenet V1 (base) with input size 224x224:
See mobilenet_v1()
Layer                                                     params           macs
--------------------------------------------------------------------------------
MobilenetV1/Conv2d_0/Conv2D:                                 864      10,838,016
MobilenetV1/Conv2d_1_depthwise/depthwise:                    288       3,612,672
MobilenetV1/Conv2d_1_pointwise/Conv2D:                     2,048      25,690,112
MobilenetV1/Conv2d_2_depthwise/depthwise:                    576       1,806,336
MobilenetV1/Conv2d_2_pointwise/Conv2D:                     8,192      25,690,112
MobilenetV1/Conv2d_3_depthwise/depthwise:                  1,152       3,612,672
MobilenetV1/Conv2d_3_pointwise/Conv2D:                    16,384      51,380,224
MobilenetV1/Conv2d_4_depthwise/depthwise:                  1,152         903,168
MobilenetV1/Conv2d_4_pointwise/Conv2D:                    32,768      25,690,112
MobilenetV1/Conv2d_5_depthwise/depthwise:                  2,304       1,806,336
MobilenetV1/Conv2d_5_pointwise/Conv2D:                    65,536      51,380,224
MobilenetV1/Conv2d_6_depthwise/depthwise:                  2,304         451,584
MobilenetV1/Conv2d_6_pointwise/Conv2D:                   131,072      25,690,112
MobilenetV1/Conv2d_7_depthwise/depthwise:                  4,608         903,168
MobilenetV1/Conv2d_7_pointwise/Conv2D:                   262,144      51,380,224
MobilenetV1/Conv2d_8_depthwise/depthwise:                  4,608         903,168
MobilenetV1/Conv2d_8_pointwise/Conv2D:                   262,144      51,380,224
MobilenetV1/Conv2d_9_depthwise/depthwise:                  4,608         903,168
MobilenetV1/Conv2d_9_pointwise/Conv2D:                   262,144      51,380,224
MobilenetV1/Conv2d_10_depthwise/depthwise:                 4,608         903,168
MobilenetV1/Conv2d_10_pointwise/Conv2D:                  262,144      51,380,224
MobilenetV1/Conv2d_11_depthwise/depthwise:                 4,608         903,168
MobilenetV1/Conv2d_11_pointwise/Conv2D:                  262,144      51,380,224
MobilenetV1/Conv2d_12_depthwise/depthwise:                 4,608         225,792
MobilenetV1/Conv2d_12_pointwise/Conv2D:                  524,288      25,690,112
MobilenetV1/Conv2d_13_depthwise/depthwise:                 9,216         451,584
MobilenetV1/Conv2d_13_pointwise/Conv2D:                1,048,576      51,380,224
--------------------------------------------------------------------------------
Total:                                                 3,185,088     567,716,352
'''
def im2col(image, ksize, stride):
    # image is a 4d tensor([batchsize, width ,height, channel])
    image_col = []
    for i in range(0, image.shape[1] - ksize + 1, stride):
        for j in range(0, image.shape[2] - ksize + 1, stride):
            col = image[:, i:i + ksize, j:j + ksize, :].reshape([-1])
            image_col.append(col)
    image_col = np.array(image_col)
    return image_col

print("Tensorflow", tf.__version__)
print("Python", sys.version)

model_name = 'mobilenet_v1_1.0_224_quant.tflite'

interpreter = tf.lite.Interpreter(model_path=model_name)
                                          
interpreter.allocate_tensors()

input_details = interpreter.get_input_details()
print(input_details[0])

tensor_details = interpreter.get_tensor_details()

id = 0
for tensor_detail in tensor_details:
    if tensor_detail['name'] == 'MobilenetV1/MobilenetV1/Conv2d_0/weights_quant/FakeQuantWithMinMaxVars':
        id = tensor_detail['index']

kernal = interpreter.get_tensor(id)
print('kernal shape:')
print(kernal.shape)
print(kernal)
image = Image.open('test.jpg')
img_nopad = np.array(image)[np.newaxis, :]
img = np.pad(img_nopad, ((0, 0),(1, 1), (1, 1), (0, 0)), 'constant', constant_values=0)
print('image shape:')
print(img.shape)
print(img.transpose(0, 3, 1, 2).shape)
#np.savetxt('imagetxt', img.transpose(0, 3, 1, 2).reshape())

featuremap_matrix = im2col(img, 3, 2).T
print('Get im2col Matrix:')
print(featuremap_matrix)
print('im2col Matrix Shape:')
print(featuremap_matrix.shape)
#np.savetxt('featuremap_matrix_txt', featuremap_matrix)

col_kernal = kernal.reshape(32, -1)
print(col_kernal)
out = np.dot(col_kernal, featuremap_matrix)
np.savetxt('col_featuremap_B.txt', featuremap_matrix, fmt='%d')
np.savetxt('col_kernal_B.txt', col_kernal, fmt='%d')
np.savetxt('out_txt_B.txt', out, fmt='%d')
print('Multiplication Shape:')
print(out.shape)
out = out.reshape(1, 112, 112, 32)
print('out shape:')
print(out.shape)
print('col2im tensor:')
print(out)
#np.savetxt('out_txt', out)
#img_matrix = tf.extract_image_patches(img, [32, 3, 3, 3], [1, 2, 2, 1], [1, 1, 1, 1], padding='SAME')

#actual = tf.reduce_sum(tf.multiply(img_matrix, tf.reshape(kernal, [27])), 3, keep_dims=True)
expected = tf.nn.conv2d(tf.to_float(img_nopad), tf.to_float(kernal.transpose(1, 2, 3, 0)), strides=[1, 2, 2, 1], padding='SAME')
print(expected)

with tf.Session() as sess:
    print(sess.run(expected))
