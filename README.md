# :brain: Global effects in fMRI reveal brain markers of anxiety project
Hello, this repo was created to provide the codes for conducting the analysis reported in the paper, ["Global effects in fMRI reveal brain markers of state and trait anxiety (Medirxn 2025)"]([https://www.medrxiv.org/content/10.1101/2025.07.15.25331571v1#:~:text=Results%3A%20We%20observe%20that%20the,tied%20to%20the%20anxious%20experience.])

## ⭐ Highlights
This repo provides the code to derive:
- temporal and spatial data of the fMRI global components (global mean signal, fMRI arousal template, heart rate)
- functional connectivity of networks pre and post regression of global components
- main analysis conducted in the paper
- code to generate Figure 1 A & C, Figure 2B & C, and supplimentary Figure 2 of the paper.
- our nifti files of where state and trait anxiety related to the global mean signal and fMRI arousal template

## 🧭 Software used in this project

- FSL version  

FSL is a neuroimaging software that was used to derive our network components thorugh its function *melodic* which conducts independent component analysis. We also used it to identify significant brain clusters that relate our global components using the function *fslrandoimise*

- Matlab version

- Rstudio version







