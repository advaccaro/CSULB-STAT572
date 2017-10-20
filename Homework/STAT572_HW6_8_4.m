%STAT572_HW6_8_4.m
%Adam Vaccaro
%Purpose: Generate n=25 random variables from a standard normal
%distribution that will serve as the random sample.  Determine the
%jackknife and bootstrap estimates of the standard error for X-bar and 
%compare these to the theoretical value of the standard error.

%% Step 1 - Set up
addpath(genpath('/Users/ADV/Documents/'))
clear all
n = 25; %sample size
X = randn(n,1); %generate random variables from standard normal
xbar = mean(X); %mean of X

%% Step 2 - Jackknife estimate
[jk_bias,jk_se,jvals] = csjack(X,'mean');

%% Step 3 - Bootstrap estimate
B = 400; %number of bootstrap trials
bootreps = bootstrp(B,'mean',X);
boot_se = std(bootreps); %bootstrap estimate of standard error

%% Step 4 - Theoretical value
S = std(X); %standard deviation
theo_se = S/sqrt(n); %theoretical standard error