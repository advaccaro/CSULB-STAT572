%STAT572_HW12_IC.m
%Adam Vaccaro
%Purpose: Generate Markov Chains of length 1000 from bivariate normal with
%mu =[3 2]' and covariance = [1.5, 0.6; 0.6, 1].  Plot each MC and
%histogram.  Make a scatterplot of X vs Y.

%% Step 0 - Set up
addpath(genpath('/Users/ADV/Documents/MATLAB/'));
clear all; close all;

%% Step 1 - Take r.s. from N(0,1), get initial values
n = 1000; %sample size
X = zeros(1,n); Y = zeros(1,n); %pre-allocate storage space
SIGMA = [1.5 0.6; 0.6 1];
MU = [3;2]; mux = MU(1); muy = MU(2);
sigx = sqrt(SIGMA(1,1));
sigy = sqrt(SIGMA(2,2));
rho = SIGMA(1,2)/(sigx*sigy);
z10 = normrnd(0,1); z20 = normrnd(0,1);
X(1) = mux + sigx*z10;
Y(1) = muy + rho*(sigx/sigy)*(X(1)-mux)+sigy*sqrt(1-rho^2)*z20;

%% Step 2 - Iterative algorithm
for i = 1:(n-1)
    X(i+1) = normrnd(mux+rho*(sigx/sigy)*(Y(i)-muy),sigx*sqrt(1-rho^2));
    Y(i+1) = normrnd(muy+rho*(sigy/sigx)*(X(i+1)-mux),sigy*sqrt(1-rho^2));
end

%% Step 3 - Burn 10%
X = X(floor(.1*numel(X))+1:end);
Y = Y(floor(.1*numel(Y))+1:end);

%% Step 4 - Plot MCs
figure(1); clf;
subplot(211); plot(X); title('X');
subplot(212); plot(Y); title('Y');

%% Step 5 - Plot histograms
figure(2); clf;
subplot(121); hist(X); title('X');
subplot(122); hist(Y); title('Y');

%% Step 6 - Plot scatterplot
figure(3); clf;
scatter(X,Y); axis square;
xlabel('X'); ylabel('Y');