library(tidyverse)  # data manipulation
library(cluster)    # clustering algorithms
library(factoextra) # clustering algorithms & visualization
library(ggplot2)
data = read_csv("C:/Users/noshadh/Desktop/500Chosen/CelProfiler_Nuclei.csv")

data_clean = na.omit(data) #removing NAs



#aggregate the cells
data_tile = data_clean %>% group_by(ImageNumber) %>% summarise_all(mean)

#removing identifiers
data_tile = data_tile %>% select(-ImageNumber,
                                   -AreaShape_EulerNumber,
                                   -Number_Object_Number)


#save the colnames
col_names = colnames(data_tile)

#Standarization
data_tile = scale(data_tile)

#convert back to dataframe
data_tile = as.data.frame(data_tile)
colnames(data_tile) = col_names


#find the distances
euci_dist = get_dist(data_tile)

#ploting the heatmap
fviz_dist(euci_dist)

#kmeans
k = kmeans(data_tile,centers = 3, nstart = 500)

#plot the clusters
fviz_cluster(k, data = data_tile) + theme_minimal()




#temp
data_tile = data_tile %>% mutate(cluster = k$cluster)
data_tile %>% filter(cluster == 239)
data_tile %>% group_by(cluster) %>% summarise(n())


#optimal number of clustering
set.seed(1024)

fviz_nbclust(data_tile, kmeans, method = "wss")

gap_stat <- clusGap(data_tile, FUN = kmeans, nstart = 100,
                    K.max = 10, B = 50)
fviz_gap_stat(gap_stat)


#QC
#1: The number of cells in each cluster:
data_tile %>% group_by(cluster) %>% 
  summarise(sum(ObjectNumber))














