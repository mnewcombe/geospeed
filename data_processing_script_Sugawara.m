% FUNCTIONS OF THIS DATA PROCESSING SCRIPT:
% - Turns raw data into vector containing radial dist in mm and MgO conc from
% edge to edge of inclusion.
% - Calculates radius of inclusion
% - Calculates starting temperature (Temp0) and final temperature (Temp2) of inclusion
% - Creates text files of processed input data ('MgO.txt') and a settings
% file ('settingsvec.txt')

% INSTRUCTIONS
% Before running this script, create a text file called 'rawdata.txt' 
% containing your MgO data. The 1st column of 'rawdata.txt' should be relative
% distance between MgO analyses (in microns) and second column should be
% MgO concentration in wt%. An example input file 'rawdata.txt' is
% included (this data is from melt inclusion VF131-4, which is 
% described in detail in Newcombe et al., 2020: https://www.frontiersin.org/articles/10.3389/feart.2020.531911/abstract). The profile should run 
% along the entire diameter of the melt inclusion. Analyses at the ends of 
% the profile that are contaminated by olivine will be automatically removed 
% by this data processing script.


global H2O
global datashift
global MgO_raw
global MgO_in
global Dfac

raw = MgO_raw;

% add a row of indices
indexvec = 1:length(raw);
B = [indexvec', raw];  
 
%sort by value of vector (in row 3 - where the MgO data is)
[Y,I] = sort(B(:,3));  
 
%reorder according to the indexes of the sorted vector
A=raw(I,:);              

min2 = A(1:2,:);         %the 2 smallest MgO concs - i.e. the measured edges of the melt inclusion

if abs(I(2)-I(1))<=2       % this loop takes care of situations where 2 points at the same edge are very close in concentration
    index = 3;
else
    index = 2;
end

if I(1)>I(index)        
    no_ol = raw(I(index):I(1), :);
else
    no_ol = raw(I(1):I(index), :);  % remove the olivine-contaminated points
end

if min2(1,1) > min2 (2,1)       % this loop finds the minimum MgO conc, treats it as the edge of the inclusion, and corrects distances to start from this point.
    shiftdist = (abs(no_ol(:,1) - min2(1,1)))/1000;     %convert to mm
    datashift = [shiftdist no_ol(:,2)];
    datashift = flipud(datashift);  % always list from small dist to large dist
    
else
    shiftdist = (no_ol(:,1) - min2(1,1))/1000;  %convert to mm
    datashift = [shiftdist no_ol(:,2)];
end

% now guess the radius and subtract from all distances to get radial dist.
% Convert to mm 

diameter = max(datashift(:,1));
radiustrial = diameter/2;    % in mm

[radius, fval] = fminsearch(@shiftMgOv3, radiustrial);

shiftdistradial = (datashift(:,1) - radius);   %subtract radius from all distances and convert to mm
radialdatashift = [shiftdistradial datashift(:,2)];

MgO = radialdatashift;
a0 = radius;

% All that's left is to calculate the minimum and maximum temperatures
% across the profile

deltaT = 40.4*H2O - (2.97*(H2O^2)) + (0.0761*(H2O^3));
Temp0 = 1316 + ((12.95/0.68)*MgO_in) - deltaT;
Temp2 = 1316 + ((12.95/0.68)*min(MgO(:,2))) - deltaT;
settingsvec = [a0 Temp0 Temp2 deltaT];

dlmwrite('MgO.txt', MgO)
dlmwrite('settingsvec.txt', settingsvec)

%{
plot(MgO(:,1), MgO(:,2), 'or')
zeroref = [0 5; 0 7];
%MgOflip = flipud(MgO(:,2));
hold on
plot(-MgO(:,1), MgO(:,2), '*r')
plot(zeroref(:,1), zeroref(:,2),'-')
%}