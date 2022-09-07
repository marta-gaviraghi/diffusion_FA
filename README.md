# diffusion_FA
Our deep learning network allows to map Fractional Anisotropy form a set of only 10 Diffusion Weighed volumes.

Give your 10 diffusion weighed images and obtein the FA!!

For all details check the paper: network for fractional anisotropy reconstruction "A generalized deep learning network for fractional anisotropy reconstruction : Application to epilepsy and multiple sclerosis" (Gaviraghi et al, 2022)
https://doi.org/10.3389/fninf.2022.891234

## you need

- Python3 (you need the following packages: natsort, tensorflow, keras, scipy, numpy)

- Matlab

For the compatibility between the Python and Matlab version see https://www.mathworks.com/content/dam/mathworks/mathworks-dot-com/support/sysreq/files/python-compatibility.pdf

Open a terminal and navigate in the foldere where you want work ('path_to_down'). 

Clone the code in your 'path_to_down'

```
git clone git@github.com:marta-gaviraghi/diffusion_FA.git
```
Give your 10 diffusion weighet images and wait ... 

```
python3 main_python.py 'path_dir' 'path_to_down' 'dwi_10'
```

if you have the brain mask you can give it as input

```
python3 main_python.py 'path_dir' 'path_to_down' 'dwi_10' 'brain_mask'
```

where the input are:

MANDATORY INPUTS:

- path_dir = 'path to the folder that contains the directory of each subject or a dirctory of subject'
- path_to_down =  'path in where you clone the repository'
- dwi_10 = 'name of the nifti of the 10 DW volumes'

OPTIONAL

- brain_mask = 'name of the brain mask'

Remember to define your path and name of fie between the single comma and that for your name file you don't indicate the extention .nii.gz
