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
    image_ref = imread(filename);
    toc
    image_ref_red =     image(:,:,1);
    image_ref_green =   image(:,:,2);
    image_ref_blue =    image(:,:,3);
    
    %ref image means
    image_ref_red_mean = mean2(image_red);
    image_ref_green_mean = mean2(image_green);
    image_ref_blue_mean = mean2(image_blue);
%% Normalize one sample
    %read the second image to normalize:
    fileName = dirname(145);  %we use first file as the refrence file
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
%% Normalize all samples and then Tiling

tic
cd /scratch/lgarmire_fluxm/noshadh/Diagnostic_Slide_images/
files = dir;
dirname = {files([files.isdir]).name};
dirname = dirname(~ismember(dirname,{'.','..'}));

%33 didn't work
fileNum = size(dirname,2);
file = dirname(1);

for k = 218:fileNum
    tic
    disp ___________________
    disp(k);
    disp(strcat('start time: ', string(datetime('now')))); 
    %set the image path
    file = dirname(k);
    scratch = strcat('/scratch/lgarmire_fluxm/noshadh/Diagnostic_Slide_images/', file, '/');
    cd(string(scratch))
    svsFile = dir('*.svs');
    filename = svsFile(1).name;

    %make the Tiles folder
    mkdir Tiles_Normalized
    %Load the Image
    image = imread(filename);
    
    %NORMALIZATION PROCESS
    image_red =     image(:,:,1);
    image_green =   image(:,:,2);
    image_blue =    image(:,:,3);
    
    image_red_mean = mean2(image_red);
    image_green_mean = mean2(image_green);
    image_blue_mean = mean2(image_blue);
    
    image_red_temp = image_red * (image_ref_red_mean/image_red_mean);
    image_green_temp = image_green * (image_ref_green_mean/image_green_mean);
    image_blue_temp = image_blue * (image_ref_blue_mean/image_blue_mean);
    
    image(:,:,1) = image_red_temp;
    image(:,:,2) = image_green_temp;
    image(:,:,3) = image_blue_temp;
    
    %tile up the image
    %each tile is a 1000*1000 pixel image, we will move a 1000*1000 window over all
    %the image and save the tiles
    %while reading the tiles, if they are a part of background, they will be
    %discarded
    counter = 1;
    imageSize = size(image);
    i = 1;
    j = 1;
    while i < imageSize(1,1) - 1000 % i indicate row number
        while j < imageSize(1,2) - 1000 % j is for moving horizontaly on image, we scan row by row
            fprintf("i is %d and j is %d\n",i,j);
            RGBSum = 0;

            wfile = strcat('Tiles_Normalized/', num2str(i), '_', num2str(j), '.tiff');
            tile = image(i:i+1000 ,j:j+1000,:);

            %here we discard the background tile
            %we do so based on the summation of RGB numbers.
            temp1 = sum(tile, 3);
            temp2 = sum(temp1, 2);
            RGBSum = sum(temp2, 1);
             if (RGBSum >= 460000000)
                 j = j + 1000;
                 continue
             end

            imwrite(tile(:,:,1:3),wfile);
            j = j + 1000;
            
            counter = counter + 1;
        end
        i = i + 1000;
        j = 1;
    end
    toc
   
end


toc
%% Save the normalized images
%% Plot distribution of colors for each channel, after and befor normalization
