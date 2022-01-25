function y = Bunnag6(x)
% -------------------------------------------------------------------------
% MATLAB coding by: Linas Stripinis
% Name:
%   Bunnag6.m
%
% Original source: 
% - Bunnag D. and  Sun M. (2005, December). Genetic algorithm for 
%   constrained global optimization in continuous variables. Applied 
%   Mathematics and Computation, 171(1), 604 - 636.
%
% Globally optimal solution:
%   f* = -268.0146300421110368
%   x* = (1, 0.90754716, 0, 1, 0.71509433, 1, 0, 0.91698113, 1, 1)
%
% Constraints (including variable bounds):
%   g(1): -2*x(1) - 6*x(2) - x(3) - 3*x(5) - 3*x(6) - 2*x(7) - 6*x(8) - 2*x(9) - 2*x(10) <= -4;
%   g(2): 6*x(1) - 5*x(2) + 8*x(3) - 3*x(4) + x(6) + 3*x(7) + 8*x(8) + 9*x(9) - 3*x(10) <= 22;
%   g(3): -5*x(1) + 6*x(2) + 5*x(3) + 3*x(4) + 8*x(5) - 8*x(6) + 9*x(7) + 2*x(8) - 9*x(10) <= -6; 
%   g(4): 9*x(1) + 5*x(2) - 9*x(4) + x(5) - 8*x(6) + 3*x(7) - 9*x(8) - 9*x(9) - 3*x(10) <= -23;
%   g(5): -8*x(1) + 7*x(2) - 4*x(3) - 5*x(4) - 9*x(5) + x(6) - 7*x(7) - x(8) + 3*x(9) - 2*x(10) <= -12;
%   g(6): -7*x(1) - 5*x(2) - 2*x(3) - 6*x(5) - 6*x(6) - 7*x(7) - 6*x(8) + 7*x(9) + 7*x(10) <= -3;
%   g(7): x(1) - 3*x(2) - 3*x(3) - 4*x(4) - x(5) - 4*x(7) + 6*x(9) <= 1;
%   g(8): x(1) - 2*x(2) + 6*x(3) + 9*x(4) - 7*x(6) + 9*x(7) - 9*x(8) - 6*x(9) + 4*x(10) <= 12;
%   g(9): -4*x(1) + 6*x(2) + 7*x(3) + 2*x(4) + 2*x(5) + 6*x(7) + 6*x(8) - 7*x(9) + 4*x(10) <= 15;
%   g(10): sum(x) <= 9;
%   g(11): -sum(x) <= -1;
%         0 <= x(1) <= 1;
%         0 <= x(2) <= 1;
%         0 <= x(3) <= 1;
%         0 <= x(4) <= 1;
%         0 <= x(5) <= 1;
%         0 <= x(6) <= 1;
%         0 <= x(7) <= 1;
%         0 <= x(8) <= 1;
%         0 <= x(9) <= 1;
%         0 <= x(10) <= 1;
%   
% Problem Properties:
%   n  = 10;
%   #g = 11;
%   #h = 0;  
% -------------------------------------------------------------------------
if nargin == 0
    y.nx = 10;
    y.ng = 11;
    y.nh = 0;
    y.xl = @(i) 0;
    y.xu = @(i) 1;
    y.fmin = @(i) -268.0146115418375529;    
                       
    xmin = [0.9999999700664299, 0.9075470211399220, 0.0000000869537941,...
        0.9999999702819241, 0.7150942649115544, 0.9999999901919779,...
        0.0000000229347797, 0.9169812916397808, 0.9999998434514531,...
        0.9999999786765920];
    y.xmin = @(i) xmin(i);
    y.confun = @(i) Bunnag6c(i);
    return
end
d = [-20, -80, -20, -50, -60, -90, 0];
b = transpose(d);
sum1 = 0;
sum2 = 0;
sum3 = 0;
for i=1:7
    sum1 = sum1 + b(i)*x(i);
    sum3 = sum3 + x(i)^2;
end
for i=8:10
    sum2 = sum2 + x(i);
end
y = sum1 + 10*sum2 - 5*sum3; 
end

function [c, ceq] = Bunnag6c( x )
c(1) = -2*x(1) - 6*x(2) - x(3) - 3*x(5) - 3*x(6) - 2*x(7) - 6*x(8) - 2*x(9) - 2*x(10) + 4;
c(2) = 6*x(1) - 5*x(2) + 8*x(3) - 3*x(4) + x(6) + 3*x(7) + 8*x(8) + 9*x(9) - 3*x(10) - 22;
c(3) = -5*x(1) + 6*x(2) + 5*x(3) + 3*x(4) + 8*x(5) - 8*x(6) + 9*x(7) + 2*x(8) - 9*x(10) + 6;
c(4) = 9*x(1) + 5*x(2) - 9*x(4) + x(5) - 8*x(6) + 3*x(7) - 9*x(8) - 9*x(9) - 3*x(10) + 23;
c(5) = -8*x(1) + 7*x(2) - 4*x(3) - 5*x(4) - 9*x(5) + x(6) - 7*x(7) - x(8) + 3*x(9) - 2*x(10) + 12;
c(6) = -7*x(1) - 5*x(2) - 2*x(3) - 6*x(5) - 6*x(6) - 7*x(7) - 6*x(8) + 7*x(9) + 7*x(10) + 3;
c(7) = x(1) - 3*x(2) - 3*x(3) - 4*x(4) - x(5) - 4*x(7) + 6*x(9) - 1;
c(8) = x(1) - 2*x(2) + 6*x(3) + 9*x(4) - 7*x(6) + 9*x(7) - 9*x(8) - 6*x(9) + 4*x(10) - 12;
c(9) = -4*x(1) + 6*x(2) + 7*x(3) + 2*x(4) + 2*x(5) + 6*x(7) + 6*x(8) - 7*x(9) + 4*x(10) - 15;
c(10) = sum(x) - 9;
suma = 0;
for i = 1:10
    suma = suma + x(i);
end
c(11) = -suma + 1;
ceq = [];
end
