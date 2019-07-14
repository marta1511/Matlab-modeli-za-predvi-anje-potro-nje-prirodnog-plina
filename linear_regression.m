clear;
close all;
clc;

%% Data preparation

tic
b_0910=csvread('csv/b_0910.csv');
b_1011=csvread('csv/b_1011.csv');
b_1112=csvread('csv/b_1112.csv');
b_1213=csvread('csv/b_1213.csv');
b_1314=csvread('csv/b_1314.csv');
b_1415=csvread('csv/b_1415.csv');
b_1516=csvread('csv/b_1516.csv');
b_1617=csvread('csv/b_1617.csv');
%b_17=csvread('csv/b_17.csv');
toc

dataLength = zeros(1,8);
dataLength(1) = length(b_0910);
dataLength(2) = length(b_1011);
dataLength(3) = length(b_1112);
dataLength(4) = length(b_1213);
dataLength(5) = length(b_1314);
dataLength(6) = length(b_1415);
dataLength(7) = length(b_1516);
dataLength(8) = length(b_1617);
%dataLength(9) = length(b_17);


dataset=[b_0910
         b_1011
         b_1112
         b_1213
         b_1314
         b_1415
         b_1516
         b_1617
        % b_17
];

dataCnt=length(dataLength)+1;
dataAll = cell(1,dataCnt);
database=standardizeData(dataset);

iStart = 1;
iEnd = dataLength(1);
for i = 1:length(dataLength)
    dataAll{i} = database(iStart:iEnd,:);
    iStart = iEnd + 1;
    if(i<length(dataLength))
        iEnd = iEnd + dataLength(i+1);
    end
end

dataAll{dataCnt} = database;

     

        XX_test = [dataAll{7}(:,1) 
                   dataAll{8}(:,1)];
        y_test = [dataAll{7}(:,end)
                  dataAll{8}(:,end)];
        
   

%% 1. Linear regression
% There is no need to use stepwise linear regression if there is only one
% predictor variable!!
        disp('Linear Regression');
        models_LR = cell(1,dataCnt);
        models_LR_output = cell(dataCnt,dataCnt);
        models_LR_fit = zeros(dataCnt,dataCnt);

        % create models for each season separately and test on the whole dataset
        for i=1:dataCnt
            if i<dataCnt
                XX_train = dataAll{i}(:,1);
                y_train = dataAll{i}(:,end);
            else
                validIndex=floor(length(dataAll{i}(:,1))*0.8);
                XX_train = dataAll{i}(1:validIndex,1);
                y_train = dataAll{i}(1:validIndex,end);               
            end
            mdl = fitlm(XX_train,y_train);

            models_LR{i} = mdl;

            for j = 1:dataCnt
                if j<dataCnt
                    XX_test = dataAll{j}(:,1);
                    y_test = dataAll{j}(:,end);
                else
                    validIndex=floor(length(dataAll{i}(:,1))*0.8);
                    XX_train = dataAll{i}(validIndex+1:end,1);
                    y_train = dataAll{i}(validIndex+1:end,end);  
                end

                y_pred = predict(mdl,XX_test);
                %fit=goodnessOfFit(y_pred,y_test,'NRMSE');
                fit = 1-norm(y_test - y_pred)/norm(y_test-mean(y_test));

                models_LR_output{i,j} = y_pred;
                models_LR_fit(i,j) = fit;
            end

        end

        %Determine overall best model
        [max_fit,max_idx] = max(models_LR_fit(:));
        %determine coordinates of max fit
        [i_max, j_max]=ind2sub(size(models_LR_fit),max_idx);

        best_LR_mdl = models_LR{i_max};

        %plot for best seasson
        %figure;
        %hold on;
        %plot(dataAll{j_max}(:,end),'b');
        %plot(models_LR_output{i_max,j_max},'r');
        %title(sprintf('LR model - tested on best season(%i)',j_max));
        %legend('Actual data',sprintf('Predicted by the model=%.2f%%',models_LR_fit(i_max,j_max)*100));
        %hold off;
        
        %plot for whole dataset
        validIndex=floor(length(dataAll{i}(:,1))*0.8);
        y_pred = predict(models_LR{end},dataAll{end}(validIndex+1:end,1));
        figure;
        hold on;
        plot(dataAll{end}(validIndex+1:end,end),'b');
        plot(y_pred,'r');
        title('LR model - tested on whole dataset');
        legend('Actual data',sprintf('Predicted by the model=%.2f%%',goodnessOfFit(y_pred,dataAll{end}(validIndex+1:end,end),'NRMSE')*100));
        hold off;