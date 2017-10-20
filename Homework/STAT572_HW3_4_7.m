%STAT572_HW3_4_7.m
%Adam Vaccaro
%Use betagen.m function to generate beta RVs, create histogram, and then
%draw true density curve.

function [ ] = STAT572_HW3_4_7(a,B,n)
Xbeta = zeros(n,1); %Preallocate space for beta RVs
for i = 1:n
    Xbeta(i) = betagen(a,B); %use betagen.m to generate beta RVs
end
%plot histogram
[N,h] = hist(Xbeta);
N = N/(h(2)-h(1))/n;
bar(h,N,1); hold on;
xs = [0:.01:1];
ys = betapdf(xs,a,B);
plot(xs,ys,'r');