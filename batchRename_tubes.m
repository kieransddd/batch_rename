clearvars
close all
%% Instructions
% This script renames selected sequence files based on information stored
% in an Excel file. To use:

% 1. Run script and select Excel file containing sample list at first prompt
% File should contain columns for tube number, template DNA, and primer
% 2. Select sequence files (.ab1) to be renamed
% 3. Script will create copy of each file with filename as follows
% 'TubeNumber_DNA_primer.ab1'
% 4. Sanity check that the filenames and file sizes make sense

%% Load tube map
[file, folder] =  uigetfile('.xlsx','Select map','MultiSelect','on');
opts = detectImportOptions([folder file]);
plateMap = readtable([folder file],opts);
clearvars file folder

map_tube = table2cell(plateMap(:,1)); 
map_DNA = table2cell(plateMap(:,2));
map_primer = table2cell(plateMap(:,3));

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
    
    % Find and tidy up tube numbers
    tube = regexp(filenameIn,['_\d*' ext],'match');
    tube = regexprep(tube,ext,'');
    tube = regexprep(tube,'_','');
    tube = str2double(tube);
    idx = find([map_tube{:}] == tube);    
    
    % Find and tidy up template DNA info
    DNA = map_DNA(idx);
    DNA = regexprep(DNA,'(\\|\/)','-');
    DNA = regexprep(DNA,'[~()]','');
    DNA = regexprep(DNA,' ','_');
    primer = map_primer(idx);
    
    % If given '.ab1' file exists for sample, save copy with new name
    if ~isempty(DNA{:})
        filenameOut = [num2str(tube) '_' DNA{:} '_' primer{:} ext];
        copyfile([folder filenameIn],[folder filenameOut ext])
    end
end
