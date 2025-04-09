%
% LTE turbo decoder for multiple segments
%

% Kalle Ruttik
% 30.10.2024

function [cbs_dec] = LTE_TurboDecode(cbs_rx)

if ~iscell(cbs_rx)
  cbs_rxl{1} =cbs_rx;
else
  cbs_rxl = cbs_rx;
end
C = length(cbs_rxl);

for r = 1:C
  tmpbits = cbs_rxl{r};
  K = length(tmpbits)/3-4; 
  
  [bits] = turbodecoder(tmpbits);

  [n,m] = size(bits);
  if n<m
    bits = (bits'>0);
  end

  cbs_dec{r} = bits;
end

end

function [decout] = turbodecoder(tmpbits)

K = length(tmpbits)/3-4;
K1 = K+4;

InterleaverValuesinLTESpec
p1 = find(Kvalues(:,2)==K);
p = Kvalues(p1,:);
% Interl 
for i1 = 0:(K-1)
  Interl(i1+1) = mod((p(3) + p(4)*i1)*i1,K);
end
Interl = Interl +1;

tmpbits = tmpbits*2;
d0 = tmpbits(1:K);
d1 = tmpbits(K1+[1:K]);
d0i = d0(Interl);
d2 = tmpbits(2*K1+[1:K]);
% fix the tail bits
d0(K+[1:3]) = [tmpbits(0*K1+K+1) tmpbits(2*K1+K+1) tmpbits(1*K1+K+2)];
d1(K+[1:3]) = [tmpbits(1*K1+K+1) tmpbits(0*K1+K+2) tmpbits(2*K1+K+2)];
d0i(K+[1:3])= [tmpbits(0*K1+K+3) tmpbits(2*K1+K+3) tmpbits(1*K1+K+4)];
d2(K+[1:3]) = [tmpbits(1*K1+K+3) tmpbits(0*K1+K+4) tmpbits(2*K1+K+4)];

% prepare the received transition probabilities

next_out   = [0 0 1 1 1 1 0 0; 1 1 0 0 0 0 1 1]';
next_state = [1 5 6 2 3 7 8 4; 5 1 2 6 7 3 4 8]';
prev_out   = [0 1 1 0 0 1 1 0; 1 0 0 1 1 0 0 1]';
prev_state = [1 4 5 8 2 3 6 7; 2 3 6 7 1 4 5 8]';

Nstates = 8; mInfty = -3000;

A1 = zeros(Nstates,K1); A1(2:Nstates,1)  = mInfty;
B1 = zeros(Nstates,K1); B1(2:Nstates,K1) = mInfty;
A2 = zeros(Nstates,K1); A2(2:Nstates,1)  = mInfty;
B2 = zeros(Nstates,K1); B2(2:Nstates,K1) = mInfty;

L_e = zeros(1,K1);
L_a = zeros(1,K1);

niter = 5;
for iter = 1:niter
L_a(Interl)=L_e(1:K);

% code 1
% forward
for k = 2:(K+3)
  t0 = A1(prev_state(:,1),k-1)        +d1(k-1)*prev_out(:,1)         ;
  t1 = A1(prev_state(:,2),k-1)+d0(k-1)+d1(k-1)*prev_out(:,2)+L_a(k-1);
  A1(:,k)=max(t0,t1) - max(max(t0,t1));
end
% backward
for k = (K+3):-1:1
  t0 = B1(next_state(:,1),k+1)        +d1(k)*next_out(:,1)         ;
  t1 = B1(next_state(:,2),k+1)+ d0(k) +d1(k)*next_out(:,2)+L_a(k);
  B1(:,k)=max(t0,t1) - max(max(t0,t1));
end
% marginals
for k = 1:(K)
  t0 = A1(prev_state(:,1),k) + B1(:,k+1) + d1(k)*prev_out(:,1);
  t1 = A1(prev_state(:,2),k) + B1(:,k+1) + d1(k)*prev_out(:,2);
  L_e(k) = max(t1) - max(t0);
end

% interl
L_a(1:K) = L_e(Interl);
% forward
for k = 2:(K+3)
  t0 = A2(prev_state(:,1),k-1)         +d2(k-1)*prev_out(:,1)         ;
  t1 = A2(prev_state(:,2),k-1)+d0i(k-1)+d2(k-1)*prev_out(:,2)+L_a(k-1);
  A2(:,k)=max(t0,t1) - max(max(t0,t1));
end
% backward
for k = (K+2):-1:1
  t0 = B2(next_state(:,1),k+1)         +d2(k)*next_out(:,1)         ;
  t1 = B2(next_state(:,2),k+1)+ d0i(k) +d2(k)*next_out(:,2)+L_a(k);
  B2(:,k)=max(t0,t1) - max(max(t0,t1));
end
% marginals
for k = 1:(K)
  t0 = A2(prev_state(:,1),k) + B2(:,k+1) + d2(k)*prev_out(:,1);
  t1 = A2(prev_state(:,2),k) + B2(:,k+1) + d2(k)*prev_out(:,2);
  L_e(k) = max(t1) - max(t0);
end

end % iter

[n,m] = size(d0i);
if n<m
  d0i = d0i';
end
decout(Interl)= (L_e(1:K)'+d0i(1:K)/2+L_a(1:K)');

end