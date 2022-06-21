function UI_wizard()

ebsd= evalin('base','ebsd');

fig=figure


c3 = uicontrol(fig,'Style','text','String','Choose Parent Phase:');
c3.Position=[200 200 200 200];
c4 = uicontrol(fig,'Style','text','String','Choose Child Phase:');
c4.Position=[200 150 200 200];


c1 = uicontrol(fig,'Style','popupmenu');
c1.Position = [200 175 200 200];
c1.String = {char(ebsd.mineralList(1)),char(ebsd.mineralList(2)),char(ebsd.mineralList(3))};
c1.Callback = @selection1;

c2 = uicontrol(fig,'Style','popupmenu');
c2.Position = [200 125 200 200];
c2.String = {char(ebsd.mineralList(1)),char(ebsd.mineralList(2)),char(ebsd.mineralList(3))};
c2.Callback = @selection2;

c = uicontrol('Style','checkbox','String','Ready importing?');
c.Position = [200 100 200 200];
waitfor(c,'Value');

function selection1(src,event)
    val = c1.Value;
    str = c1.String;
    str{val};
    disp(class(val))
%     disp(['parent_phase: ' str{val}]);
    parent_phase=cellstr(str{val})
    assignin('base','parent_phase',parent_phase)
end

function selection2(src,event)
    val = c2.Value;
    str = c2.String;
    str{val};
    disp(class(val))
%     disp(['child_phase: ' str{val}]);
    child_phase=cellstr(str{val})
    assignin('base','child_phase',child_phase)
end

end