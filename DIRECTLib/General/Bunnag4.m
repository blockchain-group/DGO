function y = Bunnag4(x)
% ------------------------------------------------------------------------------
% MATLAB coding by: Linas Stripinis
% Name:
%   Bunnag4.m
%
% Original source: 
% - Bunnag D. and  Sun M. (2005, December). Genetic algorithm for 
%   constrained global optimization in continuous variables. Applied 
%   Mathematics and Computation, 171(1), 604 - 636.
%
% Globally optimal solution:
%   f* = -213.0
%   x* = (0, 1, 0, 1, 1, 20)
%
% Constraints (including variable bounds):
%   g(1): 6*x(1)+3*x(3)+3*x(3)+2*x(4)+x(5) <= 6.5;
%   g(2): 10*x(1)+10*x(3)+x(6)             <= 20;
%         0 <= x(1) <= 1;
%         0 <= x(2) <= 1;
%         0 <= x(3) <= 1;
%         0 <= x(4) <= 1;
%         0 <= x(5) <= 1;
%         0 <= x(6) <= 20;
%   
% Problem Properties:
%   n  = 6;
%   #g = 2;
%   #h = 0;  
% ------------------------------------------------------------------------------ 
y = -10.5*x(1)-7.5*x(2)-3.5*x(3)-2.547*x(4)-1.5*x(5)-10*x(6)-0.5*((x(1)^2)+(x(2)^2)+(x(3)^2)+(x(4)^2)+(x(5)^2)); 
end