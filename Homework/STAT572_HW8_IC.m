%STAT572_HW8_IC.m
%Adam Vaccaro
%Purpose: 
%(1) Create artifiical 3-term mixture data
% 500 from N(-2.5,1)  ***  1000 from N(4.5,2) *** 1500 from N(10.5,3)
%(2) Find the finite mixture model using csfinmix.m, with initial
%p = [1/3 1/3 1/3], mu = [-2 4 10], sig2 = [1 1 1];
%(3) Generate n=3000 random variables from the FM model
%(4) Draw density histogram of data in 1 with the FM density superimposed
%(5) Repeat 4 with data from (3)

%% Step 1 - Set up
addpath(genpath('/Users/ADV/Documents/MATLAB/'))
clear all; close all;

%% Step 2 -  Create artificial 3-term mixture data
nterm = 3; %number of terms
% 500 r.v.'s from N(-2.5,1):
n1 = 500; %sample size of first group
rv1 = normrnd(-2.5,1,1,n1);
% 1000 r.v.'s from N(4.5,2):
n2 = 1000; %sample size of second group
rv2 = normrnd(4.5,sqrt(2),1,n2);
% 1500 r.v.'s from N(10.5,3):
n3 = 1500; %sample size of third group
rv3 = normrnd(10.5,sqrt(3),1,n3);

Xart = [rv1 rv2 rv3]; %concatenate created 3-term mixture data

%% Step 3 - Find finite mixture model using csfinmix
p0 = [1/3 1/3 1/3]; %initial guess for p
mu0 = [-2 4 10]; %initial guess for mu
sig20 = [1 1 1]; %initial guess for sig2
maxit = 100; %maximum iterations
tol = 1e-5; %tolerance threshold

[pies,mus,vars]=csfinmix(Xart,mu0,sig20,p0,maxit,tol);

%% Step 4 - Generate 3000 random variables from the FM model
n = 3000; %desired sample size
% Generate r.v.s from uniform distribution:
U = rand(1,n);
% Find number in each group
ind1 = length(find( U <= pies(1) ));
ind2 = length(find( U > pies(1) & U <= pies(1)+pies(2)));
ind3 = length(find( U > pies(1)+pies(2)));
% Generate random variables from the FM model
x(1:ind1) = randn(ind1,1)*sqrt(vars(1)) + mus(1);
x(ind1+1:ind1+ind2) = randn(ind2,1)*sqrt(vars(2))+mus(2);
x(ind1+ind2+1:ind1+ind2+ind3) = randn(ind3,1)*sqrt(vars(3))+mus(3);
xfm = x;
%% Step 5 - Histogram (with artificial data)
figure(1); clf;
subplot(121)
hold on;
x_lin = linspace(-10,20); %generate x-axis values
fhat = zeros(size(x_lin)); %initialize fhat
% FM density:
for i=1:nterm
    fhat = fhat+pies(i)*normpdf(x_lin,mus(i),sqrt(vars(i)));
end
% Create and resize histogram:
[N,h] = hist(Xart,12);
N = N/(h(2)-h(1))/n;
bar(h,N,1,'w'); %plot histogram of artificial data
plot(x_lin,fhat); %plot FM density
title('Histogram of artificial data with FM density superimposed')
legend('Artificial data','FM density')

%% Step 6 - Histogram (with generated FM data)
subplot(122)
hold on;
% Create and resize histogram:
[N2,h2] = hist(xfm,12);
N2 = N2/(h2(2)-h2(1))/n;
bar(h2,N2,1,'w'); %plot histogram of generated FM data
plot(x_lin,fhat); %plot FM density
title('Histogram of FM data with FM density superimposed')
legend('FM data','FM density')