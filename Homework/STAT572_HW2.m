%STAT572_HW2.m
%Adam Vaccaro

%% In-class assignment
%Purpose: Generate a random sample of size 1000 from Gamma(3,2) using the
%alternative method.  Draw histogram with true density superimposed.
clear all
addpath(genpath('/Users/ADV/Documents/MATLAB/CompStatsToolboxV2/'))

%% Step 1 - Set up
r = [0:.01:10]; %vector of x values for testing
nr = length(r); %length of test vector
ns = 1000; %sample size
%Define pdf function:
f_x = @(x) csgammp(x,3,2);
%Define CDF function:
F_x = inline('integral(f_x,0,x)','x','f_x');

%% Step 2 - Generate values of Gamma CDF to test against
for i = 1:nr
    F_r(i) = F_x(r(i),f_x);
end

%% Step 3 - Generate random sample from Gamma(3,2) distribution
for i = 1:ns
    u = rand; %generate a normally distributed random value
    r_ind = find(F_r>=u,1);
    g(i) = r(r_ind);
end
   
%% Step 4 - Create histogram with true density superimposed
figure(1); clf;
%Get the information for the histogram:
[N,h] = hist(g,12);
%Change bar heights to correspond to the theoretical density:
N = N/(h(2)-h(1))/ns;
%Calculate values of the theoretical density:
y = csgammp(r,3,2); 
bar(h,N,1,'w');  hold on; %Plot the histogram
plot(r,y,'k'); %Plot the true density curve
xlabel('X');ylabel('f(x) - Gamma(3,2)'); %add labels to axes