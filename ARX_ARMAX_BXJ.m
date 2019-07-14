clear;
close all;
clc;

% For reproducibility
rng(40541,'twister');

season = 's1'; % s2; 
runMdl = 'BXJ'; % ARX, ARMX, BXJ
%% Data preparation

switch season
    case 's1' %ima i 2017
        b_0910=csvread('csv/b_0910_s1.csv');
        b_1011=csvread('csv/b_1011_s1.csv');
        b_1112=csvread('csv/b_1112_s1.csv');
        b_1213=csvread('csv/b_1213_s1.csv');
        b_1314=csvread('csv/b_1314_s1.csv');
        b_1415=csvread('csv/b_1415_s1.csv');
        b_1516=csvread('csv/b_1516_s1.csv');
        b_1617=csvread('csv/b_1617_s1.csv');
        %b_17=csvread('csv/b_17_s1.csv');


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
                 %b_17(:,1:2)
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
        
    case 's2' %NEMA 2017
        
        b_0910=csvread('csv/b_0910_s2.csv');
        b_1011=csvread('csv/b_1011_s2.csv');
        b_1112=csvread('csv/b_1112_s2.csv');
        b_1213=csvread('csv/b_1213_s2.csv');
        b_1314=csvread('csv/b_1314_s2.csv');
        b_1415=csvread('csv/b_1415_s2.csv');
        b_1516=csvread('csv/b_1516_s2.csv');
        b_1617=csvread('csv/b_1617_s2.csv');
        


        dataLength = zeros(1,8);
        dataLength(1) = length(b_0910);
        dataLength(2) = length(b_1011);
        dataLength(3) = length(b_1112);
        dataLength(4) = length(b_1213);
        dataLength(5) = length(b_1314);
        dataLength(6) = length(b_1415);
        dataLength(7) = length(b_1516);
        dataLength(8) = length(b_1617);
        

        dataset=[b_0910
                 b_1011
                 b_1112
                 b_1213
                 b_1314
                 b_1415
                 b_1516
                 b_1617
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
end

%Create test set
datJ = detrend([y_test XX_test]);   %NEED TO PERFORM DETREND!!
test_set_id  = iddata(datJ(:,1),datJ(:,2));


%% Model parameters
na=5; %broj polova
nb=5; %broj nula + 1
nk=5; %mrtvo vrijeme
nc=5; %broj konstanti uz ulazni sum
nd=5;
nf=5;


switch runMdl
    case 'ARX'
 %% --------------- ARX model ---------------

        disp('ARX model');

        models_ARX = cell(1,6);
        models_ARX_output = cell(1,6);
        models_ARX_fit = zeros(1,6);

        % For arx models we need train and validation sets only to determine the
        % best structure
        paramsN = struc(1:na,1:nb,1:nk);

        for i=1:6
            i
            N = dataLength(i);
           
            [trainInd,valInd,testInd] = divideblock(N,0.80,0.20,0);
             dat = detrend(dataAll{i});   %NEED TO PERFORM DETREND!!
            dat_train = dat(trainInd,:);
            dat_val = dat(valInd,:);
            XX_train = dat_train(:,1);
            y_train = dat_train(:,end);
            XX_val = dat_train(:,1);
            y_val = dat_train(:,end);

            train_set_id = iddata(y_train,XX_train);
            valid_set_id = iddata(y_val,XX_val);
            
            whole_set_id  = iddata(dat(:,end),dat(:,1));
            
            %Estimate the best ARX model structure for the given season by
            %computing the loss function for each model order combination.
            %The input data is split into estimation/train and validation data sets.
            V = arxstruc(train_set_id,valid_set_id,paramsN);

            %Select the model order with the best fit to the validation data.
            best_order = selstruc(V,0);
            %Estimate an ARX model of the selected order.
            mdl = arx(whole_set_id,best_order);

            models_ARX{i} = mdl;

            %Test on Test set
            
            [model_out,fit,~] = compare(test_set_id, models_ARX{i});

            models_ARX_output{i} = model_out;
            models_ARX_fit(i) = fit;
        end

        %Determine overall best model
        [max_fit,max_idx] = max(models_ARX_fit(:));
        %determine coordinates of max fit
        %[i_max, j_max]=ind2sub(size(models_ARX_fit),max_idx);

        %best_ARX_mdl = models_ARX{max_idx};
        %x=detrend([dataAll{7}(:,1)' dataAll{8}(:,1)']');
        %y=detrend([dataAll{7}(:,end)' dataAll{8}(:,end)']');
        
        for i=1:length(models_ARX)
            Predicted_by_model = models_ARX{i};
            figure
            compare(test_set_id,Predicted_by_model);
            title(sprintf('ARX model - trained on season %i',i))
         
        end
   
        sprintf('Best model is trained on season %i',max_idx)
        
    case 'ARMX'
        %% --------------- ARMAX model ---------------

        disp('ARMAX model')

        models_ARMAX = cell(1,6);
        models_ARMAX_output = cell(1,6);
        models_ARMAX_fit = zeros(1,6);    

        %For each season determine the best model structure
        for d=1:6
            d
            N = dataLength(d);
            [trainInd,valInd,testInd] = divideblock(N,0.80,0.20,0);
            dat = detrend(dataAll{d});   %NEED TO PERFORM DETREND!!
            dat_train = dat(trainInd,:);
            dat_val = dat(valInd,:);
            XX_train = dat_train(:,1);
            y_train = dat_train(:,end);
            XX_val = dat_train(:,1);
            y_val = dat_train(:,end);

            train_set_id = iddata(y_train,XX_train);
            valid_set_id = iddata(y_val,XX_val);

            whole_set_id  = iddata(dat(:,end),dat(:,1));

            step=1;
            armax_result=zeros(5,na*nb*nc*nk);
            for i=1:na
                for j=1:nb
                    for k=1:nc
                        for range=1:nk
                            armax_model=armax(train_set_id,[i j k range]);
                            [~,fit,~]=compare(valid_set_id,armax_model);
                            armax_result(:,step)=[fit i j k range]';
                            step=step+1;
                        end
                    end
                end
            end

            %Get best order for ARMAX for a given season
            [~,maxIndex]=max(armax_result(1,:));
            best_order= armax_result(2:end,maxIndex)';
            %Estimate an ARMAX model of the selected order.
            mdl = armax(whole_set_id,best_order);

            models_ARMAX{d} = mdl;

            %Test on test set
            
            [model_out,fit,~] = compare(test_set_id, models_ARMAX{d});

            models_ARMAX_output{d} = model_out;
            models_ARMAX_fit(d) = fit;
        end

        [max_fit,max_idx] = max(models_ARMAX_fit(:));
%         %Determine overall best model
%         best_ARMAX_mdl = models_ARMAX{max_idx};
%         x=detrend([dataAll{7}(:,1)' dataAll{8}(:,1)']');
%         y=detrend([dataAll{7}(:,end)' dataAll{8}(:,end)']');
        for i=1:length(models_ARMAX)
            Predicted_by_model = models_ARMAX{i};
            figure
            compare(test_set_id,Predicted_by_model);
            title(sprintf('ARMAX model - trained on season %i',i))
        end
        sprintf('Best model is trained on season %i',max_idx)

    case 'BXJ'
        disp('Box-Jenkins model')
    
        models_BJ = cell(1,6);
        models_BJ_output = cell(1,6);
        models_BJ_fit = zeros(1,6);    
        
        for d=1:6
            d
            N = dataLength(d);
            [trainInd,valInd,testInd] = divideblock(N,0.80,0.20,0);
            dat = detrend(dataAll{d});   %NEED TO PERFORM DETREND!!
            dat_train = dat(trainInd,:);
            dat_val = dat(valInd,:);
            XX_train = dat_train(:,1);
            y_train = dat_train(:,end);
            XX_val = dat_train(:,1);
            y_val = dat_train(:,end);

            train_set_id = iddata(y_train,XX_train);
            valid_set_id = iddata(y_val,XX_val);

            whole_set_id  = iddata(dat(:,end),dat(:,1));

            step=1;
            bj_result=zeros(6,nb*nc*nd*nf*nk);
            for i=1:nb
                for j=1:nc
                    for k=1:nd
                        for range=1:nf
                            for m=1:nk
                                bj_model=bj(train_set_id,[i j k range m]);
                                [~,fit,~]=compare(valid_set_id,bj_model);
                                bj_result(:,step)=[fit i j k range m]';
                                step=step+1;
                            end
                        end
                    end
                end
            end
        
            %Get best order for BJ for a given season
            [~,maxIndex]=max(bj_result(1,:));
            best_order= bj_result(2:end,maxIndex)';
            %Estimate an BJ model of the selected order.
            mdl = bj(whole_set_id,best_order);

            models_BJ{d} = mdl;

            %Test on test set
            [~,maxIndex]=max(bj_result(1,:));
            best_order= bj_result(2:end,maxIndex)';
            %Estimate an ARMAX model of the selected order.
            mdl = bj(whole_set_id,best_order);

            models_BJ{d} = mdl;

            %Test on test set
            [model_out,fit,~] = compare(test_set_id, models_BJ{d});

            models_BJ_output{d} = model_out;
            models_BJ_fit(d) = fit;
        end
        
         [max_fit,max_idx] = max(models_BJ_fit(:));
%         %Determine overall best model
%         best_BJ_mdl = models_BJ{max_idx};
%         x=detrend([dataAll{7}(:,1)' dataAll{8}(:,1)']');
%         y=detrend([dataAll{7}(:,end)' dataAll{8}(:,end)']');
        for i=1:length(models_BJ)
             Predicted_by_model = models_BJ{i};
            figure
            compare(test_set_id,Predicted_by_model);
            title(sprintf('BJ model - trained on season %i',i))
        end
        sprintf('Best model is trained on season %i',max_idx)
end