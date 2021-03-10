function [c,ceq] = pathConstraint(x,u)
x2 = x(2,:);
up = u(1,:); uq = u(2,:);
c = [-x2.*up; x2.*uq];
ceq = up.*uq;
end