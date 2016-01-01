function coeffs = computeCoeffs(K, dt, L, LR, S)
%COMPUTECOEFFS   Compute coefficients of a SPINSCHEME.
%   COEFFS = COMPUTECOEFFS(K, DT, L, LR, S) computes the coefficients needed by  
%   the SPINSCHEME K from the timestep DT, the linear part L, the linear part 
%   for complex means LR, and the SPINOP S.

% Copyright 2016 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org/ for Chebfun information.

% Set-up:
s = K.internalStages;
q = K.steps;
dim = S.dimension;
nVars = S.numVars;
schemeName = K.scheme;
A = cell(s);
B = cell(s, 1);
C = zeros(s, 1);
U = cell(s, q-1);
V = cell(q-1, 1);
phit = cell(s);
N = size(L, 1)/nVars;

% Compute the first three phi-functions (needed by all schemes):
phi1 = spinscheme.phiEval(1, LR, N, dim, nVars);
phi2 = spinscheme.phiEval(2, LR, N, dim, nVars);
phi3 = spinscheme.phiEval(3, LR, N, dim, nVars);

% Take real part for diffusive problems (real eigenvalues):
if ( isreal(L) == 1 )
    phi1 = real(phi1);
    phi2 = real(phi2);
    phi3 = real(phi3);
end
   
if ( strcmpi(schemeName, 'eglm433') == 1 )
    
    % Compute C:
    C(1) = 0;
    C(2) = 1/2;
    C(3) = 1;
    
    % Compute the phi functions:
    phi4 = spinscheme.phiEval(4, LR, N, dim, nVars);
    phi5 = spinscheme.phiEval(5, LR, N, dim, nVars);
    phit{1,2} = spinscheme.phitEval(1, C(2), LR, N, dim, nVars);
    phit{1,3} = spinscheme.phitEval(1, C(3), LR, N, dim, nVars);
    phit{2,2} = spinscheme.phitEval(2, C(2), LR, N, dim, nVars);
    phit{3,2} = spinscheme.phitEval(3, C(2), LR, N, dim, nVars);
    
    % Take real part fo diffusive problems (real eigenvalues):
    if ( isreal(L) == 1 )
        phi4 = real(phi4);
        phi5 = real(phi5);
        phit = cellfun(@(f) real(f), phit, 'UniformOutput', 0);
    end
    
    % Compute A:
    A{3,2} = 16/15*phi2 + 16/5*phi3 + 16/5*phi4;
    
    % Compute B:
    B{2} = 32/15*(phi2 + phi3) - 64/5*phi4 - 128/5*phi5;
    B{3} = -1/3*phi2 + 1/3*phi3 + 5*phi4 + 8*phi5;
    
    % Compute U:
    U{2,1} = -2*(phit{2,2} + phit{3,2});
    U{3,1} = -2/3*phi2 + 2*phi3 + 4*phi4;
    U{2,2} = 1/2*phit{2,2} + phit{3,2};
    U{3,2} = 1/10*phi2 - 1/5*phi3 - 6/5*phi4;
    
    % Compute V:
    V{1} = -1/3*phi2 + 5/3*phi3 - phi4 - 8*phi5;
    V{2} = 1/30*phi2 - 2/15*phi3 - 1/5*phi4 + 8/5*phi5;
    
elseif ( strcmpi(schemeName, 'etdrk4') == 1 )
        
    % Compute C:
    C(1) = 0;
    C(2) = 1/2;
    C(3) = 1/2;
    C(4) = 1;
    
    % Compute the phi functions:
    phit{1,2} = spinscheme.phitEval(1, C(2), LR, N, dim, nVars);
    phit{1,3} = spinscheme.phitEval(1, C(3), LR, N, dim, nVars);
    phit{1,4} = spinscheme.phitEval(1, C(4), LR, N, dim, nVars);
    
    % Take real part fo diffusive problems (real eigenvalues):
    if ( isreal(L) == 1 )
        phit = cellfun(@(f) real(f), phit, 'UniformOutput', 0);
    end
    
    % Compute A:
    A{3,2} = phit{1,2};
    A{4,3} = 2*phit{1,2};
    
    % Compute B:
    B{2} = 2*phi2 - 4*phi3;
    B{3} = 2*phi2 - 4*phi3;
    B{4} = -phi2 + 4*phi3;

elseif ( strcmpi(schemeName, 'exprk5s8') == 1 ) 
    
    % Compute C:
    C(1) = 0;
    C(2) = 1/2;
    C(3) = 1/2;
    C(4) = 1/4;
    C(5) = 1/2;
    C(6) = 1/5;
    C(7) = 2/3;
    C(8) = 1;
    
    % Compute the phi functions:
    phi4 = spinscheme.phiEval(4, LR, N, dim, nVars);
    phit{1,2} = spinscheme.phitEval(1, C(2), LR, N, dim, nVars);
    phit{1,3} = phit{1,2};
    phit{1,4} = spinscheme.phitEval(1, C(4), LR, N, dim, nVars);
    phit{1,5} = phit{1,2};
    phit{1,6} = spinscheme.phitEval(1, C(6), LR, N, dim, nVars);
    phit{1,7} = spinscheme.phitEval(1, C(7), LR, N, dim, nVars);
    phit{1,8} = phi1;
    phit{2,2} = spinscheme.phitEval(2, C(2), LR, N, dim, nVars);
    phit{2,4} = spinscheme.phitEval(2, C(4), LR, N, dim, nVars);
    phit{2,6} = spinscheme.phitEval(2, C(6), LR, N, dim, nVars);
    phit{2,7} = spinscheme.phitEval(2, C(7), LR, N, dim, nVars);
    phit{3,2} = spinscheme.phitEval(3, C(2), LR, N, dim, nVars);
    phit{3,6} = spinscheme.phitEval(3, C(6), LR, N, dim, nVars);
    phit{3,7} = spinscheme.phitEval(3, C(7), LR, N, dim, nVars);
    phit{4,6} = spinscheme.phitEval(4, C(6), LR, N, dim, nVars);
    phit{4,7} = spinscheme.phitEval(4, C(7), LR, N, dim, nVars);
    
    % Take real part fo diffusive problems (real eigenvalues):
    if ( isreal(L) == 1 )
        phi4 = real(phi4);
        phit = cellfun(@(f) real(f), phit, 'UniformOutput', 0);
    end
    
    % Compute A:
    A{3,2} = 2*phit{2,2};
    A{4,3} = 2*phit{2,4};
    A{5,3} = -2*phit{2,2} + 16*phit{3,2};
    A{5,4} = 8*phit{2,2} - 32*phit{3,2};
    A{6,4} = 8*phit{2,6} - 32*phit{3,6};
    A{7,4} = -(125/162)*A{6,4};
    A{6,5} = -2*phit{2,6} + 16*phit{3,6};
    A{7,5} = (125/1944)*A{6,4} - (4/3)*phit{2,7} + (40/3)*phit{3,7};
    Phi = (5/32)*A{6,4} - (25/28)*phit{2,6} + (81/175)*phit{2,7} - ...
        (162/25)*phit{3,7} + (150/7)*phit{4,6} + (972/35)*phit{4,7} + 6*phi4;
    A{8,5} = -(16/3)*phi2 + (208/3)*phi3 - 40*Phi;
    A{7,6} = (3125/3888)*A{6,4} + (25/3)*phit{2,7} - (100/3)*phit{3,7};
    A{8,6} = (250/21)*phi2 - (250/3)*phi3 + (250/7)*Phi;
    A{8,7} = (27/14)*phi2 - 27*phi3 + (135/7)*Phi;
    
    % Compute B:
    B{6} = (125/14)*phi2 - (625/14)*phi3 + (1125/14)*phi4;
    B{7} = -(27/14)*phi2 + (162/7)*phi3 - (405/7)*phi4;
    B{8} = (1/2)*phi2 - (13/2)*phi3 + (45/2)*phi4;

elseif ( strcmpi(schemeName, 'krogstad') == 1 )
    
    % Compute C:
    C(1) = 0;
    C(2) = 1/2;
    C(3) = 1/2;
    C(4) = 1;
    
    % Compute the phi functions:
    phit{1,2} = spinscheme.phitEval(1, C(2), LR, N, dim, nVars);
    phit{1,3} = spinscheme.phitEval(1, C(3), LR, N, dim, nVars);
    phit{1,4} = spinscheme.phitEval(1, C(4), LR, N, dim, nVars);
    phit{2,2} = spinscheme.phitEval(2, C(2), LR, N, dim, nVars);
    
    % Take real part fo diffusive problems (real eigenvalues):
    if ( isreal(L) == 1 )
        phit = cellfun(@(f) real(f), phit, 'UniformOutput', 0);
    end
    
    % Compute A:
    A{3,2} = 4*phit{2,2};
    A{4,3} = 2*phi2;
    
    % Compute B:
    B{2} = 2*phi2 - 4*phi3;
    B{3} = 2*phi2 - 4*phi3;
    B{4} = -phi2 + 4*phi3;

elseif ( strcmpi(schemeName, 'pecec433') == 1 )
    
    % Compute C:
    C(1) = 0;
    C(2) = 1;
    C(3) = 1;
    
    % Compute the phi- and phit-functions:
    phi4 = spinscheme.phiEval(4, LR, N, dim, nVars);
    phit{1,2} = spinscheme.phitEval(1, C(2), LR, N, dim, nVars);
    phit{1,3} = spinscheme.phitEval(1, C(3), LR, N, dim, nVars);
    
    % Take real part for diffusive problems (real eigenvalues):
    if ( isreal(L) == 1 )
        phi4 = real(phi4);
        phit = cellfun(@(f) real(f), phit, 'UniformOutput', 0);
    end
    
    % Compute A:
    A{3,2} = 1/3*phi2 + phi3 + phi4;
    
    % Compute B:
    B{3} = 1/3*phi2 + phi3 + phi4;
    
    % Compute U:
    U{2,1} = -2*phi2 - 2*phi3;
    U{3,1} = -phi2 + phi3 + 3*phi4;
    U{2,2} = 1/2*phi2 + phi3;
    U{3,2} = 1/6*phi2 - phi4;
    
    % Compute V:
    V{1} = -phi2 + phi3 + 3*phi4;
    V{2} = 1/6*phi2 - phi4;

end

% PUT everything in COEFFS:
coeffs.A = A;
coeffs.B = B;
coeffs.C = C;
coeffs.U = U;
coeffs.V = V;

% Compute the missing oefficients using the summation properties of the coeffs:
coeffs = computeMissingCoeffs(K, L, coeffs, dt, phi1, phit);

end

function coeffs = computeMissingCoeffs(K, L, coeffs, dt, phi1, phit)
%COMPUTEMISSINGCOEFFS   Compute the missing oefficients of a SPINSCHEME using 
%the summation properties of the coefficients.
%   COEFFS = COMPUTEMISSINGCOEFFS(K, L, COEFFS, DT, PHI1, PHIT) uses the row 
%   summation properties to compute the COEFFS.A{I,1}, COEFFS.B{1} and COEFFS.E
%   coefficients of the SPINSCHEME K, using the linear part L of the opeartor, 
%   the PHI1 and PHIT functions, and the timestep DT.

% Copyright 2016 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org/ for Chebfun information.

% Get the coefficients:
A = coeffs.A;
B = coeffs.B; 
C = coeffs.C;
U = coeffs.U;
V = coeffs.V;

% Number of internal stages S and number of steps used Q:
s = K.internalStages;
q = K.steps;

% Precompute the coefficients Ai1 using the row summing property.
for i = 2:s
    A{i,1} = phit{1,i};
    for j = 2:i-1
        if ( ~isempty(A{i,j}) )
            A{i,1} = A{i,1} - A{i,j};
        end
    end
    for j = 1:q-1
        if ( ~isempty(U{i,j}) )
            A{i,1} = A{i,1} - U{i,j};
        end
    end
end

% Precompute the coefficient B1 using the row summing property.
B{1} = phi1;
for i = 2:s
    if ( ~isempty(B{i}) )
        B{1} = B{1} - B{i};
    end
end
for i = 1:q-1
    if ( ~isempty(V{i}) )
        B{1} = B{1} - V{i};
    end
end

% Precompute the E quantities.
E = cell(s+1, 1);
for i = 1:s
   E{i} = exp(C(i)*dt*L);
end
E{s+1} = exp(dt*L);

% Multiply by timestep:
A = cellfun(@(A) dt*A, A, 'UniformOutput', 0);
B = cellfun(@(B) dt*B, B, 'UniformOutput', 0);
U = cellfun(@(U) dt*U, U, 'UniformOutput', 0);
V = cellfun(@(V) dt*V, V, 'UniformOutput', 0);

% Put everything in COEFFS:
coeffs.A = A;
coeffs.B = B;
coeffs.E = E;
coeffs.U = U;
coeffs.V = V;

end