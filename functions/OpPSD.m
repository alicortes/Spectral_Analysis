function  [PSD, CLV] = OpPSD(t,series,window,p1,p2,p3,CL,PPLOT)


%  POWER SPECTRAL DENSITY 
%  ____________________________________________________________________
%
%  COMMAND:  OpPSD(t,series,window,p1,p2,p3,CL,PPLOT);
%
%  INPUT
%  - t:      sampling interval in seconds;
%  - serie:  time series;
%  - window: 0 no window;
%            1 cosine taper window;
%            2 hanning window;
%  - IF p1 >  0 ==> average in frequency domain (minB,maxB,ratio);
%            minB = p1:  minimum band;
%            maxB = p2:  maximum band;
%            ratio= p3:  rate of band increase; 
%  - IF p1 <= 0 ==> average in time domain (WSize,WShift);
%            WSize = p2: window size in seconds;
%            WShift= p3: window shift in seconds;
%  - CL:     confidency level option (CL=1 means conf. level stored);
%  - PPLOT:  0 means no plot & 1 generates plot.
%
%
%  OUTPUT:   [Freq PSD]
%
%  REFERENCE:
%  Bendat, J.S. & Piersol, A.G., 1986. Random data: analysis and
%     measurement procedures. 2d ed., John Wiley & Sons, 566 pp. 
%     chapter 5
%
%  The time averaging method is also known as the Welch method, which
%  is used by Matlab as the default. It divides things into bins, and
%  you tend to lose the lower frequencies. The frequency band averaging
%  is geometric, and so you keep the lower frequencies.
%  	Band >= minB
%	Band <= maxB
%	Band = minB * ratio^(i-1)
%  so as i increases, you average using maxB
%  ____________________________________________________________________
 
 serie = series(:);
%  keyboard
SSize = length(serie);

if (p1 > 0)
  minB  = p1;
  maxB  = p2;
  ratio = p3;
  w = SSize;
  s = 0;
  TAvg  = 1;
  if (PPLOT == 1)
  fprintf('\n   POWER SPECTRAL DENSITY AVERAGED IN FREQUENCY DOMAIN\n\n');
  end;
else
  minB  = 1;
  maxB  = 1;
  ratio = 1;
  WSize  = p2;
  WShift = p3;
  w = WSize/t;
  s = WShift/t;
  TAvg = fix((SSize-w+s)/s);
  if (PPLOT == 1)
  fprintf('\n   POWER SPECTRAL DENSITY AVERAGED IN TIME DOMAIN\n\n');
  end;
end;

index = (1:w);
PSD = zeros(fix(w/2),1);
for i = 1:TAvg
  dserie = (serie(index) - mean(serie(index)));
  %dserie = detrend(serie(index));
  index = index + s;
  if (window == 2)
    var0 = std(dserie)^2;
    h = .5*(1 - cos(2*pi*(1:w)'/(w+1)));
    dserie = h.*dserie;
    var1 = std(dserie)^2;
    factor = var0/var1;
    if (PPLOT == 1)
    fprintf('   HANNING WINDOW: variance correction factor is %5.2f \n',factor);
    end;
  elseif (window == 1)
    var0 = std(dserie)^2;
    h = ones(w,1);
    alfa = ceil(0.10*w);
    h(1:alfa) = 0.5*(1 - cos(pi*(1:alfa)/alfa));
    h((w-alfa):w) = 0.5*(1 - cos(pi*((w-alfa):w)/alfa));
    dserie = h.*dserie;
    var1 = std(dserie)^2;
    factor = var0/var1;
    if (PPLOT == 1)
    fprintf('   COSINE TAPER WINDOW: variance correction factor is %5.2f\n',factor);
    end;
  else
    factor = 1;
  end;

  X = fft(dserie);
  X = X(2:1+floor(w/2)); %warning here. FRAM 
  % disp(['w ',num2str(w/2)]);
  PSD = PSD + (factor*(abs(X).^2)/(w/t));

end;
PSD = PSD/TAvg;
PSD =PSD*2; % FRAM from two to one sided
Freq = [1:(w/2)]'/(w*t);

if (p1 > 0) && (maxB > 1.0)
  PSD=OpSmooth(PSD,minB,maxB,ratio);
  PSD=PSD(:,1);
  Freq=OpSmooth(Freq,minB,maxB,ratio);
  Band=Freq(:,2);
  Freq=Freq(:,1);
else
  Band=TAvg*ones(size(Freq));
end;

% jason to get CLV
CLV=[];

if (CL == -1) && (PPLOT == 1)
  PSD = OpCLevel([PSD Band]);
  loglog(Freq,PSD(:,1),Freq,PSD(:,2),':',Freq,PSD(:,3),':');
  xlabel('Frequency');
  ylabel('Spectral density');
elseif (CL == +1) && (PPLOT == 1)
  CLV = min(PSD)*ones(size(PSD));
  CLV = OpCLevel([ CLV Band]);
  h=loglog(Freq,PSD(:,1),'k',Freq,CLV(:,2),':k',Freq,CLV(:,3),':k');
  set(h,'linewidth',1.5);
  xlabel('Frequency');
  ylabel('Spectral density');
else
  CLV = nanmin(PSD)*ones(size(PSD));
  CLV = OpCLevel([ CLV Band]);
  if (PPLOT == 1)
    loglog(Freq,PSD(:,1));
    xlabel('Frequency');
    ylabel('Spectral density');
  end;
end;

%PSD=[Freq PSD(:,1)];
PSD=[Freq PSD];



return

