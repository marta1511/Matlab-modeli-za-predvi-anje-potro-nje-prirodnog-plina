clear all;
close all;
clc;

noNeurons=10;

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

dataset=[standardizeData(b_0910,2)
         standardizeData(b_1011,2)
         standardizeData(b_1112,2)
         standardizeData(b_1213,2)
         standardizeData(b_1314,2)
         standardizeData(b_1415,2)
         standardizeData(b_1516,2)
         standardizeData(b_1617,2)
%          standardizeData(b_17,2)
];
range=[ceil(size(dataset,1)*0.8),ceil(size(dataset,1)*0.8)];
train_set=dataset(1:range(1),:);
%valid_set=dataset(range(1):range(2),:);
test_set=dataset(range(2):end,:);


%------------ ANN -----------
actList = {'purelin','softmax','tansig','logsig'};
ann_result=zeros(3,noNeurons*length(actList));
ann_models=cell(1,noNeurons*length(actList));
step=1;

for i=1:noNeurons
    for j=1:length(actList)
        ann = feedforwardnet(i,'trainlm');
        ann.trainParam.showWindow=false;
        ann.layers{1}.transferFcn=actList{j};
        net=train(ann,train_set(:,1)',train_set(:,end)');
        y_ann=net(test_set(:,1)');
        ann_result(:,step)=[goodnessOfFit(y_ann',test_set(:,end),'NRMSE') i j]';
        ann_models{step}=net;
        step=step+1;
    end
end

[~,maxIndex]=max(ann_result(1,:));
ann=ann_models{maxIndex};
y_ann=ann(test_set(:,1)');

figure
hold on
plot(test_set(:,end),'r');
plot(y_ann,'b');
hold off
title('ANN model');
legend('Test set',sprintf("Predicted by model=%.2f%%",ann_result(1,maxIndex)*100));

fprintf("Best ANN parameters:\n")
fprintf("- No of Neurons: %i\n",ann_result(2,maxIndex));
fprintf("- Activation fcn: %s\n",actList{ann_result(3,maxIndex)});

