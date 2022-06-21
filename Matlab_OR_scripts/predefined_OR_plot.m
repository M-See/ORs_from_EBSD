function predefined_OR_plot()

try
    ebsd = evalin('base', 'ebsd');
catch
    disp('no EBSD imported');
end
try
    Phase1=evalin('base','parent_phase');
end
try
    Phase2=evalin('base','child_phase');
end
try
    ori_Mar_rot=evalin('base','ori_Mar_rot');
catch
    disp('no martensite orientations calculated so far. Run "automatic" mode first');
end

max_filter_angle_threshold=20

arr=[];
var_names=[];
iter=0

ipfKey_Mar = BungeColorKey(ebsd(Phase2)); % define color key 

markerSize=evalin('base','markerSize');
pre_OR=evalin('base','predefined_OR');

cs_bcc = ebsd(Phase2).CS;
cs_aus = ebsd(Phase1).CS;

try
    hkluvw=str2num(evalin('base','hkluvw'));
    ori= orientation.byMiller(hkluvw(1:3),hkluvw(4:6),cs_aus);
catch
    ori= orientation.byMiller([0 0 1],[1 0 0],cs_aus);
    disp('No (hkl)[uvw] specified. Set to default (001)[100].'); 
end




vars_pre_OR = variants(pre_OR,ori);

figure()
hChild =Miller({0,0,1},{1,1,0},{1,1,1},pre_OR.SS,'hkl');
plotPDF(ori_Mar_rot,ipfKey_Mar.orientation2color(ori_Mar_rot),hChild,'all','MarkerSize',markerSize) % plot rotated martensite on the PF
figure()
plotPDF(vars_pre_OR,ind2color(1:length(vars_pre_OR)),hChild,...
  'antipodal','MarkerEdgeColor','black','MarkerSize',markerSize)

for filter_angle_threshold=5:5:max_filter_angle_threshold
minimum_angle_pre_OR=[];
ori_Mar_new=[];
for num_ori_mar=1:length(ori_Mar_rot)
% for num_ori_mar=1:100
    omega_pre_OR=[];
    for num_var=1:length(vars_pre_OR)
       omega_pre_OR=[omega_pre_OR angle(ori_Mar_rot(num_ori_mar),vars_pre_OR(num_var))./degree];
    end
    minimum_angle_pre_OR=[minimum_angle_pre_OR min(omega_pre_OR)];
    
    if (min(omega_pre_OR) < filter_angle_threshold)
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

summ = minimum_angle_pre_OR;

iter=iter+1;


sum1=summ(1,:);sum1=sum1(sum1<filter_angle_threshold);arr(iter,1)=mean(sum1);
% sum2=summ(2,:);sum2=sum2(sum2<filter_angle_threshold);arr(iter,2)=mean(sum2);
% sum3=summ(3,:);sum3=sum3(sum3<filter_angle_threshold);arr(iter,3)=mean(sum3);
% sum4=summ(4,:);sum4=sum4(sum4<filter_angle_threshold);arr(iter,4)=mean(sum4);

var_names{iter}=strcat( 'meanVal_',num2str(filter_angle_threshold));

T = array2table(arr','RowNames',{'predefined OR'},'VariableNames',var_names)

end