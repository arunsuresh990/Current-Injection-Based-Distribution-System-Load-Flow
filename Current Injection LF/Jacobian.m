function [Jac] = Jacobian(n,Ybus)
G=full(real(Ybus));
B=full(imag(Ybus));
J=(zeros(length(G)*2));
for k=1:n
    for m=1:n
          fb3p=[3*k-2,3*k-1,3*k];%3 phases of that bus
          tb3p=[3*m-2,3*m-1,3*m];
      if sum(any(B(fb3p,tb3p)))>0 || sum(any(G(fb3p,tb3p)))>0 
          B1=B(fb3p,tb3p);G1=G(fb3p,tb3p);
          G11=G(fb3p,tb3p);B11=-B(fb3p,tb3p);         
          kN1=[6*k-5,6*k-4,6*k-3];% Jacobian has twice size of Ybus
          kN2=[6*m-5,6*m-4,6*m-3];
          kN3=kN1+3;
          kN4=kN2+3;
          J(kN1,kN2)=B1;
          J(kN1,kN4)=G1;
          J(kN3,kN2)=G11;
          J(kN3,kN4)=B11;         
      end
    end  
end
Jac=sparse(J);
end