%% Using the UCM segmentation to manually label the segments

addpath(fullfile(pwd,'lib'));

%clear all; 
clc;

% imgNames = {'PR_20081008_011127_170_LC16_small.png'; ... % rock
%     'PR_20081007_233421_375_LC16_small.png'; ... % rock sponge
%     'PR_20081007_230403_124_LC16_small.png'; ... % kelp
%     'PR_20081007_230411_127_LC16_small.png'; % kelp rock
%     };
% Get image names
dirCont = dir( '/Volumes/data/Hierarchical/images/PR_*LC16.png' );

% load cpc labels
fid = fopen( '~/Dropbox/Datasets/ACFR_TASSIE2008_DATASET/keypointdata.csv' );
CPC = textscan( fid, ...
    '%*s %*s %s %d %f %f %s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s',  ...
    'Delimiter', ',', ...
    'CommentStyle', '#');
fclose(fid);

% load tree structure
nodeDef;

%%
imgInd = 1;

while imgInd >= 1 && imgInd < size(dirCont,1)
    
    imgName = dirCont(imgInd).name(1:end-4);
    imgFile = ['/Volumes/data/Hierarchical/images/', imgName, '.png'];
    ucmFile = ['/Volumes/data/Hierarchical/ucm/', imgName, '.mat'];
    outFile = ['data/', imgName, '_gPb.mat'];
    
    %% Load image and ucm
    im = double(imread( imgFile ))/255;
    
    %load double sized ucm
    load(ucmFile,'ucm2');
    
    %% Interactive labelling
    
    % load object annotations (none exist yet)
    obj_names = {}; 
    
    [sy, sx, ~] = size(im);
    seeds = zeros(sy, sx);
    
    seeds(100, 100) = 3;
    seeds(200, 100) = 2;
    seeds(300, 100) = 1;
    
    obj_names = {'three', 'two', 'one'};
    
    
%     labels = {};
%     labelsNum = [];
%     xs = [];
%     ys = [];
%     % find the image index
%     for i = 1:size(CPC{1},1)
%         if strfind(CPC{1}{i}, imgName)
%           break
%         end
%     end
%     % get the labels
%     for j = i:i+54
%         if j > size(CPC{1},1), break; end
%         x = CPC{3}(j);
%         y = CPC{4}(j);
%         label = CPC{5}{j};
%         switch(label)
%             case 'ID'
%             case 'RUG'
%             case 'SUB'
%             case 'SLOPE'
%             case 'SIZE'
%             otherwise
%                 xs = [xs; x];
%                 ys = [ys; y];
%                 labels{end+1} = label;
%                 labelsNum = [labelsNum; nodeAt( rootNode, label )];
%                 seeds( uint16(y*sy), uint16(x*sx) ) = nodeAt( rootNode, label );
%         
%         end    
%     end
    % sort
%     [labelsNum, Ix] = sort(labelsNum);
%     for i = 1:length(Ix)
%         seeds( uint16(ys(Ix(i))*sy), uint16(xs(Ix(i))*sx) ) = labelsNum(Ix(i));
%         obj_names{end+1} = labels{Ix(i)};
%     end
%     obj_names = labels;
    
    
    % run interactive segmentation gui
    % return updated seeds and object names
    % also return last button clicked either 'prev' or 'next'
    [seeds obj_names seg action] = interactive_segmentation( ...
        im, ucm2, seeds, obj_names);
    
    if strcmpi(action, 'next')
        imgInd = imgInd+1;
    else
        imgInd = imgInd-1;
    end
    
end

fprintf( 'Labeling Ended\n' )
