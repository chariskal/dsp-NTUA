%% q 2.1
 N = 256; 

 x=randn(1,N);
 X1=dft(x,N);
 X2 = fft(x);                 % built-in FFT
error = max(abs(X1-X2))  %;
clear all 
%% q 2.2
 N=256; 
 L=256;
 n=0:L-1; 

 w=hamming(N)';
  A1=1; A2=0.8; 
  
  %ph1=rand(1)*(2*pi); ph2=rand(1)*(2*pi); Για τυχαία παραγωγή αριθμών
  %φ1,φ2  από το [0,2π]
  
  ph1=2.1314; ph2=3.4122;
  w1=pi/9; w2=pi/5;
 
x1=A1*exp(1i*n*w1+ph1);
x2=A2*exp(1i*n*w2+ph2);
x=w.*(x1+x2);
X1=dft(x,N);           
%X2 =fft(x);                 % built-in FFT
figure(1), plot(abs(X1));
  title('DFT, N=256,L=256')
  ylabel('Magnitude');
  xlabel('bins');

for w2=pi/9:pi/500:pi/2
    x1=A1*exp(1i*n*w1+ph1);
x2=A2*exp(1i*n*w2+ph2);
  x=w.*(x1+x2);

dw=abs(w1-w2) %;
 %Παρατηρείται ότι dw=0.1068 είναι η ελάχιστη τιμή της διαφοράς ώστε να
  %ξεχωρίσουν οι δύο κυματομορφές 
X1=dft(x,N);           
figure(2), plot(abs(X1));
title('DFT, N=256,L=256')
  ylabel('Magnitude');
  xlabel('bins');
   %waitforbuttonpress     %  remove '%' to be able to find th minimum dw
end
f256= w1+0.1068;     
%% q 2.3

   N=512; 
   L=256;
   n=0:L-1; 
 w1=pi/9;
 w=hamming(N)';

   for w2=pi/9:pi/500:pi/2
       x1=A1*exp(1i*n*w1+ph1);
       x2=A2*exp(1i*n*w2+ph2);
       y=x1+x2;
       y=[y zeros(1,N-L)];
       x=w.*y;
       

  dw=abs(w1-w2) %;
   %Παρατηρείται ότι dw= 0.1194 είναι η ελάχιστη τιμή της διαφοράς ώστε να
     %ξεχωρίσουν οι δύο κυματομορφές 
     
   X1=dft(x,N);           
   figure(3), plot(abs(X1));
    title('DFT, N=512,L=256')
    ylabel('Magnitude');
    xlabel('bins');
   %waitforbuttonpress            %remove '%' to be able to find th minimum dw
   end
f512= w1+0.1194;     


   N=1024; 
   L=256;
   n=0:L-1; 
 w1=pi/9;
 w=hamming(N)';

   for w2=pi/9:pi/500:pi/2
       x1=A1*exp(1i*n*w1+ph1);
       x2=A2*exp(1i*n*w2+ph2);
       y=x1+x2;
       y=[y zeros(1,N-L)];
       x=w.*y;
       
  dw=abs(w1-w2) %;
  
   %Παρατηρείται ότι dw= 0.1131 είναι η ελάχιστη τιμή της διαφοράς ώστε να
     %ξεχωρίσουν οι δύο κυματομορφές όταν υπάρχει παράθυρο hamming
   X1=dft(x,N);           
    figure(4), plot(abs(X1));
      title('DFT, N=1024,L=256')
      ylabel('Magnitude');
      xlabel('bins');
   %waitforbuttonpress
   end
f1024= w1+0.1131;     

%% q 2.4
   N=512; 
   L=512;
   n=0:L-1;       
w1=pi/9; w2=f512; % N =512;
 
x1=A1*exp(1i*n*w1+ph1);
x2=A2*exp(1i*n*w2+ph2);
  w=hamming(N)';
  x=w.*(x1+x2);
 
X1=dft(x,N);           
figure(5), plot(abs(X1));
  title('DFT, N=512,L=512')
  ylabel('Magnitude');
  xlabel('bins');

for w2=pi/9:pi/500:pi/4
       x1=A1*exp(1i*n*w1+ph1);
       x2=A2*exp(1i*n*w2+ph2);
       y=x1+x2;
       y=[y zeros(1,N-L)];
       x=w.*y;
       
  dw=abs(w1-w2) %;
  
   %Παρατηρείται ότι dw=0.1131 είναι η ελάχιστη τιμή της διαφοράς ώστε να
     %ξεχωρίσουν οι δύο κυματομορφές όταν υπάρχει παράθυρο hamming
   X1=dft(x,N);           
    figure(6), plot(abs(X1));
      title('DFT, N=512,L=512')
      ylabel('Magnitude');
      xlabel('bins');
  %waitforbuttonpress
end
   %
   %
   N=1024; 
   L=1024;
   n=0:L-1;
w1=pi/9; w2=f1024; % N=1024;
 
x1=A1*exp(1i*n*w1+ph1);
x2=A2*exp(1i*n*w2+ph2);
  w=hamming(N)';
  x=w.*(x1+x2);
 
X1=dft(x,N);           
figure(7), plot(abs(X1));
  title('DFT, N=1024,L=1024')
  ylabel('Magnitude');
  xlabel('bins');

  for w2=pi/9:pi/500:pi/4
       x1=A1*exp(1i*n*w1+ph1);
       x2=A2*exp(1i*n*w2+ph2);
       y=x1+x2;
       y=[y zeros(1,N-L)];
       x=w.*y;
       
  dw=abs(w1-w2) %;
  
   %Παρατηρείται ότι dw= 0.0314 είναι η ελάχιστη τιμή της διαφοράς ώστε να
     %ξεχωρίσουν οι δύο κυματομορφές όταν υπάρχει παράθυρο hamming
   X1=dft(x,N);           
    figure(8), plot(abs(X1));
      title('DFT, N=1024,L=1024')
      ylabel('Magnitude');
      xlabel('bins');
  %waitforbuttonpress
   end
%% q 2.5

 N=1024; 
 L=256;
 n=0:L-1;

  %ph1=rand(1)*(2*pi); ph2=rand(1)*(2*pi); Για τυχαία παραγωγή αριθμών
  %φ1,φ2  από το [0,2π]
  ph1=2.1314; ph2=3.4122;
  A1=1; A2=0.1;
  w1=0.5*pi; w2=0.6*pi;
 
  
x1=A1*exp(1i*n*w1+ph1);
x2=A2*exp(1i*n*w2+ph2);
     y=x1+x2;
     y=[y zeros(1,N-L)];
     
      w=hamming(N)'; %hamming window

       x=w.*y;
       X1=dft(x,N);           
       %X2 =fft(x);                 % built-in FFT
         figure(9), plot(abs(X1));
           title('DFT, hamming window')
           ylabel('Magnitude');
           xlabel('bins');
           
 w=ones(1,N);   %rectangular window
 x=w.*y;
       X1=dft(x,N);           
       %X2 =fft(x);                 % built-in FFT
       figure(10), plot(abs(X1));
        title('DFT, rect window')
        ylabel('Magnitude');
        xlabel('bins');

