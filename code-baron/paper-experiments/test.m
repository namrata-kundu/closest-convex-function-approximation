% Define the coefficients of the quadratic functions
a = 2; b = 3; c = 1; % Coefficients for f(x)
d = 1; e = -2; f = -3; % Coefficients for g(x)

% Define the difference function h(x) = f(x) - g(x)
syms x;

% Define the quadratic functions
f  = a*x^2 + b*x + c;
g = d*x^2 + e*x + f;

% Difference function
h = f  - g ;

% Find the derivative and its critical points
h_prime = diff(h, x);
critical_points = solve(h_prime == 0, x);

% Convert critical points to double if they are symbolic
critical_points = double(critical_points);

% Evaluate h at critical points
critical_values = double(subs(h, x, critical_points));
% Combine critical and boundary evaluations
% If your domain is not all real numbers, evaluate h at the domain boundaries as well
% For example, for a domain of [a, b]
boundary_values = double([subs(h, x, -10), subs(h, x, 10)]);
all_values = [critical_values, boundary_values];

% Find the infinity norm (assuming the entire real line or adjust for your domain)
infinity_norm = max(abs(all_values));

% Display the result
disp(infinity_norm);


Constraints = [];

objective = 0; % Initialize objective or part of the objective related to max absolute difference

num_points = 200; % Number of points to discretize each interval
for i=1:size(new_f,2)
    syms x
    af = new_f(1,i);
    bf = new_f(2,i);
    cf = new_f(3,i);
    h  = abs((af*x^2 + bf*x + cf) - (a{i}*x^2 + b{i}*x + c{i}));
    h_prime = diff(h, x);

    critical_points = solve(h_prime == 0, x);
    lower_bound = new_pieces(i);
    upper_bound = new_pieces(i+1);
% Convert critical points to double if they are symbolic
critical_points = double(critical_points);

% Evaluate h at critical points
critical_values = double(subs(h, x, critical_points));
% Combine critical and boundary evaluations
% If your domain is not all real numbers, evaluate h at the domain boundaries as well
% For example, for a domain of [a, b]
boundary_values = double([subs(h, x, lower_bound), subs(h, x, upper_bound)]);
all_values = [critical_values, boundary_values];

% Find the infinity norm (assuming the entire real line or adjust for your domain)
infinity_norm = max(abs(all_values));



%     % Initialize a variable to hold the max difference for this interval
%     max_diff_var = sdpvar(1,1,'full');
% 
%     % Constraints to ensure max_diff_var is at least the absolute difference at each point
%     for j = 1:num_points
%         x = x_values(j);
%         diff_expr = abs((af*x^2 + bf*x + cf) - (a{i}*x^2 + b{i}*x + c{i}));
%         % Add constraint for this point
%         Constraints = [Constraints, max_diff_var >= diff_expr]; % Ensure max_diff_var is greater than or equal to the abs difference at x
%     end

    % Add max_diff_var to the objective or handle it as needed
objective = objective + infinity_norm;
end
















% Constraints = [];
% 
% objective = 0; % Initialize objective or part of the objective related to max absolute difference
% 
% num_points = 200; % Number of points to discretize each interval
% for i=1:size(new_f,2)
%     syms x
%     af = new_f(1,i);
%     bf = new_f(2,i);
%     cf = new_f(3,i);
% 
%     lower_bound = new_pieces(i);
%     upper_bound = new_pieces(i+1);
%     x_values = linspace(lower_bound, upper_bound, num_points);
% 
%     % Initialize a variable to hold the max difference for this interval
%     max_diff_var = sdpvar(1,1,'full');
% 
%     % Constraints to ensure max_diff_var is at least the absolute difference at each point
%     for j = 1:num_points
%         x = x_values(j);
%         diff_expr = abs((af*x^2 + bf*x + cf) - (a{i}*x^2 + b{i}*x + c{i}));
%         % Add constraint for this point
%         Constraints = [Constraints, max_diff_var >= diff_expr]; % Ensure max_diff_var is greater than or equal to the abs difference at x
%     end
% 
%     % Add max_diff_var to the objective or handle it as needed
% objective = objective + max_diff_var;
% end
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 

