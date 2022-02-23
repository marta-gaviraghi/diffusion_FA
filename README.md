# diffusion_FA
Our deep learning network allows to map Fractional Anisotropy form a set of only 10 Diffusion Weighed volumes. See paper *DOI bla bla* for more details.

## you need

- Python3 (you need the following packages: natsort, tensorflow, scipy, numpy)

- Matlab

For the compatibility between the Python and Matlab version see https://www.mathworks.com/content/dam/mathworks/mathworks-dot-com/support/sysreq/files/python-compatibility.pdf


INPUT TO DEFINE
path -> define the path and use ''
file all nifi -> nii.gz estension indicate the name without the extention


``` git clone git@github.com:marta-gaviraghi/diffusion_FA.git ```

``` python3 main_python.py 'path_dir' 'path_to_down' 'dwi_10' ```

if you have the brain mask you can give it as input

``` python3 main_python.py 'path_dir' 'path_to_down' 'dwi_10' 'brain_mask' ```

where the arg input are:

MANDATORY INPUTS:

a) path_dir = 'path to the folder that contains the directory of each subject or a dirctory of subject'

b) path_to_down =  'path in where you clone the repository'

c) dwi_10 = 'name of the nifti of the 10 DW volumes'

OPTIONAL

d) brain_mask = 'name of the brain mask'
