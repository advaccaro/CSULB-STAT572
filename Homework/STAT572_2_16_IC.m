%STAT572_2_16_IC
%In-class assignment: Want  X ~ f(x) = 20x(1-x)^3 0<x<1
%Use the candidate Y ~ unif(0,1)
% c = 2.1

f_x = @(x) 20*x.*(1-x).^3;
c = 2.1;   % constant 
n=1000;  % generate 1000 rv's
% set up the arrays to store variates
x = zeros(1,n);  						% random variates
xy = zeros(1,n);						% corresponding y values
rej = zeros(1,n);						% rejected variates
rejy = zeros(1,n); % corresponding y values
irv=1;			
irej=1;
while irv <= n
   y = rand(1);  % random number from g(y)
   u = rand(1);  % random number for comparison
   if u <= f_x(y)/c;
      x(irv)=y;
      xy(irv) = u*c;
      irv=irv+1;
   else
             rej(irej)= y;
      rejy(irej) = u*c; % really comparing u*c<=2*y
      irej = irej + 1;
   end
end

figure(1); clf;
plot(x,xy,'o',rej,rejy,'x')
axis([0 1 0 2.15]);
hold on
%plot([0,1],[0,2],'k')
xs = [0:.01:1]; ys = f_x(xs);
plot(xs,ys);
hold off
%plot histogram
figure(2); clf;
[N,h]=hist(x);
N = N/(h(2)-h(1))/n;
bar(h,N,1);
hold on;
plot(xs,ys);