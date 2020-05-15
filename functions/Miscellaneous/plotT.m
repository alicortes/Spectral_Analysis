function plotT(time,T,depth);
% Creates a nice plot of time, T, and labels with depth.
% USAGE 
%      plotT(time,T,depth);
% VERSION
%      V 1.0 - csh 9/05

Tave = nanmean(T);
readme.T_inc_l2r = Tave(1) < Tave(end);

%figure
set(gcf,'position',goodfigsize_1ax(gcf))
%if ~readme.T_inc_l2r
    plot (time,T,'linewidth',1);
    legend (num2str(vert(depth)),'location','EastOutside');
%else
%    plot(time,fliplr(T))
%    legend (num2str(flipud(vert(depth))),'location','EastOutside');

%end
xlabel ('Time (Julian day)');
ylabel ('Temperature (ºC)');