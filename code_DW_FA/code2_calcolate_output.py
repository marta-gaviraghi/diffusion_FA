import os
from tensorflow import keras
import natsort
import scipy.io
import numpy as np

def my_loss(y_true, y_pred):
	SSIM = tf.image.ssim(y_true, y_pred, max_val=1)
	return K.sqrt(K.mean(K.square(y_pred - y_true)))+(1-SSIM)/2

def root_mean_squared_error(y_true, y_pred):
        return K.sqrt(K.mean(K.square(y_pred - y_true)))

def load_net(path_to_down):

	os.chdir(path_to_down)
	#os.chdir("/media/bcc/Volume/MARTA/u_net/y_tilde/gen128_160_0/")
	model = keras.models.load_model('unet_0.hdf5', custom_objects={'my_loss': my_loss, 'root_mean_squared_error': root_mean_squared_error})

	#inputDir = "/media/bcc/Volume/MARTA/MS/matrici_new/input/part2/"
	n_x = 128
	n_y = 160
	n_v = 10
	#load INPUT
	#inputDir = "C://marta//uni/dottorato//DWI_maps//u-net//prova_save_load//u-net_prova//test//input//"
	DWIs = []
	
	os.chdir(path_to_down)
	os.chdir('input_net')
	
	inputDir = os.getcwd()

	for files in natsort.natsorted(os.listdir(inputDir)):
		DWIs.append(scipy.io.loadmat(inputDir+ '/' + files))

	x_val = np.zeros((len(DWIs), n_x, n_y, n_v))

	for i in range(0, len(DWIs)-1):
		x_val[i]=DWIs[i]['input_DWI']

	#salvo matrice
	#os.mkdir("/media/bcc/Volume/MARTA/MS/matrici_new/output/")
	#os.chdir("/media/bcc/Volume/MARTA/MS/matrici_new/output/")
	os.chdir(path_to_down)

	y_tilde_val = model.predict(x_val)
	scipy.io.savemat('vector_output.mat', {'vect':y_tilde_val})
	print('output of the network saved')
	print(y_tilde_val.shape)
	
#load_net('/home/bcc/dw_fa/code_ok/', '/media/bcc/Volume/MARTA/DWI2FA/git/input_mat/')

#path_to_network = input("enter the path to the network")
#inputDir = input("enter the path to the mat files")

#load_net(path_to_network, inputDir)
