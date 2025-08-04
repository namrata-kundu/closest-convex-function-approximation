function y_intercept  = tangent_y_intercept(f, n)
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