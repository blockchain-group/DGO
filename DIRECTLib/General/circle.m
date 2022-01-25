function y = circle(x)
% -------------------------------------------------------------------------
% MATLAB coding by: Linas Stripinis
% Name:
%   circle.m
%
% Original source: 
% - Hock, W., & Schittkowski, K. (1980). Test examples for 
%   nonlinear programming codes. Journal of Optimization Theory and 
%   Applications, 30(1), 127–129. https://doi.org/10.1007/BF00934594
%
% Globally optimal solution:
%   f* = 4.5742477850251299
%   x* = [5.38807633805694; 6.39909755869290; 4.57424778502513]
%
% Constraints (including variable bounds):
%    g(1) = (2.545724188 - x(1))^2 + (9.983058643 - x(2))^2 - x(3)^2 <= 0;
%    g(2) = (8.589400372 - x(1))^2 + (6.208600402 - x(2))^2 - x(3)^2 <= 0;
%    g(3) = (5.953378204 - x(1))^2 + (9.920197351 - x(2))^2 - x(3)^2 <= 0;
%    g(4) = (3.710241136 - x(1))^2 + (7.860254203 - x(2))^2 - x(3)^2 <= 0;
%    g(5) = (3.629909053 - x(1))^2 + (2.176232347 - x(2))^2 - x(3)^2 <= 0;
%    g(6) = (3.016475803 - x(1))^2 + (6.757468831 - x(2))^2 - x(3)^2 <= 0;
%    g(7) = (4.148474536 - x(1))^2 + (2.435660776 - x(2))^2 - x(3)^2 <= 0;
%    g(8) = (8.706433123 - x(1))^2 + (3.250724797 - x(2))^2 - x(3)^2 <= 0;
%    g(9) = (1.604023507 - x(1))^2 + (7.020357481 - x(2))^2 - x(3)^2 <= 0;
%    g(10) = (5.501896021 - x(1))^2 + (4.918207429 - x(2))^2 - x(3)^2 <= 0;
%         0 <= x(1) <= 10;
%         0 <= x(2) <= 10;
%         0 <= x(3) <= 10;
%   
% Problem Properties:
%   n  = 3;
%   #g = 5;
%   #h = 0;  
% -------------------------------------------------------------------------
if nargin == 0
    y.nx = 3;
    y.ng = 5;
    y.nh = 0;
    y.xl = @(i) 0;
    y.xu = @(i) 10;
    y.fmin = @(i) 4.5742477850251299;
    xmin = [5.38807633805694; 6.39909755869290; 4.57424778502513];
    y.xmin = @(i) xmin(i);
    y.confun = @(i) circlec(i);
    return
end
    y = x(3);
end

function [Ineq, eq] = circlec(x)
    Ineq(1) = (2.545724188 - x(1))^2 + (9.983058643 - x(2))^2 - x(3)^2;
    Ineq(2) = (8.589400372 - x(1))^2 + (6.208600402 - x(2))^2 - x(3)^2;
    Ineq(3) = (5.953378204 - x(1))^2 + (9.920197351 - x(2))^2 - x(3)^2;
    Ineq(4) = (3.710241136 - x(1))^2 + (7.860254203 - x(2))^2 - x(3)^2;
    Ineq(5) = (3.629909053 - x(1))^2 + (2.176232347 - x(2))^2 - x(3)^2;
    Ineq(6) = (3.016475803 - x(1))^2 + (6.757468831 - x(2))^2 - x(3)^2;
    Ineq(7) = (4.148474536 - x(1))^2 + (2.435660776 - x(2))^2 - x(3)^2;
    Ineq(8) = (8.706433123 - x(1))^2 + (3.250724797 - x(2))^2 - x(3)^2;
    Ineq(9) = (1.604023507 - x(1))^2 + (7.020357481 - x(2))^2 - x(3)^2;
    Ineq(10) = (5.501896021 - x(1))^2 + (4.918207429 - x(2))^2 - x(3)^2;
    eq = [];
end