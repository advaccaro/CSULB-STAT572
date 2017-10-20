%STAT572_HW8_9_19.m
%Adam Vaccaro
%Purpose: Using the method for generating r.v.'s from a finite mixture that
% was discussed in this chapter, develop and implement an algorithm for
% generating r.v.'s based on a kernel density estiamte (use snowfall data)

%% Step 1 - Set up
addpath(genpath('/Users/ADV/Documents/MATLAB/'))
clear all; close all;
load('snowfall.mat'); %load snowfall data
X = snowfall;
n = length(X); %sample size of snowfall data
xs = linspace(floor(min(X))-10,ceil(max(X))+10);

%% Step 2 - Normal kernel density estimatation
sig_squig = min(std(X),iqr(X)/1.348);
hN = 1.06*sig_squig*n^(-1/5);
fhatN = zeros(size(xs));
for i = 1:n
    f=exp(-(1/(2*hN^2))*(xs-X(i)).^2)/sqrt(2*pi)/hN;
    fhatN = fhatN+f/(n);
end

%% Step 3 - Generate r.v.'s based on KDE
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

%% Step 4 - Histogram (snowfall data)
figure(1); clf;
subplot(121)
hold on;
% Create and resize histogram:
[N,h] = hist(X,12);
N = N/(h(2)-h(1))/n;
bar(h,N,1,'w'); %plot histogram of snowfall data
plot(xs,fhatN); %plot normal KDE
title('Histogram of snowfall data with normal KDE superimposed')
legend('Snowfall data','Normal KDE')

%% Step 5 - Histogram (generated data)
subplot(122)
hold on;
% Create and resize histogram:
[N2,h2] = hist(Xgen,12);
N2 = N2/(h2(2)-h2(1))/n;
bar(h2,N2,1,'w'); %plot histogram of generated normal KDE data
plot(xs,fhatN); %plot normal KDE
title('Histogram of generated normal KDE data with normal KDE superimposed')
legend('Normal KDE data','Normal KDE')