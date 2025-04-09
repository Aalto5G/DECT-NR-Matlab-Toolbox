function [cbs_enc]=LTE_TurboEncode(cbs_data_in)
% LTE turbo encoder 
% 1/3 encoding with two PCCC terminated codes
%
% eats
% x_bits - input bits with size L_info
% Interl - interleaver
%
% out
% en_output - 3x(L_info+3) encoded matrix
%             first row the data bits 
%             second row the first encoder output
%             third row the second encoder output
g=[1 0 1 1;1 1 0 1]; % the code polynome used in the UMTS

InterleaverValuesinLTESpec


if ~iscell(cbs_data_in)
  cbs_data{1} =cbs_data_in;
else
  cbs_data = cbs_data_in;
end
C = length(cbs_data);

for seginx = 1:C
 x_bits = cbs_data{seginx};
 [n,m] = size(x_bits);
 if n>m
   x_bits = x_bits';
 end
 K = length(x_bits);
 p1 = find(Kvalues(:,2)==K);
 p = Kvalues(p1,:);

 %[Interl]=Interleaver_M(p);
 Interl=zeros(1,p(2));
 K=p(2);
 for i1=0:p(2)-1
    v1=(p(3)*i1+p(4)*i1*i1);
    Interl(i1+1)=mod(v1,K)+1;
 end
 tmpBits = x_bits>0;
 [en_out2,x2tail,en_out2tail]= LTE_encoder(tmpBits(Interl),g);
 [en_out1,x1tail,en_out1tail]= LTE_encoder(tmpBits,g);
 en_out1(find(x_bits<0)) = -1;
 n0=[x_bits x1tail(1) en_out1tail(2) x2tail(1) en_out2tail(2)];
 n1=[en_out1 en_out1tail(1) x1tail(3) en_out2tail(1) x2tail(3)];
 n2=[en_out2 x1tail(2) en_out1tail(3) x2tail(2) en_out2tail(3)];

 K1 = p(2)+4;
 en_output=[n0  n1  n2]';
 cbs_enc{seginx} = en_output;
end

end %function