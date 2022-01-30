clear all;
close all;
clc;

load('Dataset.mat');
dataset = dataset_filtered;
[objs,feats] = size(dataset);
X = dataset(:,1:feats-1);
Y = dataset(:,feats);

cl = [7];
l = length(cl);

for c = 1:l
    [acc(c),asl(c,:)] = PT_classification(X,Y,cl(c));
end

acc

figure;
rows = 3;
cols = objs;
count1 = 0;
count2 = 0;
count3 = 0;
it = 0;
for a = asl
    it = it+1;
    if a==1
        count1 = count1 + 1;
        if count1 == 1
            ylab = 'ERBA';
            flag = true;
        end
        num = ( (a-1)*objs ) + count1;
    elseif a==2
        count2 = count2 + 1;
        if count2 == 1
            ylab = 'ACQUA';
            flag = true;
        end
        num = ( (a-1)*objs ) + count2;
    else
        count3 = count3 + 1;
        if count3 == 1
            ylab = 'FUOCO';
            flag = true;
        end
        num = ( (a-1)*objs ) + count3;
    end
    subplot(rows,cols,num);imshow(all_images{it,1});
    if flag == true
        ylabel(ylab);
        flag = false;
    end
end

max_acc = min(find(acc==max(acc)));
rows = 4;
figure(2);
ims1 = find(asl(max_acc,:)==1);
it = 0;
for i=ims1
    it = it+1;
    subplot(rows,ceil(length(ims1)/rows),it);imshow(all_images{i,:});
    sgtitle('ERBA');
end

figure(3);
ims2 = find(asl(max_acc,:)==2);
it = 0;
for i=ims2
    it = it+1;
    subplot(rows,ceil(length(ims2)/rows),it);imshow(all_images{i,:});
    sgtitle('ACQUA');
end

figure(4);
ims3 = find(asl(max_acc,:)==3);
it = 0;
for i=ims3
    it = it+1;
    subplot(rows,ceil(length(ims3)/rows),it);imshow(all_images{i,:});
    sgtitle('FUOCO');
end
