%% pseudo random sequency generation 
% 
% % prbsSeq = ltePRBS(NIDCell,Mpn);
% prbsSeq = ltePRBS(cInit,Mpn);
% %c2 = ltePRBSkru(cInit,Mpn);
% %sum(prbsSeq~=c)
% 
function [ c, cInit] = ltePRBSkru(cInit,Mpn)
Nc = 1600;
% cN(i1) 

x1 = zeros(1,31+Nc+Mpn);
x2 = zeros(1,31+Nc+Mpn);

x1(1) = 1;
x2(1:31) = (de2bi(cInit,31));

for i1 = 1:(Nc+Mpn)
  x1(i1+31) = mod(x1(i1+3)+x1(i1),2);
  x2(i1+31) = mod(x2(i1+3)+x2(i1+2)+x2(i1+1)+x2(i1),2);
end

c = zeros(Mpn,1);
for i1 = 1:Mpn
  c(i1) = mod(x1(i1+Nc)+x2(i1+Nc),2); 
end

end
