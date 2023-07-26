Va=System.Finalsol(:,2);Vb=System.Finalsol(:,4);Vc=System.Finalsol(:,6);
Vab=zeros(System.NumN,1);Vbb=zeros(System.NumN,1);Vcb=zeros(System.NumN,1);
BMt=[System.Bid(:,2) System.Bid(:,3) System.Bid(:,4)];
for k=1:System.NumN
    bmidx=find(System.Bus_ID==System.Bid(k,1));
    Vab(bmidx,1)=BMt(k,1);Vbb(bmidx,1)=BMt(k,2);Vcb(bmidx,1)=BMt(k,3);
end
id1=isnan(Vab);Vab(id1)=[];
id1=isnan(Va);Va(id1)=[];
h1=figure('Color','white');
hold on;
plot(Vab,'r*','Linewidth',2);
hold on;
plot(Va,'ko','Linewidth',2)
title('Phase A')
legend('Benchmark','Current Injection');
legend('Location','best');
legend boxoff
ax=gca;
ax.FontSize=15;
ax.FontWeight='bold';
ax.Title.FontSize=15;
ax.Title.FontWeight='bold';
ax.LineWidth=2;
ax.XLabel.String='Bus';
ax.XLabel.FontSize=20;
ax.XLabel.FontWeight='bold';
ax.XLabel.FontName='Times New Roman';
ax.YLabel.String='V pu ';
ax.YLabel.FontSize=20;
ax.YLabel.FontWeight='bold';
ax.YLabel.FontName='Times New Roman';

id1=isnan(Vbb);Vbb(id1)=[];
id1=isnan(Vb);Vb(id1)=[];
h2=figure('Color','white');
hold on;
plot(Vbb,'r*','Linewidth',2);
hold on;
plot(Vb,'ko','Linewidth',2);
title('Phase B')
legend('Benchmark','Current Injection');
legend('Location','best');
legend boxoff
ax=gca;
ax.FontSize=15;
ax.FontWeight='bold';
ax.Title.FontSize=15;
ax.Title.FontWeight='bold';
ax.LineWidth=2;
ax.XLabel.String='Bus';
ax.XLabel.FontSize=20;
ax.XLabel.FontWeight='bold';
ax.XLabel.FontName='Times New Roman';
ax.YLabel.String='V pu ';
ax.YLabel.FontSize=20;
ax.YLabel.FontWeight='bold';
ax.YLabel.FontName='Times New Roman';

id1=find(isnan(Vcb));Vcb(id1)= [];
id2=find(isnan(Vc));Vc(id2) = [];
h3=figure('Color','white');
hold on;
plot(Vcb,'r*','Linewidth',2);
hold on;
plot(Vc,'ko','Linewidth',2);
title('Phase C')
legend('Benchmark','Current Injection');
legend('Location','best');
legend boxoff
ax=gca;
ax.FontSize=15;
ax.FontWeight='bold';
ax.Title.FontSize=15;
ax.Title.FontWeight='bold';
ax.LineWidth=2;
ax.XLabel.String='Bus';
ax.XLabel.FontSize=20;
ax.XLabel.FontWeight='bold';
ax.XLabel.FontName='Times New Roman';
ax.YLabel.String='V pu ';
ax.YLabel.FontSize=20;
ax.YLabel.FontWeight='bold';
ax.YLabel.FontName='Times New Roman';

Era=100*(Vab-Va)./Vab;Erb=100*(Vbb-Vb)./Vbb;Erc=100*(Vcb-Vc)./Vcb;
MaxErrorA=max(abs(Vab-Va))
MaxErrorB=max(abs(Vbb-Vb))
MaxErrorC=max(abs(Vcb-Vc))
h4=figure('Color','white');
hold on;
plot(Era,'b','Linewidth',2);
hold on;
plot(Erb,'r','Linewidth',2);
hold on;
plot(Erc,'y','Linewidth',2);
legend('Phase A','Phase B','Phase C');
legend('Location','best');
legend boxoff
ax=gca;
ax.FontSize=15;
ax.FontWeight='bold';
ax.Title.FontSize=15;
ax.Title.FontWeight='bold';
ax.LineWidth=2;
ax.XLabel.String='Bus';
ax.XLabel.FontSize=20;
ax.XLabel.FontWeight='bold';
ax.XLabel.FontName='Times New Roman';
ax.YLabel.String='% Error ';
ax.YLabel.FontSize=20;
ax.YLabel.FontWeight='bold';
ax.YLabel.FontName='Times New Roman';

h5=figure('Color','white');
hold on;
plot(System.ErrorHistory,'r->','LineWidth',2,'MarkerSize',7,'MarkerFaceColor','red')
ax=gca;
ax.FontSize=15;
ax.FontWeight='bold';
ax.Title.FontSize=15;
ax.Title.FontWeight='bold';
ax.LineWidth=2;
ax.XLabel.String='Iteration';
ax.XLabel.FontSize=20;
ax.XLabel.FontWeight='bold';
ax.XLabel.FontName='Times New Roman';
ax.YLabel.String='Max voltage error in pu';
ax.YLabel.FontSize=20;
ax.YLabel.FontWeight='bold';
ax.YLabel.FontName='Times New Roman';

h6=figure('Color','white');
labels = {'Importing Data','Ybus Calculation','LF Calculation','Report Generation'};
labels = cellfun(@(x) strrep(x,' ','\newline'), labels,'UniformOutput',false);
Y=System.Comptime(1:4);
b=bar(Y,'FaceColor',[0.4940 0.1840 0.5560],'EdgeColor',[1 0 0],'LineWidth',1.5);
title('Computational Time')
ax=gca;
ax.FontSize=10;
ax.FontWeight='bold';
ax.Title.FontSize=13;
ax.Title.FontWeight='bold';
ax.LineWidth=1;
ax.XTickLabel = labels;
ax.XLabel.FontSize=13;
ax.XLabel.FontWeight='bold';
ax.XLabel.FontName='Times New Roman';
ax.YLabel.String='Time(s)';
ax.YLabel.FontSize=13;
ax.YLabel.FontWeight='bold';
ax.YLabel.FontName='Times New Roman';
text(1:length(Y),Y,num2str(Y'),'vert','bottom','horiz','center'); 
box off