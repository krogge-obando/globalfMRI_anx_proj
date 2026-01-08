#This code will directly compare FC-anxiety associations before and after component regression 
#with a linear mixed model and compute FDR corrections 

#Author Kim Kundert-Obando

#set up dataframes for analysis

df_stai<-read.csv("nki_data_stai.csv")

df_demo<-read.csv("nki_data_dem.csv")

df_raw<-read.csv("non_regressed.csv")

df_a<-read.csv("regressed_A.csv")

df_h<-read.csv("regressed_H.csv")

df_g<-read.csv("regressed_G.csv")

df_demo_selected<-select(df_demo, c('ID','age','gender','ethnicity'))
df_stai_selected<-select(df_stai, c('ID','state_tscore','trait_tscore'))

#redo after removing the 50 ica

#df_50 <-read.csv("/Users/roggeokk/Desktop/Projects/nki_anx_vig_proj/nki_data/ica_list.csv")
#df_raw<-df_raw[!(df_raw$ID %in% df_50$ID), ]

#df_a<-df_a[!(df_a$ID %in% df_50$ID), ]

#df_g<-df_g[!(df_g$ID %in% df_50$ID), ]

#df_h<-df_h[!(df_h$ID %in% df_50$ID), ]

#raw and fai regression where 1 represents a 1 in group and regressed is a 0

df_raw$group<-rep("1",543)

df_a$group<-rep("0",543)

df_r_a<-rbind(df_raw,df_a)

df_r_a<-left_join(df_r_a,df_demo_selected)
df_r_a<-left_join(df_r_a,df_stai_selected)


library(lme4)
library(lmerTest)
library(performance)

pre_post_regression <- function(net_col, anx_col, df) {
  
  if (!anx_col %in% names(df)) {
    stop(paste("Column", anx_col, "not found in df"))
  }
  
  form_inter <- as.formula(
    paste0(net_col,
           " ~ ", anx_col, " * group + age + gender + ethnicity + (1|ID)")
  )
  
  form_no_inter <- as.formula(
    paste0(net_col,
           " ~ ", anx_col, " + group + age + gender + ethnicity + (1|ID)")
  )
  
  fit_inter <- lmer(form_inter, data = df, REML = FALSE)
  fit_no_inter <- lmer(form_no_inter, data = df, REML = FALSE)
  
  coef_table <- summary(fit_inter)$coefficients
  
  interaction_row <- grep(
    paste0(anx_col, ":group"),
    rownames(coef_table)
  )
  
  if (length(interaction_row) != 1) {
    warning(paste("Interaction term not uniquely identified for", net_col))
    return(c(f2 = NA, estimate = NA, SE = NA, t = NA, p = NA))
  }
  
  interaction_test <- coef_table[interaction_row, ]
  
  r2_with <- performance::r2_nakagawa(fit_inter)$R2_m
  r2_without <- performance::r2_nakagawa(fit_no_inter)$R2_m
  delta_R2 <- r2_with - r2_without
  f2 <- delta_R2 / (1 - r2_with)
  
  c(
    f2 = f2,
    estimate = interaction_test["Estimate"],
    SE = interaction_test["Std. Error"],
    t = interaction_test["t value"],
    p = interaction_test["Pr(>|t|)"]
  )
}



# Columns 1:10 contain network FC values
network_cols <- names(df_r_a)[2:10]

anx_cols <- names(df_r_a)[16]

df_r_a$state_tscore<-as.numeric(df_r_a$state_tscore)

# Run function on each network
results_list_a <- lapply(network_cols, function(col) {
  pre_post_regression(net_col = col, anx_col =  anx_cols, df = df_r_a)
})

# Convert to a data frame for easier viewing
results_df_a <- do.call(rbind, results_list_a)
rownames(results_df_a) <- network_cols
results_df_a

pval_raw_fai<-results_df_a[,5]

#raw and gs regression

df_g$group<-rep("0",543)

df_r_g<-rbind(df_raw,df_g)

df_r_g<-left_join(df_r_g,df_demo_selected)
df_r_g<-left_join(df_r_g,df_stai_selected)

df_r_g$state_tscore<-as.numeric(df_r_g$state_tscore)


results_list_g <- lapply(network_cols, function(col) {
  pre_post_regression(net_col = col, anx = anx_cols, df = df_r_g)
})

results_df_g <- do.call(rbind, results_list_g)
rownames(results_df_g) <- network_cols
results_df_g

pval_raw_g<-results_df_g[,5]

#raw and hr regression

df_h<-drop_na(df_h)
df_h_id<-as.data.frame(df_h$ID)
colnames(df_h_id)<-"ID"

df_rh<-left_join(df_h_id,df_raw,by="ID")

df_h$group<-rep("0",240)

df_r_h<-rbind(df_rh,df_h)

df_r_h<-left_join(df_r_h,df_demo_selected)
df_r_h<-left_join(df_r_h,df_stai_selected)

df_r_h$state_tscore<-as.numeric(df_r_h$state_tscore)

results_list_h <- lapply(network_cols, function(col) {
  pre_post_regression(net_col = col, anx = anx_cols, df = df_r_h)
})

results_df_h <- do.call(rbind, results_list_h)
rownames(results_df_h) <- network_cols
results_df_h

pval_raw_h<-results_df_h[,5]

#compute FDR corrections
plist<-list(pval_raw_fai,pval_raw_g,pval_raw_h)
p.fdr(unlist(plist))

#repeat all the analysis for trait anxiety

network_cols <- names(df_r_a)[2:10]

anx_cols<-"trait_tscore"

df_r_a$trait_tscore<-as.numeric(df_r_a$trait_tscore)

# Run function on each network
results_list_a_t <- lapply(network_cols, function(col) {
  pre_post_regression(net_col = col, anx = anx_cols, df = df_r_a)
})

# Convert to a data frame for easier viewing
results_df_a_t <- do.call(rbind, results_list_a_t)
rownames(results_df_a_t) <- network_cols
results_df_a_t

pval_raw_fai_t<-results_df_a_t[,5]

#raw and gs regression

df_r_g$trait_tscore<-as.numeric(df_r_g$trait_tscore)

results_list_g_t <- lapply(network_cols, function(col) {
  pre_post_regression(net_col = col, anx = anx_cols, df = df_r_g)
})

results_df_g_t <- do.call(rbind, results_list_g_t)
rownames(results_df_g_t) <- network_cols
results_df_g_t

pval_raw_g_t<-results_df_g_t[,5]

#raw and hr regression
df_r_h$trait_tscore<-as.numeric(df_r_h$trait_tscore)

results_list_h_t <- lapply(network_cols, function(col) {
  pre_post_regression(net_col = col, anx = anx_cols, df = df_r_h)
})

results_df_h_t <- do.call(rbind, results_list_h_t)
rownames(results_df_h_t) <- network_cols
results_df_h_t

pval_raw_h_t<-results_df_h_t[,5]

#compute FDR corrections
plist_t<-list(pval_raw_fai_t,pval_raw_g_t,pval_raw_h_t)

library(FDRestimation)
fdr_trait_results<-p.fdr(unlist(plist_t))

fdr_trait_results_data<-as.data.frame(fdr_trait_results$`Results Matrix`)

fdr_state_results<-p.fdr(unlist(plist))
fdr_state_results_data<-as.data.frame(fdr_state_results$`Results Matrix`)



write.csv(results_df_a,"pre_post_regression_fai_state.csv")
write.csv(results_df_a_t,"pre_post_regression_fai_trait.csv")
write.csv(results_df_g,"pre_post_regression_gs_state.csv")
write.csv(results_df_g_t,"pre_post_regression_gs_trait.csv")
write.csv(results_df_h,"pre_post_regression_hr_state.csv")
write.csv(results_df_h_t,"pre_post_regression_hr_trait.csv")
write.csv(fdr_state_results_data,"pre_post_regression_fdr_state.csv")
write.csv(fdr_trait_results_data,"pre_post_regression_fdr_trait.csv")


