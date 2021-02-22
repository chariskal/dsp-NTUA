function ac = lpc_weight(a,c,order)
ac = a;
ci = c;
 for i=2:order
  ac(i) = a(i)*ci;
  ci = ci*c;
 end
end