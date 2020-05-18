import os
import sys
import numpy as np
import tensorflow as tf
import time
import matplotlib.pyplot as plt
from time import time
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

def im2col(input_data, filter_h, filter_w, stride=1, pad=0):
    """
    Parameters
    ----------
    input_data : 由(数据量, 通道, 高, 长)的4维数组构成的输入数据
    filter_h : 卷积核的高
    filter_w : 卷积核的长
    stride : 步幅
    pad : 填充

    Returns
    -------
    col : 2维数组
    """
    # 输入数据的形状
    # N：批数目，C：通道数，H：输入数据高，W：输入数据长
    N, C, H, W = input_data.shape  
    out_h = (H + 2*pad - filter_h)//stride + 1  # 输出数据的高
    out_w = (W + 2*pad - filter_w)//stride + 1  # 输出数据的长
    # 填充 H,W
    #img = np.pad(input_data, [(0,0), (0,0), (pad, pad), (pad, pad)], 'constant')
    img = np.pad(input_data, [(0,0), (0,0), (pad, pad), (pad, pad)], 'constant')
    # (N, C, filter_h, filter_w, out_h, out_w)的0矩阵
    col = np.zeros((N, C, filter_h, filter_w, out_h, out_w))
    
    for y in range(filter_h):
        y_max = y + stride*out_h
        for x in range(filter_w):
            x_max = x + stride*out_w
            col[:, :, y, x, :, :] = img[:, :, y:y_max:stride, x:x_max:stride]
    # 按(0, 4, 5, 1, 2, 3)顺序，交换col的列，然后改变形状
    col = col.transpose(0, 4, 5, 1, 2, 3).reshape(N*out_h*out_w, -1)
    return col

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
image = Image.open('test.jpg')
img = np.array(image)[np.newaxis, :, :, :]
print('image shape:')
print(img.shape)
#print(img.transpose(0, 3, 1, 2).shape)
#np.savetxt('imagetxt', img.transpose(0, 3, 1, 2).reshape())

featuremap_matrix = im2col(img.transpose(0, 3, 1, 2), 3, 3, 2, 1).T
#print('Get im2col Matrix:')
#print(featuremap_matrix)
print('im2col matrix shape:')
print(featuremap_matrix.shape)
#np.savetxt('featuremap_matrix_txt', featuremap_matrix)

col_kernal = kernal.reshape(32, -1)
print('kernel matrix shape:')
print(kernal.reshape(32, -1).shape)
start = time()
out = np.dot(col_kernal, featuremap_matrix)
stop = time()
print('convolution result matrix Shape:')
print(out.shape)
np.savetxt('col_featuremap.txt', featuremap_matrix, fmt='%d')
np.savetxt('col_kernal.txt', col_kernal, fmt='%d')
np.savetxt('out_txt.txt', out, fmt='%d')
out = out.reshape(32, 112, 112, -1).transpose(3, 1, 2, 0)
print('out shape:')
print(out.shape)
print("Start: " + str(start))
print("Stop: " + str(stop))
print("Mulplication Calculation Time:" +str (stop-start))
#print('col2im tensor:')
#print(out)
#img_matrix = tf.extract_image_patches(img, [32, 3, 3, 3], [1, 2, 2, 1], [1, 1, 1, 1], padding='SAME')

#https://zhuanlan.zhihu.com/p/33773140
#https://blog.csdn.net/Daycym/article/details/83826222

#actual = tf.reduce_sum(tf.multiply(img_matrix, tf.reshape(kernal, [27])), 3, keep_dims=True)
expected = tf.nn.conv2d(tf.to_float(img), tf.to_float(kernal.transpose(1, 2, 3, 0)), strides=[1, 2, 2, 1], padding='SAME')
#print(expected)

with tf.Session() as sess:
    start = time()
    sess.run(expected)
    stop = time()
    print("Convolution Calculation Time:" +str (stop-start))
