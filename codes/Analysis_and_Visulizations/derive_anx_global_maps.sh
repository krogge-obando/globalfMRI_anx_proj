# sh code we used to derive the brain maps associated with state anxiety. Please refer to code derive4Dmaps.m to see how we made our arousal_map_543_subj.nii file.

randomise -i /data1/neurdylab/datasets/nki_rockland/vigilance_analysis/arousal_map_543_subj.nii  -o /data1/neurdylab/datasets/nki_rockland/vigilance_analysis/fslrandomise_5000/state_543_arousal_randomise_output -d state_model.mat -t contrast.con -m /data1/neurdylab/MNI152_T1_2mm_brain_mask_filled.nii.gz -n 5000 -T -D  
