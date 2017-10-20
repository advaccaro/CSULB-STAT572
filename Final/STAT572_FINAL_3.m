%STAT572_FINAL_3.m
%Adam Vaccaro
%Purpose: Consider random variables X and Y having the following
%conditional distributions.
% f(x|y) = y*exp(-x*y), 0 < x < 10
% f(y|x) = x*exp(-x*y), 0 < y < 10
%Use Gibbs sampler to generate MC of size 1000 from the marginal
%distribution f(x).  Use your own starting values and burn-in period.
%Estimate mean, variance, skewness, and kurtosis of the marginal
%distribution.  After burn-in plot the MC and give the histogram of the
%chain.  Estimate the marginal pdf f(x) at x = 0.1, 1.8, 3.5, 9.2.
%Repeat with different starting values and compare the results.
%% Step 1 - Set up
addpath(genpath('/Users/ADV/Documents/MATLAB/'))
clear all; close all;

%Set initial values
n = 1200; %sample size 1200 (1000 after burn-in)
m = 200; %burn-in will be 200
X = zeros(1,n); Y = zeros(1,n); %pre-allocate storage space
x1 = 0.01; y1 = 0.01;  %initial values for X and Y
X(1) = x1;  Y(1) = y1;
%% Step 2 - Iterative algorithm
for i = 1:(n-1)
    good = 0; %initialize acceptance flag to 0
    while good < 1
        X(i+1) = exprnd(1/Y(i)); %generate value for X
        Y(i+1) = exprnd(1/X(i+1)); %generate value for Y
        xtest = (X(i+1) > 0 && X(i+1) < 10); %check to see if 0<x<10
        ytest = (Y(i+1) > 0 && Y(i+1) < 10); %check to see if 0<y<10
        if xtest == 1 && ytest == 1 %if both values are acceptable
            good = good + 1; %set acceptance flag to 1
        end
    end
    
end

%% Step 3 - Burn first 200 entries
X = X(m+1:end);
Y = Y(m+1:end);

%% Step 4 - Mean, Variance, Skewness, and Kurtosis
xmean = mean(X); ymean = mean(Y);
xvar = var(X); yvar = var(Y);
xskew = skewness(X); yskew = skewness(Y);
xkurt = kurtosis(X); ykurt = kurtosis(Y);

%% Step 5 - Plotting
figure(1); clf;
subplot(121); plot(X); 
titlestrx = sprintf('X: X(1) = %1.2f',x1); title(titlestrx);
subplot(122); plot(Y);
titlestry = sprintf('Y: X(1) = %1.2f',y1); title(titlestry);

%% Step 6 - Histograms
figure(2); clf;
subplot(121); histogram(X); title(titlestrx);
subplot(122); histogram(Y); title(titlestry);

%% Step 7 - Estimate marginal pdf at x =[0.1 1.8 3.5 9.2]
xs = [0.1 1.8 3.5 9.2]; %x values for testing
for i = 1:length(xs)
    fhatx(i) = mean(exppdf(xs(i),1./Y));
end