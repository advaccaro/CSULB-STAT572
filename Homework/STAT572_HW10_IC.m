% STAT572_HW10_IC.m
% Adam Vaccaro
%% Purpose:
% Beta(alpha,beta)    (part a: alpha = beta = 3)
%                     (part b: alpha = beta = 0.5)
%1. Generate random sample of size 300 using M-H. Burn in 5%
%2. Kernel density estimate for random sample in 1
%3. Plot density histogram, kernel density, and the true density
%4. Do Monte Carlo simulation to estimate ISE of estimate in 2. and MSE at
% Xo = [0.2, 0.5, 0.8]

%% Step 1 - Set up
addpath(genpath('/Users/ADV/Documents/MATLAB/'))
clear all; close all;
figure(1);clf; %initialize figure
n = 300; %sample size
as = [.5 3]; %values for alpha
bs = [.5 3]; %values for beta


%% Step 2 - Generate r.s. using M-H
for k = 1:2
    a = as(k); %retrieve value for alpha
    b = bs(k); %retrieve value for beta
    X_mh = zeros(1,n); %pre-allocate space
    X_mh(1) = rand; %generate initial value
    for i = 1:(n-1)
        % Generate candidate from proposoal distribution
        y = unifrnd(X_mh(i)-.5,X_mh(i)+.5);
        % Generate a uniform for comparison
        u = rand(1);
        num = betapdf(y,a,b);
        den = betapdf(X_mh(i),a,b);
        alpha = min(1,num/den); %prob of acceptance
        if u <= alpha && y > 0 %accept
            X_mh(i+1) = y; 
        else %reject
            X_mh(i+1) = X_mh(i); 
        end
    end
    
    % Burn in 5%
    ind = floor(.05*numel(X_mh))+1; %index starting after 5%
    X_mh = X_mh(ind:end); %remove first 5%
    
    %% Step 3 - Kernel density estimate
    xs = [0.01:.01:0.99]; %axis of test values
    ns = length(xs);
    sig_squig = min(std(X_mh),iqr(X_mh)/1.348);
    hN = 1.06*sig_squig*n^(-1/5);
    fhatN=zeros(size(xs));
    for i = 1:length(X_mh)
        f=exp(-(1/(2*hN^2))*(xs-X_mh(i)).^2)/sqrt(2*pi)/hN;
        fhatN = fhatN+f/(n);
    end
    
    %% Step 4 - Plotting
    figure(1); subplot(1,2,k);
    [N,h] = hist(X_mh,12); %histogram parameters
    N = N/(h(2)-h(1))/length(X_mh); %resize histogram
    bar(h,N,1); hold on; %plot density histogram
    plot(xs,fhatN); %plot normal KDE
    plot(xs,betapdf(xs,a,b)); %plot true density
    betatext = sprintf('Beta(%1.1f,%1.1f)', a,b);
    legend('M-H generated data' ,'Normal KDE', betatext);
    
    %% Step 5 - ISE of estimate in KDE
    ISE(k) = sum((fhatN - betapdf(xs,a,b)).^2);
    
    %% Step 6 - Monte Carlo simulation for MSE
    MC = 300;
    for i = 1:MC
        X_mc = zeros(1,n); %pre-allocate space
        X_mc(1) = rand; %generate initial value
        for j = 1:(n-1)
            % Generate candidate from proposoal distribution
            y = unifrnd(X_mc(j)-.5,X_mc(j)+.5);
            % Generate a uniform for comparison
            u = rand(1);
            num = betapdf(y,a,b);
            den = betapdf(X_mc(j),a,b);
            alpha = min(1,num/den);
            if u <= alpha && y > 0
                X_mc(j+1) = y;
            else
                X_mc(j+1) = X_mc(j);
            end
        end
        
        % Burn in 5%
        ind = floor(.05*numel(X_mc))+1;
        X_mc = X_mc(ind:end);
        
        fhatN_mc{i}=zeros(size(xs));
        for j = 1:length(X_mc)
            f=exp(-(1/(2*hN^2))*(xs-X_mc(j)).^2)/sqrt(2*pi)/hN;
            fhatN_mc{i} = fhatN_mc{i}+f/(n);
        end
    end
    
    %% Calculate MSE
    %find matching indices:
    ind02 = find(xs == 0.2); ind05 = find(xs == 0.5); ind08 = find(xs==0.8);
    %get true values:
    d02 = betapdf(0.2,3,2); d05 = betapdf(0.5,3,2); d08 = betapdf(0.8,3,2);
    %pre-allocate storage space:
    SE02 = zeros(1,MC); SE05 = zeros(1,MC); SE08 = zeros(1,MC);
    %Calculate squared errors:
    for i = 1:MC
        SE02(i) = (fhatN_mc{i}(ind02) - betapdf(.2,a,b)).^2;;
        SE05(i) = (fhatN_mc{i}(ind05) - betapdf(.5,a,b)).^2;
        SE08(i) = (fhatN_mc{i}(ind08) - betapdf(.8,a,b)).^2;
    end
    %calculate mean of SEs
    MSE02(k) = mean(SE02);
    MSE05(k) = mean(SE05);
    MSE08(k) = mean(SE08);
        
end
