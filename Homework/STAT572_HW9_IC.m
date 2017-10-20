%STAT572_HW9_IC.m
%Adam Vaccaro
%Purpose: Generate random sample of size 200 from Gamma(3,2).  Using the
%Monte Carlo integration, estimate E[g(X)] and V[g(X)] where
%(A) g(X) = sqrt(X)
%(B) g(X) = 20% trimmed mean: mean of mid 80% of sorted data
%(C) g(X) = q3(X): third quartile

%% Step 1 - Set up
addpath(genpath('/Users/ADV/Documents/MATLAB/'))
clear all; close all;

%% Step 2 - Part A: g(X) = sqrt(X)
n = 200; %set sample size
X = gamrnd(3,2,1,n); %generate Gamma(3,2) r.v.'s
GX1 = sqrt(X); %sqrt transformation
E_GX1 = (1/n)*sum(GX1(:)); %E[sqrt(X)]
V_GX1 = (1/(n-1))*sum((GX1-E_GX1).^2); %V[sqrt(X)]

%% Step 3 - Monte Carlo trials (Parts B and C):
MC = 200; %number of Monte Carlo trials
for i = 1:MC 
% Part B: g(X) = 20% trimmed mean
    X_MC = gamrnd(3,2,1,n); %generate gamma r.s. for MC trial
    GX2(i) = trimmean(X_MC,20); %GX2 = 20% trimmed mean
% Part C: - g(X) = Q3(X) third quartile
    quarts = quartiles(X_MC); %get quartiles
    GX3(i) = quarts(3); %GX3 = third quartile
end

%% Step 4 - Expectation and Variance of GX2 and GX3
E_GX2 = (1/n)*sum(GX2(:)); %E[GX2]
V_GX2 = (1/(n-1))*sum((GX2-E_GX2).^2); %V[GX2]

E_GX3 = (1/n)*sum(GX3(:)); %E[GX3]
V_GX3 = (1/(n-1))*sum((GX3-E_GX3).^2); %V[GX3]