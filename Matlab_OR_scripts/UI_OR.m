function UI_OR()

f = uifigure();
x = linspace(33, f.Position(2)*.35, 3);  % number of values per vector
y = linspace(22, f.Position(3)*.45, 4);  % number of vectors. 
[xx,yy] = ndgrid(x,y);
h = arrayfun(@(i)uieditfield(f, 'numeric', 'Position', [xx(i),yy(i), 50, 20]),1:numel(xx)); 
f.UserData = struct('Editfield',h);
setappdata(f,'OR',h)

uibutton(f,'push',...
           'Text','Save',...
           'ButtonPushedFcn', @func_compute,...
           'backgroundcolor',...
           'r','FontSize',16,...
            'Position', [300 130 150 30]);  
        
uilabel(f,...
    'Position',[50 280 200 15],...
    'Text','Choose parallel planes (parent/child):');

uilabel(f,...
    'Position',[160 210 200 30],...
    'Text','//',...
    'FontSize',25);

uilabel(f,...
    'Position',[50 130 250 15],...
    'Text','Choose parallel directions (parent/child):');

uilabel(f,...
    'Position',[160 60 200 30],...
    'Text','//',...
    'FontSize',25);
end      


function func_compute(src,~)
%     disp(h(1,1).Value);
    f = ancestor(src,"figure","toplevel");
    f.UserData;
    h=getappdata(f,'OR');
    ebsd=evalin('base','ebsd');
    parent_phase=evalin('base','parent_phase');
    child_phase=evalin('base','child_phase');
    
    cs_parent=ebsd(parent_phase).CS;
    cs_child=ebsd(child_phase).CS;

    try
    predefined_OR=orientation.map(Miller(h(1,10).Value,h(1,11).Value,h(1,12).Value,cs_parent),Miller(h(1,7).Value,h(1,8).Value,h(1,9).Value,cs_child),...
      Miller(h(1,4).Value,h(1,5).Value,h(1,6).Value,cs_parent),Miller(h(1,1).Value,h(1,2).Value,h(1,3).Value,cs_child));
    assignin('base','predefined_OR',predefined_OR);
    disp('OR succsessfully stored in "predefined_OR" variable')
    catch
        disp("Predefined OR inconsistent. Check for symmetries. (Scalar product of first/(second) plane and first/(second) direction needs to be 0.")
    end

end

