function [y] = build_piecewise_function(f, f_pieces)
% BUILD_PIECEWISE_FUNCTION - Create symbolic piecewise function for plotting
% This is a duplicate of the main build_piecewise_function.m file
% See code-baron/03-1d_plq_variable_number_of_pieces/build_piecewise_function.m for documentation

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
%     left_bound = f(1,total_num_of_pieces);
%     right_bound = extreme_right_bound;
%     if isinf(left_bound)
%         if isinf(right_bound)
%             boundary_condition = (left_bound<x);
%         else
%             boundary_condition = (left_bound<x)<right_bound;
%         end
%     elseif isinf(right_bound)
%         boundary_condition = (left_bound<=x);
%     else
%         boundary_condition = (left_bound<=x)<right_bound;
%     end
% 
%     a = value(f(2,total_num_of_pieces));
%     b = value(f(3,total_num_of_pieces));
%     c = value(f(4,total_num_of_pieces));

    % Convert to piecewise function
    T = num2cell(pieces);
    y = piecewise(T{:});
end