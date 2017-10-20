%STAT572_HW5_IC.m
%Adam Vaccaro
%Purpose: (Part a) Take random sample of size 20 from N(2,1) and calculate
%the 95% CI of median using: 1) standard method; 2) boot-t; 3) boot 
%percentile.  Plot histograms of the bootstrap estimates.
%(Part b) Repeat (a) 100 times and calculate the coverage of each method.

%% Step 1 - Set up
clear all
n = 20; %sample size
X = normrnd(2,1,1,n); %generate random sample ~ N(2,1)
B = 400; %number of bootstrap trials
med_obs = median(X); %median of sample
alpha = .05; %alpha
%% Step 2 - Bootstrap
for j = 1:100
    [med_b, X_b] = bootstrp(B,'median',X); %bootstrap replicates and samples
    med_se = std(med_b); %standard error of median
    smed_b = sort(med_b);
    %% Step 3 - Bootstrap standard CI
    zcv1 = icdf('Normal',alpha/2,0,1);
    zcv2 = icdf('Normal',1-alpha/2,0,1);
    standard_hi(j) = med_obs + zcv2*med_se;
    standard_lo(j) = med_obs + zcv1*med_se;    
    %% Step 4 - Bootstrap-t CI
    for i = 1:B
        xstar = X(X_b(:,i)); %extract resample from the data
        sehats(i) = std(bootstrp(25,'median',xstar));
    end
    zvals = (med_b - med_obs)./sehats'; %standardize med_b
    k = B*alpha/2;
    szval = sort(zvals);
    thi = szval(k); %upper t percentile
    tlo = szval(B-k); %lower t percentile
    boott_hi(j) = med_obs - thi * med_se;
    boott_lo(j) = med_obs - tlo * med_se;    
    %% Step 5 - Bootstrap percentile CI
    t1 = ceil(B*alpha/2); %lower t score
    t2 = ceil(B-k); %upper t score
    bootp_lo(j) = smed_b(t1); %bootstrap percentile CI lower limit
    bootp_hi(j) = smed_b(t2); %bootstrap percentile CI upper limit
end
%% Step 6 - Plotting
hist(med_b);
xlabel('Value of replicate (median)'); ylabel('Number of occurences');
title('Histogram of the bootstrap replicates for the median');

%% Step 7 - Calculate coverage
standard_cover = 0;
boott_cover = 0;
bootp_cover = 0;
for j = 1:100
    if standard_lo(j) < 2 && standard_hi(j) > 2
        standard_cover = standard_cover + 1;
    end
    if boott_lo(j) < 2 && boott_hi(j) > 2
        boott_cover = boott_cover + 1;
    end
    if bootp_lo(j) < 2 && bootp_hi(j) > 2
        bootp_cover = bootp_cover + 1;
    end
end
standard_cover = standard_cover/100;
boott_cover = boott_cover/100;
bootp_cover = bootp_cover/100;
