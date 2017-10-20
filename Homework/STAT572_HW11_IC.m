%STAT572_HW11_IC.m
%Adam Vaccaro
%Purpose:
%1. Generate hypothesized sample of size 100 from Bernoulli(0.2)
%2. Use a M-H sampler to generate MC of size 2000 whose invariant
%distribution is given by the posterior distribution of theta|Y.  Use later
%1500 MC to calculate mean and variance.
%3. Generate MC from Beta(y+1,n-y+1) using random-walk sampler.  Calculate
%mean and variance.
%4. Compare the histograms in Steps 2 and 3.

%% Step 0 - Set up
addpath(genpath('/Users/ADV/Documents/MATLAB'))
clear all; close all;

%% Step 1 - Generate r.s. of size 100 from Bernoulli(0.2)
n1 = 100; %sample size
U = rand(1,n1); %generate uniform r.s.
X_Bh = zeros(size(U)); %pre-allocate space
X_Bh(U <= 0.2) = 1; %Bernoulli(0.2) hypothesized
Z = sum(X_Bh); %sum of Bernoulli random sample

%% Step 2 - Use M-H sampler to generate MC of size 2000, 
% then burn first 500 and calculate mean and variance
n2 = 2000; %sample size
strg='theta1^z*(1-theta1)^(n-z)';
LIK = inline(strg,'theta1','n','z');
X_mh = zeros(1,n2); %pre-allocate space
X_mh(1) = rand; %initialize chain with uniform random number
rate1 = 0; %initialize acceptance rate
for i = 1:(n2-1)
    % Generate candidate from proposal distribution:
    y_top = min(1,X_mh(i)+.5); %upper bound for candidate
    y_bot = max(0,X_mh(i)-.5); %lower bound for candidate
    y = unifrnd(y_bot,y_top); %candidate
    % Generate a uniform for comparison:
    u = rand;
    num = LIK(y,n1,Z);
    den = LIK(X_mh(i),n1,Z);
    alpha = min(1,num/den); %prob of acceptance
    if u<= alpha %accept
        X_mh(i+1) = y;
        rate1 = rate1 + 1;
    else %reject
        X_mh(i+1) = X_mh(i);
    end
end
rate1 = rate1/n2; %rate of acceptance
X_mh2 = X_mh(501:end); %take later 1500 entries
mean1 = mean(X_mh2); %mean
var1 = var(X_mh2); %variance

%% Step 3 - Generate MC from Beta(Z+1,n-Z+1)
n3 = length(X_mh2); %sample size
 X_rw = zeros(1,n3); %pre-allocate storage space
 X_rw(1) = rand; %initialize with uniform random number
 rate2 = 0; %initialize acceptance rate
 for i = 1:(n3-1)
     %Generate candidate from proposal distribution:
     y = X_rw(i) + (rand-0.5)/(sqrt(12)); y = max(y,0);
     %Generate uniform for comparison:
     u = rand;
     num = betapdf(y,Z+1,n1-Z+1);
     den = betapdf(X_rw(i),Z+1,n1-Z+1);
     alpha = min(1,num/den);
     if u <= alpha
         X_rw(i+1) = y;
         rate2= rate2 + 1;
     else %reject
         X_rw(i+1) = X_rw(i);
     end
 end
 
 rate2 = rate2/n3; %rate of acceptance
 mean2 = mean(X_rw); %mean
 var2 = var(X_rw); %variance
     
 %% Step 4 - Compare histograms
 figure(1); clf;
 subplot(121); hist(X_mh2); title('M-H sampler');
 subplot(122); hist(X_rw); title('Random-Walk');
