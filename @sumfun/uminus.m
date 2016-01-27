function f = uminus(f)
%UMINUS   Unary minus of a SINGFUN.
%   UMINUS(F) is the negative of F.
%
% See also UPLUS, MINUS.

% Copyright 2015 by The University of Oxford and The Chebfun Developers. 
% See http://www.chebfun.org/ for Chebfun information.

% Negate the smooth part:
f.funs = cellfun(@uminus, f.funs, 'UniformOutput', false);

end
