# :brain: Global effects in fMRI reveal brain markers of anxiety project
Hello, this repo was created to provide the codes for conducting the analysis reported in the paper, ["Global effects in fMRI reveal brain markers of state and trait anxiety (Medirxn 2025)"](https://www.medrxiv.org/content/10.1101/2025.07.15.25331571v1#:~:text=Results%3A%20We%20observe%20that%20the,tied%20to%20the%20anxious%20experience.)

## ⭐ Highlights
This repo provides the code to derive:
- temporal and spatial data of the fMRI global components (global mean signal, fMRI arousal template, heart rate)
- functional connectivity of networks pre and post regression of global components
- main analysis conducted in the paper
- code to generate Figure 1 A & C, Figure 2B & C, and supplimentary Figure 2 of the paper.
- our nifti files of where state and trait anxiety related to the global mean signal and fMRI arousal template

## 🧭 Software used in this project

- FSL version 6.0.5.1

FSL is a neuroimaging software that was used to derive our network components thorugh its function *melodic* which conducts a group independent component analysis. We also used it to identify significant brain clusters that relate our global components using the function *fslrandomise*

- Matlab version 2024a

Matlab was used to derive the fMRI global components, correlates of the global components, and the functional connectivity of networks pre and post global component regression in the code *Obando_NKI_fMRIglobal_anx.m*

- Rstudio version RStudio/2024.12.0+467

Rstudio was used to conduct statistical analysis and visualizations to determine if temporal global components related to anxiety in code *Obando_GlobalComponents_Anxiety.R, and if any brain network connectivity measures related to anxiety pre and post global signal regression *Obando_Network_FC_pre_post_Regress.R*

## 📑 How to navigate the repo??

This repo was designed with two folders: 

1. codes: to see the code used to derive any of the things we stated in our *Highlights* go here, for key information of what the code does go to the section  *codes info*
2. data: due to our compliance with the Nathan Klein Institute Rockland we are unable to share the subjects state and trait anxiety scores. For this information please fill out their compliance documentation found ["here"](http://fcon_1000.projects.nitrc.org/indi/enhanced/sharing_phenotypic.html). The data we provide is our nifti files that show where state and trait relate to the strength of the expression of the global mean signal or fMRI arousal template.

##Code Info

Information on all the codes within our folder codes is located below:

1. Conduct_Group_ICA
Information to conduct a group analysis can be found on FSL's website ["here"] (https://web.mit.edu/fsl_v5.0.10/fsl/doc/wiki/MELODIC.html).
 - fix_ICA_40.sh : our code that was used to generate a group ICA analysis with 40 components
 - ICA_fix_paths.R : code to derive the text file used as an input in fix_ICA_40.sh
Note: we used manual inspection to identify which components were networks vs noise

2. Derive_Main_Data
We have a master code that derives the spatial and temporal data of our global fMRI components, conducts dual regression to derive network timeseries from our ICA components, functional connectivity pre and post global component regression on our networks of interest. Our code has comments to understand which sections derive certain components. For questions feel free to contact me, my information is at the end of this repo.
- 









