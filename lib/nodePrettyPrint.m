function nodePrettyPrint(node, depth)
% nodePrettyPrint( node, depth )
%
% Print the tree in text form
% Arguments:
%   node    -   The tree
%   depth   -   The tabbing depth (optional)
%
% Author:   Navid Nourani-Vatani @ ACFR
% Version:  1.0 2013-08-01

if nargin == 1
    depth = 0;
end

% node name
for i = 0:depth
    fprintf('\t');
end
fprintf( '%s\n', node.name );

% cpc labels
for i = 0:depth
    fprintf('\t');
end
fprintf( ' CPC: <' );
for i =  1:size(node.labels,1)
    fprintf( '%s', node.labels{i} )
    if i < size(node.labels,1)
        fprintf( ', ')
    end
end
fprintf( '>\n' );

for i = 1:size(node.children,1)
    nodePrettyPrint(node.children{i}, depth+1);
end

end
