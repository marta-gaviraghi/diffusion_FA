# MAIN CODE: 10 DW to FA
# Marta Gaviraghi
#--------------------------------------------------------------------------
import os
from tensorflow import keras
import natsort
import scipy.io
import numpy as np
from keras import backend as K
import sys

import matlab.engine
# INPUT TO DEFINE
# path -> define the path and use ''
# file all nifi -> nii.gz estension indicate the name without the extention

# MANDATORY INPUTS:
# a) path_dir = 'path to the folder that contains the directory of each
#                subject or a dirctory of subject'
# b) path_to_down =  'path in where you clone the repository'
# c) dwi_10 = 'name of the nifti of the 10 DW volumes'

# OPTIONAL
# d) brain_mask = 'name of the brain mask'

#--------------------------------------------------------------------------
## example!!
# change these INPUTS with your data and path!!
##python3 main_python.py '/media/bcc/Volume/MARTA/DWI2FA/soggetto' '/home/bcc/dw_fa/code_DW_FA' 'DWI_10_camino_new'

path_dir = sys.argv[1]
path_to_down = sys.argv[2]
dwi_10 = sys.argv[3]

#%--------------------------------------------------------------------------

## 1) code for create the inputs to the network
os.chdir(path_to_down)

eng = matlab.engine.start_matlab()
eng.cd(path_to_down)
#eng.cd('/home/bcc/dw_fa/code_ok')
print(os.getcwd())
#eng.run("code1_create_input.m", path_dir, path_to_down, path_work, dwi_10, nargout=0)
#dynamic = code1_create_input(eng, path_dir, path_to_down, path_work, dwi_10)
#dynamic(nargout=3)
eng.code1_create_input(path_dir, path_to_down, dwi_10, nargout=0)
eng.quit()


## 2) pass your inputs to the network and save the the ouput
os.chdir(path_to_down)
from code2_calcolate_output import load_net
load_net(path_to_down);

#from code2_calcolate_output.py import load_net
#code2_load_fun(path_to_down, path_work);


## 3) convert your output in files nifti
os.chdir(path_to_down)
eng = matlab.engine.start_matlab()
eng.code3_output_nifti(path_dir, path_to_down, nargout=0)
