%STAT572_HW6_IC.m
%Adam Vaccaro
%Purpose: Generate random sample of size 200 from chi-square (5 d.f.).
%Find bias(xbar) and standard error(xbar) of the mean

%% Step 1 - Set up
addpath(genpath('/Users/ADV/Documents/MATLAB/'));
clear all;
n = 200; %sample size
B = 200; %number of bootstrap trials
X = chi2rnd(5,n,1); %generate chi2 RVs
xbar = mean(X); %mean

%% Step 2 - Bootstrap estimate
bootreps = bootstrp(n,'mean',X); %generate bootstrap replicates
boot_se = std(bootreps); %bootstrap standard error
boot_bias = xbar - mean(bootreps); %bootstrap bias

%% Step 3 - Jackknife estimate
%generate jackknife bias, standard error, and values:
[jk_bias,jk_se,jvals] = csjack(X,'mean'); 

%% Cutoff
jvalinf=mean(jvals)+sqrt(n-1)*(jvals-mean(jvals));

%% Step 4 - Comparison
figure(1); clf;
subplot(211)
hist(bootreps);
title('bootstrap')
axis([4.2 5.4 0 50])
subplot(212)
hist(jvals);
title('jackknife')
axis([4.2 5.4 0 50])
%subplot(223)
%hist(jvalinf)
%title('inflated jackknife')