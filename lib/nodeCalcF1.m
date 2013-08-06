function f1 = nodeCalcF1( gt, est )
% f1 = nodeCalcF1( gt, est )
% Calculates the hierarchical f1-score by comparing a grount truth sparse
% matrix label structure to an estimated sparse matrix
%
% Arguments:
%   gt      - Ground truth sparse matrix
%   est     - Estimated sparse matrix
%
% Returns:
%   f1      - Hierarchical f1-score
%
% Author:   Navid Nourani-Vatani
% Version:  1.0 2013-08-02


tp = sum( and(gt, est) );
fpfn = sum( xor(gt, est) );

f1 = 2*tp / (2*tp+fpfn);

end
