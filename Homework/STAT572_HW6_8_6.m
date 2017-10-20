%STAT572_HW6_8_6.m
%Adam Vaccaro
%Purpose: Use Monte Carlo simulation to compare the performance of the
%bootstrap and jackknife methods for estimating the standard error and bias
%of the sample second central moment.  For every Monte Carlo trial,
%generate 100 standard normal random variables and calculate the bootstrap
%and jackknife estimates of the standard error and bias.  Show the
%distribution of the bootstrap estimates (of bias and standard error) and
%the jackknife estimates (of bias and standard error) in a histogram or a
%box plot.  

%% Step 1 - Set up
addpath(genpath('/Users/ADV/Documents/MATLAB/'))
clear all;
M = 1000; %number of Monte Carlo trials
n = 100; %sample size
%Pre-allocate storage space:
boot_se = zeros(M,1); %bootstrap standard error
boot_bias = zeros(M,1); %bootstrap bias
jk_se = zeros(M,1); %jackknife standard error
jk_bias = zeros(M,1); %jackknife bias


%% Step 2 - Monte Carlo
for i = 1:M
    X = randn(n,1); %generate random vector from standard normal
    xmom = mom(X); %second central moment of X
    % Bootstrap:
    bootreps = bootstrp(n,'mom',X); %generate bootstrap replicates
    boot_se(i) = std(bootreps); %bootstrap standard error
    boot_bias(i) = xmom - mom(bootreps); %bootstrap bias
    % Jackknife:
    [jk_bias(i),jk_se(i),jk_vals] = csjack(X,'mom');
end

%% Step 3 - Plotting
%Histograms:
figure(1); clf;
subplot(221);
hist(boot_se);
title('Bootstrap standard error')

subplot(222);
hist(boot_bias);
title('Bootstrap bias')

subplot(223);
hist(jk_se);
title('Jackknife standard error')

subplot(224);
hist(jk_bias);
title('Jackknife bias')

%Boxplots:
figure(2); clf;
subplot(221);
boxplot(boot_se);
title('Bootstrap standard error')

subplot(222)
boxplot(boot_bias);
title('Bootstrap bias')

subplot(223)
boxplot(jk_se);
title('Jackknife standard error')

subplot(224)
boxplot(jk_bias);
title('Jackknife bias')
    