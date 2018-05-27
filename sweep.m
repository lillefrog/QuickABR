
N = 1000;
RF = 100;

for x=0:N; 
  
    if (x<(N-RF+1)); y(x)=1; end;
    if (x<(RF+1)); y(x)=(cos((x*0.5*pi)/RF+0.5*pi))^2;
    if (x>(N-RF)); y(x)=(cos(((x-(N-RF))*0.5*pi)/RF))^2;    
    
    
end;