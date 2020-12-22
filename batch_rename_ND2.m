clearvars; close all; clc
%% Set params
use_plate_map = true;
plateDim = [8, 12];
sheet = 'plate_map';
   
%% Load plate map
if use_plate_map==true
    [file, folder] =  uigetfile('.xlsx','Select plate map','MultiSelect','on');
    opts = detectImportOptions([folder file]);
    opts = setvartype(opts, 'char');
    opts.DataRange = 'A1';
    opts.Sheet = sheet;
    plate_map_raw = readtable([folder file], opts);
else
    folder = pwd;
end

%% Load ND2 files
sheet = 'Sheet2';
[file, folder] =  uigetfile([folder '.ND2'],'Select ND2 files','MultiSelect','on');

%% Create well name combos
R = {'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H'};
C = num2cell(1:12);
C = cellfun(@(x) sprintf('%02d',x),C,'UniformOutput',false);
C = string(C);
[c, r] = ndgrid(1:numel(C),1:numel(R));

well_list = [R(r(:)).' C(c(:)).'];
well_list = join(well_list);
well_list = strrep(well_list,' ','');
map.well = reshape(well_list,12,8)';

% Correct for plate dimension
map.well = map.well(1:plateDim(1),1:plateDim(2));
well_list = reshape(map.well',plateDim(1)*plateDim(2),1);

%% Add labels from plate map
if use_plate_map==1
    label_list = regexp(plate_map_raw{:,:},'map_\w*','match');
    label_list = string(label_list(~cellfun('isempty',label_list)));
    
    for n = 1:numel(label_list)
        label = label_list{n};
        [w, kc] = find(strcmp(label,plate_map_raw{:,:}));
        w = w+1:w+plateDim(1);
        kc = kc+1:kc+plateDim(2);
        label = erase(label,'map_');
        map.(label) = string(plate_map_raw{w,kc});
    end
else
    map.sample = map.well;
end

for f = 1:numel(file)
    filename_in = file{f}; 
    [~, ~, ext] = fileparts(filename_in);
    
    % Find well
    well = regexp(filename_in,'((?<=Well).*?(?=_))','match');        
    [i, j] = find(contains(map.well,well));
    
    % Set output filename (edit this as needed)
    filename_out = strcat("20201221","_Well",map.well(i,j),"_",map.strain(i,j),"_",map.plasmid(i,j),"_R",map.replicate(i,j),ext);
    filename_out = string(regexprep(filename_out,'(','_'));
    filename_out = string(regexprep(filename_out,'\|','-'));
    filename_out = string(regexprep(filename_out,')',''));

    
    copyfile(fullfile(folder,filename_in),fullfile(folder,filename_out));
end

