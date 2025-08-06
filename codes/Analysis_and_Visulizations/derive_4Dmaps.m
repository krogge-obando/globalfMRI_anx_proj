%This code will be a function that derives 4D nifti file, v1 v2 v3 are
%voxel dimensions of original nifti data

function nifti_map = derive_4Dmaps(file,file_name,brainVox,mask_info,v1,v2,v3)

for i=1:height(file)
    stai_sub = file(i,:);
    spatial_map = zeros(v1,v2,v3);
    spatial_map(brainVox)=stai_sub;
    stai_spatial_map_sub(:,:,:,i)=[spatial_map];
end

niftiwrite(stai_spatial_map_sub,file_name,mask_info);

end


