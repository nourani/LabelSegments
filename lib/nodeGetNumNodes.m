function nodeNum = nodeGetNumNodes( node, nodeNum )
% nodeNum = nodeGetNumNodes( node, nodeNum )
% Takes a tree and calculates the number of nodes
%
% Argument:
%   node        - The tree
%   nodeNum     - The currect node number (0 for root node) [optional]
%
% author:   Navid Nourani-Vatani @ ACFR
% version:  1.0 2013-08-02

if nargin == 1
    nodeNum = 1;
end
%fprintf( '%s: %d\n', node.name, nodeNum );
for i = 1:length(node.children)
    nodeNum = nodeGetNumNodes(node.children{i}, nodeNum+1);
end
end
