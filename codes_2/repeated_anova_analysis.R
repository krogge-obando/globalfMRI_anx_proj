#This code will run 2 way repeated ANOVA on network corr with gs

#Author Kim Kundert-Obando

#Load in needed packages
library(dplyr)
library(tidyr)
library(tidyverse)
library(broom)
library(mvtnorm)
#install.packages("datapasta")
library(datapasta)
library(dplyr)
library(tidyr)

#Read in the data
df<-read.csv("Networks_Corr_Global_Components_last_mo_corr.csv")

df<-drop_na(df)
#Flip the sign of FAI corelations
df$A_ddmn<-df$A_ddmn*-1

df$A_vdmn<-df$A_vdmn*-1

df$A_lcen<-df$A_lcen*-1

df$A_rcen<-df$A_rcen*-1

df$A_sal<-df$A_sal*-1


#Reformat the data

df_long <- df %>%
  mutate(id=row_number()) %>%
  pivot_longer(
    cols = -id,
    names_to = c("global_component", "network"),
    names_sep = "_"
  ) %>%
  mutate(
    global_component = case_when(
      global_component == "G" ~ "gs",
      global_component == "A" ~ "fai",
      global_component == "H" ~ "hr",
      TRUE ~ global_component
    )
  ) 

df_long$id<- as.factor(df_long$id)

#class(df_long$global_component)

df_long$global_component<-as.factor(df_long$global_component)

df_long$network<-as.factor(df_long$network)



#Model 2-way interaction anova
model_component<-aov(value ~ global_component*network +Error(id/global_component*network), data=df_long)

summary(model_component)

#Compute eta-squared value from the F statistic

library(effectsize)
eta_squared(model_component, partial=TRUE)



#Conduct post-hoc analysis with mixed-effects model
library(lmerTest)

mod_lmm <- lmer(
  value ~ global_component * network + (1 | id),
  data = df_long
)

library(emmeans)

# Between components within each network
component_results_1 <- pairs(
  emmeans(mod_lmm, ~ global_component | network),
  adjust = "fdr"
)

# Between networks within each component
component_results_2<-pairs(
  emmeans(mod_lmm, ~ network | global_component),
  adjust = "fdr"
)



results1<-as.data.frame(component_results_1)
results2<-as.data.frame(component_results_2)

write.csv(results1,"gc_within_net_post_hoc.csv")
write.csv(results2,"net_within_gc_post_hoc.csv")

#generate figures

library(ggplot2)

# Define significance bars and stars
df_long$network<-factor(df_long$network, levels=c("ddmn","vdmn","sal","rcen","lcen"))
df_fai<- subset(df_long,df_long$global_component=="fai")
df_gs<- subset(df_long,df_long$global_component == "gs")
df_hr<- subset(df_long,df_long$global_component=="hr")

x_labels<-c("DDMN","VDMN","SAL","RCEN","LCEN")

ggplot(df_fai, aes(x = network, y = value, fill = network)) +
  geom_violin(trim = FALSE, alpha = 0.5, position = position_dodge(0.9)) + 
  geom_boxplot(width = 0.2, position = position_dodge(0.9)) +
  scale_x_discrete(labels=x_labels)+
  theme_minimal() + 
  theme(axis.text = element_text(size = 20), axis.title = element_text(size = 20)) +
  labs(main = "FAI", x = "Network", y = "Correlation with FAI ", fill = "Network") +
  scale_fill_manual(values = c("#C66699", "#660099", "#3333FF", "#33CC33", "#FF9933"))

ggplot(df_gs, aes(x = network, y = value, fill = network)) +
  geom_violin(trim = FALSE, alpha = 0.5, position = position_dodge(0.9)) + 
  geom_boxplot(width = 0.2, position = position_dodge(0.9)) +
  scale_x_discrete(labels=x_labels)+
  theme_minimal() + 
  theme(axis.text = element_text(size = 20), axis.title = element_text(size = 20)) +
  labs(main = "FAI", x = "Network", y = "Correlation with GS ", fill = "Network") +
  scale_fill_manual(values = c("#C66699", "#660099", "#3333FF", "#33CC33", "#FF9933"))

ggplot(df_hr, aes(x = network, y = value, fill = network)) +
  geom_violin(trim = FALSE, alpha = 0.5, position = position_dodge(0.9)) + 
  geom_boxplot(width = 0.2, position = position_dodge(0.9)) +
  scale_x_discrete(labels=x_labels)+
  # Add significance bars
  #coord_flip() +
  theme_minimal() + 
  theme(axis.text = element_text(size = 20), axis.title = element_text(size = 20)) +
  labs(main = "FAI", x = "Network", y = "Correlation with HR ", fill = "Network") +
  scale_fill_manual(values = c("#C66699", "#660099", "#3333FF", "#33CC33", "#FF9933"))
