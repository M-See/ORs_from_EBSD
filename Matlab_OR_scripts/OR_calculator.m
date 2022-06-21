iter=0;

z=[];
for a=-3:1:3
    for b=-3:1:3
        for c=-3:1:3
            z=[[a b c]; z];
        end
    end
end

range1=round(length(z)/150*iter)+1;
range2=round(length(z)/150*(iter+1));

cs_bcc = crystalSymmetry('432');
cs_aus = crystalSymmetry('432');

OR=[];
num=[];

for a=range1:range2
    for b=1:length(z)
        for c=1:length(z)
            for d=1:length(z)

                try
                GT = orientation.map(Miller(z(a,1),z(a,2),z(a,3),cs_aus),Miller(z(b,1),z(b,2),z(b,3),cs_bcc),...
                Miller(z(c,1),z(c,2),z(c,3),cs_aus),Miller(z(d,1),z(d,2),z(d,3),cs_bcc));
%                 OR=[GT OR];
                num=[ z(a,1) z(a,2) z(a,3) z(b,1) z(b,2) z(b,3) z(c,1) z(c,2) z(c,3) z(d,1) z(d,2) z(d,3); num];
%                 disp(['This OR works: ', '(',num2str(z(a,1)),' ',num2str(z(a,2)),' ',num2str(z(a,3)),') [',num2str(z(b,1)),' ',num2str(z(b,2)),' ',num2str(z(b,3)),']']);
%                 disp(['               (',num2str(z(c,1)),' ',num2str(z(c,2)),' ',num2str(z(c,3)),') [',num2str(z(d,1)),' ',num2str(z(d,2)),' ',num2str(z(d,3)),']'])

                catch
                end
            end
        end
    end
    datestr(now)
    disp(a)
end

datestr(now)

file_str=['iter_' num2str(iter) '.txt'];

fileID = fopen(file_str,'w');
fprintf(fileID,'%5d %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d\n',num);
fclose(fileID);

Folder = cd;
Folder = fullfile(Folder, '..');
save(fullfile(Folder, file_str))

movefile(file_str, Folder);



% read back in the values:
% a2=[];
% fid = fopen('test1.txt');
% tline = fgetl(fid);
% while ischar(tline)
%     disp(tline)
%     a=str2num(tline);
%     a2=[a2;a]
%     tline = fgetl(fid);
% end
% fclose(fid);