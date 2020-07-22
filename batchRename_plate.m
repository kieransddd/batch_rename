clearvars
close all
%%
% This script renames selected sequence files for samples submitted on a
% 96-well plate based on information stored in an Excel file. To use:

% 1. Run script and select Excel file containing sample list at first
% prompt. File should contain plate maps showing well locations of template
% DNA and primer.

% 2. Select sequence files (.ab1) to be renamed

% 3. Script will create copy of each '.ab1' file with each filename having
% the structure 'Well_templateDNA_primerNumber.ab1'

% 4. Sanity check that the filenames and file sizes make sense

%% Load plate map

[file, folder] =  uigetfile('.xlsx','Select plate map','MultiSelect','on');
opts = detectImportOptions([folder file]);
plateMap = readtable([folder file],opts);
clearvars file folder
map_DNA = table2cell(plateMap(2:9,2:13)); % Select which wells contain the template DNA map
map_primer = table2cell(plateMap(12:19,2:13)); % Select which wells contain the primer map

%% Build map of 96-well plate locations
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
[file, folder] = uigetfile('.ab1','Select sequence files','MultiSelect','on');

if ischar(file)==1
    file = {file};
end

%%
filelist = struct();
for f = 1:numel(file)
    filenameIn = file{f};
    [~, ~, ext] = fileparts(filenameIn);
    i = [];
    j = [];
    
    % Find and tidy up well info
    well = regexp(filenameIn,'_\d{2}\w_','match');
    well = strrep(well,'_','');
    
    % Find 96-well plate location for given sample
    [i, j] = find(contains(map_Idx,well));
    
    % Find and tidy up DNA info
    DNA = map_DNA(i,j);
    DNA = regexprep(DNA,'(\\|\/)','-');
    DNA = regexprep(DNA,'[~()]','');
    DNA = regexprep(DNA,' ','_');
    primer = map_primer(i,j);
    
    % Reformat well name
    c = regexp(well,'\d{2}','match');
    r = regexp(well,'\D','match');
    well = join([r{:} c{:}]);
    well = strrep(well,' ','');
    
    % If given '.ab1' file exists for sample, save copy with new name
    if ~isempty(DNA{:})
        filenameOut = [well{:} '_' DNA{:} '_' primer{:} ext];
        copyfile([folder filenameIn],[folder filenameOut ext])
    end
end
