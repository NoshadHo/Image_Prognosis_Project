#############################################################################################################################
## Author: Noshad Hosseini
## Start Date: 5-31-2019
## End Date:
## Subject: Converting categorical clinical data (TCGA Patients) into usable data by nueral nets (using one hot encoding)
#############################################################################################################################

#here we assume we have the data output from PostProcessing.R
#we are only going to use final_data_file image Id's

#libraries:
library(tidyverse)
library(mlr)
library(rlang)
#read the clinical data file:
clinical = readxl::read_xlsx("/scratch/lgarmire_fluxm/noshadh/Top_dense_10_Stanford_method/mmc1 (1).xlsx",
                             col_names = TRUE)

#first remove NA and Not-applicable columns
clinical = clinical %>% select(-!!1) #remove first column
#turn all the [Not Available] to NA
clinical2 = clinical %>% mutate_all(str_replace(.,'[Not Available]','NA'))
clinical = clinical %>% select()

#do the one hot encoding
clinical_OHE = clinical %>% mutate_if(is.character,as.factor) %>% 
  createDummyFeatures(method = 'refrence')

#write
