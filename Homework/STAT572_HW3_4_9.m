%STAT572_HW3_4_9.m
%Adam Vaccaro
%Purpose: Generate random variables valued 1-5 and calculate the relative
%frequency of each possible value.
n = 100; %sample size
p = [.15 .22 .33 .1 .2]; %pmf values
np = length(p);
iacc = 0;
irej = 0;
%Use accept/reject method to generate RVs:
while iacc < 100
    Y = unidrnd(5);
    U = rand;
    if U <= p(Y)/.33
        iacc = iacc + 1;
        X(iacc) = Y;
    else
        irej = irej + 1;
    end
end

for i = 1:np
    freq(i) = numel(find(X==i));
end

pfreq = freq/n %relative frequency