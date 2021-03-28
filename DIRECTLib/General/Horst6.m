function y = Horst6(x)
% ------------------------------------------------------------------------------
% MATLAB coding by: Linas Stripinis
% Name:
%   Horst6.m
%
% Original source: 
% - Horst, R., Pardalos, P.M., Thoai, N.V. (1995). Introduction to  
%   Global Optimization. Nonconvex Optimization and Its Application. 
%   Kluwer, Dordrecht  
%
% Globally optimal solution:
%   f* = -32.5793248372577
%   x* = (5.21065556278640, 5.02789999999857, 2.92950882421537e-13) 
%
% Constraints (including variable bounds):
%   g(1): 0.488509*x(1)+0.063565*x(2)+0.945686*x(3)  <= 2.865062;
%   g(2): -0.578592*x(1)-0.324014*x(2)-0.501754*x(3) <= -1.491608;
%   g(3): -0.719203*x(1)+0.099562*x(2)+0.445225*x(3) <= 0.519588;
%   g(4): -0.346896*x(1)+0.637939*x(2)-0.257623*x(3) <= 1.584087;
%   g(5): -0.202821*x(1)+0.647361*x(2)+0.920135*x(3) <= 2.198036;
%   g(6): -0.983091*x(1)-0.886420*x(2)-0.802444*x(3) <= -1.301853;
%   g(7): -0.305441*x(1)-0.180123*x(2)-0.515399*x(3) <= -0.738290;
%         0 <= x(1) <= 6;
%         0 <= x(2) <= 5.0279;
%         0 <= x(3) <= 2.6;
%   
% Problem Properties:
%   n  = 3;
%   #g = 7;
%   #h = 0;  
% ------------------------------------------------------------------------------ 
Q = [0.992934 -0.640117 0.337286; -0.640117 -0.814622 0.960807; 0.337286 0.960807 0.500874];
p = [-0.992372 -0.046466 0.891766];
y = (transpose(x)*Q*x+p*x);
end