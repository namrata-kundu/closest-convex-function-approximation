function [y] = build_piecewise_function(f, f_pieces)
% BUILD_PIECEWISE_FUNCTION - Create symbolic piecewise function for plotting
% Constructs a MATLAB symbolic piecewise function from coefficient matrix and breakpoints
%
% This function creates a symbolic piecewise function that can be used with
% MATLAB's fplot and other symbolic plotting functions. It handles infinite
% boundaries and creates appropriate boundary conditions for each piece.
%
% Inputs:
%   f - 3xN matrix defining the piecewise quadratic function
%       f(1,:) = quadratic coefficients (a)
%       f(2,:) = linear coefficients (b)
%       f(3,:) = constant coefficients (c)
%   f_pieces - breakpoint vector defining the intervals (length N+1)
%
% Outputs:
%   y - symbolic piecewise function that can be plotted with fplot
%
% Each piece is defined as: f_i(x) = a_i*x² + b_i*x + c_i for x ∈ [pieces(i), pieces(i+1)]
%
% Example:
%   [pieces, f] = w_function_examples(1);
%   piecewise_func = build_piecewise_function(f, pieces);
%   fplot(piecewise_func, [-10, 10]);
%
% See also: visualize, fplot


    syms x;
    total_num_of_pieces = size(f_pieces,2);
    
    pieces = [];
    for i=1:total_num_of_pieces-1
        left_bound = f_pieces(i);
        right_bound = f_pieces(i+1);
        if isinf(left_bound)
            if isinf(right_bound)
                boundary_condition = (left_bound<x);
            else
                boundary_condition = (left_bound<x)<right_bound;
            end
        elseif isinf(right_bound)
            boundary_condition = (left_bound<=x);
        else
            boundary_condition = (left_bound<=x)<right_bound;
        end
        
        a = value(f(1,i));
        b = value(f(2,i));
        c = value(f(3,i));
        func = a*x*x + b*x + c;
        pieces = [pieces, boundary_condition, func];
    end

    % Convert to piecewise function
    T = num2cell(pieces);
    y = piecewise(T{:});
end