
% PLEASE CITE: 
% Newcombe et al. 2020 "Pressure-Temperature-time paths during mafic
% explosive eruptions", Frontiers in Earth Sciences, 
% https://www.frontiersin.org/articles/10.3389/feart.2020.531911/abstract
% AND
% M. E. Newcombe, A. Fabbrizio, Youxue Zhang, C. Ma, M. Le Voyer, Y. Guan, 
% J. M. Eiler, A. E. Saal, and E. M. Stolper. "Chemical zonation in 
% olivine-hosted melt inclusions." Contributions to Mineralogy and 
% Petrology 168, no. 1 (2014): 1-26, DOI 10.1007/s00410-014-1030-6

% This script fits MgO concentration gradients measured across
% olivine-hosted melt inclusions to single- and two-stage linear cooling
% models. The models are described in detail in the above listed references.
% Please feel free to contact Megan (newcombe@umd.edu) if you have any
% questions!

% BEFORE RUNNING THIS SCRIPT, MAKE SURE YOU HAVE CREATED A TEXT FILE 
% CONTAINING YOUR RAW MGO ANALYSES AS DETAILED IN THE README.pdf
% FILE! AS SET UP HERE, THE SCRIPT WILL USE THE TEST DATA FILE PROVIDED.

close all;
clear all;

% global variable declaration allows parameter values to be shared among
% different scripts (no need to alter):
global H2O
global MgO_in
global MgO_raw
global iterations
global one_sig
global Dfac
global MgO
global a0
global Temp0
global Temp2
global deltaT

% CHANGE THESE TWO PARAMETERS IF NECESSARY:
one_sig = 0.1;      % 1 standard deviation of probe MgO analyses (e.g., measured on homogeneous standard)
iterations = 10;    % number of synthetic MgO profiles to be generated and fit for Monte Carlo error analysis

% load raw MgO data (column 1: distance in um, column 2: MgO in wt%; see readme.pdf for further instructions):
load VF_131_4_raw.txt

% change plottitle to your sample name:
plottitle = 'VF-131-4';

% define MgO_raw variable to match your raw MgO data filename:
MgO_raw = VF_131_4_raw;

% set the initial MgO concentration in the melt inclusion (see Newcombe et
% al. 2014, 2020 for suggestions and guidance):
MgO_in = 3.89;  % initial MgO concentration

% set the water concentration of your melt inclusion:
H2O = 4;    % water concentration in melt (wt%)

% if your melt inclusion is arc basalt with ~4 wt% water, set Dfac to
% 3.44; if your melt inclusion is ocean island basalt or MORB, set Dfac
% to 1.
Dfac = 3.44;

% now run the data processing and fitting scripts:
data_processing_script_Sugawara
geospeed_master_script_Sugawara

