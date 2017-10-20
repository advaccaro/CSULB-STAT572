%STAT572_HW7_IC.m
%Adam Vaccaro
%Purpose: Generate a random sample of size 100 ~ exp(5).  Find the estimate
%of the density using the normal and Epanechnikov kernels.  Plot a
%histogram with the kernel estimators superimposed.  Perform Monte Carlo
%simulations to estimate MSE at Xo = 1,5,10 for Normal and Epanechnikov.

%% Step 1 - Set up
n = 100; %sample size
X = exprnd(1/5,n,1); %generate random sample
xs = linspace(0,15); %generate axis of test values
ns = length(xs); %length of test axis

%% Step 2 - Normal kernel estimation
sig_squig = min(std(X),iqr(X)/1.348);
hN = 1.06*sig_squig*n^(-1/5);
fhatN=zeros(size(xs));
for i = 1:n
    f=exp(-(1/(2*hN^2))*(xs-X(i)).^2)/sqrt(2*pi)/hN;
    fhatN = fhatN+f/(n);
end

%% Step 3 - Epanechnikov kernel estimation
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
%% Step 4 - Histogram
h = 2.15*sqrt(var(X))*n^(-1/5);
t0 = min(X)-1;
tm = max(X)+1;
bins = t0:h:tm;
vk = histc(X,bins);
vk(end) = [];
fhat = vk/(n*h);
bc = (t0+h/2):h:(tm-h/2);
%% Step 5 - Plotting
figure(1); clf;
subplot(121)
hold on
bar(bc,fhat,1,'w')
plot(xs,fhatN,'b',xs,fhatE,'r')
legend('Histogram','Normal kernel','Epanechnikov kernel')
axis([-.25 15.25 0 3])

%figure(2); clf; %zoomed in
subplot(122)
hold on
bar(bc,fhat,1,'w')
plot(xs,fhatN,'b',xs,fhatE,'r')
legend('Histogram','Normal kernel', 'Epanechnikov kernel')
axis([0 1.5 0 3])

%% Step 6 - Monte Carlo
M = 1000; %number of Monte Carlo trials
xs_mc = [1 5 10]; ns_mc = length(xs_mc);
%Pre-allocate storage for MC data:
fhatN_M = zeros(M,ns_mc);
fhatE_M = zeros(M,ns_mc);
for j = 1:M
    X_mc = exprnd(1/5,n,1);
    % Normal kernel estimation:
    X = X_mc;
    sig_squig = min(std(X),iqr(X)/1.348);
    hN = 1.06*sig_squig*n^(-1/5);
    for i = 1:n
        f=exp(-(1/(2*hN^2))*(xs_mc-X(i)).^2)/sqrt(2*pi)/hN;
        fhatN_M(j,:) = fhatN_M(j,:)+f/(n);
    end
    
    % Epanechnikov kernel estimation:
    hE = hN*(30*sqrt(pi))^.2;
    for i = 1:n
        dom=(xs_mc-X(i))/hE;
        for k = 1:ns_mc
            if abs(dom(k))<=1
                f(k)=3*(1-((xs_mc(k)-X(i))/hE).^2)/(4*hE);
            else
                f(k) = 0;
            end
        end
        fhatE_M(j,:) = fhatE_M(j,:)+f/(n);
    end
end

%% Calculate MSE
xs1 = 1 + zeros(M,1);
ys1 = exppdf(xs1,1/5);
MSE_N1 = immse(fhatN_M(:,1),ys1);
MSE_E1 = immse(fhatE_M(:,1),ys1);
xs5 = 5 + zeros(M,1);
ys5 = exppdf(xs5,1/5);
MSE_N5 = immse(fhatN_M(:,2),ys5);
MSE_E5 = immse(fhatE_M(:,2),ys5);
xs10 = 10 + zeros(M,1);
ys10 = exppdf(xs10,1/5);
MSE_N10 = immse(fhatN_M(:,3),ys10);
MSE_E10 = immse(fhatE_M(:,3),ys10);