function f = imag(f)
%IMAG   Imaginary part of a CHEBTECH.
%   IMAG(F) is the imaginary part of F.
%
% See also REAL, ISREAL, CONJ.

% Copyright 2013 by The University of Oxford and The Chebfun Developers. 
% See http://www.chebfun.org for Chebfun information.

if ( ~any(f.coeffs(:)) )
    % Input was real, so output a zero CHEBTECH:
    f = f.make(zeros(1, size(f.coeffs, 2)), 0, f.hscale);
    f.ishappy = 1;
else
    % Compute imaginary part of the coefficients:
    f.coeffs = imag(f.coeffs);
end
f = simplify(f); 
f.vscale = getvscl(f); 
end
