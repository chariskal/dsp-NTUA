function u = cb_gener(N)
n=1024;
t=(0:N-1);
u=zeros(n,N);

for i=1:n
    sum=0;
  for k=1:N
    ck= raylrnd(1);
    ph=rand(1)*(2*pi); % Για τυχαία παραγωγή αριθμών φ από το [0,2π]
    sum=sum+ck*cos(pi*t*k/N+ph);
    %plot(sum)
    %waitforbuttonpress
  end
  u(i,:)=sum;
end
 u=u';
end