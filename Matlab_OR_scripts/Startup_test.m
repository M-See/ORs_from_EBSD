function Startup_test
% This function extracts the ebsd data etc.


try
    ebsd = evalin('base', 'ebsd');
    assignin('base','ebsd_original',ebsd);
catch
    disp('No EBSD data found.')
end

try
    grains=evalin('base','grains');
end

Backup_fname='BackUp1.txt';
assignin('base','Backup_fname',Backup_fname)
Backup_fname2='BackUp2.txt';
assignin('base','Backup_fname2',Backup_fname2)


% Phase2=char(ebsd.mineralList(2));%Child
% assignin('base','Phase2',Phase2)
% try
%     Phase1=char(ebsd.mineralList(3)); %Parent
% catch
%     Phase1=strcat(Phase2,'2');
%     disp('No second phase found. Set second as the first')
% end
% assignin('base','Phase1',Phase1)

Phase2=evalin('base','child_phase');
Phase1=evalin('base','parent_phase');

try
    CS=evalin('base','CS');
    disp("read corrected CS")
end

if exist('CS','var') == 1 && exist('grains','var') == 0
    
    
    disp("CS overwritten.. waiting for corrected EBSD")
%     assignin('base','CSLIST',ebsd.CSList);
%     plot(ebsd)
     ebsd1=ebsd(ebsd.phaseId==2);
     ebsd2=ebsd(ebsd.phaseId==3);
     ebsd1.CS=CS{2};
     ebsd2.CS=CS{3};
     ebsd=[ebsd('notIndexed');ebsd1;ebsd2];
     disp("EBSD corrected!")
     assignin('base','ebsd',ebsd);
     [grains,ebsd.grainId] = calcGrains(ebsd('indexed'),'threshold',5*degree);
     assignin('base','grains',grains);
end

% coloring phases
ebsd(Phase2).color =str2rgb('red');
try
    ebsd(Phase1).color =str2rgb('blue');
catch
    disp('No second phase found. Set color not possible')
end
%calculate grains
if exist('grains','var') == 0
    [grains,ebsd.grainId] = calcGrains(ebsd('indexed'),'threshold',5*degree);
    assignin('base','grains',grains);
end

%plot(grains(12345),grains(12345).meanOrientation);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %     % needs to be deleted if EBSD data is correct --> dont delete for FeNiCSi, otherwise wrong indexed!
% % %     ebsd1=ebsd(ebsd.phaseId==3);
% % %     ebsd2=ebsd(ebsd.phaseId==2);
% % %     ebsd1.CS=CS{2};
% % %     ebsd2.CS=CS{3};
% % %     ebsd=[ebsd('notIndexed');ebsd1;ebsd2];


%% Selection of Phases
manually_or_automatic= questdlg('Select grains manually or automatic selection?', ...
        'Choice of procedure', ...
        'Manually','Semi-Automatic','Automatic','Automatic');
    switch manually_or_automatic
       case 'Manually'
           inner_orientation= questdlg('Intergranular orientation?', ...
            'Inner grain method', ...
                'Yes','No','No');
            switch inner_orientation
                case 'Yes'
                    manually_or_automatic =3;
                case 'No'
                    manually_or_automatic=1;
            end
       case 'Automatic'
           manually_or_automatic=0;
       case 'Semi-Automatic'
           manually_or_automatic=2;
    end

if manually_or_automatic==1
    clear indSelected
    %% %%%%%%%%%%%%%%%%%%%%%%%%% martensite/Austenite PoleFigures and ODFs
    %%%% Choose Austenite and martensite grains from map

    backupcall_yes=0;
    backupcall = questdlg('Reload old values?', ...
            'Loading Backup Data', ...
            'Yes','No','No');
        switch backupcall
            case 'Yes'
                backupcall_yes=1;
            case 'No'
                disp('continuing without loading any data..')
        end
     if backupcall_yes ==1
        try
            Read_BackUp = regexp(fileread(Backup_fname),'\n','split');
        catch
            disp('No Backup-file found. Try reloading')
        end
        whichline = find(contains(Read_BackUp,'XXXXXXXXXXNEWVALUESXXXXXXXXXX'));
        number_backup_choice = str2double(inputdlg("Found " + length(whichline) + " Backups. Which one to load?",...
                 'Backup loader', [1 50]));
        if isempty(number_backup_choice)
            disp('continuing without loading any data')
        elseif number_backup_choice == 1
            BackUpValues=str2double(Read_BackUp(whichline(end)+1:end)');
        else
            BackUpValues=str2double(Read_BackUp(whichline(end-number_backup_choice+1)+1:whichline(end-number_backup_choice+2)-1)');
        end
        austenite2=[BackUpValues(1:length(find(BackUpValues<=20)))]';
        amount_grains=[BackUpValues(length(austenite2)+1:(length(austenite2)*2))]';
        martensite2=[BackUpValues(length(austenite2)*2+1:length(austenite2)*2+sum(amount_grains))]';
     end

    if backupcall_yes == 0
        FileName=Backup_fname;

        figure()
        plot(grains(Phase2))
        hold on
        try
            plot(grains(Phase1),grains(Phase1).meanOrientation,'FaceAlpha',1)
        catch
            disp('No second phase found. Just one plot shown.')
        end
        hold on

        not_ready = 0;
        austenite2 =[];
        temp2=[];
        martensite2=[];
        temp=[];
        amount_grains =[];
        while not_ready < 2
            answer = questdlg('Choose the grains (BE CAREFUL, CHOOSE FIRST SINGLE PARENT GRAIN AND AFTERWARDS CORRESPONDING CHILD(REN)--> REPEAT THE PROCESS):', ...
                'Grain detector', ...
                char(Phase2),char(Phase1),'Done','Done');
            % Handle response
            switch answer
                case char(Phase2)
                    selectInteractive(grains,'lineColor','white')
                    global indSelected
                    selecter=grains(indSelected);
                    selecter.id
                    waitfor(msgbox('Ready choosing grains(s)?.'));
                    disp('Done waiting.');       
                    list = {'not ready','ready'};
                    [not_ready,tf] = listdlg('ListString',list,'ListSize',[150,75],'SelectionMode','single');
                    temp=[martensite2 indSelected'];
                    martensite2=temp;
                    temp3=[amount_grains;length(indSelected)];
                    amount_grains=temp3;
                case char(Phase1)
                    selectInteractive(grains,'lineColor','white')
                    global indSelected
                    selecter=grains(indSelected);
                    selecter.id
                    waitfor(msgbox('Ready choosing grain(s)?.'));
                    disp('Done waiting.');       
                    list = {'not ready','ready'};
                    [not_ready,tf] = listdlg('ListString',list,'ListSize',[150,75]);
                    temp2 =[austenite2 indSelected'];
                    austenite2=temp2;
                case 'Done'
                    disp('Grain choice canceled.')
                    not_ready=2;
            end
        end

        % write backup values to file for reprocuibility:
        fileID = fopen(FileName,'a');
        fprintf(fileID,'\n')
        fprintf(fileID,"XXXXXXXXXXNEWVALUESXXXXXXXXXX" );
        stringy='%i\n%i\n%i\n';
        fprintf(fileID,stringy,austenite2, amount_grains, martensite2);
        fclose(fileID);
    end
    
    assignin('base','austenite2',austenite2);
    assignin('base','martensite2',martensite2);
    Single_Austenite_Grain= austenite2; %[34087,50454]
    How_many_mart_per_austenite=amount_grains; %[6,2]
    Martensites= martensite2; %[34514,35361,35901,35811,33519,35359,49320,49905]
    
    figure
    plot(grains(martensite2'))
    hold on
    plot(grains(austenite2'))

    figure()
    plot(grains(Phase2))
    hold on
    try
        plot(grains(Phase1),grains(Phase1).meanOrientation,'FaceAlpha',1)
    catch
        disp('No second phase found. Just one plot shown.')
    end
    hold on
    plot(grains(Martensites).boundary,'lineWidth',2,'lineColor','yellow')
    hold on
    plot(grains(Single_Austenite_Grain).boundary,'lineWidth',2,'lineColor','red')
    hold off

    try
        h_austenite = Miller({1,0,0},{0,1,1},{1,1,1},ebsd(Phase1).CS);
    catch
        h_austenite = Miller({1,0,0},{0,1,1},{1,1,1},ebsd(Phase2).CS);
        disp('No second phase found. Miller indices just set once.')
    end
    h_martensite = Miller({1,0,0},{0,1,1},{1,1,1},ebsd(Phase2).CS);
%     plotPDF(grains(Single_Austenite_Grain(1)).meanOrientation,h_austenite,'figSize','medium') %%% AUSTENITE grain

    for k=1:numel(Single_Austenite_Grain)
        orientat{k}=inv(grains(Single_Austenite_Grain(k)).meanOrientation);
        rotat{k}=rotation.byEuler(orientat{k}.phi1,orientat{k}.Phi,orientat{k}.phi2);
    end

    %invert the orientation to return austenite Orientation to 001
    orient=inv(grains(Single_Austenite_Grain(1)).meanOrientation);
    rot= rotation.byEuler(orient.phi1,orient.Phi,orient.phi2);

    %%%%% for ODF plot..
    % odf_single_grain_austenite=calcDensity(grains(Single_Austenite_Grain(1)).meanOrientation)
    % odf_rotated_austenite=rotate(odf_single_grain_austenite,rotat{1})
    % figure()
    % plotPDF(odf_rotated_austenite,h_austenite,'figSize','medium')
    % 
    % counter=0
    % figure()
    % for j=1:numel(rotat)
    %     for k=1:numel(Martensites)
    %         counter=counter+1
    %         od{counter}=calcDensity(grains(Martensites(counter)).meanOrientation)
    %         od_rot{counter}=rotate(od{counter},rotat{j})
    %         plotPDF(od_rot{counter},h_martensite,'figSize','medium')
    %         hold all
    %         if k==How_many_mart_per_austenite(j)
    %             break
    %         end
    %     end
    % end
    % hold off


    %%%%%%%%%%%%%%%%%%%% Single Point plots

    single_grain_austenite=grains(Single_Austenite_Grain(1));
    rotated=rotate(single_grain_austenite,rotat{1});

    % figure()
    % plotPDF(rotated.meanOrientation,h_austenite,'figSize','medium')
    % title("PDF of Austenite")

    counter=0;
    figure()
    grains_manually_selected_rot_ori=[];
    for j=1:numel(austenite2)
        for k=1:numel(Martensites)
            counter=counter+1;
            grain_martens{counter}=grains(Martensites(counter));
            grain_martens_rot{counter}=rotate(grain_martens{counter},rotat{j});
            plotPDF(grain_martens_rot{counter}.meanOrientation,h_martensite,'figSize','medium')
            grains_manually_selected_rot_ori= [grain_martens_rot{counter}.meanOrientation grains_manually_selected_rot_ori];
            hold all
            if k==How_many_mart_per_austenite(j)
                break
            end
        end
    end
    nextAxis(1)
    hold on
    plot(rotated.meanOrientation * h_austenite(1).symmetrise ,'MarkerFaceColor','r')
    xlabel('\((100)\)','Color','red','Interpreter','latex')
    nextAxis(2)
    plot(rotated.meanOrientation * h_austenite(3).symmetrise ,'MarkerFaceColor','r')
    xlabel('\((111)\)','Color','red','Interpreter','latex')
    nextAxis(3)
    plot(rotated.meanOrientation * h_austenite(2).symmetrise ,'MarkerFaceColor','r')
    xlabel('\((110)\)','Color','red','Interpreter','latex')
    hold off
%     assignin('base','grains_manually_selected_rot_ori',grains_manually_selected_rot_ori);
    
    Var_plot(grains_manually_selected_rot_ori,ebsd(Phase1),ebsd(Phase2));
end

if manually_or_automatic==0
    No_grains_Parent_phase = str2double(cell2mat(inputdlg({'Enter number of Orientations grains to be analyzed'},'Number of grains',[1 50],{'100'})));
    assignin('base','No_grains_Parent_phase',No_grains_Parent_phase);
    automaticOR
end


% 
if manually_or_automatic ==2
    
    backupcall_yes=0;
    backupcall = questdlg('Reload old values?', ...
            'Loading Backup Data', ...
            'Yes','No','No');
        switch backupcall
            case 'Yes'
                backupcall_yes=1;
            case 'No'
                disp('continuing without loading any data..')
        end
     if backupcall_yes ==1
        try
            Read_BackUp = regexp(fileread(Backup_fname2),'\n','split');
        catch
            disp('No Backup-file found. Try reloading.')
        end
        whichline = find(contains(Read_BackUp,'XXXXXXXXXXNEWVALUESXXXXXXXXXX'));
        number_backup_choice = str2double(inputdlg("Found " + length(whichline) + " Backups. Which one to load?",...
                 'Backup loader', [1 50]));
        if isempty(number_backup_choice)
            disp('continuing without loading any data')
        elseif number_backup_choice == 1
            BackUpValues=str2double(Read_BackUp(whichline(end)+1:end-1)');
        else
            BackUpValues=str2double(Read_BackUp(whichline(end-number_backup_choice+1)+1:whichline(end-number_backup_choice+2)-1)');
        end
        austenite2=BackUpValues;
     end

    if backupcall_yes == 0
        FileName=Backup_fname2;

        clear indSelected
        figure()
        plot(grains(Phase2))
        hold on
        try
            plot(grains(Phase1),grains(Phase1).meanOrientation,'FaceAlpha',1)
        catch
            disp('No second phase found. Just showing single plot.')
        end
        hold on

        not_ready = 0;
        austenite2 =[];
            while not_ready < 2
                selectInteractive(grains,'lineColor','gold')
                global indSelected
                selecter=grains(indSelected);
                selecter.id
                waitfor(msgbox('Choose parent grains. Ready choosing grain(s), click ok?.'));
                disp('Done waiting.');
                austenite2=indSelected';
                not_ready=2;
            end
        disp(['Analyzing ' num2str(austenite2) ' ' char(Phase1) ' grains..'])

        % write backup values to file for reprocuibility:
        fileID = fopen(FileName,'a');
        fprintf(fileID,"XXXXXXXXXXNEWVALUESXXXXXXXXXX" );
        stringy='\n%i\n%i\n%i';
        fprintf(fileID,stringy,austenite2);
        fclose(fileID);
    end

    No_grains_Parent_phase=austenite2;
    assignin('base','No_grains_Parent_phase',No_grains_Parent_phase);
    semiautomaticOR
%    clearvars -except ebsd grains grains_aus grains_Mar Phase1 Phase2

end


%% Manually selected austenite/martensite and plotting the OR from interior 
if manually_or_automatic==3

    % martensite grain pixels
    clear ebsd_small_aus ebsd_small_mart
    
    figure()
    plot(grains(Phase2))
    hold on
    try
        plot(grains(Phase1),grains(Phase1).meanOrientation,'FaceAlpha',1)
    catch
        disp('No second phase found. Just single plot shown.')
    end
    hold on
    
    small_ebsd_grains=[];
     
    waitfor(msgbox('Choose two grains in the next figure(BE CAREFUL, CHOOSE FIRST SINGLE PARENT GRAIN AND AFTERWARDS CORRESPONDING CHILD)', ...
        'Grain detector'));
    selectInteractive(grains,'lineColor','gold')
    global indSelected
    selecter=grains(indSelected);
    selecter.id
    waitfor(msgbox('Ready choosing grains(s)?.'));
    disp('Done waiting.');       
    temp5=[small_ebsd_grains indSelected'];
    small_ebsd_grains=temp5;

    grainID=small_ebsd_grains(1);  % 24187 martensite grain - manually
    grainID_aus=small_ebsd_grains(2);   % 41328 austenite grain - manually

    x=ebsd(ebsd.grainId==grainID_aus);
    x2=ebsd(ebsd.grainId==grainID);
    
    
    answer2 = questdlg('Analyze a range of pixels, a rectangular region or space-separated distinct pixels', ...
            'Grain detector', ...
            'Range','Region','Specific Pixels','Specific Pixels');
        % Handle response
        switch answer2
            case 'Range'
                Index_Range = str2double(inputdlg({'Index-Start','Index-End'},'ID-Range', [1 11; 1 11]));
                List=Index_Range(1):Index_Range(2);
            case 'Region'
                 waitfor(msgbox('Choose region of parent phase in the next figure.'));
                figure()
%                 plot(x,x.orientations)
%                 ebsd_small_aus=selectInteractive(ebsd)
%                 waitfor(msgbox('Choose region of child phase in the next figure.'));
%                 hold on
                plot(x2,x2.orientations)
                ebsd_small_mart=selectInteractive(ebsd)
                List=find(ismember(x2.id,ebsd_small_mart.id))'
            case 'Specific Pixels'
                List = (inputdlg('Enter space-separated Index-Numbers:','Distinct Pixels', [1 50]))
                List = str2num(List{1});
        end


    try
        h_austenite = Miller({1,0,0},{0,1,1},{1,1,1},ebsd(Phase1).CS);
    catch
        h_austenite.Miller({1,0,0},{0,1,1},{1,1,1},ebsd(Phase2).CS);
        disp('No second phase found. Miller indices set once.')
    end
    h_martensite = Miller({1,0,0},{0,1,1},{1,1,1},ebsd(Phase2).CS);
% 
%     figure()
%     plot(x2)
%     ori=x2.orientations
%     odf=calcDensity(ori)
%     plotPDF(odf,h_martensite,'figSize','medium')
   

    orientat=inv(grains(grainID_aus).meanOrientation);
    rotat=rotation.byEuler(orientat.phi1,orientat.Phi,orientat.phi2);
    rotated=rotate(grains(grainID_aus),rotat);
   
    figure
    % for k=1:length(x2)
    for k=List
        x2_rot{k}=rotate(x2(k),rotat);
        plotPDF(x2_rot{k}.orientations,h_martensite,'figSize','medium')
        hold all
    end

    nextAxis(1)
    hold on
    plot(rotated.meanOrientation * h_austenite(1).symmetrise ,'MarkerFaceColor','r')
    xlabel('\((100)\)','Color','red','Interpreter','latex')
    nextAxis(2)
    plot(rotated.meanOrientation * h_austenite(3).symmetrise ,'MarkerFaceColor','r')
    xlabel('\((111)\)','Color','red','Interpreter','latex')
    nextAxis(3)
    plot(rotated.meanOrientation * h_austenite(2).symmetrise ,'MarkerFaceColor','r')
    xlabel('\((110)\)','Color','red','Interpreter','latex')
    hold off

    figure
    plot(x)
    hold on
    plot(x2)

    for k=List
    hold on
    plot(x2(k),x2(k).orientations)
    end
    hold off

end