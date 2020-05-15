%% MAIN_ClearLake_PSD.m
%       It computes spectra of temperature isodepths
% INPUTS
%       The user can select the .MAT with raw temperature
% FUNCTIONS required
%       OpPSD.m and OpCLevel.m
% OUTPUTS
%       Plots showing the PSD at each depth
% VERSION
%       v.1. A. Cortes - April 2020

clc
close all
clear 

%% Select by user!!

SizeWindow = 1; %day
[FileLst, pname] = uigetfile('*.mat', 'Select t-chain *.mat files');
pfname = [pname FileLst];
load(pfname)
doy = dnum2doy(time);
cd(pname)
cd ..
mkdir('results')
cd('results')

figure;plotT(doy,T,depth)

%day1 and day2
% day1 = input('Input the first day (doy) of your period of interest =  '); 
% day2 = input('Input the last day (doy) of your period of interest =  '); 
yeart = 2019;
day1 = 165;
day2 = 172; 



%% ... Buoyancy frequency, with raw density 

dens = freshwater_density(T,(280/1000).*0.85);
mean_rho = mean(mean(dens));
[drhodz] = gradient(dens,depth,0.3);
nsq = 9.81*drhodz/mean_rho;
n_cph = real(sqrt(nsq))*3600/(2*pi); % in cph
n_s = real(sqrt(nsq)); % in s-1

close 

figure
pcolor(time,depth,n_cph');shading interp
colorbar
caxis([0 20])
title('\bfBuoyancy Frequency [cph]');ylabel('Depth (m)')
xlabel('Time')

close 

%% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%% %% SPECTRA of T using Antenucci
%% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ... Define a window and study period
ttime = doy;
t1v = [day1:SizeWindow:day2];
t2v = t1v + SizeWindow; %0.5 and 1

% ... Loop over the study period of time
for k = 1:length(t1v)
    % define period of time
    t1 = t1v(k);
    t2 = t2v(k);
    dex = find(t1<=ttime & ttime<=t2);
    ptime = ttime(dex);
    
    % select the temperature matrix during the selected window. I don't compute potential energy
    pT = T(dex,:);
    dt = mean(diff(ptime));

    % ... Loop over depths. I select the bottom 12
    d1 = 1;
   
    np = 0;
    h = figure;
    for j = d1:length(depth)
        % select the study temp line
        np = np + 1;
        tmp = pT(:,j); 
        subplot(4,4,np)
        [PSD,~]=OpPSD(dt* 1*24*3600,tmp,1,1,16,1.0905,1,1); 
        
        % select the buoyancy freq. during the study window. Mean?
        dum = find(t1<=ttime & ttime<=t2); 
        nf = mean(n_s(dum,j));
        hold on;
        vector = [nf,nf];
        line(vector,get(gca,'ylim'),'color','m','linestyle','--','linewidth',1);
        
        
        clear tmp  
        title (['Depth = ',num2str(depth(j))],'fontsize',12,'FontWeight','bold')
        if np == 1
            line1 = ['t_1 = ',num2str(t1),' and t_2 = ',num2str(t2)];
            line2 = ['Depth = ',num2str(depth(j))];
            title({line1;line2},'FontWeight','bold','fontsize',12);
        end
        if np == 13
              xlabel('Frequency');
              ylabel('Spectral density');
        end
    end
% size and save
set(gcf,'position',goodfigsize(gcf))
saveFig(pwd,['ClearLake_LA03_set',num2str(k)]);
close

end


