#Clean the data

# Read the data
library(readxl)
PotPlants1 <- read_excel("~/Desktop/PotPlants_18.xlsx", 
                           sheet = "Sample Set One")
PotPlants2 <- read_excel("~/Desktop/PotPlants_18.xlsx", 
                         sheet = "Sample Set Two")
PotPlants3 <- read_excel("~/Desktop/PotPlants_18.xlsx", 
                         sheet = "Sample Set Three")

# Change the first column name of PotPlants2 
name <- names(PotPlants2)
names(PotPlants2) <- c("Sample,Name", name[2:40])

# Combine three dataframes
pot_plants <- rbind(PotPlants1, PotPlants2, PotPlants3)

# Understand the basic structure of the data
# Verify that pot_plants is a data.frame
class(pot_plants)

# View the structure, first and last 6 rows of the data
str(pot_plants)
head(pot_plants)
tail(pot_plants)

# Load the tidyr package
library(tidyr)

# Gather the columns
pot_plants <- gather(pot_plants, elements, value, Mg:Th, na.rm = TRUE)

# Load the stringr package
library(stringr)

# remove "Missing" and replace "potting mix" with "pm"
pot_plants$value <- str_replace(pot_plants$value, "Missing", "")
pot_plants$Group <- str_replace(pot_plants$Group, "potting mix", "pm")

# Check the classes of the arguments of pot_plants and do some conversion
str(pot_plants)
pot_plants$Group <- as.factor(pot_plants$Group)
pot_plants$value <- as.numeric(pot_plants$value)

# Verify the classes 
str(pot_plants)

# Find missing values
sum(is.na(pot_plants))
summary(pot_plants)
indices <- which(is.na(pot_plants$value))
pot_plants[indices, ]

# Remove rows with missing values
pot_plants <- na.omit(pot_plants)

# Spread the columns
pot_plants <- spread(pot_plants, elements, value)

# There is no demonstrably wrong values
# pot_plants2 now is appropriate for analysis
#---------------------------Finish cleaning data---------------------------#

# Select Ti, Ca, Ga, Ba, Zn to analyse
pot_plants <- as.data.frame(pot_plants[,c("Sample,Name", "Group", 
                                          "Ti", "Ca","Ga", "Ba", "Zn")])

# Code for Q1
attach(pot_plants)
table(Group)

# Compute means for each group
mean <- lapply(pot_plants[3:7], function(x){
  aggregate(x, by = list(Group), FUN = mean)})
mean

# Compute sds for each group
sd <- lapply(pot_plants[3:7], function(x){
  aggregate(x, by = list(Group), FUN = sd)})
sd

# Summarise outputs of aov function
sumANOVA <- lapply(pot_plants[3:7], function(x){
  summary(aov(x ~ Group, pot_plants))})
sumANOVA


# Code for Q2
# Calculate the Pearson correlation coefficient between elements
cor(pot_plants[3:7], method = "pearson")

# Test the significance of correlation
cor.test(pot_plants$Ga, pot_plants$Ba)
cor.test(pot_plants$Ga, pot_plants$Zn)
cor.test(pot_plants$Ba, pot_plants$Zn)

# Make plots to visualize the correlation
library(ggplot2)
ggplot(pot_plants) + 
  geom_point(mapping = aes(x = pot_plants$Ba, y = pot_plants$Ga))
ggplot(pot_plants) + 
  geom_point(mapping = aes(x = pot_plants$Ba, y = pot_plants$Zn))
ggplot(pot_plants) + 
  geom_point(mapping = aes(x = pot_plants$Ga, y = pot_plants$Zn))


# Code for Q3
# Make boxplots for Ti and Ca to see the ranges
library(ggplot2)
ggplot(pot_plants) + 
  geom_boxplot(mapping = aes(x = Group, y = pot_plants$Ti))
ggplot(pot_plants) + 
  geom_boxplot(mapping = aes(x = Group, y = pot_plants$Ca))

