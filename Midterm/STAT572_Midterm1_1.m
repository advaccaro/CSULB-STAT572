%STAT572_Midterm1_1.m
%Adam Vaccaro
%Purpose: Consider pdf: f(x) = 12x(x-1)^2, 0<=x<=1
%(a) Use accept/reject method to generate random sample of size 200 from
%pdf.  Provide density histogram of the random numbers with the true
%density superimposed.  Calculate the probabilty of rejection.  Make figure
%showing accepted/rejected ariates as in Figure 4.3 in the text.
%(b) Implement the kernel density estimation procedure on the random sample
%you generated in part (a).  Use the Normal and Epanechnikov kernels.
%Make histogram of the random numbers with the kernel densities
%superimposed.
%(c) Using Monte Carlo simulation, estimate the MSE at x0 = [0:0.2:1] for
%both Kernel density estimates.

%% Set up
addpath(genpath('/Users/ADV/Documents/MATLAB/')) %add path to functions
clear all;
f_x = @(x) 12.*x.*(x-1).^2; %define pdf f(x) as function
n = 200; %sample size
%Pre-allocate storage space:
x = zeros(1,n); %random variates
xy = zeros(1,n); %corresponding y values
rej = zeros(1,n); %rejected variates
rejy = zeros(1,n); %corresponding y values
xs = linspace(0,1); %test axis
ns = length(xs); %length of test axis
ys = f_x(xs); %corresponding y values
c = f_x(1/3); %c value for accept/reject
%Initialize counters:
irv = 1;
irej = 1;

%% Accept/reject procedure:
while irv <= n
    y = rand;
    u = rand;
    if u <= f_x(y)/c
        x(irv) = y;
        xy(irv) = u*c;
        irv = irv + 1;
    else
        rej(irej) = y;
        rejy(irej) = u*c;
        irej = irej + 1;
    end
end

reject_rate = irej/(irej+irv); %rejection rate
%% Plotting
figure(1); clf;
subplot(211)
plot(x,xy,'o',rej,rejy,'x')
hold on
plot(xs,ys,'k')
hold off
title('Accept/reject diagram')
subplot(212)
[N,h] = hist(x);
N = N/(h(2)-h(1))/n;
bar(h,N,1,'w');
hold on;
plot(xs,ys,'k');
title('Histogram of generated random variables')



%% Normal kernel estimation:
X = x;
sig_squig = min(std(X),iqr(X)/1.348);
hN = 1.06*sig_squig*n^(-1/5);
fhatN=zeros(size(xs));
for i = 1:n
    f=exp(-(1/(2*hN^2))*(xs-X(i)).^2)/sqrt(2*pi)/hN;
    fhatN = fhatN+f/(n);
end

%% Epanechnikov kernel estimation:
fhatE = zeros(size(xs));
hE = hN*(30*sqrt(pi))^.2;
for i = 1:n
    dom=(xs-X(i))/hE;
    for j = 1:ns
        if abs(dom(j))<=1
            f(j)=3*(1-((xs(j)-X(i))/hE).^2)/(4*hE);
        else
            f(j) = 0;
        end
    end
    fhatE = fhatE+f/(n);
end

%% Plotting
figure(2); clf;
hold on
[N,h] = hist(x);
N = N/(h(2)-h(1))/n;
bar(h,N,1,'w');
plot(xs,fhatN,'b',xs,fhatE,'r')
axis([0 1 0 2.5])
legend('Histogram','Normal kernel', 'Epanechnikov kernel')

%% Monte Carlo
M = 100; %number of Monte Carlo trials
xs = [0:.2:1]; ns = length(xs);
%Pre-allocate storage for MC data:
fhatN_M = zeros(M,ns);
fhatE_M = zeros(M,ns);

for j = 1:M
    %Initialize counters:
    irv = 1;
    irej = 1;
    
    % Accept/reject
    while irv <= n
        y = rand;
        u = rand;
        if u <= f_x(y)/c
            x(irv) = y;
            xy(irv) = u*c;
            irv = irv + 1;
        else
            rej(irej) = y;
            rejy(irej) = u*c;
            irej = irej + 1;
        end
    end
    % Normal kernel estimation:
    X = x;
    sig_squig = min(std(X),iqr(X)/1.348);
    hN = 1.06*sig_squig*n^(-1/5);
    for i = 1:n
        f=exp(-(1/(2*hN^2))*(xs-X(i)).^2)/sqrt(2*pi)/hN;
        fhatN_M(j,:) = fhatN_M(j,:)+f/(n);
    end
    
    % Epanechnikov kernel estimation:
    hE = hN*(30*sqrt(pi))^.2;
    for i = 1:n
        dom=(xs-X(i))/hE;
        for k = 1:ns
            if abs(dom(k))<=1
                f(k)=3*(1-((xs(k)-X(i))/hE).^2)/(4*hE);
            else
                f(k) = 0;
            end
        end
        fhatE_M(j,:) = fhatE_M(j,:)+f/(n);
    end
end

%% Calculate MSE
xs00 = zeros(M,1);
MSE_N00 = immse(fhatN_M(:,1),xs00);
MSE_E00 = immse(fhatE_M(:,1),xs00);
xs02 = 0.2 + zeros(M,1);
MSE_N02 = immse(fhatN_M(:,2),xs02);
MSE_E02 = immse(fhatE_M(:,2),xs02);
xs04 = 0.4 + zeros(M,1);
MSE_N04 = immse(fhatN_M(:,3),xs04);
MSE_E04 = immse(fhatE_M(:,3),xs04);
xs06 = 0.6 + zeros(M,1);
MSE_N06 = immse(fhatN_M(:,4),xs06);
MSE_E06 = immse(fhatE_M(:,4),xs06);
xs08 = 0.8 + zeros(M,1);
MSE_N08 = immse(fhatN_M(:,5),xs08);
MSE_E08 = immse(fhatE_M(:,5),xs08);
xs10 = 1.0 + zeros(M,1);
MSE_N10 = immse(fhatN_M(:,6),xs10);
MSE_E10 = immse(fhatE_M(:,6),xs10);

MSE_N = [MSE_N00 MSE_N02 MSE_N04 MSE_N06 MSE_N08 MSE_N10];
MSE_E = [MSE_E00 MSE_E02 MSE_E04 MSE_E06 MSE_E08 MSE_E10];

%% Plotting
figure(3); clf;
hold on;
bar(h,N,1,'w')
plot(xs,MSE_N,'b-x',xs,MSE_E,'r--o')
plot(linspace(0,1),f_x(linspace(0,1)));
legend('Histogram','Normal MSE', 'Epanechnikov MSE', 'true density')
title('Histogram with MSE curves')
