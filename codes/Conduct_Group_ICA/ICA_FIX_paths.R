
#This code will derive the paths input needed to conduct a melodic group ICA

#load data frame (df) that has the name of the subjects
#redundant comment
df <-read.csv("/Users/roggeokk/Desktop/Projects/nki_anx_vig_proj/nki_data/nki_df_vig_img_stai_groups_mastr.csv")

#select a randome sample of 50 subject for group ICA

df_ica<-sample(df$ID, 50)

df_ica <-as.data.frame(df_ica)

#main file path where the fMRI nifti file is located
#redundant comment
file_path-> c('/data1/neurdylab/datasets/nki_rockland/fix_ica/sub-A00028150/fix_ants_out')

for (x in df_ica)

  
{paths<-paste('/data1/neurdylab/datasets/nki_rockland/fix_ica/',x,'/fix_ants_out/',x,'_ses-BAS1_task-rest_acq-1400_bold_mo_FIX_EPI2MNI_sm_nr.nii.gz',sep="")

 print(paths)}

paths_df<-as.data.frame(paths)

#save file as a csv and text file. FSL takes the text file
write.csv(paths_df,"/Users/roggeokk/Desktop/Projects/nki_anx_vig_proj/nki_data/fix_ica_path_list.csv")

write.table(paths_df,file="/Users/roggeokk/Desktop/Projects/nki_anx_vig_proj/nki_data/fix_ica_path_list.txt", sep = "\t", row.names= FALSE, col.names = FALSE,quote = FALSE)


