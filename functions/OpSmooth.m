function [Fserie] = OpSmooth(serie,minB,maxB,ratio)

if ((rem(minB,1) ~= 0) | (rem(maxB,1) ~= 0))
  fprintf('\n   Error: minB and maxB should be integers.\n\n');
  return;
end;

[Lserie,Wserie] = size(serie);

if (maxB < minB)
  minB = maxB;
end;
Band = minB;

Fserie = zeros(Lserie,Wserie+1);

i=1;
j=1;
k=1;
while k <= Lserie-maxB+1,
  Band = round(minB*(abs(ratio)^(i-1)));
  if Band < maxB
    i = i+1;
  else
    Band = maxB;
  end;
  kl = k-1+Band;
  Bmean = sum(serie(k:kl,:))./Band;
  %%%Bmean = median(serie(k:kl,:));
  Fserie(j,:) = [Bmean Band];
  j = j+1;
  k = k+Band;
  if ((minB == 1) & (maxB ~= 1))
    minB = 2;
  end;
end;

Fserie = Fserie(1:j-1,:);
if (ratio < 0)
  Fserie(:,Wserie+1) = [];
end;

return
