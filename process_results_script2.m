load settingsvec.txt
load final_results_1stage.txt
load final_results_2stage.txt
load MgO.txt

% assume that rate1 and rate2 follow a lognormal distribution:
x1 = [median(log10(final_results_1stage(:,1))) std(log10(final_results_1stage(:,1)))];
x2 = log10(final_results_2stage(:,2:4));   % rate1, T1, rate2
Temp1_bf = final_results_2stage(:,3);

stats_1stage = [median(final_results_1stage(:,1)) std(final_results_1stage(:,1))];
dlmwrite('stats_1stage.txt', stats_1stage)

stats_2stage = [median(x2(:,1)), std(x2(:,1)), median(Temp1_bf)-273, std(Temp1_bf), median(x2(:,3)), std(x2(:,3))];
dlmwrite('stats_2stage.txt', stats_2stage)

temp0_C = settingsvec(:,2)-273;
temp2_C = settingsvec(:,3)-273;
all_stats = [settingsvec(:,1) temp0_C temp2_C settingsvec(:,4) x1 stats_2stage];
dlmwrite('all_stats2.txt', all_stats)

av = x1(1);
sd = x1(2);
geospeed1plotSugawara(10^av)

x2_centre = [median(x2(:,1)), median(x2(:,2)), median(x2(:,3))];
geospeed2plotSugawara(10.^x2_centre)

fitresults = final_results_2stage;
fitresults = log10(fitresults);

logcentre = [median(fitresults(:,2)), median(fitresults(:,4))];
covr1r2 = cov(fitresults(:,2), fitresults(:,4));

figure(1)
title(plottitle)
subplot(2,2,3:4)
set(gca, 'fontsize', 12)
p3=error_ellipse(covr1r2, logcentre, 0.95)
set(p3, 'displayname', '95% error ellipse')
hold on

p1=errorbar(av, av, sd, sd, 'ok','markerfacecolor', 'r', 'markersize', 10, 'displayname', '1-stage best fit');
%xlim([1 4])
%ylim([2 5])
p4=plot(fitresults(:,2), fitresults(:,4),'ok','markersize', 2, 'displayname', '2-stage MC');
p2=plot(logcentre(1), logcentre(2), 'sb', 'markersize', 10, 'linewidth', 2.0,'markerfacecolor', 'b', 'displayname', '2-stage best fit');
ylabel('log({\itq_2}({\circ}C hr^-^1))')
xlabel('log({\itq_1}({\circ}C hr^-^1))')
set(gca, 'ticklength', [0.02 0], 'fontsize', 12)
legend3 = legend(gca, 'show');
%set(legend3,'Location','northwest', 'fontsize', 10);
set(legend3,'Position',[0.7 0.3, 0.1, 0.2], 'fontsize', 10);
axis square

set(gcf, 'PaperUnits', 'inches');
orient portrait
papersize = get(gcf, 'PaperSize');
width =8;         % Initialize a variable for width.
height = 8;          % Initialize a variable for height.
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf, 'PaperPosition', myfiguresize);

print -dsvg -r600 summaryplot
print -dpdf -r600 summaryplot

