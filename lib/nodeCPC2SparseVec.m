function sVec = nodeCPC2SparseVec( node, label )
% dVec = nodeCPC2SparseVec( node, label )
% Takes the cpc label and generates a sparse vector corresponding to the
% hierarchy of the label within the tree
%
% Arguments:
%   node    - The tree
%   label   - The CPC label 
%
% Author:   Navid Nourani-Vatani @ ACFR
% Version:  1.0 2013-08-01

verbose = false;
if verbose == true
    fprintf( 'Looking for %s\n', label );
end

% get total number of nodes 
numNodes = nodeGetNumNodes( node );

% create sparce vec. NOTE: rootNode is not counted here
sVec = zeros(numNodes-1, 1);

% get the node the label
nodeCurr = nodeAt( node, label );
if strcmpi( nodeCurr.name, 'rootNode' )
    return
end

nodePar  = nodeParent( node, nodeCurr.num );
if verbose == true
    fprintf( '%s is @ %d\n', nodeCurr.name, nodeCurr.num );
end

sVec(nodeCurr.num) = true;

while strcmpi( nodePar.name, 'rootNode' ) == 0

    nodeCurr = nodeAt( node, nodePar.name );
    nodePar  = nodeParent( node, nodeCurr.num );
    sVec(nodeCurr.num) = true;
end


