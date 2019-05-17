library(tidyverse)
library(haven)

setwd('/scratch/lgarmire_fluxm/noshadh/Top_dense_10_Stanford_method/')


nuclei = read_tsv("/scratch/lgarmire_fluxm/noshadh/Top_dense_10_Stanford_method/dense_10FilteredNuclei.txt")
nuclei_backup = nuclei


#remove na's
nuclei_clean = na.omit(nuclei)
#take the mean, median, std, min, max over all the cells within a tile

#mean
ptm = proc.time()
print("mean")
nuclei_tile_mean = nuclei_clean %>% group_by(ImageNumber) %>% summarise_all(mean)
print(proc.time()- ptm)
#median
ptm = proc.time()
print("median")
nuclei_tile_median = nuclei_clean %>% group_by(ImageNumber) %>% summarise_all(median)
print(proc.time()- ptm)
#sd
ptm = proc.time()
print("sd")
nuclei_tile_sd = nuclei_clean %>% group_by(ImageNumber) %>% summarise_all(sd)
print(proc.time()- ptm)
#min
ptm = proc.time()
print("min")
nuclei_tile_min = nuclei_clean %>% group_by(ImageNumber) %>% summarise_all(min)
print(proc.time()- ptm)
#max
ptm = proc.time()
print("max")
nuclei_tile_max = nuclei_clean %>% group_by(ImageNumber) %>% summarise_all(max)
print(proc.time()- ptm)

#remove the na's
nuclei_tile_mean = na.omit(nuclei_tile_mean)
nuclei_tile_median = na.omit(nuclei_tile_median)
nuclei_tile_sd = na.omit(nuclei_tile_sd)
nuclei_tile_min = na.omit(nuclei_tile_min)
nuclei_tile_max = na.omit(nuclei_tile_max)


#check which tiles has been removed (due to na omits)
full_list = as.vector(1:3130) # full list should be from 1 to 3130
tile_list = as.vector(nuclei_tile_mean$ImageNumber)
deleted_tiles = setdiff(full_list,tile_list)

#set the column names  (Add whether they are from mean or median or ...)
colnames(nuclei_tile_mean) = paste("Mean_",colnames(nuclei_tile_mean),sep = "")
colnames(nuclei_tile_median) = paste("Median_",colnames(nuclei_tile_median),sep = "")
colnames(nuclei_tile_sd) = paste("Sd_",colnames(nuclei_tile_sd),sep = "")
colnames(nuclei_tile_min) = paste("Min_",colnames(nuclei_tile_min),sep = "")
colnames(nuclei_tile_max) = paste("Max_",colnames(nuclei_tile_max),sep = "")
#remove mean,median,... from the image number. It is our ID you idiot :|
colnames(nuclei_tile_mean)[1] = "ImageNumber"
colnames(nuclei_tile_median)[1] = "ImageNumber"
colnames(nuclei_tile_sd)[1] = "ImageNumber"
colnames(nuclei_tile_min)[1] = "ImageNumber"
colnames(nuclei_tile_max)[1] = "ImageNumber"


#merge these files together
nuclei_tile = left_join(nuclei_tile_mean,nuclei_tile_median, by = "ImageNumber")
nuclei_tile = left_join(nuclei_tile,nuclei_tile_sd, by = "ImageNumber")
nuclei_tile = left_join(nuclei_tile,nuclei_tile_min, by = "ImageNumber")
nuclei_tile = left_join(nuclei_tile,nuclei_tile_max, by = "ImageNumber")

#index the samples
# Sample Orders:
# 100 -> 109
# 10
# 110 -> 119
# 11
# ...

indexes = c(100:105,108:109,10,110:116,118:119,11,121:122,124:129,12,130,132:133,135:138,13,140,143:149,14,150:151,153:159,15,162:167,169,16,170:172,174:176,178,17,182:189,18,190:193,196:199,1,
            200:204,206:209,20,210:212,214:218,21,220:229,230:234,236:239,23,240:246,248:249,24,250:259,25,260:261,263,265,267:269,26,270:272,274,276:279,27,280,282:284,286:289,290:299,29,2,301:309,310:313,315:317,319,31,320,322:323,325:329,32,330:339,33,340:349,34,350:359,35,360:361,363:364,366:367,
            36:39,3,40:46,49,50:54,56:59,60:66,68:69,6,70:79,80:83,85:89,8,90:97,9)

indexes_10x = numeric()
for (id in indexes){
  for (i in 1:10){
    indexes_10x = c(indexes_10x,id)
  }
}

#now remove the deleted tiles from our indexes
indexes_10x = indexes_10x[-deleted_tiles]

#add indexes to the file as a column
nuclei_tile = nuclei_tile %>% mutate(ImageNumber = indexes_10x)

#reshape the matrix to 313 rows
#we take mean,median,max,min,sd
nuclei_sample_mean = nuclei_tile %>% group_by(ImageNumber) %>% summarise_all(mean)
nuclei_sample_median = nuclei_tile %>% group_by(ImageNumber) %>% summarise_all(median)
nuclei_sample_sd = nuclei_tile %>% group_by(ImageNumber) %>% summarise_all(sd)
nuclei_sample_min = nuclei_tile %>% group_by(ImageNumber) %>% summarise_all(min)
nuclei_sample_max = nuclei_tile %>% group_by(ImageNumber) %>% summarise_all(max)

#change the name
#set the column names  (Add whether they are from mean or median or ...)
colnames(nuclei_sample_mean) = paste("SMean_",colnames(nuclei_sample_mean),sep = "")
colnames(nuclei_sample_median) = paste("SMedian_",colnames(nuclei_sample_median),sep = "")
colnames(nuclei_sample_sd) = paste("SSd_",colnames(nuclei_sample_sd),sep = "")
colnames(nuclei_sample_min) = paste("SMin_",colnames(nuclei_sample_min),sep = "")
colnames(nuclei_sample_max) = paste("SMax_",colnames(nuclei_sample_max),sep = "")
#remove mean,median,... from the image number. It is our ID you idiot :|
colnames(nuclei_sample_mean)[1] = "ImageNumber"
colnames(nuclei_sample_median)[1] = "ImageNumber"
colnames(nuclei_sample_sd)[1] = "ImageNumber"
colnames(nuclei_sample_min)[1] = "ImageNumber"
colnames(nuclei_sample_max)[1] = "ImageNumber"

#concatinate all of these together
nuclei_sample = left_join(nuclei_sample_mean,nuclei_sample_median, by = "ImageNumber")
nuclei_sample = left_join(nuclei_sample,nuclei_sample_sd, by = "ImageNumber")
nuclei_sample = left_join(nuclei_sample,nuclei_sample_min, by = "ImageNumber")
nuclei_sample = left_join(nuclei_sample,nuclei_sample_max, by = "ImageNumber")

#Write the file
setwd('/scratch/lgarmire_fluxm/noshadh/Top_dense_10_Stanford_method/')
write_tsv(nuclei_sample, "/scratch/lgarmire_fluxm/noshadh/Top_dense_10_Stanford_method/FilteredNuclei_sample.tsv", col_names = TRUE)
