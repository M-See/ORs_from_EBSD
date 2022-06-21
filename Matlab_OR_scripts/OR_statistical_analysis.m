function OR_statistical_analysis()

try
    ebsd = evalin('base', 'ebsd');
catch
    disp('No ebsd data available');
end
try
    Phase1=evalin('base','parent_phase');
catch
    disp('No Phase1 defined');
end
try
    Phase2=evalin('base','child_phase');
    catch
    disp('No Phase2 defined');
end
try
    ori_Mar_rot=evalin('base','ori_Mar_rot');
catch
    disp('no martensite orientations calculated so far. Run "automatic" mode first');
end

markerSize=evalin('base','markerSize');

cs_bcc = ebsd(Phase2).CS;
cs_aus = ebsd(Phase1).CS;

%%%%%%%%%%%%%%%%%%%%%Calculation of rotation angle between OriÂ´s %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
max_filter_angle_threshold=20;

arr=[];
var_names=[];
iter=0;
ori= orientation.byMiller([0 0 1],[1 0 0],cs_aus);

try
    hkluvw=str2num(evalin('base','hkluvw'));
    ori= orientation.byMiller(hkluvw(1:3),hkluvw(4:6),cs_aus);
catch
    disp('No specific (hkl)[uvw] chosen. Default reference parent_phase system set to(001)[100]');
end

try
    evalin('base','predefined_OR');
catch
    disp('No predefined OR used. Plotting GT/KS/Pitsch/NW');
end


ipfKey_Mar = BungeColorKey(ebsd(Phase2)); % define color key 
% [uvw,hkl]=round2Miller(ori_Mar_rot)
% % revert back GT misorientation ship
% mori=orientation.GreningerTrojano(cs_bcc,cs_aus)

if exist('prefedined_OR','var') == 0 
    
GT = orientation.map(Miller(1,2,-3,cs_aus),Miller(1,3,3,cs_bcc),...
  Miller(1,1,1,cs_aus),Miller(0,1,-1,cs_bcc));
KS = orientation.map(Miller(1,1,1,cs_aus),Miller(0,1,1,cs_bcc),...
      Miller(-1,0,1,cs_aus),Miller(-1,-1,1,cs_bcc));
Pitsch = orientation.map(Miller(1,1,0,cs_aus),Miller(1,1,1,cs_bcc),...
      Miller(0,0,1,cs_aus),Miller(1,-1,0,cs_bcc));
NW = orientation.map(Miller(1,1,1,cs_aus),Miller(0,1,1,cs_bcc),...
      Miller(1,1,-2,cs_aus,'uvw'),Miller(0,-1,1,cs_bcc,'uvw')); 
  
vars_GT = variants(GT,ori);
vars_KS = variants(KS,ori);
vars_NW = variants(NW,ori);
vars_Pitsch = variants(Pitsch,ori);

figure()
hChild =Miller({0,0,1},{1,1,0},{1,1,1},GT.SS,'hkl');
plotPDF(ori_Mar_rot,ipfKey_Mar.orientation2color(ori_Mar_rot),hChild,'all','MarkerSize',markerSize) % plot rotated martensite on the PF
figure()
plotPDF(vars_GT,ind2color(1:length(vars_GT)),hChild,...
  'antipodal','MarkerEdgeColor','black','MarkerSize',markerSize)

for filter_angle_threshold=5:5:max_filter_angle_threshold
minimum_angle_GT=[];
minimum_angle_NW=[];
minimum_angle_KS=[];
minimum_angle_Pitsch=[];
ori_Mar_new=[];
for num_ori_mar=1:length(ori_Mar_rot)
% for num_ori_mar=1:100
    omega_GT=[];
    omega_NW=[];
    omega_KS=[];
    omega_Pitsch=[];
    for num_var=1:length(vars_GT)
       omega_GT=[omega_GT angle(ori_Mar_rot(num_ori_mar),vars_GT(num_var))./degree];
       omega_KS=[omega_KS angle(ori_Mar_rot(num_ori_mar),vars_KS(num_var))./degree];
    end
    for num_var=1:length(vars_NW)
        omega_NW=[omega_NW angle(ori_Mar_rot(num_ori_mar),vars_NW(num_var))./degree];
        omega_Pitsch=[omega_Pitsch angle(ori_Mar_rot(num_ori_mar),vars_Pitsch(num_var))./degree];
    end
    minimum_angle_GT=[minimum_angle_GT min(omega_GT)];
    minimum_angle_KS=[minimum_angle_KS min(omega_KS)];
    minimum_angle_NW=[minimum_angle_NW min(omega_NW)];
    minimum_angle_Pitsch=[minimum_angle_Pitsch min(omega_Pitsch)];
    
    if (min(omega_GT) < filter_angle_threshold) && (min(omega_KS) < filter_angle_threshold) && (min(omega_NW) < filter_angle_threshold) && (min(omega_Pitsch) < filter_angle_threshold)
        ori_Mar_new=[ori_Mar_new ori_Mar_rot(num_ori_mar)];
    end
end

try
    disp(['now plotting for threshold value of ', num2str(filter_angle_threshold)])
    figure
    plotPDF(ori_Mar_new,ipfKey_Mar.orientation2color(ori_Mar_new),hChild,'all','MarkerSize',markerSize) % plot filtered martensite on the PF
catch
    disp(['no Ori´s found for threshold of ', num2str(filter_angle_threshold)])
end

summ = [minimum_angle_GT; minimum_angle_KS; minimum_angle_NW; minimum_angle_Pitsch];

iter=iter+1;


sum1=summ(1,:);sum1=sum1(sum1<filter_angle_threshold);arr(iter,1)=mean(sum1);
sum2=summ(2,:);sum2=sum2(sum2<filter_angle_threshold);arr(iter,2)=mean(sum2);
sum3=summ(3,:);sum3=sum3(sum3<filter_angle_threshold);arr(iter,3)=mean(sum3);
sum4=summ(4,:);sum4=sum4(sum4<filter_angle_threshold);arr(iter,4)=mean(sum4);

var_names{iter}=strcat( 'meanVal_',num2str(filter_angle_threshold));

T = array2table(arr','RowNames',{'GT' 'KS' 'NW' 'Pitsch'},'VariableNames',var_names)
end

else
    predefined_OR_plot();
end

% writetable(T,'A1.txt')
% mean(arr(:,1))