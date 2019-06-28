%Noshad Hosseini
%10/18/2018
%Now that we have the tiles of each image, we have to choose the top 10
%most dense ones, so hopefully they have more cells and more data into them
%step2

%we have enough ram, so we will load all the tiles, and compare them all
%together, hope to do so in O(nlogn)


%image = imread('/home/noshadh/Desktop/pathologyImages/5ba8307e-1485-4b5c-a596-2eb07f355d5f/TilesLab/1.tiff');



%this is not good for timing, lets do other approaches
%

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
    

fileNum = size(dirname,2);
%temprory, we only process the first 217 samples, we are waiting for the
%rest to be ready, next we will process 218 to fileNum
%fileNum = 300;
fileName = dirname(1);
for k = 1:fileNum
    try
        tic
        disp __________________________________
        disp(k);
        disp(strcat('start time: ', string(datetime('now'))));
        fileName = string(dirname(k));
        %set the image path
        scratch = strcat('/scratch/lgarmire_fluxm/noshadh/Diagnostic_Slide_images/', fileName, '/');
        cd(string(scratch));
        cd Tiles_Normalized_2/

        %{
        %make the 5,10,15,...,50 file directories
        i = 5;
        while i < 55
           mkdir(strcat('Dense_', num2str(i)));
           i = i + 5;
        end
        %}
        %make 20 file directory

        tilesNum = size(dir('*.tiff'),1);
        imageMap = containers.Map;
        sums  = zeros(1,tilesNum);
        fileList = dir;
        fname = {fileList.name};
        fname = fname(~ismember(fname,{'.','..'}));
        for i= 1:tilesNum
            fileAddress = char(fname(i));
            file = imread(fileAddress);
            temp1 = sum(file, 3);
            temp2 = sum(temp1, 2);
            sums(i) = sum(temp2, 1);
            %disp(sums);
            color_sums = sum(sum(file,1),2);
            imageMap(num2str(sums(i))) = file;
        end


        mkdir(strcat('Dense_10_', string(fileName)));
        sortIm = sort(sums);
        selectionNum = 10;  
        %for selectionNum = 5:5:50
        
        disp("here")
        if tilesNum > selectionNum
            for i = 1:selectionNum
                if sortIm(i) ~= 0
                    %slide id + TCGA Id + slideNumber
                    folder = strcat('Dense_10_', string(fileName),'/');
                    fileAddress = strcat('./', folder,num2str(k),'_', string(fileName), '_', num2str(i - (selectionNum)),'.tiff');
                    imwrite(imageMap(num2str(sortIm(i))), char(fileAddress));
                    %imwrite(imageMap(num2str(sortIm(i))), sprintf('/scratch/lgarmire_fluxm/noshadh/Diagnostic_Slide_images/Dense20/%d_%s_%d.tiff',k,string(fileName),i));
                else
                    fprintf("*****************")
                    disp(dirname(i))
                end
            end
        %end
        end
        toc
    catch ME
        ME
        disp("in catch!!!!!!!!!!!!!!!!!!!!!!!!!")
       continue; 
    end
end

%{
tic
path = '/home/noshadh/Desktop/pathologyImages/5ba8307e-1485-4b5c-a596-2eb07f355d5f/TilesLab/';
imageMap = containers.Map;
sums  = zeros(1,31);
for i= 1:31
    filename = strcat(path, num2str(i), '.tiff');
    file = imread(filename);
    
    temp1 = sum(file, 3);
    temp2 = sum(temp1, 2);
    sums(i) = sum(temp2, 1);
    disp(i);
    disp(sums);
    imageMap(num2str(sums(i))) = file;
end


sortIm = sort(sums);

for i = 1:31
    filename = strcat(path, 'S', num2str(i),'.tiff');
    %imwrite(imageMap(num2str(sortIm(i))), filename);
end


toc
%}

