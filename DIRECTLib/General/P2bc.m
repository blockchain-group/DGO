function [c, ceq] = P2bc( x )
c(1) = x(4)+x(1)-600; 
c(2) = -(x(4)+x(1)); 
c(3) = x(5)+x(2)-200;  
c(4) = -(x(5)+x(2));  
c(5) = x(3)*x(5)+2*x(2)-1.5*(x(5)+x(2)); 
c(6) = x(3)*x(4)+2*x(1)-2.5*(x(4)+x(1));  
c(7) = ((x(3)*x(4)+x(3)*x(5)-x(4)-x(5))/2)-500; 
c(8) = -((x(3)*x(4)+x(3)*x(5)-x(4)-x(5))/2);  
c(9) = x(4)+x(5)-((x(3)*x(4)+x(3)*x(5)-x(4)-x(5))/2)-500; 
c(10) = -(x(4)+x(5)-((x(3)*x(4)+x(3)*x(5)-x(4)-x(5))/2));  
ceq = [];
end

