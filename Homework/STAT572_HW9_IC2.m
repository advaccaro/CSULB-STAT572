%STAT572_HW9_IC2.m
%Adam Vaccaro
%Purpose: Simulation AR(1) MC of length 500 with mu0 = 5 and sig2 = 0.25
%with (a) phi = 0.4, (b) phi = 0.9, (c) phi = 1, (d) phi = 1.1 and then
%plot them.

%% Step 1 - Set up
clear all; close all;
mu0 = 5; %initial value for mu
sig2 = 0.25; %variance
phi = [0.4 0.9 1 1.1]; %values of phi
n = 500;
%Initialize chains w/ first value:
chain1 = mu0; chain2 = mu0; chain3 = mu0; chain4 = mu0;

%% Step 2 - Generate chains
for i = 1:(n-1)
    chain1(i+1) = phi(1)*chain1(i)+sqrt(sig2)*randn;
    chain2(i+1) = phi(2)*chain2(i)+sqrt(sig2)*randn;
    chain3(i+1) = phi(3)*chain3(i)+sqrt(sig2)*randn;
    chain4(i+1) = phi(4)*chain4(i)+sqrt(sig2)*randn;
end

%% Step 3 - Plotting
figure(1); clf;
subplot(411); plot(chain1); legend('\phi = 0.4'); legend('boxoff');
subplot(412); plot(chain2); legend('\phi = 0.9'); legend('boxoff');
subplot(413); plot(chain3); legend('\phi = 1.0'); legend('boxoff');
subplot(414); plot(chain4); legend('\phi = 1.1'); legend('boxoff');