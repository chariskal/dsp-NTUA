function[nums]=ttdecode(sig,A) 
%%ο Α είναι ο πίνακας με την αντιστοιχία δεικτών-συχνοτήτων
N=1000;                        

sig(find(sig==0))=[];
windowSize=N;
 
 l=length(sig);
 windowNUM=round(l/N);
 sqw=zeros(windowSize,windowNUM); %preallocating matrix
  for i = 1:windowNUM
   sqw(:,i)=abs(fft(sig((i-1)*windowSize+1:i*windowSize)));
  end
 j=1;
  for w=1:windowNUM
    for i=1:1000
         if(sqw(i,w)>300)
          k(w,j)=i;
          j=j+1;
         end
      if(j==3) break; 
      end
    end   
    j=1;
  end
    
  i=1;
      for w=1:windowNUM
           for y=1:10
              if(k(w,i)==A(y,i)&& k(w,i+1)==A(y,i+1))
              nums(w)=A(y,5);
              end
           end
      end
 
