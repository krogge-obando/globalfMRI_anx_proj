# :brain: Global effects in fMRI reveal brain markers of anxiety project
Hello, this repo was created to provide the codes for conducting the analysis reported in the paper, ["Global effects in fMRI reveal brain markers of state and trait anxiety (Medirxn 2025)"](https://www.medrxiv.org/content/10.1101/2025.07.15.25331571v1#:~:text=Results%3A%20We%20observe%20that%20the,tied%20to%20the%20anxious%20experience.)  

Update: We have provided codes used in the manuscript accepted at Cerebral Cortex that can be read ["here"](https://academic.oup.com/cercor/article/36/2/bhag008/8488885)

## ⭐ Highlights
This repo provides the code to derive:
- temporal and spatial data of the fMRI global components (global mean signal, fMRI arousal template, heart rate)
- functional connectivity of networks pre and post regression of global components
- main analysis conducted in the paper
- code to generate Figure 1 A & C, Figure 2B & C, and supplimentary Figure 3 of the paper on medirxn.
- Data only supplied to generate Figure 2 and Sup.Figure 3 on medirxn.
- our nifti files of where state and trait anxiety related to the global mean signal and fMRI arousal template

## 📑 How to navigate the repo??

This repo was designed with two folders: 

1. codes: to see the code used to derive any of the things we stated in our *Highlights* go here, for key information of what the code does go to the section  *codes info*
2. codes_2: updated codes for the resubmission to Cerebral Cortex. We have introduced the repeated anova and linear model analysis to test pre and post regression analysis.
3. data: due to our compliance with the Nathan Klein Institute Rockland we are unable to share the subjects state and trait anxiety scores which limits the data we can share. To obtain the state and trait data please fill out their data usage agreement form found ["here"](http://fcon_1000.projects.nitrc.org/indi/enhanced/sharing_phenotypic.html). The data we provide is: our nifti files that show where state and trait relate to the strength of the expression of the global mean signal or fMRI arousal template, data to generate Figures 2 B & C as well as supplementary Figure 3 of our medirxn paper. To generate violin plots of or Cerebral Cortex Figure 4.D and E we have violin plot code available in codes_2.

## 🧭 Software used in this project

- FSL version 6.0.5.1

FSL is a neuroimaging software that was used to derive our network components thorugh its function *melodic* which conducts a group independent component analysis. We also used it to identify significant brain clusters that relate our global components using the function *fslrandomise*

- Matlab version 2024a

Matlab was used to derive the fMRI global components, correlates of the global components, and the functional connectivity of networks pre and post global component regression in the code *fMRIglobal_anx.m*

- Rstudio version RStudio/2024.12.0+467

Rstudio was used to conduct statistical analysis and visualizations to determine if temporal global components related to anxiety in code *anx_global_analysis_fig.R*, and if any brain network connectivity measures related to anxiety pre and post global signal regression *net_regress_model.R*

## 💻 Code Info

Information on all the codes within our folder codes is located below:

**1. Conduct_Group_ICA**
 - fix_ICA_40.sh : code that was used to generate a group ICA analysis with 40 components
 - ICA_fix_paths.R : code to derive the text file used as an input in fix_ICA_40.sh

Note: we used manual inspection to identify which components were networks vs noise, for more information to conduct a group ICA analysis can be found on FSL's website ["here"](https://web.mit.edu/fsl_v5.0.10/fsl/doc/wiki/MELODIC.html).

**2. Derive_Main_Outputs**

- fMRIglobal_anx.m : a master code that derives the spatial and temporal data of our global fMRI components [NOTE our updated code is in codes_2 that removes additional motion regressors], conducts dual regression to derive network timeseries from our ICA components, functional connectivity pre and post global component regression on our networks of interest. Our code has comments to understand which sections derive certain components and below are functions we wrote needed to run the code. For questions feel free to contact me, my information is at the end of this repo.
  - create_hr_basis_dt.m : function code needed fMRIglobal_anx.m to derive the hr basis functions to model heart rate fluctuations in fMRI
  - regress_tc.m : function code needed fMRIglobal_anx.m to regress the global component form the networks time series
  - retrieve_fc_values: function code needed in fMRIglobal_anx.m to store functional connectivity measures after pre and post regression
  - xcov_signals.m: function to run cross correlation between heart rate and networks or other global components. This function also stored the highest correlation. 
   
- global_sd.m : code that derives the estimated drowsiness value (standard deviation of the fMRI arousal template), and the variation of the global mean signal.
- lags_test.m : code that investigated if lags of global components significantly alter brain connectivity relationships to anxiety. (It did not)
  - generate_fmri_lags.m : function needed for lags_test.m that preforms lags of the global components
  - regress_tc_non_zscored.m: function that regresses the values similar to regress_tc but does not zscore the values in the function because they were previously zscored

**3. Analysis_and_Visulizations**

- anx_global_analysis_fig.R : code that conducts the analysis to identify if estimated drowsines or GS_SD relates to state or trait anxiety. Also makes Figure 1) A & C in the paper on medrxiv .
- derive_anx_maps.sh : sample code we used to run fslrandomise to identify brain clusters that relate global measures to anxiety. We only share the code that ran the arousal spatial maps to anxiety measures.
  - derive4Dmaps.m : function code used to derive the 4D maps needed for fslrandomise.
- net_regress_model.R : code that conducts the regression analysis comparing brain connectivity to state and trait anxiety (uncorrected results).
- FDR_analysis.R : code that conducts the fdr corrections for the results derived from nki_multiple_regression_function_and_results.R
- Violin_fig.R: Codes to generate Figure 2 B & C on the manuscript. Note: data to run this is provided in data folder.
- histogram_fig.R: Codes to generate supplementary Figure 3.

## ❓Have Questions

For additional information about the project or how to use the codes feel free to reach out to me at my Vanderbilt email at kim.kundert.obando@vanderbilt.edu


   









