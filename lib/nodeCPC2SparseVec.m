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

verbose = true;
if verbose == true
    fprintf( 'Looking for %s\n', label );
end

% get total number of nodes 
numNodes = nodeGetNumNodes( node );

% create sparce vec. NOTE: rootNode is not counted here
sVec = zeros(numNodes-1, 1);

% get the node number for the label
[nodeNum, nodeCurr, nodePar] = nodeAt( node, label );
sVec(nodeNum) = true;
if verbose == true
    fprintf( '%s is @ %d, Parent = %s\n', nodeCurr.name, nodeNum, nodePar.name );
end

while strcmpi( nodePar.name, 'rootNode' ) == 0

    [nodeNum, nodeCurr, nodePar] = nodeAt( node, nodePar.name );
    sVec(nodeNum) = true;
    if verbose == true
        fprintf( '%s is @ %d, Parent = %s\n', nodeCurr.name, nodeNum, nodePar.name );
    end
end


