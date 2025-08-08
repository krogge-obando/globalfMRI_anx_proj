#NKI- Global Component variation relates to anxiety analysis and figure
#Author: Kim Kundert-Obando for questions please reach out to me at k.rogge.obando@gmail.com

#load packages
library(ggplot2)
library(tidyr)
library(dplyr)
library(reshape2)
library(rlang)
library(sensemakr)

#loading dataframe stai
df_anx_demo<- read.csv('543_demo.csv')

df_ar<- read.csv('estimated_drowsiness.csv')
df_gs<- read.csv('543_gs_sd.csv')

df_anx_demo<-select(df_anx_demo, c('ID','age','gender','ethnicity','state_tscore','trait_tscore'))

df<- left_join(df_anx_demo,df_ar,by="ID")
df<- left_join(df,df_gs,by="ID")

#uncomment to see the ages for less than 55
#df<-subset(df,df$age < 55)

#Change the scores and age to numeric values
df$trait_tscore<-as.numeric(df$trait_tscore)
df$state_tscore<-as.numeric(df$state_tscore)
df$age<-as.numeric(df$age)


#make models that correct for age and gender
fit_state_a = lm( state_tscore ~estimated_drowsiness+gender+ethnicity, data=df)
summary(fit_state_a)

fit_trait_a = lm(trait_tscore ~estimated_drowsiness  +gender, data=df)
summary(fit_trait_a)

partial_f2(fit_state_a) 
parital_f2(fit_trait_a)

#Make the equations for state and trait correlations
equation1=function(x){coef(fit_state_a)[2]*x+coef(fit_state_a)[1]}
equation2=function(x){coef(fit_trait_a)[2]*x+coef(fit_trait_a)[1]}

#new dataframe for the plot that has the variables we need
df_plot<-df[, c("estimated_drowsiness","state_tscore","trait_tscore")]

#renaming colomn names to state and trait for plot
colnames(df_plot)[colnames(df_plot)=="state_tscore"] ="state"
colnames(df_plot)[colnames(df_plot)=="trait_tscore"] ="trait"

#gathering the data to plot in a long form
df_test_plt<-gather(df_plot,Anxiety,Score,state:trait,factor_key=TRUE)

#generate figure with the state and trait linear lines and state and trait points
fig<-ggplot(df_test_plt, aes(x=estimated_drowsiness,y=Score ,color=Anxiety))+geom_point()+
  stat_function(fun=equation1,geom="line",color="blue")+
  stat_function(fun=equation2,geom="line",color="mediumaquamarine")+
  xlab('Estimated Drowsiness')+ylab('Anxiety Score')

#Change text size and make the color of the points blue and mediumaquamarine
fig+ theme(
  text=element_text(family="Arial"),
  axis.title=element_text(size=25),
  axis.text=element_text(size=16),
  panel.background = element_blank(),
  axis.line = element_line(color = 'black',size=1))+ scale_color_manual(values=c("blue","mediumaquamarine"))

#Global Signal and Anxiety

#make models that correct for age and gender
fit_state_gs = lm( state_tscore ~ GS_sd +age+gender+ethnicity, data=df)
summary(fit_state_gs)

fit_trait_gs = lm( trait_tscore ~ GS_sd +age +gender+ethnicity, data=df)
summary(fit_trait_gs)

partial_f2(fit_state_gs) 
partial_f2(fit_trait_gs) 


#Make the equations for state and trait correlations
equation1=function(x){coef(fit_state_gs)[2]*x+coef(fit_state_gs)[1]}
equation2=function(x){coef(fit_trait_gs)[2]*x+coef(fit_trait_gs)[1]}

#new dataframe for the plot that has the variables we need
df_plot<-df[, c("GS_sd","state_tscore","trait_tscore")]

#renaming colomn names to state and trait for plot
colnames(df_plot)[colnames(df_plot)=="state_tscore"] ="state"
colnames(df_plot)[colnames(df_plot)=="trait_tscore"] ="trait"

#gathering the data to plot in a long form
df_test_plt<-gather(df_plot,Anxiety,Score,state:trait,factor_key=TRUE)


#generate figure with the state and trait linear lines and state and trait points
fig<-ggplot(df_test_plt, aes(x=GS_sd,y=Score ,color=Anxiety))+geom_point()+
  stat_function(fun=equation1,geom="line",color="darkslateblue")+
  stat_function(fun=equation2,geom="line",color="darkorchid2")+
  xlab('GS SD')+ylab('Anxiety Score')

fig+ theme(
  text=element_text(family="Arial"),
  axis.title=element_text(size=25),
  axis.text=element_text(size=16),
  panel.background = element_blank(),
  axis.line = element_line(color = 'black',size=1))+ scale_color_manual(values=c("darkslateblue","darkorchid2"))





