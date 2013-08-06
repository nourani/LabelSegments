function label = nodeSparseVec2CPC( node, sVec )
% label = nodeSparseVec2CPC( node, sVec )
% Takes the sparse vector and finds the CPC label corresponding to the
% hierarchy of the label within the tree
%
% Arguments:
%   node    - The tree
%   sVec    - The sparse vector
%
% Returns:
%   label   - The CPC label 
%
% Author:   Navid Nourani-Vatani 
% Version:  1.0 2013-08-02

verbose = true;

i = find( sVec == 1, 1, 'last' );
if verbose == true
    fprintf( 'Looking for node %d\n', i )
end

numNodes = nodeGetNumNodes( node );
if i > numNodes
    error( 'requesting a node outside of tree' )
end

[~, node, ~] = nodeAt( node, i );

if isempty(node.labels)
    warning( 'nodeSparseVec2CPC', 'requested node has no CPC label' )
end

label = node.labels;
