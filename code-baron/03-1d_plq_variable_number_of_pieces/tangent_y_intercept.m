function y_intercept  = tangent_y_intercept(f, n)
% TANGENT_Y_INTERCEPT - Calculate y-intercept of tangent line to quadratic function
% Computes where the tangent line at point x=n intersects the y-axis
%
% For a quadratic function f(x) = ax² + bx + c, this function:
% 1. Evaluates the function at point x = n
% 2. Calculates the derivative (slope) at x = n
% 3. Finds where the tangent line crosses the y-axis (x = 0)
%
% Inputs:
%   f - 3x1 vector defining quadratic function coefficients [a; b; c]
%       where f(x) = a*x² + b*x + c
%   n - x-coordinate where tangent is calculated
%
% Outputs:
%   y_intercept - y-coordinate where tangent line crosses y-axis
%
% Mathematical formula:
%   y_intercept = f(n) - n * f'(n)
%   where f'(n) = 2*a*n + b
%
% Example:
%   f = [1; 2; 3];  % f(x) = x² + 2x + 3
%   y_int = tangent_y_intercept(f, 1);  % Tangent at x=1

    % Coefficients of the quadratic function
    a = f(1);
    b = f(2);
    c = f(3);

    % Value of the function at x = n
    f_n = a*n^2 + b*n + c;

    % Derivative of the function at x = n
    f_prime_n = 2*a*n + b;

    % y-intercept of the tangent
    y_intercept = f_prime_n * (0 - n) + f_n;
end