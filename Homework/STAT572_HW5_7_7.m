%STAT572_HW5_7_7.m
%Adam Vaccaro
%Purpose: Implement the parametric bootstrap on the forearm data.  Assume
%the normal distribution is a reasonable model for the data and get a
%bootstrap estimate of the standard error and bias of the coefficients of
%skewness and kurtosis.  Get a bootstrap percentile interval for the sample
%central moment.
%% Step 1 - Set up
clear all
addpath(genpath('/Users/ADV/Documents/MATLAB/'))

load forearm %load data
X = forearm; %rename data for modularity
n = length(X); %length of input sample
B = 400; %number of bootstrap trials
alpha = .05; %alpha
%Calculate desired statistics:
sk_obs = skewness(X); %observed skewness
ku_obs = kurtosis(X); %observed kurtosis
mom_obs = mom(X); %observed second central moment
%% Step 2 - Bootstrap set up
%Pre-allocate storage space for bootstrap trials:
sk_b = zeros(1,B); %skewness
ku_b = zeros(1,B); %kurtosis
mom_b = zeros(1,B); %second central moment
X_b = zeros(n,B); % X (bootstrap resamples)

inds = unidrnd(n,n,B); %indices for bootstrap resampling
X_b = X(inds); %Bootstrap resamples
%% Step 3 - Bootstrap loop
for i = 1:B
    X_bsam = X_b(:,i);
    %Calculate bootstrap replicates:
    sk_b(i) = skewness(X_bsam);
    ku_b(i) = kurtosis(X_bsam);
    mom_b(i) = mom(X_bsam);
    %Redo bootstrap to get SE hats for mom:
    mom_sehats(i) = std(bootstrp(25,'mom',X_bsam));
end
%% Step 4 - Calculate standard errors and biases
%Calculate standard errors:
sk_se = std(sk_b);
ku_se = std(ku_b);
mom_se = std(mom_b);
%Calculate biases:
sk_bias = sk_obs - mean(sk_b);
ku_bias = ku_obs - mean(ku_b);
%% Step 5 - Calculate percentile interval for second moment
smom_b = sort(mom_b); %sort mom_b in ascending order
k1 = ceil(B*alpha/2); %lower percentile index
k2 = ceil(B-k1); %upper percentile index
%Get the endpoints of the interval:
blo = smom_b(k1);
bhi = smom_b(k2);
    