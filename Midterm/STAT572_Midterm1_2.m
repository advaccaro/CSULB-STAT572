%STAT572_Midterm1_2.m
%Adam Vaccaro
%Purpose: (a) Use Bootstrap and Jackknife methods to estimate the bias and
%standard error of the parameter theta for customer data, where theta = P(X>=10), X = number
%of customers per period.  Make histograms of Boostrap and Jackknife
%replicates. (b) Derive 95% Bootstrap-t and Bootstrap percentile intervals
%of theta.  Use Monte Carlo simulation to estimate the coverage of each
%interval.

%% Set up:
clear all;
addpath(genpath('/Users/ADV/Documents/MATLAB/')) %add path to needed functions
% Define data set:
X = [9 10 7 6 12 11 10 8 7 7 9 14 8 3 2 4 5 7 10 11 9 6 7]';
n = length(X); %sample size
theta_hat = theta(X); %calculate theta hat = P(X>=10) using theta.m
alpha = .05; %alpha

%% Bootstrap:
B = 250; %number of Bootstrap trials
M = 150; %number of Monte Carlo trials
inds = unidrnd(n,n,B); %indices for Bootstrap resampling
X_b = X(inds); %Bootstrap resamples
%Monte Carlo aglorithm:
for j = 1:M
    %Generate Bootstrap replicates and sample using bootstrp.m:
    [theta_b, X_b] = bootstrp(B,'theta',X); 
    se_b = std(theta_b); %Bootstrap standard error
    bias_b = theta_hat - mean(theta_b); %Bootstrap bias
    %Repeat bootstrap for Bootstrap-t CI:
    for i = 1:B 
        xstar = X(X_b(:,i)); %extract resample from the data
        %Calculate SE hats using bootstrp.m:
        [theta_bb, X_bb] = bootstrp(25,'theta',xstar);
        sehats(i) = std(theta_bb);
    end
    zvals = (theta_b - theta_hat)./sehats'; %z scores
    k = ceil(B*alpha/2); %index of critical value
    szval = sort(zvals); %sorted z vals
    thi = szval(k); %upper critical value
    tlo = szval(B-k); %lower critical value
    %boott_hi(j) = theta_hat - thi * se_b; %upper Boot-t CI limit
    boott_hi(j) = mean(theta_b) - thi * se_b;
    %boott_lo(j) = theta_hat - tlo * se_b; %lower Boot-t CI limit
    boott_lo(j) = mean(theta_b) - tlo * se_b;
    
    %Bootstrap percentile CI:
    t1 = ceil(B*alpha/2); %lower t score
    t2 = ceil(B-k); %upper t score
    stheta_b = sort(theta_b); %sorted bootstrap replicates
    bootp_lo(j) = stheta_b(t1); %Bootstrap percentile CI lower limit
    bootp_hi(j) = stheta_b(t2); %Bootstrap percentile CI upper limit
end
        
%% Jackknife:
for i = 1:n
    X_jk = [[X(1:(i-1))]; [X((i+1):end)]]; %Jackknife samples
    theta_jk(i) = theta(X_jk); %Jackknife replicates
end
bias_jk = (n-1)*(mean(theta_jk)-theta_hat); %Jackknife bias
se_jk = sqrt((n-1)/n*sum((theta_jk-mean(theta_jk)).^2)); %Jackknife SE
    
    
%% Plotting:
figure(2);clf;
subplot(121)
[N,h] = hist(theta_b);
N = N/(h(2)-h(1))/n;
bar(h,N,1);
title('Histogram of Bootstrap replicates of theta')
clear N h
subplot(122)
[N,h] = hist(theta_jk);
N = N/(h(2)-h(1))/n;
bar(h,N,1);
title('Histogram of Jackknife replicates of theta')



%% Calculate coverage
theta_true = .15;
boott_cover = 0;
bootp_cover = 0;
for j = 1:M
    if boott_lo(j) < theta_true && boott_hi(j) > theta_true
        boott_cover = boott_cover + 1;
    end
    if bootp_lo(j) < theta_true && bootp_hi(j) > theta_true
        bootp_cover = bootp_cover + 1;
    end
end
boott_cover = boott_cover/M;
bootp_cover = bootp_cover/M;
