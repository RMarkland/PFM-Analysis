%%

clear;
clc;

addpath("/Users/reidmarkland/Documents/Research/SULI23/Work For Di",...
    "/Users/reidmarkland/Documents/Research/SULI23/Work For Di/Igor2Matlab")

[files, identifiers, modelf, coeff, error_R, xdata, ydata] =...
    PFM_fit();
SpotStruct = Calc_Slope(files, identifiers, coeff);

plot = Plotd33(SpotStruct)
hold on

%% Plot individual data
k = 30;
xFit = linspace(min(xdata(:,k)), max(xdata(:,k)), 2000);
yFit = modelf(coeff(k,:), xFit(:));
plot(xdata(:,k),ydata(:,k),'Linewidth',3)
hold on
plot(xFit, yFit,'Color','r','Linewidth',3)
hold off
grid on

%% Plot spot data

spot = 's4';

voltage = SpotStruct.(spot).voltage;
amplitude = SpotStruct.(spot).amp_adj(:,1);
error = SpotStruct.(spot).amp_adj(:,2);
finalVals = SpotStruct.(spot).finalVals;

errorbar(voltage,amplitude,error,'or')
hold on
plot(voltage, voltage*finalVals(1)+finalVals(2))
hold off
%% Overall average plot with error bar (Applied bias (mV) vs Amplitude (mV))

scatter(avg_C_C9R5(:,1),avg_C_C9R5(:,2),'filled')

hold on

er = errorbar(avg_C_C9R5(1,1),avg_C_C9R5(1,2),avg_C_C9R5(1,3));    
er.Color = [0 0 0];
er.LineWidth = 1.5;
er = errorbar(avg_C_C9R5(2,1),avg_C_C9R5(2,2),avg_C_C9R5(2,3));    
er.Color = [0 0 0];
er.LineWidth = 1.5;
er = errorbar(avg_C_C9R5(3,1),avg_C_C9R5(3,2),avg_C_C9R5(3,3));    
er.Color = [0 0 0];
er.LineWidth = 1.5;
er = errorbar(avg_C_C9R5(4,1),avg_C_C9R5(4,2),avg_C_C9R5(4,3));    
er.Color = [0 0 0];
er.LineWidth = 1.5;
% er = errorbar(avg_C_C9R5(5,1),avg_C_C9R5(5,2),avg_C_C9R5(5,3));    
% er.Color = [0 0 0];
% er.LineWidth = 1.5;
% er = errorbar(avg_C_C9R5(6,1),avg_C_C9R5(6,2),avg_C_C9R5(6,3));    
% er.Color = [0 0 0];
% er.LineWidth = 1.5;
% er = errorbar(avg_C_C9R5(7,1),avg_C_C9R5(7,2),avg_C_C9R5(7,3));    
% er.Color = [0 0 0];
% er.LineWidth = 1.5;
er.LineStyle = 'none';  

linearCoefficients = polyfit(avg_C_C9R5(:,1), avg_C_C9R5(:,2), 1);     % Coefficients
y_lin = polyval(linearCoefficients, avg_C_C9R5(:,1)); 
plot(avg_C_C9R5(:,1),y_lin,'r','LineWidth',1.5)

hold off

set(gca, 'FontSize',20)

%% Overall scatter plot 

scatter(total_(:,1),total_(:,2),'filled')

hold on

plot(avg_C_C9R5(:,1),y_lin)

hold off

set(gca, 'FontSize',20)


