clearvars
close all
%% Load files
[file, folder] =  uigetfile('.xlsx','Select map','MultiSelect','on');
plateMaps = readtable([folder file]);
clearvars file folder
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

%%
tic
filelist = struct();
for f = 1:numel(file)
    well = extractBetween(file{f},'Well','_');
    well = well{:};
    [i, j] = find(contains(map_Idx,well));
    sample = map_sample{i,j};
    sample = strrep(sample,'+','_');
    sample = regexprep(sample,'\s+','');
    time = map_t{i,j};
    
    filelist(f).sourcefile = file{f};
    filelist(f).well = well;
    filelist(f).sample = sample;
    filelist(f).time = time;
end
clearvars -except folder filelist
filelist = struct2table(filelist);

%%
samplelist = unique(filelist.sample);

for s = 1:numel(samplelist)
    sampleidx = find(strcmp(filelist.sample, samplelist{s})==1);
    
    for n = 1:numel(sampleidx)
        fileidx = sampleidx(n);
        imfile = [folder filelist.sourcefile{fileidx}];
        im = bfopen(imfile);
        nPos  = size(im,1);
        [h, w] = size(im{1,1}{1,1});
        
        if ~contains(filelist.time(fileidx),'c')            
            prefix = filelist.sample{fileidx};
        else
            prefix = [filelist.sample{fileidx} '_control'];
        end
        
        DIC = [];
        iRFP = [];
        mCh = [];
        
        for p = 1:nPos
            
            DIC0 = im{p, 1}{1,1};
            DIC = horzcat([DIC DIC0]);
            iRFP0 = im{p, 1}{2,1};
            iRFP = horzcat([iRFP iRFP0]);
            mCh0 = im{p,1}{3,1};
            mCh = horzcat([mCh mCh0]);
            

        end
        imwrite(DIC,[folder 'SplitImages\' prefix '_DIC.tif'],'WriteMode','append');
        imwrite(iRFP,[folder 'SplitImages\' prefix '_iRFP.tif'],'WriteMode','append');
        imwrite(mCh,[folder 'SplitImages\' prefix '_mCh.tif'],'WriteMode','append');
    end
end
toc