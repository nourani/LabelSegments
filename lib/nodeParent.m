function nodeParent = nodeParent( tree, label )
% parent = nodeParent( tree, label )
% Takes a tree and a label, finds the parent node in the tree and returns
%
% Argument:
%   node        - The tree
%   label       - The cpc label, node name, or node number
%
% Returns:
%   node        - The parent node
%
% author:   Navid Nourani-Vatani @ ACFR
% version:  1.0 2013-08-15
       
verbose = false;
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
        fprintf( '%2d - curr: %s\n', ...
            nodeCurr.num, nodeCurr.name );
    end
    
    % is it a node number?
    if isa( label, 'numeric' )
        if nodeCurr.num == label
            nodeParent = nodeParent{nodeNum+1};
            break
        end
    else
        % is it a node name?
        if strcmpi( label, nodeCurr.name )
            nodeParent = nodeParent{nodeNum+1};
            break;
        end
        
        % is the label here?
        for i = 1:length(nodeCurr.labels)
            if strcmpi( label, nodeCurr.labels{i} )
                found = true;
                break;
            end
        end
    end
    
    if found
        nodeParent = nodeParent{nodeNum+1};
        return
    end
    
    for i = 1:length(nodeCurr.children)
        nodeList{end+1} = nodeCurr.children{i};
        nodeParent{end+1} = nodeCurr;
    end
    
    nodeNum = nodeNum + 1;
end




end
