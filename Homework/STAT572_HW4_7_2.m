%STAT572_HW4_7_2.m
%Adam Vaccaro
%Exercise 7.2: Using the information in example 7.3, plot the probability
%of Type II error as a function of mu.  How does this compare with figure
%7.2?

%% Step 1 - Set up
clear all
mualt = 40:60; %values for mu under the alternative hypothesis
cv = 1.645; %critical value
sig = 1.5; %standard deviation for x-bar
ct = cv*sig + 45; %convert critical value to non-standardized form
ctv = ct*ones(size(mualt)); %vector of critical values w/ size of mualt
%% Step 2 - Calculations
beta = normcdf(ctv,mualt,sig); %probabilities of Type II error
pow = 1 - beta; %power
%% Step 3 - Plotting
figure(1); clf;
subplot(211)
% Panel showing mu vs. power:
plot(mualt,pow);
xlabel('True Mean \mu')
ylabel('Power')
axis([40 60 0 1.1])
subplot(212)
% Panel showing mu vs. beta:
plot(mualt,beta);
xlabel('True Mean \mu')
ylabel('Beta (probability of a Type II error)')
axis([40 60 0 1.1])
