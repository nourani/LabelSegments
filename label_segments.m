%% Using the UCM segmentation to manually label the segments

if ~isdeployed
    addpath('lib/')
end

clear all;
clc;

% User choices
% /Volumes/data/Hierarchical
imgDir  = './data/images';
ucmDir  = './data/ucm';
outDir  = './data/segments';
cpcFile = './keypointdata.csv';
useCPCLabels = false;

if ~exist( outDir, 'dir' ) && ~mkdir( outDir )
    warning( 'label_segments:create_dir', 'Failed to create output dir' );
end

%%
% Get image names
dirCont = dir( [imgDir, '/*LC16.png'] );
fprintf( 'Starting segment labeling with %d images\n', length(dirCont) );

% load cpc labels
if useCPCLabels == true
    fid = fopen( cpcFile );
    CPC = textscan( fid, ...
        '%*s %*s %s %d %f %f %s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s',  ...
        'Delimiter', ',', ...
        'CommentStyle', '#');
    fclose(fid);
end

% load tree structure
tree = nodeDef();

% load object annotations from the tree
obj_names = cell(nodeGetNumNodes(tree)-1,1);
for i = 1:length(obj_names)
    node = nodeAt(tree,i);
    s = strfind(node.name, '_');
    n = '';
    for j = 1:node.level-1
        n = [n, '   ']; % three spaces for each level
    end
    obj_names{i} = [n, int2str(node.num), ') ', node.name(s(end)+1:end)];
end

%%
imgInd = 1;
%rng( 'shuffle' )
while imgInd >= 1 && imgInd < size(dirCont,1)
    %imgInd = randi(size(dirCont,1), 1);
    
    fprintf( 'Loading image # %d\n', imgInd );
    
    imgName = dirCont(imgInd).name(1:end-4);
    imgFile = [imgDir, '/', imgName, '.png'];
    ucmFile = [ucmDir, '/', imgName, '.mat'];
    outFile = [outDir, '/', imgName, '_seeds.mat'];
    
    %% Load image and ucm
    im = double(imread( imgFile ))/255;
    
    %load double sized ucm
    load(ucmFile,'ucm2');
    
    %% Interactive labelling
    
    [sy, sx, ~] = size(im);
    seeds = zeros(sy, sx);
    
    if useCPCLabels == true
        labels = {};
        labelsNum = [];
        xs = [];
        ys = [];
        % find the image index
        for i = 1:size(CPC{1},1)
            if strfind(CPC{1}{i}, imgName)
                break
            end
        end
        % get the labels
        for j = i:i+54
            if j > size(CPC{1},1), break; end
            x = CPC{3}(j);
            y = CPC{4}(j);
            label = CPC{5}{j};
            switch(label)
                case 'ID'
                case 'RUG'
                case 'SUB'
                case 'SLOPE'
                case 'SIZE'
                otherwise
                    %xs = [xs; x];
                    %ys = [ys; y];
                    %labels{end+1} = label;
                    %labelsNum = [labelsNum; nodeAt( rootNode, label )];
                    node = nodeAt( tree, label );
                    seeds(ceil(y*sy), ceil(x*sx)) = node.num;
            end
        end
    elseif exist( outFile, 'file' )
        load( outFile );
    end
    
    % run interactive segmentation gui
    % return updated seeds and object names
    % also return last button clicked either 'prev' or 'next'
    [seeds, ~, seg, action] = interactive_segmentation( obj_names, ...
        im, ucm2, seeds, imgName);
    
    % discard changes and exit
    if strcmp(action, 'exit'), break; end
    % save
    if true == true
        outFile = [outDir, '/', imgName, '_seeds.mat'];
        if exist( outFile, 'file' )
            uisave('seeds_ret', outFile);
        else
            save( outFile, 'seeds' );
        end
        outFile = [outDir, '/', imgName, '_seg.mat'];
        if exist( outFile, 'file' )
            uisave('seg', outFile)
        else
            save( outFile, 'seg' );
        end
        fprintf( 'Saving labels for image # %d\n', imgInd );
    else
        warning( 'LabelSegments:Saving','File save skipped!' );
    end
    % next action
    if strcmpi(action, 'next')
        imgInd = imgInd+1;
    elseif strcmp(action, 'prev')
        imgInd = imgInd-1;
    else
        break;
    end
    
end

fprintf( 'Labeling Ended\n' )

if isdeployed
    exit
end

%% Cool images
% 429
