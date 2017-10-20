%STAT572_FINAL_1.m
%Adam Vaccaro
%Purpose: Let X1, X2,..., Xn be iid random variables having unknown mean
%mu.  For given constant a < b, we are interested in estimating
%p= Prob[a < (xbar-mu)/SE(xbar) < b].  Explain how we can use the bootstrap
%approach to estimate p.  Use the forearm data to estimate p with a = -2,
%b = 2.  Provide the 95% bootstrap percentile CI for p.  Discuss your
%findings.

%% Set Up
clear all; close all;
addpath(genpath('/Users/ADV/Documents/MATLAB/'))
load forearm
X = forearm; %rename data
mu = mean(X); %estimated mean
% Set variables:
a = -2; b = 2; %values for a and b
B = 500; %number of bootstrap trials
alpha = .05; %alpha for confidence interval
p = zeros(1,B); %pre-allocate storage for P = Prob(a<z<b)

%% Bootstrap
for i = 1:B
    count=0; %initialize counter
    xbars = bootstrp(B,'mean',X); %bootstrap replicates of xbar
    se = std(xbars); %bootstrap estimate of SE of xbar
    for j = 1:B
        z = (xbars(j)-mu)/se;
        if z > a && z < b
            count=count+1;
        end
    end
    p(i) = count/B; %prob(a<z<b) per bootstrap trial
end

%% Calculate Prob(a<z<b)
P = mean(p);

%% Calculate 95% bootstrap percentile CI for p
psort = sort(p); %sort p in ascending order
% Indices corresponding to critical values
k1 = ceil(B*alpha/2);
k2 = ceil(B-k1);
% Lower and upper bounds:
lower = psort(k1);
upper = psort(k2);
