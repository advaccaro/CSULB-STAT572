%STAT572_HW4_7_4.m
%Adam Vaccaro
%Exercise 7.4: Using the same value for the sample mean, repeat example 7.3
%for different sample sizes of n= 50, 100, 200.  What happens to the curve
%showing the power as a function of the true mean as the sample size
%changes?

%% Step 1 - Set up
clear all
mualt = 40:60; %values for mu under the alternative hypothesis
n = [50 100 200]; %sample sizes
cv = 1.645; %critical value
sig = 15; %sigma
figure(1); clf; %initialize figure
%% Step 2 - Calculations and plot for each sample size
for i = 1:length(n)
    sigxbar = sig/sqrt(n(i)); %standard deviation for x-bar
    ct = cv*sigxbar + 45; %convert critical value to non-standardized form
    ctv = ct*ones(size(mualt)); %vector of critical values w/ size of mualt
    beta = normcdf(ctv,mualt,sigxbar); %probabilities of Type II error
    pow = 1 - beta; %power
    % Plot mu vs. power:
    figure(1); hold on;
    plot(mualt,pow);
    xlabel('True Mean \mu')
    ylabel('Power')
    axis([40 60 0 1.1])
end
%% Step 3 - Finish plot
legend('n = 50', 'n = 100', 'n = 200')
legend('location','southeast')
legend('boxoff')
