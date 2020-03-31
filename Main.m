%Created by Achyutuni Aravinda Karthik Date:03/30/2020
%This code only supports binomial classification of non-separable classes
%using SVM with RBF kernel and box parameters(Regularization Parameters)
%This code selects and saves a best model based on high accuracy among other models created at different
%regularization parameters and displays the decision boundary on a 
%100 x 100 grid.
clc;
clear;
close all;
%% Data Initialization & Handling
Data = xlsread('HW2Data.xlsx');
Data(:,3) = [];
PD = 0.25; %Partition of Test Data
cv = cvpartition(size(Data,1),'HoldOut',PD);
Xtr = Data(cv.training,:); %Training data
Xte = Data(cv.test,:); %Testing data
dynamic = 0; %Change to 0 to hardcode regularization parameter values
Reg_vals = 0.1:0.18:1; %Regularization Parameter values
max_params = 6; %change it to include more/less regularization parameters
print_graphs = 0; %change it to stop/start printing graphs for accuracy, precision and recall
if dynamic
    Reg_vals = fetchval(max_params); %fetching parameter values dynamically
end
mdl = struct;
pred = struct;
grid = [];
clearvars cv Data PD dynamic max_params;
%% Training the SVM Model
for i = 1:length(Reg_vals)
    mdl(i).SVMModel = fitcsvm(Xtr(:,1:end-1),Xtr(:,end),'BoxConstraint',Reg_vals(i),'KernelFunction','RBF');
end
%% Testing the SVM Model
for i = 1:length(mdl)
    pred(i).class = predict(mdl(i).SVMModel,Xte(:,1:end-1));
    pred(i).conf_mat = confusionmat(Xte(:,end),pred(i).class);
    pred(i).accuracy = accuracy(pred(i).conf_mat);
    pred(i).precision = precision(pred(i).conf_mat);
    pred(i).recall = recall(pred(i).conf_mat);
    pred(i).reg_param = Reg_vals(i);
end
%% Displaying the Results
for i = 1:length(mdl)
    disp("When Regularization Parameter is : " + Reg_vals(i));
    disp("Confusion Matrix : ");
    disp(pred(i).conf_mat);
    disp("Accuracy : " + pred(i).accuracy);
    disp("Precision : " + pred(i).precision);
    disp("Recall : " + pred(i).recall);
end
%% Plotting the Results
if print_graphs
    figure;
    plot(Reg_vals,extractfield(pred,'accuracy'));
    title("Accuracy with respect to Regularization Parameter");
    xlim([min(Reg_vals) max(Reg_vals)]);
    xticks(Reg_vals);
    ylabel('Accuracy');
    xlabel('Regularization Parameter Values');
    figure;
    plot(Reg_vals,extractfield(pred,'precision'));
    title("Precision with respect to Regularization Parameter");
    xlim([min(Reg_vals) max(Reg_vals)]);
    xticks(Reg_vals);
    ylabel('Precision');
    xlabel('Regularization Parameter Values');
    figure;
    plot(Reg_vals,extractfield(pred,'recall'));
    title("Recall with respect to Regularization Parameter");
    xlim([min(Reg_vals) max(Reg_vals)]);
    xticks(Reg_vals);
    ylabel('Recall');
    xlabel('Regularization Parameter Values');
end
%% Plotting Decision surface on a 100x100 grid
[M,I] = max(extractfield(pred,'accuracy'));
for x = 1:100
    for y = 1:100
        grid = [grid;[x,y]]; %Generating Grid points
    end
end
%% Predicting the grid points
yhat = predict(mdl(I).SVMModel,grid);
fin_mdl = mdl(I).SVMModel;
grid = [grid yhat];
%% Plotting the grid points
class1 = grid(:,end)==1;
plot(grid(class1,1),grid(class1,2),'.r','markersize',20);
hold on;
plot(grid(~class1,1),grid(~class1,2),'^b','markersize', 3);
legend("class-1","class-2");
title("Decision Boundary when Regularization Parameter = " + Reg_vals(I));
hold off;
save('BestSVMModel','fin_mdl');
clearvars i I mdl class1 M grid;