function [minima, xatmin, history] = sDirect_sym(Problem, bounds, opts)
%--------------------------------------------------------------------------
% Function   : sDirect_sym
% Author 1   : Linas Stripinis          (linas.stripinis@mif.vu.lt)
% Author 2   : Remigijus Paualvicius    (remigijus.paulavicius@mif.vu.lt)
% Created on : 03/17/2020
% Purpose    : DIRECT optimization algorithm for box constraints.
%--------------------------------------------------------------------------
% [minima, xatmin, history] = sDirect_sym(Problem, bounds, opts)
%       s         - static memory management in data structure
%       glbSolve  - DIRECT(DIvide a hyper-RECTangle) algorithm
%       sym       -  DIRECT extension for symmetric functions
%
% Input parameters:
%       Problem - Structure containing problem
%                 Problem.f       = Objective function handle
%
%       bounds  - (n x 2) matrix of bound constraints LB <= x <= UB
%                 The first column is the LB bounds and the second
%                 column contains the UB bounds
%
%       opts    - MATLAB structure which contains options.
%                 opts.maxevals  = max. number of function evals
%                 opts.maxits    = max. number of iterations
%                 opts.maxdeep   = max. number of rect. divisions
%                 opts.testflag  = 1 if globalmin known, 0 otherwise
%                 opts.globalmin = globalmin (if known)
%                 opts.showits   = 1 print iteration status
%                 opts.ep        = global/local weight parameter
%                 opts.tol       = tolerance for termination if
%                                  testflag = 1
%
% Output parameters:
%       minima  -  best minimum value which was founded
%
%       xatmin  - coordinate of minimal value
%
%       history - (iterations x 4) matrix of iteration history
%                 First column coresponds iterations
%                 Second column coresponds number of objective function
%                 evaluations
%                 Third column coresponds minima value of objecgtive
%                 function which was founded at iterations
%                 Third column coresponds time cost of the algorithm
%
% Original DIRECT implementation taken from:
%--------------------------------------------------------------------------
% D.R. Jones, C.D. Perttunen, and B.E. Stuckman. "Lipschitzian
% Optimization Without the Lipschitz Constant". Journal of Optimization
% Theory and Application, 79(1):157-181, (1993). DOI 10.1007/BF00941892
%
% Grbic, R., Nyarko, E.K., Scitovski, R. "A modi?cation of the DIRECT
% method for Lipschitz global optimization for a symmetric function".
% J. Global Optim. 1�20 (2012). DOI 10.1007/s10898-012-0020-3
%--------------------------------------------------------------------------

% Get options
OPTI = Options(opts, nargout);

% Alocate sets and create initial variables
[VAL, MSS] = Alocate(bounds, OPTI);

% Initialization step
[OPTI, VAL, Xmin, Fmin, MSS] = Initialization(VAL, OPTI, Problem, MSS);

while VAL.perror > OPTI.TOL                                 % Main loop
    % Selection of potential optimal hyper-rectangles step
    [POH, VAL] = Find_po(MSS.FF(1:VAL.m), Fmin, OPTI.ep,...
        MSS.DD(1:VAL.m), VAL);
    
    % Subdivide potential optimalhyper-rectangles
    [MSS, VAL] = Subdivision(VAL, Problem, MSS, POH);
    
    % Update minima and check stopping conditions
    [VAL, Fmin, Xmin, MSS] = Arewedone(OPTI, VAL, MSS);
end                                                         % End of while

% Return value
minima      = Fmin;
if OPTI.G_nargout == 2
    xatmin    = (abs(VAL.b - VAL.a)).*Xmin(:, 1) + VAL.a;
elseif OPTI.G_nargout == 3
    xatmin    = (abs(VAL.b - VAL.a)).*Xmin(:, 1) + VAL.a;
    history   = VAL.history(1:(VAL.itctr - 1), 1:4);
end
%--------------------------------------------------------------------------
return

%--------------------------------------------------------------------------
% AUXILIARY FUNCTION BLOCK
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Function  : Options
% Purpose   : Get options from inputs
%--------------------------------------------------------------------------
function OPTI = Options(opts,narg)
%--------------------------------------------------------------------------
% Determine option values
if nargin < 3 && (isempty(opts))
    opts = [];
end
getopts(opts, 'maxits', 1000,'maxevals', 100000, 'maxdeep', 1000,...
    'testflag', 0, 'globalmin', 0, 'tol', 0.01, 'showits', 1,...
    'ep', 1e-4);

OPTI.G_nargout = narg;     % output arguments
OPTI.MAXits    = maxits;   % Fmax of iterations
OPTI.MAXevals  = maxevals; % Fmax # of function evaluations
OPTI.MAXdeep   = maxdeep;  % Fmax number of side divisions
OPTI.TOL       = tol;      % allowable relative error if f_reach is set
OPTI.TESTflag  = testflag; % terminate if global minima is known
OPTI.globalMIN = globalmin;% minimum value of function
OPTI.showITS   = showits;  % print iteration stat
OPTI.ep         = ep;      % global/local weight parameter
%--------------------------------------------------------------------------
return

%--------------------------------------------------------------------------
% Function  : BEGIN
% Purpose   : Create necessary data accessible to all workers
%--------------------------------------------------------------------------
function [VAL, MSS] = Alocate(bounds, OPTI)
%--------------------------------------------------------------------------
tic                                     % Mesure time
VAL.a       = bounds(:, 1);             % left bound
VAL.b       = bounds(:, 2);             % right bound
VAL.n       = size(bounds, 1);          % dimension
VAL.time    = 0;                        % initial time
VAL.itctr   = 1;                        % initial iteration
VAL.perror  = 10;                       % initial perror
VAL.m       = 1;
% alociate MAIN sets
z   = round(OPTI.MAXevals);
MSS = struct('FF', zeros(1, z), 'DD', -ones(1, z),...
    'LL', zeros(VAL.n, z), 'CC', zeros(VAL.n, z));

if OPTI.G_nargout == 3
    VAL.history = zeros(OPTI.MAXits, 4); % allocating history
end
%--------------------------------------------------------------------------
return

%--------------------------------------------------------------------------
% Function  : Initialization
% Purpose   : Initialization of the DIRECT
%--------------------------------------------------------------------------
function [OPTI, VAL, Xmin, Fmin, MSS] = Initialization(VAL, OPTI,...
    Problem, MSS)
%--------------------------------------------------------------------------
VAL.I  = 1;                                       % evaluation counter
MSS.LL(:, 1) = ones(VAL.n, 1)/2;                  % side lengths
MSS.DD(1) = sqrt(sum(MSS.LL(:, 1).^2));        % initial diameter
MSS.CC(:, 1) = ones(VAL.n, 1)/2;                  % initial midpoint
MSS.FF(1) = feval(Problem.f, abs(VAL.b - VAL.a).*(MSS.CC(:, 1)) + VAL.a);
Fmin = MSS.FF(1);                                 % initial minima
Xmin = MSS.CC(:, 1);                              % initial point

% Check stop condition if global minima is known
if OPTI.TESTflag  == 1
    if OPTI.globalMIN ~= 0
        VAL.perror = (Fmin - OPTI.globalMIN)/abs(OPTI.globalMIN);
    else
        VAL.perror = Fmin;
    end
else
    VAL.perror   = 2;
end
%--------------------------------------------------------------------------
return

%--------------------------------------------------------------------------
% Function  : Arewedone
% Purpose   : Update minima value and check stopoing conditions
function [VAL, Fmin, Xmin, MSS] = Arewedone(OPTI, VAL, MSS)
%--------------------------------------------------------------------------
[Fmin, fminindex] =  min(MSS.FF(1:VAL.m));
Xmin              = MSS.CC(:, fminindex);
MSS.DD(1:VAL.m) = roundn(MSS.DD(1:VAL.m), -12);

if OPTI.showITS == 1                % Show iteration stats
    VAL.time = toc;
    fprintf(...
    'Iter: %4i   f_min: %15.10f    time(s): %10.05f    fn evals: %8i\n',...
        VAL.itctr, Fmin, VAL.time, VAL.I);
end

if OPTI.TESTflag == 1               % Check for stop condition
    if OPTI.globalMIN ~= 0            % Calculate error if globalmin known
        VAL.perror = 100*(Fmin - OPTI.globalMIN)/abs(OPTI.globalMIN);
    else
        VAL.perror = 100*Fmin;
    end
    if VAL.perror < OPTI.TOL
        fprintf('Minima was found with Tolerance: %4i', OPTI.TOL);
        VAL.perror = -10;
    end
else
    VAL.perror = 10;
end

if VAL.itctr >= OPTI.MAXits         % Have we exceeded the maxits?
    disp('Exceeded max iterations. Increase maxits');
    VAL.perror = -10;
end

if VAL.I > OPTI.MAXevals       % Have we exceeded the maxevals?
    disp('Exceeded max fcn evals. Increase maxevals');
    VAL.perror = -10;
end

if OPTI.G_nargout == 3              % Store History
    VAL.history(VAL.itctr,1) = VAL.itctr;
    VAL.history(VAL.itctr,2) = VAL.I;
    VAL.history(VAL.itctr,3) = Fmin;
    VAL.history(VAL.itctr,4) = VAL.time;
end

VAL.itctr = VAL.itctr + 1 ;
%--------------------------------------------------------------------------
return

%--------------------------------------------------------------------------
% Function  : Subdivision
% Purpose   : Calculate; new points, function values, lengths and indexes
%--------------------------------------------------------------------------
function [MSS, VAL] = Subdivision(VAL, O, MSS, POH)
%--------------------------------------------------------------------------
for i = 1:size(POH, 2)
    % Initial calculations
    max_L  = max(MSS.LL(:, POH(i)));
    ls     = find(MSS.LL(:, POH(i)) == max_L);
    LL     = length(ls);
    dl     = 2*max_L/3;
    c      = MSS.CC(:, POH(i))*ones(1, 2*LL);
    
    % Calculate new points and evaluate at the objective function
    c(ls, 1:2:end) = c(ls, 1:2:end) + diag(repelem(dl, LL));
    c(ls, 2:2:end) = c(ls, 2:2:end) - diag(repelem(dl, LL));
    point = abs(VAL.b - VAL.a).*c + VAL.a;
    f = arrayfun(@(x) feval(O.f, point(:, x)), (1:2*LL));
    [~, order] = sort([min(f(1:2:end), f(2:2:end))' ls], 1);
    for j = 1:LL
        VAL.I = VAL.I + 2;
        MSS.LL(ls(order(j)), POH(i))  = dl/2;
        MSS.DD(POH(i)) = sqrt(sum(MSS.LL(:, POH(i)).^2));
        
        discard = symdirect(VAL, c(:, 2*order(j) - 1), POH(i), MSS);
        [VAL, MSS] = coordi(VAL, discard, MSS, POH(i),...
            c(:, 2*order(j) - 1), f(2*order(j) - 1));
        
        discard = symdirect(VAL, c(:, 2*order(j)), POH(i), MSS);
        [VAL, MSS] = coordi(VAL, discard, MSS, POH(i),...
            c(:, 2*order(j)), f(2*order(j)));
        
        if j == LL
            discard  = symdirect(VAL, MSS.CC(:, POH(i)), POH(i), MSS);
            if discard == true
                MSS.DD(POH(i)) = 0;
                MSS.FF(POH(i)) = 1E6;
            end
        end
    end
end
%--------------------------------------------------------------------------
return

%--------------------------------------------------------------------------
% Function  : symdirect
% Purpose   : symDIRECT strategy
%--------------------------------------------------------------------------
function discard = symdirect(VAL, c_tp, index, MSS)
%--------------------------------------------------------------------------
% Generate all rectangle vertices in terms of O and 1
ok = 1; % true
b = zeros(VAL.n, 1);
k = 1;
V(:, k) = b;
k = k + 1;
while (ok == 1)
    j = VAL.n;
    while ((j > 0) && (b(j) == 1))
        b(j) = 0;
        j = j - 1;
    end
    if (j > 0)
        b(j) = 1;
        V(:, k) = b';
        k = k + 1;
    else
        ok = 0;
    end
end

% Transform to real coordinates
for i = 1:2^VAL.n
    for j = 1:VAL.n
        if V(j, i) == 0
            V(j, i) = c_tp(j, 1) - MSS.LL(j, index);
        else
            V(j, i) = c_tp(j, 1) + MSS.LL(j, index);
        end
    end
end

% Checking the symmetry for first rectangle
% Avoid distances between two cluster centers smaller than delta
discard = true;
for i = 1:2^VAL.n
    check = 0;
    for j = 1:VAL.n - 1
        if V(j ,i) >= V(j + 1, i); check = check + 1; end
    end
    if check == VAL.n - 1; discard = false; break; end
end
%--------------------------------------------------------------------------
return

%--------------------------------------------------------------------------
% Function  : coordi
% Purpose   : symDIRECT strategy
%--------------------------------------------------------------------------
function [VAL, MSS] = coordi(VAL, discard, MSS, index, cc, ff)
%--------------------------------------------------------------------------
if discard == false
    VAL.m               = VAL.m + 1;
    MSS.LL(:, VAL.m)    = MSS.LL(:, index);
    MSS.DD(VAL.m)       = MSS.DD(index);
    MSS.CC(:, VAL.m)    = cc;
    MSS.FF(VAL.m)       = ff;
end
%--------------------------------------------------------------------------
return

%--------------------------------------------------------------------------
% Function   :  Find_po
% Purpose    :  Return list of PO hyperrectangles
%--------------------------------------------------------------------------
function [S, VAL] = Find_po(fc, f_min, epsilon, szes, VAL)
% Find all rects on hub
E          = max(epsilon*abs(f_min), 1e-8);
[~, i_min] = min((fc - f_min + E)./szes);
d          = unique(szes);
idx        = find(d == szes(i_min));
jj         = length(d);
d_min      = zeros(1, jj);

for i = 1:jj
    d_min(i) = min(fc(szes == d(i)));
end

Su = cell(1, jj);
for i = idx:jj
    Su{i} = find((abs(fc - d_min(i)) <= 1E-12) & (szes == d(i)));
end
S_1 = cell2mat(Su);

Sp = cell(1, jj);
if jj - idx > 1
    a1 = szes(i_min);
    b1 = fc(i_min);
    a2 = d(jj);
    b2 = d_min(jj);
    % The line is defined by: y = slope*x + const
    slope = (b2 - b1)/(a2 - a1);
    const = b1 - slope*a1;
    for i = 1 : length(S_1)
        j = S_1(i);
        if fc(j) <= slope*szes(j) + const + 1e-08
            Sp{i} = j;
        end
    end
    S_2 = cell2mat(Sp);
    % S_2 now contains all points in S_1 which lies on or below the line
    % Find the points on the convex hull defined by the points in S_2
    xx = szes(S_2);
    yy = fc(S_2);
    h = conhull(xx, yy); % conhull is an internal subfunction
    S_3 = S_2(h);
else
    S_3 = S_1;
end
S = S_3;
return

%--------------------------------------------------------------------------
% Function   :  conhull
% Purpose    :  conhull returns all points on the convex hull.
%--------------------------------------------------------------------------
function h = conhull(x, y)
% conhull returns all points on the convex hull, even redundant ones.
format long;
x = x(:);
y = y(:);
xyAR = roundn([x y], -12);
xyUnique = unique(xyAR, 'rows');
x = xyUnique(:, 1);
y = xyUnique(:, 2);
[w, m, cond] = deal(length(x));
cond = cond - 1;
Z = cell(1, m);
xy = [x, y];
if m == 2
    for i = 1:m
        Z{i} = find(xy(i, 1) == xyAR(:, 1) & xy(i, 2) == xyAR(:, 2))';
    end
    h = cell2mat(Z);
    return;
end
if m == 1
    for i = 1:m
        Z{i} = find(xy(i, 1) == xyAR(:, 1) & xy(i, 2) == xyAR(:, 2))';
    end
    h = cell2mat(Z);
    return;
end
[v, START, flag] = deal(1);

% Index vector for points in convex hull
h = (1:length(x))';
while (cond ~= START) || (flag == 1)
    if cond == w,  flag = 0; end                                                                    
    a = h(v);                                                                  
    
    if v == m, b = 1; else, b = v + 1; end
    
    b = h(b); 
    if v == m, c = 1; else, c = v + 1; end
    if c == m, c = 1; else, c = c + 1; end
    c = h(c);
    if det([x(a) y(a) 1 ; x(b) y(b) 1 ; x(c) y(c) 1]) >= 0
        leftturn = 1;
    else
        leftturn = 0;
    end
    if leftturn
        if v == m, v = 1; else, v = v + 1; end
        cond = v;
    else
        if v == m, j = 1; else, j = v + 1; end
        h(j:m - 1) = h(j + 1:m);
        m = m - 1;
        w = w - 1;
        if v == 1, v = m; else, v = v - 1; end
        if v == m, cond = 1; else, cond = v + 1; end                        
    end

end
xy = [x(h(1:m)), y(h(1:m))];
hh = size(xy, 1);
Z = cell(1, hh);
for i = 1:hh
    Z{i} = find(xy(i, 1) == xyAR(:, 1) & xy(i, 2) == xyAR(:, 2))';
end
h = cell2mat(Z);
return

%--------------------------------------------------------------------------
% GETOPTS Returns options values in an options structure
%--------------------------------------------------------------------------
function varargout = getopts(options, varargin)
K = fix(nargin/2);
if nargin/2 == K
    error('fields and default values must come in pairs')
end
if isa(options,'struct')
    optstruct = 1;
else
    optstruct = 0;
end
varargout = cell(K, 1);
k = 0; ii = 1;
for i = 1:K
    if optstruct && isfield(options, varargin{ii})
        assignin('caller', varargin{ii}, options.(varargin{ii}));
        k = k + 1;
    else
        assignin('caller', varargin{ii}, varargin{ii + 1});
    end
    ii = ii + 2;
end
if optstruct && k ~= size(fieldnames(options), 1)
    warning('options variable contains improper fields')
end
return
%--------------------------------------------------------------------------
% END of BLOCK
%--------------------------------------------------------------------------