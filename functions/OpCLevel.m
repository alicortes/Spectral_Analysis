function [CLserie] = OpCLevel(serie);

mode = 0;

if (mode == 0)
  Chi95 = [ 0.0039  0.103  0.352  0.711  1.15  1.64  2.17  2.73  3.33  3.94 ...
            4.57    5.23   5.89   6.57   7.26  7.96  8.68  9.36 10.12 10.85 ...
           11.59   12.34  13.09  13.85  14.61 15.38 16.15 16.93 17.71 18.49 ...
           26.51   43.19  95.70];
  Chi05 = [ 3.84    5.99   7.81   9.49  11.07 12.59 14.07 15.51 16.92 18.31 ...
           19.68   21.03  22.36  23.68  25.00 26.30 27.59 28.87 30.14 31.41 ...
           32.67   33.92  35.17  36.42  37.65 38.88 40.11 41.34 42.56 43.77 ...
           55.76   79.08 146.57];
  ChiN =  [1:30 40 60 120];
  temp = 2*serie(:,2).*serie(:,1);
  llim = temp./interp1(ChiN,Chi05,(2*serie(:,2)));
  hlim = temp./interp1(ChiN,Chi95,(2*serie(:,2)));
else
  % the Chi distribution with N degrees of freedom at Alfa is the
  % Gamma distribution with N/2 degrees of freedom an m=2.
  %temp = 2*serie(:,2).*serie(:,1);
  %llim = temp./gaminv(1-0.05,(2*serie(:,2))/2,2);
  %hlim = temp./gaminv(1-0.95,(2*serie(:,2))/2,2);
end;

CLserie = [serie(:,1) llim hlim];

