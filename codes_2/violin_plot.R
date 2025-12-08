#This code will run manova on network corr with gs

library(dplyr)
library(tidyr)
library(ggplot2)

df<-read.csv("Networks_Corr_Global_Components_last_mo_corr.csv")


df$A_ddmn<-df$A_ddmn*-1

df$A_vdmn<-df$A_vdmn*-1

df$A_lcen<-df$A_lcen*-1

df$A_rcen<-df$A_rcen*-1

df$A_sal<-df$A_sal*-1

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

class(df_long$global_component)

df_long$global_component<-as.factor(df_long$global_component)

df_long$network<-as.factor(df_long$network)


# Define significance bars and stars
df_long$network<-factor(df_long$network, levels=c("ddmn","vdmn","sal","rcen","lcen"))
df_fai<- subset(df_long,df_long$global_component=="fai")
df_gs<- subset(df_long,df_long$global_component == "gs")
df_hr<- subset(df_long,df_long$global_component=="hr")

x_labels<-c("DDMN","VDMN","SAL","RCEN","LCEN")


ggplot(df_fai, aes(x = network, y = value, fill = network)) +
  geom_violin(trim = FALSE, alpha = 0.5, position = position_dodge(0.9)) + 
  geom_boxplot(width = 0.2, position = position_dodge(0.9)) +
  # Add stars above each network
  scale_x_discrete(labels=x_labels)+
  theme_minimal(base_size = 20) + 
  theme(axis.text = element_text(size = 20), axis.title = element_text(size = 20)) +
  labs( x = "Network", y = "Correlation with FAI", fill = "Network") +
  scale_fill_manual(values = c("#C66699", "#660099", "#3333FF", "#33CC33", "#FF9933"))+ylim(-1.0,1.20)


ggplot(df_gs, aes(x = network, y = value, fill = network)) +
  geom_violin(trim = FALSE, alpha = 0.5, position = position_dodge(0.9)) + 
  geom_boxplot(width = 0.2, position = position_dodge(0.9)) +
  scale_x_discrete(labels=x_labels)+
  theme_minimal(base_size=20) + 
  theme(axis.text = element_text(size = 20), axis.title = element_text(size = 20)) +
  labs( x = "Network", y = "Correlation with GS", fill = "Network") +
  scale_fill_manual(values = c("#C66699", "#660099", "#3333FF", "#33CC33", "#FF9933"))+ylim(-1.0, 1.30)



ggplot(df_hr, aes(x = network, y = value, fill = network)) +
  geom_violin(trim = FALSE, alpha = 0.5, position = position_dodge(0.9)) + 
  geom_boxplot(width = 0.2, position = position_dodge(0.9)) +
  scale_x_discrete(labels=x_labels)+
  theme_minimal(base_size=20) + 
  theme(axis.text = element_text(size = 20), axis.title = element_text(size = 20)) +
  labs( x = "Network", y = "Correlation with HR", fill = "Network") +
  scale_fill_manual(values = c("#C66699", "#660099", "#3333FF", "#33CC33", "#FF9933"))+ylim(-1,1.20)

