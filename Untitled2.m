clearvars
close all
%% Load plate map
[file, folder] =  uigetfile('.xlsx','Select map','MultiSelect','on');
plateMap = readtable([folder file]);
clearvars file folder

map_sample = table2cell(plateMap(13:20,1:12));
map_primer = table2cell(plateMap(35:42,1:12));

R = {'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H'};
C = num2cell(1:12);
C = cellfun(@(x) sprintf('%02d',x),C,'UniformOutput',false);
C = string(C);
[c, r] = ndgrid(1:numel(C),1:numel(R));

map_Idx = [C(c(:)).' R(r(:)).'];
map_Idx = join(map_Idx);
map_Idx = 

%% Load sequence files
[file, folder] = uigetfile('.ab1','Select images','MultiSelect','on');

if ischar(file)==1
    file = {file};
end


tic
filelist = struct();
for f = 1:numel(file)
    filename = file{f}
    well = regexp(filename,'_\d{2}\w_','match')
    
    well = regexp(x,'_\d{2}\w_','match')
    well = extractBetween(file{f},'Well','_');
    well = well{:};
    [i, j] = find(contains(map_Idx,well));
    sample = map_sample{i,j};
    sample = strrep(sample,'+','_');
    sample = regexprep(sample,'\s+','');
    time = map_primer{i,j};
    
    filelist(f).sourcefilename = file{f};
    filelist(f).well = well;
    filelist(f).sample = sample;
    filelist(f).time = time;
end

%%


% clearvars file folder
map_Idx = table2cell(plateMap(3:10,1:12));
x = '15322_jkashjbcjh_01A_1.ab1'
x2 = regexp(x,'_\d{2}\w_','match')
return
%%
map_Idx = table2cell(plateMaps(3:10,1:12));
map_sample = table2cell(plateMaps(13:20,1:12));
map_t = table2cell(plateMaps(35:42,1:12));
% [i, j] = find(contains(map_Idx,'D12'));


%% Load images
[file, folder] = uigetfile('.nd2','Select images','MultiSelect','on');

if ischar(file)==1
    file = {file};
end




clearvars
%% Create well name combos
R = {'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H'};
C = num2cell(1:12);
C = cellfun(@(x) sprintf('%02d',x),C,'UniformOutput',false);
C = string(C);
[c, r] = ndgrid(1:numel(C),1:numel(R));

map_wellName = [C(c(:)).' R(r(:)).'];
map_wellName = join(map_wellName);

wellNames = [R(r(:)).' C(c(:)).'];
wellNames = join(wellNames);
wellNames = strrep(wellNames,' ','');

wellMap = reshape(wellNames,12,8)';



%%

[file, folder] =  uigetfile('.ab1','Select sequence files','MultiSelect','on');

if ischar(file)==1
    file = {file};
end
f = 1;
sourceFile = file{f};
sourceFileName = extractBefore(sourceFile,'.ab1');
sourceFileWell = regexprep(sample,'\s+','')


%%
idx = find(strcmp(well,rawdata{:,1}));
renameSequenceFiles.m
Displaying renameSequenceFiles.m.