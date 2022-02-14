%% MAIN CODE: 10 DW to FA
% Marta Gaviraghi
%--------------------------------------------------------------------------

%% INPUT TO DEFINE
% path -> define the path and use '' 
% file all nifi -> nii.gz estension indicate the name without the extention

% MANDATORY INPUTS:
% a) path_dir = 'path to the folder that contains the directory of each 
%                subject or a dirctory of subject'
% b) path_to_down =  'path to the download directory'
% c) path_work = 'path in where working and create the output'
% d) dwi_10 = 'name of the nifti of the 10 DW volumes'
%
% OPTIONAL
% e) brain_mask = 'name of the brain mask'

%--------------------------------------------------------------------------
%% example!!
% change these INPUTS with your data and path!!
%path_dir = '/media/bcc/Volume/MARTA/DWI2FA/soggetto';
%path_to_down = '/media/bcc/Volume/MARTA/DWI2FA/git';

%path_work = '/media/bcc/Volume/MARTA/DWI2FA/git/input_mat/';

%dwi_10 = 'DWI_10_camino_new';
%brain_mask = 'brain_mask';
%--------------------------------------------------------------------------

%% 1) code for create the inputs to the network
cd(path_to_down)
code1_create_input(path_dir, path_to_down, path_work, dwi_10)


%% 2) pass your inputs to the network and save the the ouput
cd(path_to_down)
%!python3 from code2_calcolate_output2.py import load_net
unix(horzcat('python3 code2_load_fun.py ' , path_to_down, ' ', path_work));


%% 3) convert your output in files nifti
cd(path_to_down)
code3_output_nifti(path_dir, path_to_down)

