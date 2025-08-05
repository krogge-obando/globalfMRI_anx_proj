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

## 💻: Code Info

Information on all the codes within our folder codes is located below:

**1. Conduct_Group_ICA**
 - fix_ICA_40.sh : code that was used to generate a group ICA analysis with 40 components
 - ICA_fix_paths.R : code to derive the text file used as an input in fix_ICA_40.sh

Note: we used manual inspection to identify which components were networks vs noise, for more information to conduct a group ICA analysis can be found on FSL's website ["here"](https://web.mit.edu/fsl_v5.0.10/fsl/doc/wiki/MELODIC.html).

**2. Derive_Main_Data**

- Obando_NKI_fMRIglobal_anx.m : a master code that derives the spatial and temporal data of our global fMRI components, conducts dual regression to derive network timeseries from our ICA components, functional connectivity pre and post global component regression on our networks of interest. Our code has comments to understand which sections derive certain components and below are functions we wrote needed to run the code. For questions feel free to contact me, my information is at the end of this repo.
  - create_hr_basis_dt.m : function code needed Obando_NKI_fMRIglobal_anx.m to derive the hr basis functions to model heart rate fluctuations in fMRI
  - regress_tc.m : function code needed Obando_NKI_fMRIglobal_anx.m to regress the global component form the networks time series
  - retrieve_fc_values: function code needed in Obando_NKI_fMRIglobal_anx.m to store functional connectivity measures after pre and post regression
   
- Obando_derive_sd_of_global_info.m : code that derives the estimated drowsiness value (standard deviation of the fMRI arousal template), and the variation of the global mean signal.
- Obando_lags_investigation.m : code that investigated if lags of global components significantly alter brain connectivity relationships to anxiety. (It did not)
  -generate_fmri_lags.m : function needed for Obando_lags_investigation.m that preforms lags of the global components
  -regress_tc_non_zscored.m: function that regresses the values similar to regress_tc but does not zscore the values in the function because they were previously zscored

**3. Conduct_Main_Analysis_Visulizations**

- Obando_nki_anx_global_analysis_fig.R : code that conducts the analysis to identify if estimated drowsines or GS_SD relates to state or trait anxiety. Also makes Figure 1) A & C in the paper.
- Obando_nki_multiple_regression_function_and_results.R : code that conducts the regression analysis comparing brain connectivity to state and trait anxiety (uncorrected results).
- FDR_analysis.R : code that conducts the fdr corrections for the results derived from Obando_nki_multiple_regression_function_and_results.R
- Obando_violinPlots_Manuscript.R: Codes to generate figure 2 B & C on the manuscript. Note data to run this is provided in data folder.
- Lee_Obando_histogramPlots.R: Codes to generate supplementary figure 3. 


   









