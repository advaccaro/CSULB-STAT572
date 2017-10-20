%STAT572_HW4.m
%Adam Vaccaro
%Purpose: Estimate the Monte Carlo power of test for testing 
%H_0: sigma = 7.8 vs. H_1: sigma > 7.8.
%Redo example 7.6, except with updated H_0 and H_1.

%% Step 1 - Set up
clear all
addpath(genpath('/Users/ADV/Documents/MATLAB/'))

load mcdata %load the data
n = length(mcdata); %get length of data
sigma = 7.8; %population standard deviation					
sigxbar = sigma/sqrt(n); %standard deviation of x-bar
meanobs = mean(mcdata); %observed mean
varobs = var(mcdata); %observed variance
Tobs = (n-1)*varobs/(sigma^2); %observed test statistic
M = 1000;				% Number of Monte Carlo trials
Tm = zeros(1,M); %preallocate storage space for MC test statistics
%% Step 2 - Monte Carlo trials	
for i = 1:M
	xs = normrnd(meanobs,sigma,1,n); %random sample under H_0
    Tm(i) = (n-1)*var(xs)/(sigma^2); %calculate test statistic    
end
%% Step 3 - One-tailed test (test different values of sigma)
alpha = 0.05; %set alpha
cv = csquantiles(Tm,1-alpha); %critical value
sig_alt = 7.8:.1:15; %alternative values of sigma
ns = length(sig_alt); %number of alternative sigmas
Tm_alt = zeros(1,M); %preallocate storage for Tm_alt
Bm = zeros(1,ns); %preallocate storage for beta estimation counter
%% Step 4 - Test different values of sigma
for j = 1:ns
    for k = 1:M
        xs_alt = normrnd(meanobs,sig_alt(j),1,n); %random sample under H_1
        Tm_alt(k) = (n-1)*var(xs_alt)/(sigma^2); %test statistic under H_1
        if Tm_alt(k) <= cv
            Bm(j) = Bm(j) + 1; %increase beta estimation counter
        end
    end
end
%% Step 5 - Calculate estimated power
betahat = Bm/M; %estimated beta
power = 1 - betahat; %estimated power
%% Step 6 - Plotting
figure(1); clf;
plot(sig_alt,power);
xlabel('sigma \sigma'); ylabel('Power');

    

