%STAT572_2_23_IC.m
%Adam Vaccaro
% Redo Example 7.6 except with null hypothesis: sigma = 7.8 vs sigma ~= 7.8
% Load up the data.
load mcdata
n = length(mcdata);  								
% Population sigma is known.
sigma = 7.8;					
sigxbar = sigma/sqrt(n);
% Get the observed value of the test statistic.
%Tobs = (mean(mcdata)-454)/sigxbar;
meanobs = mean(mcdata);
varobs = var(mcdata);
Tobs = (n-1)*varobs/(sigma^2);

% This command generates the normal probability plot.
% It is a function in the MATLAB Statistics Toolbox.
%normplot(mcdata)

M = 1000;				% Number of Monte Carlo trials
	% Storage for test statistics from the MC trials.
	Tm = zeros(1,M);
	% Start the simulation.
for i = 1:M
			% Generate a random sample under H_0
			% where n is the sample size.
			xs = normrnd(meanobs,sigma,1,n);
			%Calculate test statistic
            Tm(i) = (n-1)*var(xs)/(sigma^2);
    
end

% Get the critical values for alpha.
% This is a two-tailed test
alpha = 0.05;
cv1 = csquantiles(Tm,alpha/2);
cv2 = csquantiles(Tm,1-alpha/2);
if (Tobs >= cv1) && (Tobs <= cv2)
    pval = 2*length(find(Tm >= Tobs))/M;
else
    display('Test statistic is in rejection region')
end

figure(1); clf;
hist(Tm,20,'w');
hold on;
plot(Tobs,0:150,'ro',cv1,0:150,'bo',cv2,0:150,'bo');