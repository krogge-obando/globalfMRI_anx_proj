#This code will generate the violin plots

library(tidyr)
library(dplyr)
library(ggplot2)

df<-read.csv("/Users/roggeokk/Desktop/Projects/nki_anx_vig_proj/nki_data/Networks_Corr_Global_Components.csv")

df_543 <- df[, 1:(ncol(df) - 5)]

df_240<-drop_na(df)

# Assuming your data frame is named df
long_df_543 <- df_543 %>%
  pivot_longer(
    cols = -ID,  # all columns except ID
    names_to = "name",  # temporary name column
    values_to = "Correlation"
  ) %>%
  separate(name, into = c("Component", "Network"), sep = "_") %>%
  mutate(
    Component = recode(Component,
                       "A" = "FAI",
                       "G" = "Global signal"),
    Network = recode(Network,
                     "ddmn" = "DDMN",
                     "vdmn" = "VDMN",
                      "sal" = "SAL",
                     "lcen"= "LCEN",
                     "rcen"= "RCEN"
                     )
  )

# Assuming your data frame is named df
long_df_240 <- df_240 %>%
  pivot_longer(
    cols = -ID,  # all columns except ID
    names_to = "name",  # temporary name column
    values_to = "Correlation"
  ) %>%
  separate(name, into = c("Component", "Network"), sep = "_") %>%
  mutate(
    Component = recode(Component,
                       "A" = "FAI",
                       "G" = "Global signal",
                       "H" = "Heart rate"),
    Network = recode(Network,
                     "ddmn" = "DDMN",
                     "vdmn" = "VDMN",
                     "sal" = "SAL",
                     "lcen"= "LCEN",
                     "rcen"= "RCEN"
    )
  )



ggplot(long_df_543, aes(x = Network, y = Correlation, fill = Component)) +
     geom_violin(trim = FALSE, alpha = 0.5, position = position_dodge(0.9)) + 
     geom_boxplot(width = 0.2, position = position_dodge(0.9)) +
     theme_minimal() + 
     theme(axis.text = element_text(size = 16), axis.title = element_text(size = 18)) +
     coord_flip() +
     labs(
                   x = "Network",
                   y = "Correlation",
                   fill = "Global Component") +      
     scale_fill_manual(values = c("#C66699", "#660099", "#3333FF"), labels = c("FAI", "GS","HR"))

ggplot(long_df_240, aes(x = Network, y = Correlation, fill = Component)) +
  geom_violin(trim = FALSE, alpha = 0.5, position = position_dodge(0.9)) + 
  geom_boxplot(width = 0.2, position = position_dodge(0.9)) +
  theme_minimal() + 
  theme(axis.text = element_text(size = 16), axis.title = element_text(size = 18)) +
  coord_flip() +
  labs(
    x = "Network",
    y = "Correlation",
    fill = "Global Component") +      
  scale_fill_manual(values = c("#C66699", "#660099", "#3333FF"), labels = c("FAI", "GS","HR"))

#Now we will multiply by negative to arousal


library(dplyr)

long_df_543 <- long_df_543 %>%
  mutate(
    Correlation = if_else(Component == "FAI", Correlation * -1, Correlation)
  )


ggplot(long_df_543, aes(x = Network, y = Correlation, fill = Component)) +
  geom_violin(trim = FALSE, alpha = 0.5, position = position_dodge(0.9)) + 
  geom_boxplot(width = 0.2, position = position_dodge(0.9)) +
  theme_minimal() + 
  theme(axis.text = element_text(size = 16), axis.title = element_text(size = 18)) +
  coord_flip() +
  labs(
    x = "Network",
    y = "Correlation",
    fill = "Global Component") +      
  scale_fill_manual(values = c("#C66699", "#660099", "#3333FF"), labels = c("FAI", "GS","HR"))


long_df_240 <- long_df_240 %>%
  mutate(
    Correlation = if_else(Component == "FAI", Correlation * -1, Correlation)
  )

ggplot(long_df_240, aes(x = Network, y = Correlation, fill = Component)) +
  geom_violin(trim = FALSE, alpha = 0.5, position = position_dodge(0.9)) + 
  geom_boxplot(width = 0.2, position = position_dodge(0.9)) +
  theme_minimal() + 
  theme(axis.text = element_text(size = 16), axis.title = element_text(size = 18)) +
  coord_flip() +
  labs(
    x = "Network",
    y = "Correlation",
    fill = "Global Component") +      
  scale_fill_manual(values = c("#C66699", "#660099", "#3333FF"), labels = c("FAI", "GS","HR"))

