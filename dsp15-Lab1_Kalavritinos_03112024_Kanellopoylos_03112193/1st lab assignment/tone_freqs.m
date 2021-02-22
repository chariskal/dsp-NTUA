function[x,y]=tone_freqs(num)
A=[ 0.5346 0.5906 0.6535 0.7217;0.9273 0 0 0;1.0247 0 0 0;1.1328 0 0 0];
if (num<10)
    if(num<=3 && num~=0)
        x=A(1,1);y=A(num+1,1);
    elseif(num<=6 &&num~=0)
        x=A(1,2);y=A(num-2,1);
    elseif(num<=9 &&num~=0)
        x=A(1,3);y=A(num-5,1);
    else
        x=0.7217;y=1.0247;
    end
end
