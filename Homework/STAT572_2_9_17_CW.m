% %STAT572 - 2/9 In Class
% r=gamrnd(2,5,1000,1);
% xbar=mean(r);msq=(mean(r.^2));
% alphahat=xbar^2/(msq-xbar^2);
% betahat=(msq-xbar^2)/xbar;
% 
% mlegam = mle(r,'distribution','gam')
% 
% mme = [alphahat betahat]



% Generate random vector from Gamma(3,2) using alternative method.  Plot
% histogram with the true density superimposed.
for i = 1:1000
    u = rand(0,1);

csgammp
quad