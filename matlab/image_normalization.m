%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Author: Noshad Hosseini                                                         %%
%%Start Date: 06-07-2019                                                          %%
%%End Date:                                                                       %%
%%Subject: Using one picture color combination, normalize other images ...        %%
%%...based on that color distribution, we do it for each channel individually     %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load the refrence image and seperate the channels

%get a list of files
    cd /scratch/lgarmire_fluxm/noshadh/Diagnostic_Slide_images/
    files = dir;
    dirname = {files([files.isdir]).name};
    dirname = dirname(~ismember(dirname,{'.','..'}));
    %remember to remove 3 directory from the list:
    %   missed_images   ->369
    %   Dense_10_tiles  ->220
    %   Dense20         ->219
    dirname(369) = [];
    dirname(220) = [];
    dirname(219) = [];
    fileNum = size(dirname,2);
    
%load the refrence file
    fileName = dirname(2);  %we use first file as the refrence file
    %set the image path
    scratch = strcat('/scratch/lgarmire_fluxm/noshadh/Diagnostic_Slide_images/', fileName, '/');
    cd(string(scratch));
    svsFile = dir('*.svs');
    filename = svsFile(1).name;
    tic             %to measure how long does it take to load the image
    image = imread(filename);
    toc
    image_red =     image(:,:,1);
    image_green =   image(:,:,2);
    image_blue =    image(:,:,3);
%% Normalize one sample -> extend it to all samples
    %read the second image to normalize:
    fileName = dirname(17);  %we use first file as the refrence file
    %set the image path
    scratch = strcat('/scratch/lgarmire_fluxm/noshadh/Diagnostic_Slide_images/', fileName, '/');
    cd(string(scratch));
    svsFile = dir('*.svs');
    filename = svsFile(1).name;
    tic             %to measure how long does it take to load the image
    image_2 = imread(filename);
    toc
    image_2_gray = rgb2gray(image_2);
    image_red_2 =     image_2(:,:,1);
    image_green_2 =   image_2(:,:,2);
    image_blue_2 =    image_2(:,:,3);
    
    %use scale normalization by mean
    %ref image means
    image_red_mean = mean2(image_red);
    image_green_mean = mean2(image_green);
    image_blue_mean = mean2(image_blue);
    
    %case image means
    image_red_2_mean = mean2(image_red_2);
    image_green_2_mean = mean2(image_green_2);
    image_blue_2_mean = mean2(image_blue_2);
    
    image_red_2_temp = image_red_2 * (image_red_mean/image_red_2_mean);
    image_green_2_temp = image_green_2 * (image_green_mean/image_green_2_mean);
    image_blue_2_temp = image_blue_2 * (image_blue_mean/image_blue_2_mean);
    
    image_2_temp(:,:,1) = image_red_2_temp;
    image_2_temp(:,:,2) = image_green_2_temp;
    image_2_temp(:,:,3) = image_blue_2_temp;
%% Save the normalized images
%% Plot distribution of colors for each channel, after and befor normalization
