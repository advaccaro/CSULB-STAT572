%STAT572_HW2_3_1.m
%Adam Vaccaro
%% Exercise 3.1
%Purpose: Generate 500 random samples from the standard normal distribution
%for sample sizes of n = 2, 15, and 45.  At each sample size, calculate the
%sample mean for all 500 samples.  How are the means distributed as n gets
%large?  Look at a histogram of the sample means to help answer this
%question.  What is the mean and variance of the sample means for each n?
%Is this what you would expect from the Central Limit Theorem?
clear all
%% Step 1 - Set up
n = 45;
% Generate 500 random samples of size n:
x = randn(n,500);
% Get the mean of each sample:
xbar = mean(x,1);
%% Step 2 - Calculate relevant statistics
mean_xbar = mean(xbar);
var_xbar = var(xbar);
%% Step 3 - Create histogram with fitted distribution
histfit(xbar);