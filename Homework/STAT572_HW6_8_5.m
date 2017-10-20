%STAT572_HW6_8_5.m
%Adam Vaccaro
%Purpose: Generate 15 random variables from uniform(0,1) distribution.
%Determine the jackknife estimate of the standard error for x-bar, and
%calculate the bootstrap estimate of the standard error for the same
%statistic.  Compare these values to s/sqrt(n)

%% Step 1 - Set up
addpath(genpath('/Users/ADV/Documents/'))
clear all
n = 15; %number of variables to be generated
X = rand(n,1);

%% Step 2 - Jackknife estimate
[jk_b,jk_se,jk_vals] = csjack(X,'mean');

%% Step 3 - Bootstrap estimate
B = 400;
bootreps = bootstrp(B,'mean',X);
boot_se = std(bootreps);

%% Step 4 - Theoretical
theo_se = std(X)/sqrt(n);