%theta.m
%Adam Vaccaro
%Purpose: Function used for STAT572 Midterm 1 Problem 2.
% Calculates the value of theta = P(X>=10)
function t = theta(X)
t = length(find(X>=10))/length(X);
end