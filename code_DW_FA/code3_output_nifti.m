%% calcolo MSE tra output desiderato e output reale for TLE

function [] = code3_output_nifti(path_dir, path_to_down)

cd(path_to_down)

%% load data output for tle
%load('all_output_6.mat');
load('vector_output.mat');
%carico fa ricampionata alla risoluzione degli HCP ecrop 128x128x128
%cd /home/bcc/Documents/Analysis/MARTA/TLE/
cd(path_to_down)

!gunzip fa_HCP_ref.nii.gz
fa_HCP_struct = load_untouch_nii('fa_HCP_ref.nii');
fa_HCP = fa_HCP_struct.img;
!gzip fa_HCP_ref.nii

cd(path_dir);
folderContents = dir;
folderContents(1:2)=[];

%1:70
for sog=1:length(folderContents)
    if folderContents(sog).isdir
        myFolder = fullfile(pwd, folderContents(sog).name);
        cd (myFolder);
        s = sog;
        %output1 = vect(((s-1)*128+1):s*128, :, :);
        %no crop on slice
        output1 = vect(((s-1)*145+1):s*145, :, :);
        new = zeros(size(output1,2),size(output1,3),size(output1,1));
        
        for i=1:size(new,1)
            for j=1:size(new,2)
                for k=1:size(new,3)
                    new(i,j,k)= output1(k,i,j)';
                end
            end
        end

        fa_ric2_struct = fa_HCP_struct;
        new2 = zeros(145, 174, 145);
        %new2(5:132, 27:154, :)=new;
        new2(5:132, 8:167, :) = new;
        fa_ric2_struct.img = new2;
       
        %fa ricostruita alla risoluzione dei tle
        save_untouch_nii(fa_ric2_struct, 'fa_ric.nii');

        %% ATTENZIONE AI NOMI DELLE MATRICI!!
        %calculate inverse matrix -> for return to original dimension
        unix(horzcat('/usr/share/fsl/6.0/bin/convert_xfm -omat ', myFolder,'/matrix_b0_125_inv.mat -inverse ', myFolder,'/matrix_b0_125.mat'));
        
        %fa in original dimension
        unix(horzcat('/usr/share/fsl/6.0/bin/flirt -in ' , myFolder, '/fa_ric.nii -applyxfm -init ', myFolder, '/matrix_b0_125_inv.mat -out ', myFolder, '/fa.nii.gz -paddingsize 0.0 -interp nearestneighbour -ref ' ,myFolder, '/DWI_10_camino_new.nii.gz'));
        fprintf('save nifti for subject %d number\n', sog)

    end
    cd(path_dir)
end
end
