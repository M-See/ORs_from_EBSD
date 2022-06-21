function automaticOR()

Phase1=evalin('base','Phase1');
Phase2=evalin('base','Phase2');
grains=evalin('base','grains');
ebsd=evalin('base','ebsd');
No_grains_Parent_phase=evalin('base','No_grains_Parent_phase');

 disp(['Analyzing ' num2str(No_grains_Parent_phase) ' ' num2str(Phase1) ' grains..'])
     % filtering the martensites in the largest austenite grains and rotate 
    % their orientation with the same rotation matrix that could be used to 
    % rotate the matrix austenite to (000)
    grains_aus=grains(Phase1); %% filter out austenite grains
    grains_Mar=grains(Phase2); %% filter out the martensite
    gB_Mar=grains_Mar.boundary(Phase1,Phase2); % get the boundaries between martensite and austenite
    [~,id_aus]=sort(grains_aus.area,'descend'); %% sort the grains according to grain area
    for j=1:No_grains_Parent_phase %% investigate the largest 500 grains
        An=angle(grains_aus.meanOrientation,...
        grains_aus(id_aus(j)).meanOrientation)/degree; %caculate the angle between other austenite grains and the target grain
        grainsS_aus=grains_aus(An<5); %% filter out the grains with similar orientation (<5 degree)
        grainsS_aus=grainsS_aus(grainsS_aus.grainSize>5); %% filter the grains with at least five indexed points to avoid the noises
        id=grainsS_aus.id; %% get the austenite grain id
        ori_Mar=[];
        for i=1:size(id,1) %% in this loop we try to filter out all of the neighboring martensite
            % bounded with a boundary with the target austenite
            id2=find(gB_Mar.grainId==id(i));
            if ~isempty(id2)
                idS=unique(gB_Mar(id2).grainId);
                t=grains(idS(idS~=id(i))); % get the martensites
            % grainsS_Mar{i,j}=t(t.grainSize>5);
            if ~isempty(t(t.grainSize>5))
                ori_Mar=[ori_Mar;t(t.grainSize>5).meanOrientation]; %% save the orientations of martensite grains (> 5 indexed points)
            end
            end
        end
        if j==1
            ori_rot=[];
            ori_Mar_rot=[];
        end
        if ~isempty(ori_Mar)
            ori0=grains(id).meanOrientation; % get the orientaion of target grains
            rot=rotation('axis',axis(ori0(1)),'angle',-angle(ori0(1))); % define the rotation matrix
            ori_rot=[ori_rot,rot*ori0]; %% rotate the orientation of target grains to (000)
            ori_Mar_rot=[ori_Mar_rot,rot*ori_Mar]; % rotate the corrsponding martensites
        end
    end
% plotting
h_austenite = Miller({1,0,0},{0,1,1},{1,1,1},ebsd(Phase1).CS); %% define the plane of PF
h_martensite = Miller({1,0,0},{0,1,1},{1,1,1},ebsd(Phase2).CS); 
ipfKey_Mar = ipfColorKey(ebsd(Phase2)); % define color key
ipfKey_Aus = ipfColorKey(ebsd(Phase1)); 
figure
plotPDF(ori_Mar_rot,ipfKey_Mar.orientation2color(ori_Mar_rot),h_martensite,'all') % plot rotated martensite on the PF
figure
plotPDF(ori_rot,ipfKey_Aus.orientation2color(ori_rot),h_austenite,'all')% plot rotated austenite on the PF