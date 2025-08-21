#Author: Kim Kundert-Obando for questions please reach out to me at k.rogge.obando@gmail.com

#Example on how to do FDR corrections with one output file from the mixed model code "net_regress_model"

install.packages("FDRestimation")
library(FDRestimation)

#load files

df<-read.csv("/Users/roggeokk/Desktop/Projects/nki_anx_vig_proj/nki_data/multiple_regression_results_non_regressed_543.csv")

#Here I am extracting the p-value of each correlation result
p_value_state<-df$state_pval
p_value_trait<-df$trait_pval


#Here I am making them into a list that will be compared against eachoter
p_val_list<-list(p_value_state,p_value_trait)

#Here we conduct the fdr against these p-values
p.fdr(unlist(p_val_list))

