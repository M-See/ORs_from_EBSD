function EBSD_load()



try
    ebsd = evalin('base', 'ebsd');
end
try
    filename=evalin('base','filename');
end

if exist('filename','var') == 1 
    disp('MTex folder found..')
    
else
    disp('No MTex folder found. Please choose directory:')
    filename=strcat(char(uigetdir('C:\','SELECT MTEX Folder')),'\startup_mtex.m');
    run(filename);
    assignin('base','filename',filename);
end

if exist('ebsd','var') == 1
    
    ebsd_data=0;
    backupcall = questdlg('Use old EBSD?', ...
            'Load New EBSD', ...
            'Yes','No','Yes');
        switch backupcall
            case 'Yes'
                ebsd_data=1;
            case 'No'
                'loading new EBSD data..'
        end
    if ebsd_data ==1 
        
        Startup_test
        
    else
        
        import_wizard('EBSD')
        waitfor(msgbox('Ready chosing EBSD file?'));

        UI_wizard

        Startup_test
    end
    
else
    
    import_wizard('EBSD')
    waitfor(msgbox('Ready chosing EBSD file?'));

    UI_wizard

    Startup_test
end


