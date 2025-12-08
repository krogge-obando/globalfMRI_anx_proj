#This code will generate a one-sample ttest of global comonents across networks

df<-read.csv("Networks_Corr_Global_Components_last_mo_corr.csv")

df<-subset(df, select = -c(11:15))

results<-t.test(df$G_ddmn,mu=0)

results$statistic

t_results <- sapply(df, function(x) t.test(x,mu=0)$p.value)
tstat_results<-sapply(df, function(x) t.test(x,mu=0)$statistic)
tstat_results<-as.data.frame(tstat_results)

df<-read.csv("Networks_Corr_Global_Components_last_mo_corr.csv")

df_hr<-drop_na(df)

df_hr<-subset(df_hr,select= -c(1:10))

t_results_hr <- sapply(df_hr, function(x) t.test(x,mu=0)$p.value)
tstat_results_hr<-sapply(df, function(x) t.test(x,mu=0)$statistic)
tstat_results_hr<-as.data.frame(tstat_results_hr)

pval<-list(t_results_hr,t_results)

p_fdr<-p.fdr(unlist(pval))

p_fdr<-as.data.frame(p_fdr$`Results Matrix`)

results_df<-cbind(tstat_results_hr,p_fdr)

write.csv(results_df,"one_sample_Ttest_results.csv")
