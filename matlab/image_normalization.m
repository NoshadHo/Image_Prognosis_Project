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
    fileName = dirname(1);  %we use first file as the refrence file
    %set the image path
    scratch = strcat('/scratch/lgarmire_fluxm/noshadh/Diagnostic_Slide_images/', fileName, '/');
    cd(string(scratch));
    svsFile = dir('*.svs');
    filename = svsFile(1).name;
    tic             %to measure how long does it take to load the image
    image = imread(filename);
    toc
%% Normalize one sample -> extend it to all samples

%% Save the normalized images
%% Plot distribution of colors for each channel, after and befor normalization
