%% STAT 572 - Homework 1
% Adam Vaccaro
% Purpose: Generate a random sample of size 1000 from Gamma(2,3)
% distribution and estimate the value of the second parameter (beta)
% using the Newton-Raphson method.
clear all

%% Step 1 - Setup 
x = gamrnd(2,3,1000,1); %Generate 1000x1 vector of Gamma(2,3) random variables
n = length(x); %get length of data vector
x_bar = mean(x); %mean of data vector
tol = .0000000001; %set tolerance threshold
loop = 0; %initialize loop counter at 0
B0 = 1; %set initial guess for B0


%% Step 2 - Calculate Bhat (Fisher scoring)
%Formula for the score (u):
u = inline('((-2*n)/B)+((n*x_bar)/(B^2))','B','n','x_bar');

%Formula for the inverse of the information (I^-1):
I_inv = inline('(B^2)/(2*n)','B','n');

%Calculate Bhat using initial guess:
Bhat = B0 + I_inv(B0,n)*u(B0,n,x_bar);

%% Step 3 - Algorithm
while abs(Bhat - B0) > tol
    B0 = Bhat;
    Bhat = B0 + I_inv(B0,n)*u(B0,n,x_bar);
    loop = loop +1; 
end

%% Step 4 - Print results
fprintf('Bhat = %4.4f \n',Bhat) %print final value of Bhat
fprintf('loop = %1.0f \n',loop) %print final value of loop
