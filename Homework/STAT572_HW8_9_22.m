%STAT572_HW8_9_22.m
%Adam Vaccaro
%Purpose: Use some of the univariate density estimation techniques from
%this chapter to explore the elderly data set.  Look for evidence of bumps
%and modes.

%% Step 1 - Set up 
addpath(genpath('/Users/ADV/Dcouments/MATLAB/'))
clear all; close all;
load('elderly.mat') %load height data
X = heights;
n = length(X); %sample size
xs = linspace(floor(min(X))-10,ceil(max(X))+10); %x-axis values

%% Step 2 - Visual inspection of raw data
figure(1); clf;
hist(X);
title('Histogram of raw height data')

%% Step 3 - Find finite mixture model (nterm = 2)
p0 = [.5 .5]; %initial guess for p
mu0 = [158 168]; %initial guess for mu
sig20 = [1 1]; %initial guess for sig20
maxit = 100; %maximum iterations
tol = 1e-5; %tolerance threshold

[pies2,mus2,vars2] = csfinmix(X,mu0,sig20,p0,maxit,tol);

%% Step 4 - Generate n r.v.'s from the 2-term FM model
% Generate r.v.'s from uniform distribution:
U = randn(1,n);
ind1 = length(find( U <= pies2(1) ));
ind2 = length(find( U > pies2(1) ));
% Generate random variables from the 2-term FM model
x(1:ind1) = randn(ind1,1)*sqrt(vars2(1)) + mus2(1);
x(ind1+1:ind1+ind2) = randn(ind2,1)*sqrt(vars2(2)) + mus2(2);
xfm2 = x;
fhat2 = zeros(size(xs));
for i = 1:2
    fhat2 = fhat2+pies2(i)*normpdf(xs,mus2(i),sqrt(vars2(i)));
end

%% Step 5 - Find FM model (nterm = 3)
p0 = [1/3 1/3 1/3]; %initial guess for p
mu0 = [158 168 154]; %initial guess for mu
sig20 = [1 1 1]; %initial guess for sig2
maxit = 100; %maximum iterations
tol = 1e-5; %tolerance threshold

[pies3,mus3,vars3]=csfinmix(X,mu0,sig20,p0,maxit,tol);

%% Step 6 - Generate n r.v.'s from the 3-term FM model
% Generate r.v.s from uniform distribution:
U = rand(1,n);
% Find number in each group
ind1 = length(find( U <= pies3(1) ));
ind2 = length(find( U > pies3(1) & U <= pies3(1)+pies3(2)));
ind3 = length(find( U > pies3(1)+pies3(2)));
% Generate random variables from the FM model
x(1:ind1) = randn(ind1,1)*sqrt(vars3(1)) + mus3(1);
x(ind1+1:ind1+ind2) = randn(ind2,1)*sqrt(vars3(2))+mus3(2);
x(ind1+ind2+1:ind1+ind2+ind3) = randn(ind3,1)*sqrt(vars3(3))+mus3(3);
xfm3 = x;
fhat3 = zeros(size(xs));
for i = 1:3
    fhat3 = fhat3+pies3(i)*normpdf(xs,mus3(i),sqrt(vars3(i)));
end

%% Step 7 - Normal KDE
sig_squig = min(std(X),iqr(X)/1.348);
hN = 1.06*sig_squig*n^(-1/5);
fhatN = zeros(size(xs));
for i = 1:n
    f=exp(-(1/(2*hN^2))*(xs-X(i)).^2)/sqrt(2*pi)/hN;
    fhatN = fhatN+f/(n);
end

%% Step 8 - Generate r.v.'s based on normal KDE
% Generate r.v.'s from uniform distribution:
U = rand(1, n);
Xgen = [];
for i = 1:n
    % Find number in each group
    ind = length(find( U >= (i-1)/n & U < i/n));
    % Generate data from normal distribution:
    gen{i} = randn(ind,1)*hN + X(i);
    Xgen(end+1:end+ind) = gen{i};
end

%% Step 9 - Histogram 
figure(2); clf;
hold on;
% Create and resize histogram:
[N,h] = hist(X,12);
N = N/(h(2)-h(1))/n;
bar(h,N,1,'w'); %plot histogram of height data
plot(xs,fhat2); %plot 2-term FM density
plot(xs,fhat3); %plot 3-term FM density
plot(xs,fhatN); %plot normal KDE
title('Histogram of elderly height data with estimated densities superimposed')
legend('Height data','2-term FM', '3-term FM', 'Normal KDE')
axis([138 184 0 .08])

%% Step 10 - MSE
mseN = immse(X,Xgen)
mse2 = immse(X,xfm2)
mse3 = immse(X,xfm3)