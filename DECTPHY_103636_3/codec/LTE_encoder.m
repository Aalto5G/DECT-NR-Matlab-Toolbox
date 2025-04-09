function [y,xtail,ytail] = LTE_encoder(x, g)

% encodes a block of data input (0/1) with a recursive systematic
% convolutional code with generator vectors in g, and
% returns the output in y (0/1).
% assumes that the first row in g is recursive part
% second row is feedforward part

% determine the constraint length (k), memory (m)
% and number of information bits.
[n,k] = size(g);
m = k - 1;
% initialize the encoder memory (state vector)
state = zeros(1,m);

L_info = length(x);
y=zeros(1,L_info);
% generate the codeword
for i = 1:L_info

  d_k = x(i);
% part  due to the feedback polynome
  a_k = rem( g(1,:)*[d_k state]', 2 );
% part due to the feedforward polynome
  encoded_bit=rem(g(2,:)*[a_k state]',2);

% new memory content
  state = [a_k, state(1:m-1)];

  y(i)=encoded_bit;
end

% trellis termination
for i = 1:(size(g,2)-1)
  d_k = 0;
% part  due to the feedback polynome
  a_k = rem( g(1,:)*[d_k state]', 2 );
  xtail(i)=a_k;
  a_k=0;
  % part due to the feedforward polynome
  encoded_bit=rem(g(2,:)*[a_k state]',2);
  % new memory content
  state = [a_k, state(1:m-1)];
  ytail(i)=encoded_bit;
end

end
