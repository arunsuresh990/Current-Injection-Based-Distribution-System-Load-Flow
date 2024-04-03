function [Igen] = Ibusgen(System,vPr)
Sbase=System.BaseVA;
NumN = System.NumN;
Ibusstar = zeros(NumN*3,1);
for k = 1:System.NumG
      N1 = System.Generators(k,1); %node of load          
      Sstar = zeros(3,1);
      Sstar(1) = (System.Generators(k,4) + j*(System.Generators(k,5)))/Sbase; 
      Sstar(2) = (System.Generators(k,6) + j*(System.Generators(k,7)))/Sbase; 
      Sstar(3) = (System.Generators(k,8) + j*(System.Generators(k,9)))/Sbase;
      
      V=vPr(3*N1-2:3*N1);  
      Ibusstar(3*N1-2) =Ibusstar(3*N1-2)+ conj(Sstar(1)/V(1));
      Ibusstar(3*N1-1) =Ibusstar(3*N1-1)+ conj(Sstar(2)/V(2));     
      Ibusstar(3*N1) =Ibusstar(3*N1)+ conj(Sstar(3)/V(3));       
end
Igen=(Ibusstar);   
