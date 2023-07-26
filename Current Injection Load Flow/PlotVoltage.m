Va=System.Finalsol(:,2);Vb=System.Finalsol(:,4);Vc=System.Finalsol(:,6);
id1 = find(isnan(Va));Va(id1) = [];
h1=figure('Color','white');
hold on;
plot(Va,'r*','Linewidth',2)
title('Phase A')
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


id1 = find(isnan(Vb));Vb(id1) = [];
h2=figure('Color','white');
hold on;
plot(Vb,'r*','Linewidth',2);
title('Phase B')
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


id2 = find(isnan(Vc));Vc(id2) = [];
h3=figure('Color','white');
hold on;
plot(Vc,'r*','Linewidth',2);
title('Phase C')
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

h4=figure('Color','white');
hold on;
plot(System.ErrorHistory,'r->','LineWidth',2,'MarkerSize',7,'MarkerFaceColor','red')
title('Max Error')
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

h5=figure('Color','white');
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
clearvars -EXCEPT  System pb