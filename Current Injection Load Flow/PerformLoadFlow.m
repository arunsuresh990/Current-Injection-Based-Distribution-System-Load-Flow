function System=PerformLoadFlow(System)
% Injection Current Sensitivity (ICS) based 3 Phase Unbalanced  Distribution System Power flow
tStartlf=tic;
constjacob=0;% 0 for constant Jacobian, 1 for variable Jacobian
 if constjacob==1
    disp('Constant Jacobian Method')
 end
n=System.NumN;%Total number of bus
%% Misiing phase and Y bus sparsity tests
availalenodeidx=find(any(System.Ybus,2)); %finding rows/columns of atleast 1 non zero
missingnodeidx=~any(System.Ybus,2);%finding rows/columns of all zeros
Jac=Jacobian(n,System.Ybus);% Full Jacobian Calculation is only done once at this step. Later only diagonal blocks are modified
%% Getting Specified Values. These are used for Jacobian updation
PL3ph=[System.Specified(:,4) System.Specified(:,6) System.Specified(:,8)];
QL3ph=[System.Specified(:,5) System.Specified(:,7) System.Specified(:,9)];
PG3ph=[System.Specified(:,10) System.Specified(:,12) System.Specified(:,14)];
QG3ph=[System.Specified(:,11) System.Specified(:,13) System.Specified(:,15)];
QS3ph=[System.Specified(:,16) System.Specified(:,17) System.Specified(:,18)];
Pload=reshape(PL3ph',[],1); % Making 3 phase vector as 1 vector
Qload=reshape(QL3ph',[],1);
Pgen=reshape(PG3ph',[],1);
Qgen=reshape(QG3ph',[],1);
Qshnt=reshape(QS3ph',[],1);
Pl=Pload/(1*System.BaseVA);%Per unitize Pload
Ql=Qload/(1*System.BaseVA);
Pg=Pgen/(1*System.BaseVA);
Qg=Qgen/(1*System.BaseVA);
Qsh=Qshnt/(1*System.BaseVA);
%% Initialization of variables
v0=System.Vpu_slack; %slack bus initial voltage
Vin=repmat(v0,n,1);% Initial voltage for LF. Considering all bus voltages same as slack bus voltage
Vr=real(Vin);Vi=imag(Vin);V=Vr+1i*Vi;% Complex Voltage
G=real(System.Ybus);B=imag(System.Ybus);
Iinj=zeros(1,2*n*3)';
Iinji=zeros(1,n*3)';Iinjr=zeros(1,n*3)';
Imis3ph=zeros(n,6);
delVr3ph=zeros(n,3);delVi3ph=zeros(n,3);
error=100;errorHist=[];cnt=0;
Psp=Pg-Pl;% Net power injection
Qsp=Qg+Qsh-Ql;
Sl=complex(Psp,Qsp);% complex power injection
while error>0.00001 
    %  Iinj1=conj(Sl./V); % Isp with all loads considered Y-PQ
    Iload=Ibusload(System,V);% Load current injection with all loads types
    Icap=Ibuscap(System,V);% Capacitor current injection
    Igen=Ibusgen(System,V);% Generator current injection
    Isp=(Igen+Icap)-Iload;% Isp with all loads, generators and caps 
    Iinj=System.Ybus*(Vr+1i*Vi);% Ical
    delI1=Isp-Iinj; % Del I= Isp-Ical Current Mismatch calculation
    Vold=V; % voltage for this iteration.. used to check error after updated voltage
    %current mismatch in real and imaginary components
    Irmi=real(delI1);Iimi=imag(delI1);
    %%Imismatch values of abc phases of each node
    for u=0:n-1%
        k=3*u+1;
        Irmisa=Irmi(k);Irmisb=Irmi(k+1); Irmisc=Irmi(k+2);
        Irmis3ph=[Irmisa,Irmisb,Irmisc];%real component of current mismatch
        Iimisa=Iimi(k);Iimisb=Iimi(k+1);Iimisc=Iimi(k+2);
        Iimis3ph=[Iimisa,Iimisb,Iimisc];%imaginary component of current mismatch
        Imis3ph(u+1,:)=[Iimis3ph,Irmis3ph];
    end
      Imis=reshape(Imis3ph',[],1);
    %% Jacobian formation 
  if constjacob==1 % do jacobian only in 1st iteration: Constant jacobian method
    J=Jac;% off diagonal parts do not require modification
    Viabccalc=reshape(Vi,3,n).';
    Via=Viabccalc(:,1);Vib=Viabccalc(:,2);Vic=Viabccalc(:,3);
    Vrabccalc=reshape(Vr,3,n).';
    Vra=Vrabccalc(:,1);Vrb=Vrabccalc(:,2);Vrc=Vrabccalc(:,3);
    Pspabccalc=reshape(Psp,3,n).';
    Pspa=Pspabccalc(:,1);Pspb=Pspabccalc(:,2);Pspc=Pspabccalc(:,3);
    Qspabccalc=reshape(Qsp,3,n).';
    Qspa=Qspabccalc(:,1);Qspb=Qspabccalc(:,2);Qspc=Qspabccalc(:,3);
     for k=1:n
        for m=1:n
               fb3p=[3*k-2,3*k-1,3*k];%3 phases of that bus
               tb3p=[3*m-2,3*m-1,3*m];
           if k==m % only diagonal blocks require modification
            alpha=System.Specified(k,3); %type... PQ=0,I=1,Z=2   
             if(alpha==0)   %type... PQ
              aka=(Qspa(k)*(Vra(k)^2-Via(k)^2)-2*Vra(k)*Via(k)*Pspa(k))/(Vra(k)*Vra(k)+Via(k)*Via(k))^2;   
              bka=(Pspa(k)*(Vra(k)^2-Via(k)^2)+2*Vra(k)*Via(k)*Qspa(k))/(Vra(k)*Vra(k)+Via(k)*Via(k))^2;
              cka=-(Pspa(k)*(Vra(k)^2-Via(k)^2)+2*Vra(k)*Via(k)*Qspa(k))/(Vra(k)*Vra(k)+Via(k)*Via(k))^2;
              dka=(Qspa(k)*(Vra(k)^2-Via(k)^2)-2*Vra(k)*Via(k)*Pspa(k))/(Vra(k)*Vra(k)+Via(k)*Via(k))^2;
    
              akb=(Qspb(k)*(Vrb(k)^2-Vib(k)^2)-2*Vrb(k)*Vib(k)*Pspb(k))/(Vrb(k)*Vrb(k)+Vib(k)*Vib(k))^2;   
              bkb=(Pspb(k)*(Vrb(k)^2-Vib(k)^2)+2*Vrb(k)*Vib(k)*Qspb(k))/(Vrb(k)*Vrb(k)+Vib(k)*Vib(k))^2;
              ckb=-(Pspb(k)*(Vrb(k)^2-Vib(k)^2)+2*Vrb(k)*Vib(k)*Qspb(k))/(Vrb(k)*Vrb(k)+Vib(k)*Vib(k))^2;
              dkb=(Qspb(k)*(Vrb(k)^2-Vib(k)^2)-2*Vrb(k)*Vib(k)*Pspb(k))/(Vrb(k)*Vrb(k)+Vib(k)*Vib(k))^2;
              
              akc=(Qspc(k)*(Vrc(k)^2-Vic(k)^2)-2*Vrc(k)*Vic(k)*Pspc(k))/(Vrc(k)*Vrc(k)+Vic(k)*Vic(k))^2;   
              bkc=(Pspc(k)*(Vrc(k)^2-Vic(k)^2)+2*Vrc(k)*Vic(k)*Qspc(k))/(Vrc(k)*Vrc(k)+Vic(k)*Vic(k))^2;
              ckc=-(Pspc(k)*(Vrc(k)^2-Vic(k)^2)+2*Vrc(k)*Vic(k)*Qspc(k))/(Vrc(k)*Vrc(k)+Vic(k)*Vic(k))^2;
              dkc=(Qspc(k)*(Vrc(k)^2-Vic(k)^2)-2*Vrc(k)*Vic(k)*Pspc(k))/(Vrc(k)*Vrc(k)+Vic(k)*Vic(k))^2;
             end
      
             if (alpha==1)   %type... I
              aka=(Vra(k)*Via(k)*Pspa(k)+Qspa(k)*Via(k)^2)/sqrt((Vra(k)*Vra(k)+Via(k)*Via(k)))^3;   
              bka=(-Vra(k)*Via(k)*Qspa(k)+Pspa(k)*Vra(k)^2)/sqrt((Vra(k)*Vra(k)+Via(k)*Via(k)))^3;   
              cka=(Vra(k)*Via(k)*Qspa(k)-Pspa(k)*Via(k)^2)/sqrt((Vra(k)*Vra(k)+Via(k)*Via(k)))^3; 
              dka=(Vra(k)*Via(k)*Pspa(k)-Qspa(k)*Vra(k)^2)/sqrt((Vra(k)*Vra(k)+Via(k)*Via(k)))^3;   
              
              akb=(Vrb(k)*Vib(k)*Pspb(k)+Qspb(k)*Vib(k)^2)/sqrt((Vrb(k)*Vrb(k)+Vib(k)*Vib(k)))^3;   
              bkb=(-Vrb(k)*Vib(k)*Qspb(k)+Pspb(k)*Vrb(k)^2)/sqrt((Vrb(k)*Vrb(k)+Vib(k)*Vib(k)))^3;   
              ckb=(Vrb(k)*Vib(k)*Qspb(k)-Pspb(k)*Vib(k)^2)/sqrt((Vrb(k)*Vrb(k)+Vib(k)*Vib(k)))^3; 
              dkb=(Vrb(k)*Vib(k)*Pspb(k)-Qspb(k)*Vrb(k)^2)/sqrt((Vrb(k)*Vrb(k)+Vib(k)*Vib(k)))^3;   
              
              akc=(Vrc(k)*Vic(k)*Pspc(k)+Qspc(k)*Vic(k)^2)/sqrt((Vrc(k)*Vrc(k)+Vic(k)*Vic(k)))^3;   
              bkc=(-Vrc(k)*Vic(k)*Qspc(k)+Pspc(k)*Vrc(k)^2)/sqrt((Vrc(k)*Vrc(k)+Vic(k)*Vic(k)))^3;   
              ckc=(Vrc(k)*Vic(k)*Qspc(k)-Pspc(k)*Vic(k)^2)/sqrt((Vrc(k)*Vrc(k)+Vic(k)*Vic(k)))^3; 
              dkc=(Vrc(k)*Vic(k)*Pspc(k)-Qspc(k)*Vrc(k)^2)/sqrt((Vrc(k)*Vrc(k)+Vic(k)*Vic(k)))^3;  
             end
    
             if (alpha==2)   %type...Z
              aka=Qspa(k);   
              bka=-Pspa(k);
              cka=-Pspa(k);
              dka=-Qspa(k);
              
              akb=Qspb(k);   
              bkb=-Pspb(k);
              ckb=-Pspb(k);
              dkb=-Qspb(k);
              
              akc=Qspc(k);   
              bkc=-Pspc(k);
              ckc=-Pspc(k);
              dkc=-Qspc(k);
              end
    % Jacobian modification
              B1=B(fb3p,tb3p)-diag([aka;akb;akc]);G1=G(fb3p,tb3p)-diag([bka;bkb;bkc]);
              G11=G(fb3p,tb3p)-diag([cka;ckb;ckc]);B11=-B(fb3p,tb3p)-diag([dka;dkb;dkc]);         
              kN1=[6*k-5,6*k-4,6*k-3];% Jacobian has twice size of Ybus
              kN2=[6*m-5,6*m-4,6*m-3];
              kN3 = kN1+3;
              kN4 = kN2+3;          
                
              J(kN1,kN2)=B1;
              J(kN1,kN4)=G1;
              J(kN3,kN2)= G11;
              J(kN3,kN4)=B11;  
           end
        end     
     end
  else % no jacobian update
        J=Jac;
  end
    %% Loadflow main step-- DelV=inv(J)*DelI
    availalenodeindexjc=find(any(J,2)); %finding column of atleast 1 non zeros
    missingnodeindexjc=~any(J,2);%finding column of all zeros
    Jnet=J(availalenodeindexjc,availalenodeindexjc);
    Imisnet=Imis(availalenodeindexjc);
    delVrs=Jnet(7:end,7:end)\[Imisnet(7:end)];% DelV=inv(J)*DelI (removing slack bus portion ie first 6 rows/columns)
    delV=[0;0;0;0;0;0;delVrs];% adding back slack bus portion
    delva=zeros(2*3*n,1);%
    delva(availalenodeindexjc,1)=delV;
    delva(missingnodeindexjc,1)=0;
    delV=delva;
    %%delVr and delVi values of abc phases of each node
    for u=0:n-1%
        k=6*u+1;
        delVra=delV(k);delVrb=delV(k+1);delVrc=delV(k+2);
        delVr3ph(u+1,:)=[delVra,delVrb,delVrc];%
        delVia=delV(k+3);delVib=delV(k+4);delVic=delV(k+5);
        delVi3ph(u+1,:)=[delVia,delVib,delVic];%
    end
    delVr=reshape(delVr3ph',[],1);
    delVi=reshape(delVi3ph',[],1);
    Vr=Vr+delVr;Vi=Vi+delVi;V=Vr+1i*Vi;
    cnt=cnt+1;
    error=max(abs(V-Vold));errorHist=[errorHist error];
    System.ErrorHistory=errorHist;
        if cnt==100 % to avoid infinite looping in case of non-convergence
            disp('Solution did not converged after 100 iterations')
            break  
        end
end
fprintf('Load Flow Converged in %d iterations \n', cnt)
V(missingnodeidx,1)=NaN;%Making unavailable phases to NAN
v3phase=reshape(V,3,n).';
resultsVMag=[abs(v3phase)];resultsVPhase=(angle(v3phase))*180/pi;
System.ComplexVoltage=V;
System.Finalsol=[System.Bus_ID resultsVMag(:,1) resultsVPhase(:,1) resultsVMag(:,2) resultsVPhase(:,2) resultsVMag(:,3) resultsVPhase(:,3)];
System.Comptime(3)=toc(tStartlf); % Computational Time for Load Flow calculation
clearvars -EXCEPT  System pb
end 
 