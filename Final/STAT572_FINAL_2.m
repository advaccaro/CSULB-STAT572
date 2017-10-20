%STAT572_FINAL_2.m
%Adam Vaccaro
%NOTE: This script uses custom functions LIK_RATIO.m and LIK_RATIO2.m
% (geyser data) We have used the finite mixture method to estimate the
% density of the geyser data. dN(mu1,sig1^2) + (1-d)*N(mu2,sig2^2).
% We are interested in Monte Carlo inference on d.
%(a) Assuming a unif(0,1) prior distribution for d use MCMC techniques to
%construct a Markov Chain of size 1000 whose stationary distribution equals
%the posterior density of d.  For mu's and d's use the estimates from the
%finite mixture.  After 10% burn-in provide the histogram of the chain,
%Monte Carlo estimate of the mean E(d) and the variance var(d).  Construct
%an approximate 90% CI for E(d).  Also give the mix rate.
%(b) Repeat (a) with Beta density as prior.  Choose parameters of your
%proposal density carefully so that the chain moves quickly away from the
%starting value and converges to it stationary distribution.  Compare with
%(a).

%% Step 1 - Set Up
addpath(genpath('/Users/ADV/Documents/MATLAB/'))
clear all; close all;

load geyser %load geyser data
X = geyser;

%Estimate mus and vars visually (for initial guess):
figure(1); hist(X);
mu1 = 52; var1 = 10;
mu2 = 80; var2 = 10;

%Get estimates for mus and vars using csfinxmix:
[WTS,MUS,VARS] = csfinmix(X,[mu1 mu2], [var1 var2], [.5 .5], 100, .0005);
mu1 = MUS(1); var1 = VARS(1);
mu2 = MUS(2); var2 = VARS(2);

%% Step 2 - Use M-H sampler to generate MC of size 1000 (part a)
n = 1000;
d_mh = zeros(n,1); %pre-allocate space for d
d_mh(1) = rand; %initialize chain with uniform random number
rate1 = 0; %initialize acceptance rate

for i = 1:(n-1)
    %    Generate candidate from proposal distribution:
    y_top = min(1,d_mh(i) + .5);
    y_bot = max(0,d_mh(i) - .5);
    y = unifrnd(y_bot,y_top);
    % For Pat (b):
    %   Generate another uniform for comparison:
    u = rand;
    LR = LIK_RATIO(y,u,X,mu1,var1,mu2,var2);
    alpha = min(1,LR);
    if u <= alpha %accept
        d_mh(i+1) = y;
        rate1 =rate1 + 1;
    else
        d_mh(i+1) = d_mh(i);
    end
end

%% Step 3 - Calculate Mean, variance, mix rate, CIs (part a)
rate1 = rate1/n; %rate of acceptance
d_mh = d_mh(floor(.1*numel(d_mh))+1:end); %burn 10%
% Calculate mean, variance, and 90% confidence interval
d_mean = mean(d_mh);
d_var = var(d_mh);
nd = length(d_mh);
d_SEM = std(d_mh)/sqrt(nd); %standard error
ts = tinv([0.05 0.95],nd-1); %T-score
d_CI = d_mean + ts*d_SEM; %90% CI using T-score

% Bootstrap to estimate 90% CI of mean:
B = 400;
B_means = bootstrp(B,'mean',d_mh);
B_means = sort(B_means);
alpha = 0.10;
k1 = floor(B*alpha/2);
k2 = floor(B*(1-alpha/2));
B_CI = [B_means(k1) B_means(k2)];


%% Step 4 - Histogram of MC (part a)
figure(2); subplot(121); hist(d_mh);
title('Histogram of values generated assuming a Unif(0,1) Prior');


%% Step 2 -  Use M-H sampler to generate MC (Part b)
d_mh = zeros(n,1); %pre-allocate space for d
d_mh(1) = rand; %initialize chain with uniform random number
rate1 = 0; %initialize acceptance rate

for i = 1:(n-1)
    %    Generate candidate from proposal distribution:
    y = betarnd(1,8);
    %   Generate another uniform for comparison:
    u = rand;
    LR = LIK_RATIO(y,u,X,mu1,var1,mu2,var2);
    alpha = min(1,LR);
    if u <= alpha %accept
        d_mh(i+1) = y;
        rate1 =rate1 + 1;
    else
        d_mh(i+1) = d_mh(i);
    end
end
d_mh = d_mh(floor(.1*numel(d_mh))+1:end); %burn 10%
%% Step 3 - Calculate mean, variance, and 90% confidence interval (part b)
rate1 = rate1/n; %rate of acceptance
d_mean = mean(d_mh);
d_var = var(d_mh);
nd = length(d_mh);
d_SEM = std(d_mh)/sqrt(nd); %standard error
ts = tinv([0.05 0.95],nd-1); %T-score
d_CI = d_mean + ts*d_SEM; %90% CI using T-score

% Bootstrap to estimate 90% CI of mean
B = 400;
B_means = bootstrp(B,'mean',d_mh);
B_means = sort(B_means);
alpha = 0.10;
k1 = floor(B*alpha/2);
k2 = floor(B*(1-alpha/2));
B_CI = [B_means(k1) B_means(k2)];


%% Step 4 - Histogram of MC (part b)
figure(2); %subplot(121); hist(d_mh);
%title('Histogram of values generated assuming a Unif(0,1) Prior');
subplot(122);
hist(d_mh);
title('Histogram of values generated assuming a Beta prior');
