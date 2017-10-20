%STAT572_HW5_7_8.m
%Adam Vaccaro
%Purpose: Write MATLAB code that will get the bootstrap standard confidence
%interval.  Use it with the forearm data to get a confidence interval for
%the sample central second moment.  Compare this interval with the ones
%obtained in the examples and in the previous problem.

%% Step 1 - Set up
clear all
addpath(genpath('/Users/ADV/Documents/MATLAB/'))

load forearm %load data
X = forearm; %rename data for modularity
n = length(X); %length of input sample
B = 400; %number of bootstrap trials
alpha = .05; %alpha
%Calculate desired statistics:
mom_obs = mom(X); %observed second central moment
%% Step 2 - Bootstrap set up
%Pre-allocate storage space for bootstrap trials:
mom_b = zeros(1,B); %second central moment
X_b = zeros(n,B); % X (bootstrap samples)

inds = unidrnd(n,n,B); %indices for bootstrap resampling
X_b = X(inds); %Bootstrap resamples
%% Step 3 - Bootstrap loop
for i = 1:B
    X_bsam = X_b(:,i);
    %Calculate bootstrap replicates:
    mom_b(i) = mom(X_bsam);
end
%% Step 4 - Calculate standard errors and biases
mom_se = std(mom_b); %calculate standard error
z1 = icdf('Normal',alpha/2,0,1); %z critical value 1
z2 = icdf('Normal',1-alpha/2,0,1); %z critical value 2
blo = mom_obs+z1*mom_se; %interval lower limit
bhi = mom_obs+z2*mom_se; %interval upper limit