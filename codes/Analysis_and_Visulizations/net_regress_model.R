#This code will be a function that runs mixed model while correcting for age,
#gender, and, ethnicity in the FC comparisions with state and trait anxiety and outputs the beta an p-values results


#install and open packages

#install.packages("dplyr")
#install.packages("tidyverse")
#install.packages("sensemakr")
#install.packages("rlang")
library(dplyr)
library(tidyverse)
library(sensemakr)
library(rlang)


#upload all dataframes

df_stai<-read.csv("nki_data_stai.csv")

df_demo<-read.csv("nki_data_dem.csv")

df_raw<-read.csv("non_regressed.csv")

df_a<-read.csv("regressed_A.csv")

df_h<-read.csv("regressed_H.csv")

df_g<-read.csv("regressed_G.csv")

df_ag<-read.csv("regressed_AG.csv")

df_all<-read.csv("regressed_All.csv")

#make a function that conducts the multiple regression and stores beta, p-value and the partial effect size f2.

  multiple_regression_beta_pvalue<- function(net,anx,df) {
  
  #state corr with trinetworks raw
  fit_anx_net=lm( formula =  net ~ as.numeric(anx) +as.numeric(age) + as.numeric(gender)+as.numeric(ethnicity),data=df)
  fit_anx_net_results <-summary(fit_anx_net)
  model_effect_size<-partial_f2(fit_anx_net)
  
  beta<-fit_anx_net_results$coefficients[2]
  pval<-fit_anx_net_results$coefficients[2,4]
  
  library(rlang)
  output<-c(beta,pval,as.list(model_effect_size))
  return(output)
  }
  
  
  #function if we exclude age
  #multiple_regression_beta_pvalue<- function(net,anx,df) {
    
    #state corr with trinetworks raw
    #fit_anx_net=lm( formula =  net ~ as.numeric(anx) + as.numeric(gender)+as.numeric(ethnicity),data=df)
    #fit_anx_net_results <-summary(fit_anx_net)
    #model_effect_size<-partial_f2(fit_anx_net)
    #beta<-fit_anx_net_results$coefficients[2]
    #pval<-fit_anx_net_results$coefficients[2,4]
    #output<-c(beta,pval,as.list(model_effect_size))
    #return(output)
  #}
  
  
#Function that runst the previous function for all of the networks of interest. 

multiple_regression_results<-function(df){

ddmn.vdmn<-multiple_regression_beta_pvalue(df$ddmn.vdmn,df$state_tscore,df)
state.ddmn.vdmn<-as.data.frame(ddmn.vdmn,col.names = c("state_Beta","state_pval","state_intercept_eff","state_eff","state_age_eff","state_gender_eff","state_ethnicity_eff"), row.names = c("ddmn.vdmn"))

ddmn.sal<-multiple_regression_beta_pvalue(df$ddmn.sal,df$state_tscore,df)
state.ddmn.sal<-as.data.frame(ddmn.sal,col.names = c("state_Beta","state_pval","state_intercept_eff","state_eff","state_age_eff","state_gender_eff","state_ethnicity_eff"), row.names = c("ddmn.sal"))

ddmn.lcen<-multiple_regression_beta_pvalue(df$ddmn.lcen,df$state_tscore,df)
state.ddmn.lcen<-as.data.frame(ddmn.lcen,col.names = c("state_Beta","state_pval","state_intercept_eff","state_eff","state_age_eff","state_gender_eff","state_ethnicity_eff"), row.names = c("ddmn.lcen"))

ddmn.rcen<-multiple_regression_beta_pvalue(df$ddmn.rcen,df$state_tscore,df)
state.ddmn.rcen<-as.data.frame(ddmn.rcen,col.names = c("state_Beta","state_pval","state_intercept_eff","state_eff","state_age_eff","state_gender_eff","state_ethnicity_eff"), row.names = c("ddmn.rcen"))

vdmn.sal<-multiple_regression_beta_pvalue(df$vdmn.sal,df$state_tscore,df)
state.vdmn.sal<-as.data.frame(vdmn.sal,col.names =c("state_Beta","state_pval","state_intercept_eff","state_eff","state_age_eff","state_gender_eff","state_ethnicity_eff"), row.names = c("vdmn.sal"))

vdmn.lcen<-multiple_regression_beta_pvalue(df$vdmn.lcen,df$state_tscore,df)
state.vdmn.lcen<-as.data.frame(vdmn.lcen,col.names = c("state_Beta","state_pval","state_intercept_eff","state_eff","state_age_eff","state_gender_eff","state_ethnicity_eff"), row.names = c("vdmn.lcen"))

vdmn.rcen<-multiple_regression_beta_pvalue(df$vdmn.rcen,df$state_tscore,df)
state.vdmn.rcen<-as.data.frame(vdmn.rcen,col.names = c("state_Beta","state_pval","state_intercept_eff","state_eff","state_age_eff","state_gender_eff","state_ethnicity_eff"), row.names = c("vdmn.rcen"))

lcen.sal<-multiple_regression_beta_pvalue(df$lcen.sal,df$state_tscore,df)
state.lcen.sal<-as.data.frame(lcen.sal,col.names = c("state_Beta","state_pval","state_intercept_eff","state_eff","state_age_eff","state_gender_eff","state_ethnicity_eff"), row.names = c("lcen.sal"))

lcen.rcen<-multiple_regression_beta_pvalue(df$lcen.rcen,df$state_tscore,df)
state.lcen.rcen<-as.data.frame(lcen.rcen,col.names = c("state_Beta","state_pval","state_intercept_eff","state_eff","state_age_eff","state_gender_eff","state_ethnicity_eff"), row.names = c("lcen.rcen"))

rcen.sal<-multiple_regression_beta_pvalue(df$rcen.sal,df$state_tscore,df)
state.rcen.sal<-as.data.frame(rcen.sal,col.names = c("state_Beta","state_pval","state_intercept_eff","state_eff","state_age_eff","state_gender_eff","state_ethnicity_eff"), row.names = c("rcen.sal"))

#Repeat function for trait measures

ddmn.vdmn<-multiple_regression_beta_pvalue(df$ddmn.vdmn,df$trait_tscore,df)
trait.ddmn.vdmn<-as.data.frame(ddmn.vdmn,col.names = c("trait_Beta","trait_pval","trait_intercept_eff","trait_eff","trait_age_eff","trait_gender_eff","trait_ethnicity_eff"), row.names = c("ddmn.vdmn"))

ddmn.sal<-multiple_regression_beta_pvalue(df$ddmn.sal,df$trait_tscore,df)
trait.ddmn.sal<-as.data.frame(ddmn.sal,col.names = c("trait_Beta","trait_pval","trait_intercept_eff","trait_eff","trait_age_eff","trait_gender_eff","trait_ethnicity_eff"), row.names = c("ddmn.sal"))

ddmn.lcen<-multiple_regression_beta_pvalue(df$ddmn.lcen,df$trait_tscore,df)
trait.ddmn.lcen<-as.data.frame(ddmn.lcen,col.names = c("trait_Beta","trait_pval","trait_intercept_eff","trait_eff","trait_age_eff","trait_gender_eff","trait_ethnicity_eff"), row.names = c("ddmn.lcen"))

ddmn.rcen<-multiple_regression_beta_pvalue(df$ddmn.rcen,df$trait_tscore,df)
trait.ddmn.rcen<-as.data.frame(ddmn.rcen,col.names = c("trait_Beta","trait_pval","trait_intercept_eff","trait_eff","trait_age_eff","trait_gender_eff","trait_ethnicity_eff"), row.names = c("ddmn.rcen"))

vdmn.sal<-multiple_regression_beta_pvalue(df$vdmn.sal,df$trait_tscore,df)
trait.vdmn.sal<-as.data.frame(vdmn.sal,col.names = c("trait_Beta","trait_pval","trait_intercept_eff","trait_eff","trait_age_eff","trait_gender_eff","trait_ethnicity_eff"), row.names = c("vdmn.sal"))

vdmn.lcen<-multiple_regression_beta_pvalue(df$vdmn.lcen,df$trait_tscore,df)
trait.vdmn.lcen<-as.data.frame(vdmn.lcen,col.names = c("trait_Beta","trait_pval","trait_intercept_eff","trait_eff","trait_age_eff","trait_gender_eff","trait_ethnicity_eff"), row.names = c("vdmn.lcen"))

vdmn.rcen<-multiple_regression_beta_pvalue(df$vdmn.rcen,df$trait_tscore,df)
trait.vdmn.rcen<-as.data.frame(vdmn.rcen,col.names = c("trait_Beta","trait_pval","trait_intercept_eff","trait_eff","trait_age_eff","trait_gender_eff","trait_ethnicity_eff"), row.names = c("vdmn.rcen"))

lcen.sal<-multiple_regression_beta_pvalue(df$lcen.sal,df$trait_tscore,df)
trait.lcen.sal<-as.data.frame(lcen.sal,col.names = c("trait_Beta","trait_pval","trait_intercept_eff","trait_eff","trait_age_eff","trait_gender_eff","trait_ethnicity_eff"), row.names = c("lcen.sal"))

lcen.rcen<-multiple_regression_beta_pvalue(df$lcen.rcen,df$trait_tscore,df)
trait.lcen.rcen<-as.data.frame(lcen.rcen,col.names =c("trait_Beta","trait_pval","trait_intercept_eff","trait_eff","trait_age_eff","trait_gender_eff","trait_ethnicity_eff"), row.names = c("lcen.rcen"))

rcen.sal<-multiple_regression_beta_pvalue(df$rcen.sal,df$trait_tscore,df)
trait.rcen.sal<-as.data.frame(rcen.sal,col.names = c("trait_Beta","trait_pval","trait_intercept_eff","trait_eff","trait_age_eff","trait_gender_eff","trait_ethnicity_eff"), row.names = c("trait.rcen.sal"))

state.net<-do.call("rbind",list(state.ddmn.vdmn,state.ddmn.sal,state.ddmn.lcen,state.ddmn.rcen,state.vdmn.sal,
                                state.vdmn.rcen,state.vdmn.lcen,state.lcen.sal,state.lcen.rcen,state.rcen.sal))
trait.net<-do.call("rbind",list(trait.ddmn.vdmn,trait.ddmn.sal,trait.ddmn.lcen,trait.ddmn.rcen,trait.vdmn.sal,
                                trait.vdmn.lcen,trait.vdmn.rcen,trait.lcen.sal,trait.lcen.rcen,trait.rcen.sal))


multiple_regression_results_df<-cbind(state.net,trait.net)}

#Now the functions are complete we need to run both of these functions to complete our analysis.

#Select variables of interest from large data sets

df_demo_selected<-select(df_demo, c('ID','age','gender','ethnicity'))
df_stai_selected<-select(df_stai, c('ID','state_tscore','trait_tscore'))
df_model<- left_join(df_stai_selected,df_demo_selected, by="ID")



#conduct analysis this for raw_regressed
df_non_regressed<-left_join(df_raw,df_model,by="ID")

multiple_regression_non_regressed<-multiple_regression_results(df_non_regressed)

#store data
write.csv(multiple_regression_non_regressed,"/Users/roggeokk/Desktop/Projects/nki_anx_vig_proj/nki_data/multiple_regression_results_non_regressed_543.csv")



#do this for arousal regressed
df_a_demo<-left_join(df_a,df_model)

multiple_regression_a_regressed<-multiple_regression_results(df_a_demo)

write.csv(multiple_regression_a_regressed,"/Users/roggeokk/Desktop/Projects/nki_anx_vig_proj/nki_data/multiple_regression_results_A_regressed_543.csv")


#do this for global signal regressed

df_g_demo<-left_join(df_g,df_model)

multiple_regression_g_regressed<-multiple_regression_results(df_g_demo)

write.csv(multiple_regression_g_regressed,"/Users/roggeokk/Desktop/Projects/nki_anx_vig_proj/nki_data/multiple_regression_results_G_regressed_543.csv")


#do this for hr regressed
df_hr_demo<-left_join(df_h,df_model,by="ID")
df_hr_demo_clean<- df_hr_demo %>% drop_na(ddmn.vdmn)

multiple_regression_hr_regressed<-multiple_regression_results(df_hr_demo_clean)

write.csv(multiple_regression_hr_regressed,"/Users/roggeokk/Desktop/Projects/nki_anx_vig_proj/nki_data/multiple_regression_results_HR_regressed_543.csv")



#Redo arousal and global signal and arousal-global signal with 240 subjects

df_240<- select(df_hr_demo_clean,c("ID"))
df_240_nr<-left_join(df_240,df_non_regressed)

multiple_regression_non_regressed_240<-multiple_regression_results(df_240_nr)

write.csv(multiple_regression_non_regressed_240,"/Users/roggeokk/Desktop/Projects/nki_anx_vig_proj/nki_data/multiple_regression_results_non_regressed_240.csv")

df_240_a<-join(df_240,df_a_demo)

multiple_regression_a_regressed_240<-multiple_regression_results(df_240_a)

write.csv(multiple_regression_a_regressed_240,"/Users/roggeokk/Desktop/Projects/nki_anx_vig_proj/nki_data/multiple_regression_results_A_regressed_240.csv")

df_240_g<-left_join(df_240,df_g_demo)
multiple_regression_g_regressed_240<-multiple_regression_results(df_240_g)

write.csv(multiple_regression_g_regressed_240,"/Users/roggeokk/Desktop/Projects/nki_anx_vig_proj/nki_data/multiple_regression_results_G_regressed_240.csv")



