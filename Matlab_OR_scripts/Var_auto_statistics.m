function Var_auto_statistics(orientations,ebsd_Phase1,ebsd_Phase2)

threshold=10;

cs_parent=ebsd_Phase1.CS;
cs_child=ebsd_Phase2.CS;

try
    hkluvw=str2num(evalin('base','hkluvw'));
    ori= orientation.byMiller(hkluvw(1:3),hkluvw(4:6),cs_aus);
catch
    disp('No specific (hkl)[uvw] chosen for Variant hist-plot. Default reference parent_phase system set to(001)[100]');
    ori= orientation.byMiller([0 0 1],[1 0 0],cs_parent);
    
end
    
try 
    evalin('base','predefined_OR');
    vars = variants(predefined_OR,ori);
    hChild =Miller({0,0,1},{1,1,0},{1,1,1},predefined_OR.SS,'hkl');
catch
    disp('No predefined_OR chosen for Variant hist-plot. As default set Greninger-Troiano OR.');
    GT = orientation.map(Miller(1,2,-3,cs_parent),Miller(1,3,3,cs_child),...
      Miller(1,1,1,cs_parent),Miller(0,1,-1,cs_child));
    vars = variants(GT,ori);
    hChild =Miller({0,0,1},{1,1,0},{1,1,1},GT.SS,'hkl');
end


markerSize=evalin('base','markerSize');
ipfKey_Mar = ipfColorKey(ebsd_Phase2);
% ori_Mar_rot=evalin('base',grains_manually_selected_rot_ori);

angles=[];
new_ori_mar_filtered_angles=[];

stor=[];
for num_ori_mar=1:length(orientations)
    omega_GT=[];
    for num_var=1:length(vars)
        omega_GT=[angle(orientations(num_ori_mar),vars(num_var))./degree omega_GT ];
%         disp(['this angle: ',num2str(angle(ori_Mar_rot(num_ori_mar),vars(num_var))./degree) , ' for this variant: ']);
%         vars(num_var)
        
    end
    if min(omega_GT)<threshold
        angles=[omega_GT; angles];
        new_ori_mar_filtered_angles=[orientations(num_ori_mar) new_ori_mar_filtered_angles];
    end
end

%col-length
for num_angles=1:size(angles,1)
    
    [stored_angle,stored_variant] = min(angles(num_angles,:));
    
    stor=[stored_angle, stored_variant; stor];
    
end

figure('name','histogram for variants');
histogram(stor(:,2));
xlabel('Variant');
ylabel('Quantity');
xlim([0,25]);
ylim([0,35]);


plotted_ori=1:size(stor,1);
figure('name',['filtered child orientations by a threshold of', num2str(threshold)]);
plotPDF(new_ori_mar_filtered_angles,ipfKey_Mar.orientation2color(new_ori_mar_filtered_angles),hChild,'all','MarkerSize',markerSize) % plot filtered martensite on the PF
