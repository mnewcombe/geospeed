# geospeed

Instructions for ‘Geospeed’ MATLAB package for using MgO concentration profiles in olivine-hosted melt inclusions to constrain the thermal histories of the inclusions. A formatted version of these instructions is available in the folder as 'readme.pdf'.

PLEASE CITE:
1.	NEWCOMBE ET AL. (2014) 'CHEMICAL ZONATION IN OLIVINE-HOSTED MELT INCLUSIONS' Contrib Mineral Petrol., 168:1030 DOI 10.1007/s00410-014-1030-6
2.	NEWCOMBE ET AL. (2020) ‘MAGMA PRESSURE-TEMPERATURE-TIME PATHS DURING MAFIC EXPLOSIVE ERUPTIONS’, Frontiers in Earth Sciences, doi: 10.3389/feart.2020.531911, https://www.frontiersin.org/articles/10.3389/feart.2020.531911/abstract

Background:
Olivine-hosted melt inclusions tend to be compositionally zoned. This zonation forms in the last few seconds to hours of syneruptive cooling and crystallization of olivine on the walls of the inclusions, leading to the formation and propagation of diffusive boundary layers in the adjacent melt. This MATLAB package fits MgO concentration profiles across compositionally zoned olivine-hosted melt inclusions to constrain their syneruptive thermal histories. Two models are included: single-stage linear cooling from the liquidus to the temperature corresponding to the lowest measured MgO in the inclusion; and two-stage linear cooling.  

Inputs:
You will need to create a text file containing your MgO data. The first column of this file should contain the distance between MgO analyses across the melt inclusion and neighboring olivine (in relative microns). The second column should contain the MgO concentration data (in wt%). The file should be saved in the same folder as the other scripts and functions provided in the zip file. Please examine the example input file provided (VF_131_4_raw.txt). Make sure that your microprobe traverse measures across the entire diameter of the melt inclusion, including a few points in the host olivine at both ends of the traverse.
In the file ‘geospeed_master_script.m’ you will need to input the standard deviation of your MgO probe analyses (in wt%) and the number of synthetic profiles that you would like to run for the Monte Carlo analysis.

To run:
1.	Create a file containing your raw MgO data, as described above.
2.	Open file ‘setup.m’ and update the file name corresponding to your raw MgO data file. Set the number of iterations you wish to calculate for the Monte Carlo analysis, the one-sigma error on your MgO analyses, the initial MgO concentration of the melt inclusion you would like to fit (see Newcombe et al. 2014, 2020 for suggestions and guidance), and the water concentration of the melt inclusion in wt%. Also select the correct value of Dfac for your melt composition (Dfac = 3.44 for arc basalts, Dfac = 1 for MORB and OIB). 
3.	Run the setup file. You do not need to make changes to any of the other MATLAB functions or scripts.
4.	Your results will be output as figures and text files (see next section).

Outputs:
The figures output by the code are as follows: (1) a temperature-time plot displaying the one- and two-stage thermal histories that produce the best fits to MgO concentration gradients measured within the inclusion; (2) a plot of MgO data measured along a linear traverse across the diameter of the melt inclusion and best-fit one- and two-stage model curves showing the expected distribution of MgO across the inclusion after cooling; and (3) results of a Monte Carlo simulation to estimate uncertainties on the best-fit cooling rates derived from the model.
Best fit model parameters are compiled in the text files ‘stats_1stage.txt’ and ‘stats_2stage.txt’. stats_1stage.txt summarizes the results of the 1-stage cooling Monte Carlo simulation and stats_2stage.txt summarizes the results of the 2-stage cooling Monte Carlo simulation.
‘stats_1stage.txt’: column 1 is best-fit 1-stage cooling rate in K/hour (as represented by the median value of the best-fit cooling rates found for each Monte Carlo simulation); column 2 is 1 standard deviation of the best-fit 1-stage cooling rates found by the Monte Carlo simulation.
‘stats_2stage.txt’: column 1 is the median value of cooling rate 1 in K/hour, column 2 is the standard deviation of best-fit values of cooling rate 1, column 3 is the median value of ‘Temp1’ (the temperature at which the cooling rate switches from rate 1 to rate 2), column 4 is the standard deviation of best-fit values of Temp1, column 5 is the median value of cooling rate 2, and column 6 is the standard deviation of best-fit values of cooling rate 2.

