%STAT572_HW4_7_5.m
%Adam Vaccaro
%Exercise 7.5: Repeat example 7.6 using a two-tail test.  In other words,
%test for the alternative hypothesis that the mean is not equal to 454.

%% Step 1 - Set up
clear all
addpath(genpath('/Users/ADV/Documents/MATLAB/'))
load mcdata %load the data
n = length(mcdata); %length of data
sigma = 7.8; %population sigma
sigxbar = sigma/sqrt(n); %standard deviation of x-bar
Tobs = (mean(mcdata)-454)/sigxbar %observed value of test statistic
normplot(mcdata) %generate normal probability plot
M = 1000; % Number of Monte Carlo trials
Tm = zeros(1,M); %preallocate storage for test statistics from MC trials
%% Step 2 - Monte Carlo trials
for i = 1:M
    xs = sigma*randn(1,n) + 454; %Generate random sample under H_0
    Tm(i) = (mean(xs) - 454)/sigxbar; %calculate test statistic
end
%% Step 3 - Two-tail test
alpha = 0.05; %set alpha
cv1 = csquantiles(Tm,alpha/2) %first critical value
cv2 = csquantiles(Tm,1-alpha/2) %second critical value
%check to see if observed test statistic is in critical region:
if (Tobs >= cv1) && (Tobs <= cv2) 
    pval = 2*length(find(Tm >= Tobs))/M; %calculate p-value, if needed
else
    display('Test statistic in rejection region')
end