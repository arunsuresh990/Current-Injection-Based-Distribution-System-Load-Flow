function [Icap] = Ibuscap(System,vPr)
Sbase=System.BaseVA;
NumN = System.NumN;
Ibusstar = zeros(NumN*3,1);
Ibusdelta = zeros(NumN*3,1);
for k = 1:System.NumCa
      N1 = System.Capacitors(k,1); %node of load          
      star = System.Capacitors(k,2);%star  if value=1, Delta if value =0
      alpha = System.Capacitors(k,3); %type... PQ=0,I=1,Z=2   
      Sstar = zeros(3,1);
      Sdelta    = zeros(3,1);
      if star == 1
         Sstar(1) =  1j*(System.Capacitors(k,4))/Sbase; 
         Sstar(2) = 1j*(System.Capacitors(k,5))/Sbase; 
         Sstar(3) = 1j*(System.Capacitors(k,6))/Sbase; 
      else
         Sdelta(1) = 1j*(System.Capacitors(k,4))/Sbase; 
         Sdelta(2) = 1j*(System.Capacitors(k,5))/Sbase; 
         Sdelta(3) = 1j*(System.Capacitors(k,6))/Sbase;                
      end
       V=vPr(3*N1-2:3*N1);   
      if (alpha ==0 && star == 1)%Y-PQ
         Ibusstar(3*N1-2) =Ibusstar(3*N1-2)+ conj(Sstar(1)/V(1));
         Ibusstar(3*N1-1) =Ibusstar(3*N1-1)+ conj(Sstar(2)/V(2));     
         Ibusstar(3*N1) =Ibusstar(3*N1)+ conj(Sstar(3)/V(3)); 
      end
      if (alpha ==0 && star == 0)%D-PQ
          I12=conj(Sdelta(1)/(V(1)-V(2)));  I23=conj(Sdelta(2)/(V(2)-V(3)));I31=conj(Sdelta(3)/(V(3)-V(1)));
         Ibusdelta(3*N1-2) =Ibusdelta(3*N1-2)+ (I12-I31);
          Ibusdelta(3*N1-1) =Ibusdelta(3*N1-1)+ (I23-I12);     
          Ibusdelta(3*N1) =Ibusdelta(3*N1)+ (I31-I23);              
      end   
      if (alpha ==1 && star == 1)%Y-I
         Vi=System.VinitZloads;%constani I load has same magnitude of current irrespective of voltage. So in all iterations Vflat is used to find mag I and Vact to fing angle I 
         MagIa=abs(conj(Sstar(1)/Vi(1)));MagIb=abs(conj(Sstar(2)/Vi(2)));MagIc=abs(conj(Sstar(3)/Vi(3)));
          AngIa=angle(conj(Sstar(1)/V(1)));AngIb=angle(conj(Sstar(2)/V(2)));AngIc=angle(conj(Sstar(3)/V(3)));
         Ibusstar(3*N1-2) =Ibusstar(3*N1-2)+ MagIa*exp(sqrt(-1)*AngIa);
         Ibusstar(3*N1-1) =Ibusstar(3*N1-1)+  MagIb*exp(sqrt(-1)*AngIb);   
         Ibusstar(3*N1) =Ibusstar(3*N1)+  MagIc*exp(sqrt(-1)*AngIc);
      end
      if (alpha ==1 && star == 0)%D-I
          Vi=System.VinitZloads;%constani I load has same magnitude of current irrespective of voltage. So in all iterations Vflat is used to find mag I and Vact to fing angle I 
         MagI12=abs(conj(Sdelta(1)/(Vi(1)-Vi(2))));  MagI23=abs(conj(Sdelta(2)/(Vi(2)-Vi(3))));MagI31=abs(conj(Sdelta(3)/(Vi(3)-Vi(1))));
         AngI12=angle(conj(Sdelta(1)/(V(1)-V(2))));  AngI23=angle(conj(Sdelta(2)/(V(2)-V(3))));AngI31=angle(conj(Sdelta(3)/(V(3)-V(1))));
         I12=MagI12*exp(sqrt(-1)*AngI12);I23=MagI23*exp(sqrt(-1)*AngI23);I31=MagI31*exp(sqrt(-1)*AngI31);
         Ibusdelta(3*N1-2) =Ibusdelta(3*N1-2)+ (I12-I31);
          Ibusdelta(3*N1-1) =Ibusdelta(3*N1-1)+ (I23-I12);     
          Ibusdelta(3*N1) =Ibusdelta(3*N1)+ (I31-I23);                             
      end    
      if (alpha ==2 && star == 1)  %Y-Z
          Vz=System.VinitZloads;
          Za=(abs(Vz(1)))^2/conj(Sstar(1));
          Zb=(abs(Vz(2)))^2/conj(Sstar(2));
          Zc=(abs(Vz(3)))^2/conj(Sstar(3));
          Ibusstar(3*N1-2) =Ibusstar(3*N1-2)+ V(1)/Za;
         Ibusstar(3*N1-1) =Ibusstar(3*N1-1)+ V(2)/Zb;     
         Ibusstar(3*N1) =Ibusstar(3*N1)+ V(3)/Zc;
        end
      if (alpha ==2 && star == 0) %D-Z
            Vz=System.VinitZloads;
         Zab=(abs(Vz(1)-Vz(2)))^2/conj(Sdelta(1));
         Zbc=(abs(Vz(2)-Vz(3)))^2/conj(Sdelta(2));
         Zca=(abs(Vz(3)-Vz(1)))^2/conj(Sdelta(3));  
          I12=(V(1)-V(2))/Zab;  I23=(V(2)-V(3))/Zbc; I31=(V(3)-V(1))/Zca; 
         Ibusdelta(3*N1-2) =Ibusdelta(3*N1-2)+ (I12-I31);
          Ibusdelta(3*N1-1) =Ibusdelta(3*N1-1)+ (I23-I12);     
          Ibusdelta(3*N1) =Ibusdelta(3*N1)+ (I31-I23);  
      end       							    
end
   Icap=(Ibusstar+Ibusdelta);   
