% Objective Function
fun = @(x) -x(1) - x(2);

% Nonlinear Constraints
nlcon = @(x) x(1)*x(2); %note we could also use prod(x)
cl = -Inf;
cu = 4;

% Bounds
lb = [0;0];
ub = [6;4];

% This can be solved using BARON as follows:

x = baron(fun,[],[],[],lb,ub,nlcon,cl,cu)

disp("*****************")
% Objective Function
fun = @(x) 400*x(1)^0.9 + 22*(-14.7 + x(2))^1.2 + x(3) + 1000;

% Nonlinear Constraints
nlcon = @(x) [ x(3)*x(1) + 144*x(4);
               -exp(11.86 - 3950/(460 + x(4))) + x(2) ];
cl = [11520;0];
cu = [Inf;0];

% Bounds
lb = [0;14.7;0;-459.67];
ub = [15.1;94.2;5371;80];

% Starting Guess
x0 = [NaN;14.7;NaN;NaN];

% In the above code block, we have also defined a starting guess for x2 as 14.7. For the other variables, NaN indicates to BARON to let it choose a starting point. The problem can be solved as follows:

[x,fval,exitflag,info] = baron(fun,[],[],[],lb,ub,nlcon,cl,cu,[],x0)