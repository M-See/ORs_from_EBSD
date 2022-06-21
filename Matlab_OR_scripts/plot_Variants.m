% for v = 1:0.5:15
function plot_Variants()

markerSize=5.5;
warning('off','all')

%load EBSD before
% cs_child = ebsd('Martensite').CS;
% cs_parent = ebsd('Austenite').CS;

ebsd=evalin('base','ebsd');
cs_child=evalin('base','cs_child');
cs_parent=evalin('base','cs_parent');
markerSize2=evalin('base','markerSize');

if ~exist('Variants', 'dir')
       mkdir('Variants')
end

KS = orientation.map(Miller(1,1,1,cs_parent),Miller(0,1,1,cs_child),...
      Miller(-1,0,1,cs_parent),Miller(-1,-1,1,cs_child));

ori= orientation.byMiller([0 0 1],[1 0 0],cs_parent);

vars = variants(KS,ori);

hChild =Miller({0,0,1},{1,1,0},{1,1,1},KS.SS,'hkl');

plotPDF(vars,ind2color(1:length(vars)),hChild(1),...
  'antipodal','MarkerEdgeColor','black','MarkerSize',markerSize)

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5 5])
saveas(gcf, [pwd '/Variants/KS_1.png'])

plotPDF(vars,ind2color(1:length(vars)),hChild(2),...
  'antipodal','MarkerEdgeColor','black','MarkerSize',markerSize)

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5 5])
saveas(gcf, [pwd '/Variants/KS_2.png'])

plotPDF(vars,ind2color(1:length(vars)),hChild(3),...
  'antipodal','MarkerEdgeColor','black','MarkerSize',markerSize)

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5 5])
saveas(gcf, [pwd '/Variants/KS_3.png'])

%% Pitsch
Pitsch = orientation.map(Miller(1,1,0,cs_parent),Miller(1,1,1,cs_child),...
      Miller(0,0,1,cs_parent),Miller(1,-1,0,cs_child));

ori= orientation.byMiller([0 0 1],[1 0 0],cs_parent);

vars = variants(Pitsch,ori);

hChild =Miller({0,0,1},{1,1,0},{1,1,1},Pitsch.SS,'hkl');

plotPDF(vars,ind2color(1:length(vars)),hChild,...
  'antipodal','MarkerEdgeColor','black','MarkerSize',markerSize)

plotPDF(vars,ind2color(1:length(vars)),hChild(1),...
  'antipodal','MarkerEdgeColor','black','MarkerSize',markerSize)

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5 5])
saveas(gcf,[pwd '/Variants/Pitsch_1.png'])

plotPDF(vars,ind2color(1:length(vars)),hChild(2),...
  'antipodal','MarkerEdgeColor','black','MarkerSize',markerSize)

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5 5])
saveas(gcf,[pwd '/Variants/Pitsch_2.png'])

plotPDF(vars,ind2color(1:length(vars)),hChild(3),...
  'antipodal','MarkerEdgeColor','black','MarkerSize',markerSize)

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5 5])
saveas(gcf,[pwd '/Variants/Pitsch_3.png'])

%% GT
GT = orientation.map(Miller(1,2,-3,cs_parent),Miller(1,3,3,cs_child),...
      Miller(1,1,1,cs_parent),Miller(0,1,-1,cs_child));

ori= orientation.byMiller([0 0 1],[1 0 0],cs_parent);

vars = variants(GT,ori);

hChild =Miller({0,0,1},{1,1,0},{1,1,1},GT.SS,'hkl');
figure
plotPDF(vars,ind2color(1:length(vars)),hChild,...
  'antipodal','MarkerEdgeColor','black','MarkerSize',markerSize)

plotPDF(vars,ind2color(1:length(vars)),hChild(1),...
  'antipodal','MarkerEdgeColor','black','MarkerSize',markerSize)

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5 5])
saveas(gcf,[pwd '/Variants/GT_1.png'])

plotPDF(vars,ind2color(1:length(vars)),hChild(2),...
  'antipodal','MarkerEdgeColor','black','MarkerSize',markerSize)

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5 5])
saveas(gcf,[pwd '/Variants/GT_2.png'])

plotPDF(vars,ind2color(1:length(vars)),hChild(3),...
  'antipodal','MarkerEdgeColor','black','MarkerSize',markerSize)

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5 5])
saveas(gcf,[pwd '/Variants/GT_3.png'])


%% NW
NW = orientation.map(Miller(1,1,1,cs_parent),Miller(0,1,1,cs_child),...
      Miller(1,1,-2,cs_parent,'uvw'),Miller(0,-1,1,cs_child,'uvw'));

ori= orientation.byMiller([0 0 1],[1 0 0],cs_parent);

vars = variants(NW,ori);

hChild =Miller({0,0,1},{1,1,0},{1,1,1},NW.SS,'hkl');

plotPDF(vars,ind2color(1:length(vars)),hChild,...
  'antipodal','MarkerEdgeColor','black','MarkerSize',markerSize)

plotPDF(vars,ind2color(1:length(vars)),hChild(1),...
  'antipodal','MarkerEdgeColor','black','MarkerSize',markerSize)

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5 5])
saveas(gcf,[pwd '/Variants/NW_1.png'])

plotPDF(vars,ind2color(1:length(vars)),hChild(2),...
  'antipodal','MarkerEdgeColor','black','MarkerSize',markerSize)

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5 5])
saveas(gcf,[pwd '/Variants/NW_2.png'])

plotPDF(vars,ind2color(1:length(vars)),hChild(3),...
  'antipodal','MarkerEdgeColor','black','MarkerSize',markerSize)

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5 5])
saveas(gcf,[pwd '/Variants/NW_3.png'])


%%
image_compare

% end