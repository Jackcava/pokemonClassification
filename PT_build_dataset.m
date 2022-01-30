clear all;
close all;
clc;

path1 = 'resources\ERBA';
path2 = 'resources\ACQUA';
path3 = 'resources\FUOCO';

% Get list of all BMP files in this directory
% DIR returns as a structure array.  You will need to use () and . to get
% the file names.
% imagefiles = dir(pathR); 
imagefiles1 = dir(path1); 
imagefiles2 = dir(path2); 
imagefiles3 = dir(path3); 
nfiles1 = length(imagefiles1);    % Number of files found
nfiles2 = length(imagefiles2);
nfiles3 = length(imagefiles3);

for ii=3:nfiles1
   currentfilename = imagefiles1(ii).name;
   currentimage = im2double(imread(strcat(path1,'\',currentfilename)));
   i = ii-2;
   images1{i,1} = currentimage;
   
   %padding
   num_ints = 150;
   [m,n,c] = size(images1{i,1});
   interv1{i,1} = floor(m / num_ints);
   newdim{i,1} = interv1{i,1}*num_ints;
   border{i,1} = ( m - newdim{i,1} ) / 2;
   im1{i,1} = zeros(m-(2*border{i,1}),m-(2*border{i,1}));
   for can=1:3
       im1{i,1}(:,:,can) = images1{i,1}(1+border{i,1}:end-border{i,1},1+border{i,1}:end-border{i,1},can);
   end
end

for ii=3:nfiles2 
   currentfilename = imagefiles2(ii).name;
   currentimage = im2double(imread(strcat(path2,'\',currentfilename)));
   i = ii-2;
   images2{i,1} = currentimage;
   
   %padding
   num_ints = 150;
   [m,n,c] = size(images2{i,1});
   interv2{i,1} = floor(m / num_ints);
   newdim{i,1} = interv2{i,1}*num_ints;
   border{i,1} = ( m - newdim{i,1} ) / 2;
   im2{i,1} = zeros(m-(2*border{i,1}),m-(2*border{i,1}));
   for can=1:3
       im2{i,1}(:,:,can) = images2{i,1}(1+border{i,1}:end-border{i,1},1+border{i,1}:end-border{i,1},can);
   end
end

for ii=3:nfiles3 
   currentfilename = imagefiles3(ii).name;
   currentimage = im2double(imread(strcat(path3,'\',currentfilename)));
   i = ii-2;
   images3{i,1} = currentimage;
   
   %padding
   num_ints = 100;
   [m,n,c] = size(images3{i,1});
   interv3{i,1} = floor(m / num_ints);
   newdim{i,1} = interv3{i,1}*num_ints;
   border{i,1} = ( m - newdim{i,1} ) / 2;
   im3{i,1} = zeros(m-(2*border{i,1}),m-(2*border{i,1}));
   for can=1:3
       im3{i,1}(:,:,can) = images3{i,1}(1+border{i,1}:end-border{i,1},1+border{i,1}:end-border{i,1},can);
   end
end

num_obj1 = size(images1,1);
for i=1:num_obj1
    for j=1:3
        for range=1:num_ints
            if range==1
                dataset(i,j*range) = mean(mean(im1{i,1}(1:interv1{i,1},1:interv1{i,1},j)));
            else
                dataset(i,j*range) = mean(mean(im1{i,1}((range-1)*interv1{i,1}:range*interv1{i,1},(range-1)*interv1{i,1}:range*interv1{i,1},j)));
            end
        end
    end
end

num_obj2 = size(images2,1);
for i=1:num_obj2
    for j=1:3
        for range=1:num_ints
            if range==1
                dataset(i+num_obj1,j*range) = mean(mean(im2{i,1}(1:interv2{i,1},1:interv2{i,1},j)));
            else
                dataset(i+num_obj1,j*range) = mean(mean(im2{i,1}((range-1)*interv2{i,1}:range*interv2{i,1},(range-1)*interv2{i,1}:range*interv2{i,1},j)));
            end
        end
    end
end

num_obj3 = size(images3,1);
for i=1:num_obj3
    for j=1:3
        for range=1:num_ints
            if range==1
                dataset(i+num_obj1+num_obj2,j*range) = mean(mean(im3{i,1}(1:interv3{i,1},1:interv3{i,1},j)));
            else
                dataset(i+num_obj1+num_obj2,j*range) = mean(mean(im3{i,1}((range-1)*interv3{i,1}:range*interv3{i,1},(range-1)*interv3{i,1}:range*interv3{i,1},j)));
            end
        end
    end
end


col = 0;
for c = 1:length(dataset)
%     dataset_filtered = dataset;
%     if mean(dataset(:,c),1)~=0 && mean(dataset(:,c),1)~=1
    if mean(dataset(:,c),1)>0.1 && mean(dataset(:,c),1)<0.9 %more stringent
        col = col + 1;
        dataset_filtered(:,col) = dataset(:,c);
    end
end

dataset_filtered(1:num_obj1,length(dataset_filtered)+1) = 1;
dataset_filtered(num_obj1+1:num_obj1+num_obj2,length(dataset_filtered)) = 2;
dataset_filtered(num_obj1+num_obj2+1:num_obj1+num_obj2+num_obj3,length(dataset_filtered)) = 3;

all_images = [images1;images2;images3];

save('Dataset.mat','dataset_filtered','all_images');
    
