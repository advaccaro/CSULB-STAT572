%STAT572_HW3_4_6.m
%Adam Vaccaro
function [ ] = STAT572_HW3_4_6(df,n)
%Purpose: Use the chi2gen.m function to generate chi-sq RVs and plot a
%histogram with true density superimposed.
%Inputs: df - degrees of freedom
%        n - Sample size
%Outputs: Histogram w/ density superimposed
Xchi = zeros(n,1); %Pre-allocate space for chi-sq RVs
for i = 1:n
    Xchi(i) = chi2gen(df); %use chi2gen.m function to generate chi-sq RVs
end
%plot histogram
[N,h]=hist(Xchi);
N = N/(h(2)-h(1))/n;
bar(h,N,1); hold on;
xs = [0:.01:15];
ys = chi2pdf(xs,2);
plot(xs,ys,'r');