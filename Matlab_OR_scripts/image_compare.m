arr=[];

path='variants';


noteOfInterest = imread([path '\NW_1.png']);
noteOfInterest = rgb2gray(noteOfInterest);
C1 = normxcorr2(noteOfInterest,noteOfInterest);

noteOfInterest2 = imread([path '\KS_1.png']);
noteOfInterest2 = rgb2gray(noteOfInterest2);
C1 = normxcorr2(noteOfInterest2,noteOfInterest2);

noteOfInterest3 = imread([path '\GT_1.png']);
noteOfInterest3 = rgb2gray(noteOfInterest3);
C1 = normxcorr2(noteOfInterest3,noteOfInterest3);

noteOfInterest4 = imread([path '\Pitsch_1.png']);
noteOfInterest4 = rgb2gray(noteOfInterest4);
C1 = normxcorr2(noteOfInterest4,noteOfInterest4);

noteOfInterest5 = imread([path '\NW_2.png']);
noteOfInterest5 = rgb2gray(noteOfInterest5);
C1 = normxcorr2(noteOfInterest5,noteOfInterest5);

noteOfInterest6 = imread([path '\KS_2.png']);
noteOfInterest6 = rgb2gray(noteOfInterest6);
C1 = normxcorr2(noteOfInterest6,noteOfInterest6);

noteOfInterest7 = imread([path '\GT_2.png']);
noteOfInterest7 = rgb2gray(noteOfInterest7);
C1 = normxcorr2(noteOfInterest7,noteOfInterest7);

noteOfInterest8 = imread([path '\Pitsch_2.png']);
noteOfInterest8 = rgb2gray(noteOfInterest8);
C1 = normxcorr2(noteOfInterest8,noteOfInterest8);

noteOfInterest9 = imread([path '\NW_3.png']);
noteOfInterest9 = rgb2gray(noteOfInterest9);
C1 = normxcorr2(noteOfInterest9,noteOfInterest9);

noteOfInterest10 = imread([path '\KS_3.png']);
noteOfInterest10 = rgb2gray(noteOfInterest10);
C1 = normxcorr2(noteOfInterest10,noteOfInterest10);

noteOfInterest11 = imread([path '\GT_3.png']);
noteOfInterest11 = rgb2gray(noteOfInterest11);
C1 = normxcorr2(noteOfInterest11,noteOfInterest11);

noteOfInterest12 = imread([path '\Pitsch_3.png']);
noteOfInterest12 = rgb2gray(noteOfInterest12);
C1 = normxcorr2(noteOfInterest12,noteOfInterest12);


aDifferentNoteFromLibrary = imread([path '\exp_1.png']);
aDifferentNoteFromLibrary = rgb2gray(aDifferentNoteFromLibrary);
C1 = normxcorr2(noteOfInterest,aDifferentNoteFromLibrary);
sprintf('NW %0.5f %%',max(C1(:))*100);
arr(1,1)=max(C1(:))*100;
C2 = normxcorr2(noteOfInterest2,aDifferentNoteFromLibrary);
sprintf('KS %0.5f %%',max(C2(:))*100);
arr(1,2)=max(C2(:))*100;
C3 = normxcorr2(noteOfInterest3,aDifferentNoteFromLibrary);
sprintf('GT %0.5f %%',max(C3(:))*100);
arr(1,3)=max(C3(:))*100;
C4 = normxcorr2(noteOfInterest4,aDifferentNoteFromLibrary);
sprintf('Pitsch %0.5f %%',max(C4(:))*100);
arr(1,4)=max(C4(:))*100;
aDifferentNoteFromLibrary = imread([path '\exp_2.png']);
aDifferentNoteFromLibrary = rgb2gray(aDifferentNoteFromLibrary);
C5 = normxcorr2(noteOfInterest5,aDifferentNoteFromLibrary);
sprintf('NW2 %0.5f %%',max(C5(:))*100);
arr(2,1)=max(C5(:))*100;
C6 = normxcorr2(noteOfInterest6,aDifferentNoteFromLibrary);
sprintf('KS2 %0.5f %%',max(C6(:))*100);
arr(2,2)=max(C6(:))*100;
C7 = normxcorr2(noteOfInterest7,aDifferentNoteFromLibrary);
sprintf('GT2 %0.5f %%',max(C7(:))*100);
arr(2,3)=max(C7(:))*100;
C8 = normxcorr2(noteOfInterest8,aDifferentNoteFromLibrary);
sprintf('Pitsch2 %0.5f %%',max(C8(:))*100);
arr(2,4)=max(C8(:))*100;
aDifferentNoteFromLibrary = imread([path '\exp_3.png']);
aDifferentNoteFromLibrary = rgb2gray(aDifferentNoteFromLibrary);
C9 = normxcorr2(noteOfInterest9,aDifferentNoteFromLibrary);
sprintf('NW3 %0.5f %%',max(C9(:))*100); arr(3,1)=max(C9(:))*100;
C10 = normxcorr2(noteOfInterest10,aDifferentNoteFromLibrary);
sprintf('KS3 %0.5f %%',max(C10(:))*100); arr(3,2)=max(C10(:))*100;
C11 = normxcorr2(noteOfInterest11,aDifferentNoteFromLibrary);
sprintf('GT3 %0.5f %%',max(C11(:))*100); arr(3,3)=max(C11(:))*100;
C12 = normxcorr2(noteOfInterest12,aDifferentNoteFromLibrary);
sprintf('Pitsch3 %0.5f %%',max(C12(:))*100); arr(3,4)=max(C12(:))*100;
% 
% aDifferentNoteFromLibrary = imread([path '\expA2_1.png']);
% aDifferentNoteFromLibrary = rgb2gray(aDifferentNoteFromLibrary);
% C1 = normxcorr2(noteOfInterest,aDifferentNoteFromLibrary);
% sprintf('NW %0.5f %%',max(C1(:))*100); arr(4,1)=max(C1(:))*100;
% C2 = normxcorr2(noteOfInterest2,aDifferentNoteFromLibrary);
% sprintf('KS %0.5f %%',max(C2(:))*100); arr(4,2)=max(C2(:))*100;
% C3 = normxcorr2(noteOfInterest3,aDifferentNoteFromLibrary);
% sprintf('GT %0.5f %%',max(C3(:))*100); arr(4,3)=max(C3(:))*100;
% C4 = normxcorr2(noteOfInterest4,aDifferentNoteFromLibrary);
% sprintf('Pitsch %0.5f %%',max(C4(:))*100); arr(4,4)=max(C4(:))*100;
% aDifferentNoteFromLibrary = imread([path '\expA2_2.png']);
% aDifferentNoteFromLibrary = rgb2gray(aDifferentNoteFromLibrary);
% C5 = normxcorr2(noteOfInterest5,aDifferentNoteFromLibrary);
% sprintf('NW2 %0.5f %%',max(C5(:))*100); arr(5,1)=max(C5(:))*100;
% C6 = normxcorr2(noteOfInterest6,aDifferentNoteFromLibrary);
% sprintf('KS2 %0.5f %%',max(C6(:))*100); arr(5,2)=max(C6(:))*100;
% C7 = normxcorr2(noteOfInterest7,aDifferentNoteFromLibrary);
% sprintf('GT2 %0.5f %%',max(C7(:))*100); arr(5,3)=max(C7(:))*100;
% C8 = normxcorr2(noteOfInterest8,aDifferentNoteFromLibrary);
% sprintf('Pitsch2 %0.5f %%',max(C8(:))*100); arr(5,4)=max(C8(:))*100;
% aDifferentNoteFromLibrary = imread([path '\expA2_3.png']);
% aDifferentNoteFromLibrary = rgb2gray(aDifferentNoteFromLibrary);
% C9 = normxcorr2(noteOfInterest9,aDifferentNoteFromLibrary);
% sprintf('NW3 %0.5f %%',max(C9(:))*100); arr(6,1)=max(C9(:))*100;
% C10 = normxcorr2(noteOfInterest10,aDifferentNoteFromLibrary);
% sprintf('KS3 %0.5f %%',max(C10(:))*100); arr(6,2)=max(C10(:))*100;
% C11 = normxcorr2(noteOfInterest11,aDifferentNoteFromLibrary);
% sprintf('GT3 %0.5f %%',max(C11(:))*100); arr(6,3)=max(C11(:))*100;
% C12 = normxcorr2(noteOfInterest12,aDifferentNoteFromLibrary);
% sprintf('Pitsch3 %0.5f %%',max(C12(:))*100); arr(6,4)=max(C12(:))*100;

arr=[arr; mean(arr)];

T = array2table(arr,...
    'VariableNames',{'NW','KS','GT','Pitsch'},....
    'RowNames',{'A1_001' 'A1_011' 'A1_111','meanValue'})

writetable(T,[num2str(markerSize) '.txt'])

plot(categorical(T{1:4, 1}), T{1:4, 1:4});
legend(T.Properties.VariableNames(1:4));
xlabel('LandUse Types');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% differences

%%To be deleted before publishing!

a = imread([path '\GT_2.png']);
aa = imread([path '\exp_2.png']);

a2 = imresize(a,[500 500]); 
a3=rgb2gray(a2); % use if the image containing RGB value 3
figure;imshow(a3);

aa2 = imresize(aa,[500 500]); 
aa3=rgb2gray(aa2); % use if the image containing RGB value 3
figure;imshow(aa3);

difference_image = double(a3) - double(aa3);

absDiffImage=imabsdiff(a3,aa3); 
figure; 
imshow(absDiffImage,[]); 
colormap(jet); 
colorbar; 