%STAT572_2_16.m
clear all
pvec = [.01, .09, .9];
qvec = [.1, .2, .7];
c = max(pvec./qvec);
size = 1000; i = 1; nrej = 0;
x = zeros(1,1);
while length(x) < size
    u1(i) = rand;
    if u1(i) <= qvec(1)
        y(i) = 1;
    elseif u1(i) <= qvec(1)+qvec(2)
        y(i) = 2;
    else
        y(i) = 3;
    end
    
    u2(i) = rand;
    if u2(i)<=(pvec(y(i))/(c*qvec(y(i))))
        x(i) = y(i);
        i = i + 1;
    else
        nrej = nrej + 1;
    end
end
acceptRate = size/(size+nrej);
cat = hist(x,3);
bar(cat./size);