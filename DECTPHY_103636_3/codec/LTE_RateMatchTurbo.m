%
% Test LTE encoder 
%

% Kalle Ruttik
% 29.10.2024

function [rmatched,w] = LTE_RateMatchTurbo(din,lenout,rv,N_ss,N_bps)


InterleaverValuesinLTESpec

if ~iscell(din)
  dinc{1} =din;
else
  dinc = din;
end
C = length(dinc);
Gprim = lenout/(N_ss*N_bps);
gamma = mod(Gprim,C);

rmatched = [];
for seginx = 1 : C
d = dinc{seginx};
w = LTE_ChannelInterleaver(d);

if((seginx-1)<=(C-gamma-1))
  E = N_ss*N_bps*floor(Gprim/C);
else
  E = N_ss*N_bps*ceil(Gprim/C);
end

% rate match
K2 = length(d)/3;
K = K2-4;
p1 = find(Kvalues(:,2)==K);
p = Kvalues(p1,:);
% K=p(2);

C_subblock_TC = 32;
R_subblock_TC = ceil((K+4)/C_subblock_TC);
K1 = C_subblock_TC*R_subblock_TC;
K1_3 = 3*K1;

k = 0; 
j = 0;
% N_cb = min(floor(),K1_3)
N_cb = K1_3;
k0 = R_subblock_TC*(2*ceil(N_cb/(8*R_subblock_TC))*rv+2);
while k < E
  if(w(mod((k0+j),K1_3)+1)~=-1)
    rmatchedSeg(k+1) = w(mod((k0+j),K1_3)+1);
    k = k+1;
  end
  j = j+1;
end
rmatched = [rmatched;rmatchedSeg'];

end

end