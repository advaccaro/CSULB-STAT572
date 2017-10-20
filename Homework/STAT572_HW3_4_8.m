%STAT572_HW3_4_8.m
%Adam Vaccaro

c = 2; %constant
n = 1000; %generate 1000 random variables
% Set up the arrays to store variables
x = zeros(1,n); %random variates
xy = zeros(1,n); %corresponding y values
rej = zeros(1,n); %rejected variates
rejy = zeros(1,n); %corresponding y values
irv = 1;
irej = 1;
while irv <= n
    y = rand(1); %random number from g(y)
    u = rand(1); %random number for comparison
    if u <= 2*y/c;
        x(irv) = y;
        xy(irv) = u*c;
        irv = irv + 1;
    else
        rej(irej) = y;
        rejy(irej) = u*c; %really comparing u*c<=2*y
        irej = irej + 1;
    end
end
