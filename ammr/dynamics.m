function f = dynamics(x,u,p)

x1 = x(1,:); up = u(1,:);
x2 = x(2,:); uq = u(2,:);
x3 = x(3,:); Ae = p.fe; Ff = p.fc; T = p.ts; 
ntime = length(x1); t = linspace(0,T,ntime);
Te = Ae*sin(2*pi/T*t);

f1 = x2;
f2 = 1/500*(-1500*x2-2000*x1 + Te + Ff*((up-uq).*x3 - (up+uq).*x2));
f3 = 1/100*(-30*x3 - Ff*((up+uq).*x3-(up-uq).*x2));

f = [f1;f2;f3];

end