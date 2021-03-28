function Value = zecevic4(x)
% ------------------------------------------------------------------------------
% MATLAB coding by: Linas Stripinis
% Name:
%   zecevic4.m
%
% Original source: 
% - Vaz, A.I.F.: PSwarm solver home page (2010).
%   http://www.norg.uminho.pt/aivaz/pswarm/. Accessed 12 Dec 2013  
%
% Globally optimal solution:
%   f* = 7.557507868931737
%   x* = (1.725, 0.25) 
%
% Constraints (including variable bounds):
%     g(1) = x(1)*x(2) - x(1) - x(2) <=0  
%     g(2) = -x(1) - x(2) + 3 <=0  
%
%       0 <= x(i) <= 10, i = 1...n
%       bounds = ones(n, 1).*[0, 10];
%   
% Problem Properties:
%   n  = 2;
%   #g = 2;
%   #h = 0;  
% ------------------------------------------------------------------------------ 
    Value = 6*x(1)^2 + x(2)^2 - 60*x(1) - 8*x(2) + 166;
end

