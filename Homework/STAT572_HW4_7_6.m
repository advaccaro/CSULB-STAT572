%STAT572_HW4_7_6.m
%Adam Vaccaro
%Exercise 7.6: Repeat example 7.8 for larger M.  Does the estimated Type I
%error get closer to the true value?

%% Step 1 - Set up
clear all;
M = 50000 %number of Monte Carlo trials
sigma = 7.8; %Set population standard deviation
alpha = 0.05; %Set alpha
n = 25; %Set sample size
sigxbar = sigma/sqrt(n); %standard deviation of x-bar
cv = norminv(alpha,0,1); %get critical value
% Start the simulation
Im = 0; %Initialize counter for alphahat estimation
%% Step 2 - Monte Carlo trials
for i = 1:M
    %Generate a random sample under H_0
    xs = sigma*randn(1,n) + 454; %generate random sample under H_0
    Tm = (mean(xs)-454)/sigxbar; %Calculate the test statistic
    if Tm <= cv %then reject H_0
        Im = Im + 1;
    end
end
%% Step 3 - Estimate probability of Type I error
alphahat = Im/M %caluclate estimate of alpha
