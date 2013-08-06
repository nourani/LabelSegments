function [nodeNum nodeCurr nodeParent] = nodeAt( tree, label )
% [num node parent] = nodeGetNum( tree, label )
% Takes a tree and a label, finds it in the tree and returns its position,
% itself and its parent node
%
% Argument:
%   node        - The tree
%   label       - The cpc label, node name, or node number
%
% Returns:
%   num         - The node number
%   node        - The node itself
%   parent      - The node's parent node
%
% author:   Navid Nourani-Vatani @ ACFR
% version:  1.0 2013-08-02
verbose = false;
if verbose == true
    if isa( label, 'numeric' )
        fprintf( 'Looking for node %d\n', label )
    else
        fprintf( 'Looking for %s\n', label );
    end
end

nodeList = {};
nodeList{1} = tree;

nodeNum = 0;
nodeParent{1} = tree;
nodeParent{1}.name = '';
nodeParent{1}.labels = {};
nodeParent{1}.children = {};


found = false;
while ~isempty(nodeList) && ~found
    nodeCurr = nodeList{nodeNum+1};
    
    if verbose == true
        fprintf( '%2d - curr: %s - par: %s\n', ...
            nodeNum, nodeCurr.name, nodeParent{nodeNum+1}.name );
    end
    
    % is it a node number?
    if isa( label, 'numeric' )
        if nodeNum == label
            nodeParent = nodeParent{nodeNum+1};
            break
        end
    else
        % is it a node name?
        if strcmpi( label, nodeCurr.name )
            nodeParent = nodeParent{nodeNum+1};
            if verbose == true
                fprintf( 'FOUND %s @ %d\n', label, nodeNum );
            end
            break;
        end
        
        % is the label here?
        for i = 1:length(nodeCurr.labels)
            if strcmpi( label, nodeCurr.labels{i} )
                found = true;
                if verbose == true
                    fprintf( 'FOUND %s @ %d\n', label, nodeNum );
                end
                break;
            end
        end
    end
    
    if found
        nodeParent = nodeParent{nodeNum+1};
        break
    end
    
    for i = 1:length(nodeCurr.children)
        nodeList{end+1} = nodeCurr.children{i};
        nodeParent{end+1} = nodeCurr;
    end
    
    nodeNum = nodeNum + 1;
end




end
