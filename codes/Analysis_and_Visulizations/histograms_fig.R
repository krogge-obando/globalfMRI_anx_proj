#Author: Terra Lee Checked:Kim-Kundert Obando

#The purpose of this code is to generate the histogram figures in Supplementary Figure 3 in the manuscript.

#load data
df_543_net_corr_data <-read.csv("GlobalComponents_Corr_GlobalComponents_Fin.csv")
df_240_net_corr_data <- na.omit(df_543_net_corr_data)

# Now, combine your two dataframes into one.  
# First make a new column in each that will be 
# a variable to identify where they came from later.
df_543_net_corr_data$combined <- 'df_543'
df_240_net_corr_data$combined <- 'df_240'

# and combine into your new data frame vegLengths
new_histogram_data <- rbind(df_543_net_corr_data, df_240_net_corr_data)

#change to numeric

str(df_240_net_corr_data)
df_240_net_corr_data$corrAG <- as.numeric(as.character(df_240_net_corr_data$corrAG))
df_543_net_corr_data$corrAG <- as.numeric(as.character(df_543_net_corr_data$corrAG))

# Verify if the conversion worked
str(df_240_net_corr_data$corrAG)

df_240_net_corr_data$corrAG <- as.numeric(df_240_net_corr_data$corrAG)
df_543_net_corr_data$corrAG <- as.numeric(df_543_net_corr_data$corrAG)


set.seed(42)
hist_543 <- hist(df_543_net_corr_data$corrAG, breaks = 20, ylim=c(0,200))                     # centered at 4
hist_240 <- hist(df_240_net_corr_data$corrAG, breaks = 20, ylim=c(0,200))                     # centered at 6
plot( hist_543, col=rgb(0,0,0,1), xlim=c(-1.0, 1.0), ylim=c(0,150), xlab = "Pearson's Correlation", ylab = "Number of Subjects", main = 'Correlation Between FAI and Global Signal')  # first histogram
plot( hist_240, col=rgb(1/2,1/2,1/2,1), xlim=c(-1.0, 1.0), ylim=c(0,150), xlab = "Pearson's Correlation", ylab = "Number of Subjects", main = 'Correlation Between FAI and Global Signal', add=T)  # second
legend("topright", legend = c("543 Subjects", "240 Subjects"), 
       fill = c(rgb(0, 0, 0, 1), col= rgb(1/2,1/2,1/2,1)), 
       title = "Legend", bty = "n")


#ggplot 
ggplot(new_histogram_data, aes(x = value , y = combined)) + 
geom_histogram(alpha = 0.5)
labs(title = "Arousal and Global Signal (543 and 240 Subjects)",
     x = "Correlation Values",
     y = "Number of Subjects")     


#Histograms for Correlation Between Heart Rate and FAI, and Between Heart Rate and Global Signal

df_543_net_arousal_cleaned <- df_543_net_corr_data[!is.na(df_543_net_corr_data$corrHA), ]

#write.csv(df_543_net_arousal_cleaned, "filtered_240_net_arousal.csv", row.names = FALSE)

hist(df_543_net_arousal_cleaned$corrHA)

hist(df_543_net_arousal_cleaned$corrHA , xlim = c(-1.0, 1.0), ylim = c(0, 150), col=rgb(1/2,1/2,1/2,1), border = "black", breaks = 20, xlab = "Pearson's Correlation", ylab = "Number of Subjects", main = 'Correlation Between Heart Rate and FAI') 

hist(df_543_net_arousal_cleaned$corrHG)

hist(df_543_net_arousal_cleaned$corrHG , xlim = c(-1.0, 1.0), ylim = c(0, 150), col=rgb(1/2,1/2,1/2,1), border = "black", breaks = 20, xlab = "Pearson's Correlation", ylab = "Number of Subjects", main = 'Correlation Between Heart Rate and Global Signal') 


