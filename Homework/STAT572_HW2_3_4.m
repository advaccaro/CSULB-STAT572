%STAT572_HW2_3_4.m
%Adam Vaccaro

%% Exercise 3.4
%Purpose: Repeat Example 3.1 using different sample sizes.  What happens to
%the coefficient of skewness and kurtosis as the sample size gets large?
clear all

%% Step 1 - Set up
% Generate a random sample from the uniform distribution.
n = 100000;
x = randn(1,n);
% Find the mean of the sample.
mu = mean(x);

%% Step 2 - Calculate relevant statistics
% Find the numerator and denominator for gamma_1.
num = (1/n)*sum((x-mu).^3);
den = (1/n)*sum((x-mu).^2);
gam1 = num/den^(3/2);

% Find the kurtosis.
num = (1/n)*sum((x-mu).^4);
den = (1/n)*sum((x-mu).^2);
gam2 = num/den^2;