function sum_res_squared = geospeed1plotSugawara(x0)
%x0 = 100;
global MgO
global a0
global Temp0
global Temp2
global deltaT
global Dfac

numx = 51;   %number of grid points in x=r/a
dx = 1/(numx - 1);
x = 0:dx:1;   %vector of x values, to be used for plotting
Dmax = Dfac*1e6*exp(-7.895-26257/Temp0);  
q1_hour = x0;    % cooling rate 1 in degrees per hour
q1 = q1_hour/3600;   % initial cooling rate in degrees per second
tau=(Temp0-Temp2)/q1; %Temp in K & tau1 in s
dt = 0.01*a0*(dx^2)/Dmax;    % sets dt1/dx^2 <0.5 for stability
t = 0:dt:tau;
numt = length(t);  %number of time steps to be iterated over

if numt<=0 || q1<=1e-3
    sum_res_squared = 100000;
else

C = zeros(numx,numt);   %initialize everything to zero
w = zeros(numx, numt);
X1 = zeros(2*numx-1, 3);
we = zeros(1,numt);
D = zeros(1,numt);
t1 = zeros(1,numt); 
Temp=Temp0-(q1*t); 
   
 
%specify initial conditions
%wi=exp(7.82-8040/Temp0); %initial MgO wt percent
wi = (Temp0 + deltaT - 1316)*(0.68/12.95);
wmin = 0;
we(1)=wi;
D(1)=Dmax;
C(:,1) = x;

%iterate difference equation
for j=1:numt-1
   
   %we(j+1)=exp(7.82-8040/Temp(j+1));
   we(j+1)=(Temp(j+1) + deltaT - 1316)*(0.68/12.95);
   D(j+1)=Dfac*1e6*exp(-7.895-26257/Temp(j+1));
   dt1=sqrt(D(j)*D(j+1))*(t(j+1)-t(j))/((a0)^2); 
   t1(j+1)=t1(j)+dt1;   
   C(1,j+1)=0; C(numx,j+1)=max(wmin/wi,we(j+1)/wi);
   dstep=dt1/(dx^2); 
   for i=2:numx-1
      C(i,j+1) = C(i,j) + dstep*(C(i+1,j) - 2*C(i,j) + C(i-1,j)); 
   end
end
%convert C=r*w/(a*wi) matrix to w matrix
for j=1:numt
    for i=2:numx
        w(i,j)=C(i,j)*wi/x(i);
    end
    w(1,j)=1.5*w(2,j)-0.5*w(3,j); %center conc
end

r=a0*x;

%store r(mm),initial conc, and final conc in matrix X1
for i=2:numx
    X1(i+numx-1,1)=r(i); X1(numx+1-i,1)=-r(i);
    X1(i+numx-1,2)=wi; X1(numx+1-i,2)=wi;
    X1(i+numx-1,3)=w(i,numt); X1(numx+1-i,3)=w(i,numt);
end
X1(numx,1)=0; X1(numx,2)=wi; 
X1(numx,3)=w(1,numt); % center conc


MgOmodel = spline(X1(:,1),X1(:,3),MgO(:,1));
residuals = MgO(:,2) - MgOmodel;
res_squared = residuals.^2;
sum_res_squared = sum(res_squared)/length(MgO(:,1));

TempC = Temp - 273;
figure(1)
subplot(2,2,1)
hold on
set(gca, 'fontsize', 16)
plot(t, TempC, 'r--', 'linewidth', 2.0, 'displayname', '1-stage model')
xlabel('Time (s)', 'fontsize', 12)
ylabel('Temperature (\circC)', 'fontsize', 12)
axis square

figure(1)
subplot(2,2,2)
hold on
y=MgO(:,2);
%margin = 0.3;
%ciplot(y-margin, y+margin, 1000*MgO(:,1), [0.9 0.9 0.9])
plot(1000*MgO(:,1),MgO(:,2),'ok', 'displayname', 'MgO data');
plot(1000*X1(:,1),X1(:,2), 'k', 'linewidth', 2.0, 'displayname', 'Initial condition')
plot(1000*X1(:,1),X1(:,3), 'r--', 'linewidth', 2.0, 'displayname', '1-stage model')
xlim([-80 80])
ylim([1 8])
xlabel('Radial distance (\mum)', 'fontsize', 12)
ylabel('MgO (wt%)', 'fontsize', 12)
%legend1 = legend(gca, 'show');
%set(legend1,'Location','north');
axis square
end
 