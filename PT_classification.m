function [acc,asl] = PT_classification(X,Y,cl)

% cls_name{1} = '1nn';
% cls_name{2} = 'knn(opt K)';
% cls_name{3} = 'linear svm';
% cls_name{4} = 'gaussian svm';
% cls_name{5} = 'RF-50';
% cls_name{6} = 'RF-100';
% cls_name{7} = 'RF-150';
% cls_name{8} = 'RF-200';
% cls_name{9} = 'nmc';
% cls_name{10} = 'ldc';

nclas = length(unique(Y));
objs = size(X,1);
asl = zeros(objs,1);

prwaitbar off;

for i=1:objs
    i
    Xtr = X;
    Xtr(i,:) = [];
    Ytr = Y;
    Ytr(i) = [];
    Xte = X(i,:);
    
    switch cl
        case 1  %1nn
            Mdl = fitcknn(Xtr,Ytr,'NumNeighbors',1);
            asl(i) = predict(Mdl,Xte);
            
        case 2  %knn optimized
%             if mod(i,5) == 0
%                 fprintf('%d/%d\n',i,nel), end
            Mdl = fitcknn(Xtr,Ytr,'OptimizeHyperparameters','NumNeighbors','HyperparameterOptimizationOptions',struct('ShowPlots',false,'verbose',0));
            asl(i) = predict(Mdl,Xte);
            
        case 3  %svm linear
            Mdl = fitcsvm(Xtr,Ytr,'KernelFunction','linear','KernelScale','auto');
            asl(i) = predict(Mdl,Xte);
            
        case 4  %svm gaussian
            Mdl = fitcsvm(Xtr,Ytr,'KernelFunction','gaussian','KernelScale','auto');
            asl(i) = predict(Mdl,Xte);
            
        case {5,6,7,8} % Random Forests
            if cl == 5
                ntrees = 50;
            elseif cl == 6
                ntrees = 100;
            elseif cl == 7
                ntrees = 150;
            else
                ntrees = 200;
            end
            Mdl = TreeBagger(ntrees,Xtr,Ytr,'OOBPrediction','On','Method','classification');
            aa = predict(Mdl,Xte);
            asl(i) = str2num(aa{1});   
                
            case {9,10}
                TR = prdataset(Xtr,Ytr);
                TE = prdataset(Xte);
                switch cl
                    case 9
                        w = nmc(TR);
                    case 10
                        w = ldc(TR,1e-6)*logdens;
                end
                asl(i) = TE*w*labeld;
    end
    close all;
end
acc = sum(asl == Y)./objs;


end