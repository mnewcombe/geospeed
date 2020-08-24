% This script fits MgO concentration gradients measured across
% olivine-hosted melt inclusions to single- and two-stage linear cooling
% models. The models are described in detail in Newcombe et al. (2014, 2020).
% Please feel free to contact Megan (newcombe@umd.edu) if you have any
% questions!

% BEFORE RUNNING THIS SCRIPT, MAKE SURE YOU HAVE RUN THE SETUP SCRIPT! 

global one_sig
global iterations
global MgO
global a0
global Temp0
global Temp2
global deltaT

load MgO.txt
load settingsvec.txt

Temp0 = settingsvec(2);
Temp2 = settingsvec(3);
a0= settingsvec(1);  %radius of melt inclusion in mm
deltaT = settingsvec(4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% First, fit the data to a 1-stage linear cooling model
x0 = 100;
results = zeros(iterations,3+length(MgO));

for k = 1:iterations
    k
    
% Generate fake noisy data    
MgOnoise = addnoise(MgO, one_sig);
MgO = MgOnoise;

options = optimset('TolFun',1, 'TolX', 1);
[x, fval, exitflag] = fminsearch(@geospeed1Sugawara, x0, options);
results(k,:) = [x fval exitflag MgO(:,2)'];
end

%av = mean(results(:,1));
%sd = std(results(:,1));

clear x
clear fval
clear x0
 
dlmwrite('final_results_1stage.txt', results)
%dlmwrite('stats_1stage.txt', [av sd])


%%%%%%%%%%%%%%%%%%%%%
% Now fit the data to a 2-stage linear cooling model

% Monte Carlo error analysis: Add random noise to the original MgO data to
% create p=# iterations synthetic MgO profiles. Fit each of these profiles.
% Choose starting values for cooling rate fit parameters (q1, q2, Temp1 -
% see supplementary information of Newcombe et al. 2014) by testing n=200
% randomly selected starting values. 
% Reduce values of # iterations and p if program takes too long to run.
n=200;
p=iterations;

final_results = zeros(p,4+length(MgO)+1);

results_ordered = zeros(n,4);
sar = zeros(1,n);

for k = 1:p
    k
load MgO.txt    
%Generate fake noisy data    
MgOnoise = addnoise(MgO, one_sig);
MgO = MgOnoise;

% Generate random starting positions for Monte Carlo analysis
xtrial(:,1) = rand(n,1)*2000 + 10;  % 50:1001 K/hour
xtrial(:,2) = rand(n,1)*(Temp0-Temp2) + Temp2;  
xtrial(:,3) = rand(n,1)*2000 + 10;         

% Calculate misfit of model at each starting position
for i = 1:n
    sar(i) = geospeed2Sugawara(xtrial(i,:));   %store values of sum of residuals, q1, Temp1, and q2.
end

% Sort results from lowest to highest misfit
results = [sar' xtrial];
[Y,I]=sort(results(:,1));
results_ordered=results(I,:);  %use the column indices from sort() to sort all columns of A.

clear xtrial
clear results

% Select the best result with the lowest misfit
x0 = results_ordered(1,2:4);

% Use fminsearch starting from the best Monte Carlo result to find the
% minimum. Iterate 5 times.
 
for j = 1
    options = optimset('TolFun',1, 'TolX', 1);
    [x, fval, exitflag] = fminsearch(@geospeed2Sugawara, x0, options);
    x0 = x;
end
  final_results(k, 1:7) = [fval x x0];
  final_results(k, 8:length(MgO)+7) = MgO(:,2)';
  final_results(k, end) = exitflag;
  
  clear x
  clear fval
  clear x0
   
end

dlmwrite('final_results_2stage.txt', final_results)

process_results_script2