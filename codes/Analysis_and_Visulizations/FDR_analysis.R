#Author: Kim Kundert-Obando for questions please reach out to me at k.rogge.obando@gmail.com

#install packaged and open them
#Redundant comment
install.packages("FDRestimation")
library(FDRestimation)

#Here I am extracting the p-value of each correlation result
p_val_trait_mean_hrv<-trait_mean_hrv[[3]]
p_val_trait_mean_hr <-trait_mean_hr[[3]]
p_val_trait_sd_vig<-trait_sd_vig[[3]]

p_val_state_mean_hrv<-state_mean_hrv[[3]]
p_val_state_mean_hr <-state_mean_hr[[3]]
p_val_state_sd_vig<-state_sd_vig[[3]]


#Here I am making them into a list that will be compared against eachother
p_val_list_state<-list(p_val_state_sd_vig,p_val_state_mean_hr,p_val_state_mean_hrv)

p_val_list_trait<-list(p_val_trait_sd_vig,p_val_trait_mean_hr,p_val_state_mean_hrv)

#Here we conduct the fdr against these p-values
p.fdr(unlist(p_val_list_state))
p.fdr(unlist(p_val_list_trait))

