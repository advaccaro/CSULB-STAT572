%STAT572_HW5_7_9.m
%Adam Vaccaro
%Purpose: Use your program from problem 7.8 and the forearm data to get a
%bootstrap confidence interval for the mean.  Compare with to the
%theoretical one.

%% Step 1 - Set up
clear all
addpath(genpath('/Users/ADV/Documents/MATLAB/'))

load forearm %load data
X = forearm; %rename data for modularity
n = length(X); %length of input sample
B = 400; %number of bootstrap trials
alpha = .05; %alpha
%Calculate desired statistics:
mu_obs = mean(X); %observed second central moment
%% Step 2 - Bootstrap set up
%Pre-allocate storage space for bootstrap trials:
mu_b = zeros(1,B); %second central moment
X_b = zeros(n,B); % X (bootstrap samples)

inds = unidrnd(n,n,B); %indices for bootstrap resampling
X_b = X(inds); %Bootstrap resamples
%% Step 3 - Bootstrap loop
for i = 1:B
    X_bsam = X_b(:,i);
    %Calculate bootstrap replicates:
    mu_b(i) = mean(X_bsam);
end
%% Step 4 - Calculate standard errors and biases
mu_se = std(mu_b); %calculate standard error
z1 = icdf('Normal',alpha/2,0,1);
z2 = icdf('Normal',1-alpha/2,0,1);
blo = mu_obs+z1*mu_se; %upper interval limit
bhi = mu_obs+z2*mu_se; %lower interval limit