clearvars
close all
%% Load plate map
[file, folder] =  uigetfile('.xlsx','Select map','MultiSelect','on');
opts = detectImportOptions([folder file]);
plateMap = readtable([folder file],opts);
clearvars file folder

%% Extract plate maps from file
map_sample = table2cell(plateMap(2:9,2:13));
map_primer = table2cell(plateMap(14:21,2:13));

%% Build well location map
R = {'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H'};
C = num2cell(1:12);
C = cellfun(@(x) sprintf('%02d',x),C,'UniformOutput',false);
C = string(C);
[c, r] = ndgrid(1:numel(C),1:numel(R));

map_Idx = [C(c(:)).' R(r(:)).'];
map_Idx = join(map_Idx);
map_Idx = strrep(map_Idx,' ','');
map_Idx = reshape(map_Idx,12,8)';

%% Load sequence files
[file, folder] = uigetfile('.ab1','Select images','MultiSelect','on');

if ischar(file)==1
    file = {file};
end

%%
filelist = struct();
for f = 1:numel(file)
    filenameIn = file{f};
    [~, ~, ext] = fileparts(filenameIn);
    well = regexp(filenameIn,'_\d{2}\w_','match');
    well = strrep(well,'_','');
    [i, j] = find(contains(map_Idx,well));
    
    sample = map_sample(i,j);
    sample = regexprep(sample,'(\\|\/)','-');
    sample = regexprep(sample,'[~()]','');
    sample = regexprep(sample,' ','_');
    primer = map_primer(i,j);
    
    % Reformat well name
    c = regexp(well,'\d{2}','match');
    r = regexp(well,'\D','match');
    well = join([r{:} c{:}]);
    well = strrep(well,' ','');    
    
    filenameOut = [well{:} '_' sample{:} '_' primer{:} ext];
    
    copyfile([folder filenameIn],[folder filenameOut ext])
end
% movefile(files(id).name, sprintf('%03d.pdf', num));