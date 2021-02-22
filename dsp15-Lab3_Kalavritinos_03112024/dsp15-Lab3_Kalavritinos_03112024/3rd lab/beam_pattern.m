function[B] = beam_pattern(d,N,f,thetas,c,theta)
w=2*pi*f;

    x=(w*d)/(2*c)*(cos(theta)-cos(thetas));
    B=sin(N*x)./(N*sin(x));
end