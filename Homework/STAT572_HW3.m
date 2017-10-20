%STAT572_HW3.m
%Adam Vaccaro
%Purpose: Use accept/reject method to generate a r.v. with density
%f(x) ={(x-2)/2 for 2<=x<=3, (2-(x/3))/2 for 3<=x<=6}.  Plot accept/reject
%diagram, make histogram with true density superimposed, calculate
%acceptance rate.

f_x1 = @(x) (x-2)./2;
f_y1 = @(y) y-2;
f_x2 = @(x) (2-(x./3))./2;
f_y2 = @(y) 2-(y./3);

c = 2;   % constant 
n=1000;  % generate 1000 rv's
% set up the arrays to store variates
x = zeros(1,n);  						% random variates
xy = zeros(1,n);						% corresponding y values
rej = zeros(1,n);						% rejected variates
rejy = zeros(1,n); % corresponding y values
irv=1;			
irej=1;
while irv <= n
   y = unifrnd(2,6);  % random number from g(y)
   u = unifrnd(0,1);  % random number for comparison
   if y <= 3 && u <= f_y1(y)
      x(irv)=y;
      xy(irv) = u*c*0.25;
      irv=irv+1;
   elseif y > 3 && u<= f_y2(y)
       x(irv) = y;
       xy(irv) = u*c*0.25;
       irv=irv+1;
   else
      rej(irej)= y;
      rejy(irej) = u*c*.25; % really comparing u*c<=2*y
      irej = irej + 1;
   end
end

figure(1); clf;
plot(x,xy,'o',rej,rejy,'x')
%axis([0 1 0 2.15]);
hold on
%plot([0,1],[0,2],'k')
xs1 = [2:.01:3]; ys1 = f_x1(xs1);
xs2 = [3:.01:6]; ys2 = f_x2(xs2);
plot(xs1,ys1,'k',xs2,ys2,'k');
hold off
%plot histogram
figure(2); clf;
[N,h]=hist(x);
N = N/(h(2)-h(1))/n;
bar(h,N,1);
hold on;
plot(xs1,ys1,'k',xs2,ys2,'k');