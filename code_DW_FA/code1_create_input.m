%path_dir = '/media/bcc/Volume/MARTA/TLE_all/HC'
%% INPUT
% Marta Gaviraghi

%path_dir = path to the folder that contains the directory of each subject
%path_to_down = path in where you clone the repository
%dwi_10 = 'name file nifti'

function [] = code1_create_input(path_dir, path_to_down, dwi_10, brain_mask)

cd(path_dir)

folderContents = dir;
folderContents(1:2)=[];

for k=1:length(folderContents)
    if folderContents(k).isdir
        myFolder = fullfile(pwd, folderContents(k).name);
        cd (myFolder);

        if nargin == 3
            disp('No image for mask brain -> creating the brain mask...')
            unix(horzcat('gunzip ', dwi_10, '.nii.gz'));

            DWI_struct = load_untouch_nii(strcat(dwi_10,'.nii'));
            DWI = DWI_struct.img;
            unix(horzcat('gzip ', dwi_10, '.nii'));
            unix(horzcat('bet ', dwi_10,' brain -F'));
            !gunzip brain_mask.nii.gz
            mask_struct = load_untouch_nii('brain_mask.nii');
            mask = mask_struct.img;
            !gzip brain_mask.nii

        elseif nargin == 4
            unix(horzcat('gunzip ', brain_mask, '.nii.gz'));
            mask_struct = load_untouch_nii(strcat(brain_mask,'.nii'));
            mask = mask_struct.img;
            unix(horzcat('gzip ', brain_mask, '.nii'));
        else
            disp('ERROR number input');
            break
        end

        %% 1) NORMALIZE THE INPUT
        % load the 10 DWI and the brain mask
        unix(horzcat('gunzip ', dwi_10, '.nii.gz'));
        DWI_struct = load_untouch_nii(strcat(dwi_10,'.nii'));
        DWI = DWI_struct.img;
        unix(horzcat('gzip ', dwi_10, '.nii'));

        % resampling to HCP resolution
        DWI_v_vect = DWI(:);
        DWI_v_vect = double(DWI_v_vect);
        mean_DWI_v = mean(DWI_v_vect);
        std_DWI_v = std(DWI_v_vect);
        DWI_v_vet = (DWI_v_vect - mean_DWI_v)./std_DWI_v;

        new_10_n = reshape(DWI_v_vet, size(DWI,1), size(DWI,2), size(DWI,3), size(DWI,4));

        mask = double(mask);

        %put the background to zeros
        for v = 1: size(new_10_n,4)
            DWI_bm(:,:,:,v) = mask.*new_10_n(:,:,:,v);
        end

        DWI_new_struct = DWI_struct;
        save_untouch_nii(DWI_new_struct, 'DWI_10_norm.nii');
        !gzip DWI_10_norm.nii -f

        !fslsplit DWI_10_norm
    
        unix(horzcat('/usr/share/fsl/6.0/bin/flirt -in ' , myFolder, '/vol0000.nii.gz -ref ' , path_to_down, '/b0_HCP_ref.nii.gz -out ', myFolder, '/b0_125.nii.gz -omat ', myFolder, '/matrix_b0_125.mat -bins 256 -cost normmi -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp sinc -sincwidth 7 -sincwindow hanning'));


        vol = sprintf('%04d ', 1:9);
        vols = strsplit(vol);


        for i=1:9%10
            unix(horzcat('/usr/share/fsl/6.0/bin/flirt -in ' , myFolder, '/vol', vols{i}, '.nii.gz -applyxfm -init ', myFolder, '/matrix_b0_125.mat -out ', myFolder, '/DWI_125_', vols{i}, '.nii.gz -paddingsize 0.0 -interp sinc -sincwidth 7 -sincwindow hanning -ref ' , path_to_down, '/b0_HCP_ref.nii.gz'));
        end

        !fslmerge -t DWI9_125.nii.gz DWI_125_*.nii.gz
        !fslmerge -t DWI_125.nii.gz b0_125.nii.gz DWI9_125.nii.gz

        !gunzip DWI_125.nii.gz
        DWI_125_struct = load_untouch_nii('DWI_125.nii');
        DWI_125 = DWI_125_struct.img;
        !gzip DWI_125.nii

        !rm DWI_125_00*
        !rm vol00*
        %1) crop
        DWI_125 = DWI_125(5:132, 8:167, :, :);

        %2) group by slice
        new = zeros(size(DWI_125,1),size(DWI_125,2),size(DWI_125,4), size(DWI_125,3));

        for x=1:size(new,1)
            for y=1:size(new,2)
                for z=1:size(new,3)
                    for v=1:size(new,4)
                        new(x,y,z,v)= DWI_125(x,y,v,z);
                    end
                end
            end
        end

        %% 3) crate input for NETWORK in format .mat

        cd(path_to_down)
        mkdir('input_net')
        cd('input_net')

        disp('create input for network!!!')    

        for slice=1:size(new,4)
            input_DWI = new(:,:,:,slice);
            save(sprintf('DWIs_%d_%d.mat',k, slice), 'input_DWI');         
        end
    end
    cd(path_dir)
end

