function [g,g_pieces ] = simple_merging_based_on_values(f,pieces, eps)
% SIMPLE_MERGING_BASED_ON_VALUES - Merge adjacent pieces with similar function values
% Reduces the number of pieces by merging adjacent pieces that have small differences
%
% This function uses symbolic integration to compute the L2 norm difference between
% adjacent pieces and merges them if the difference is below the specified tolerance.
%
% Inputs:
%   f - 3xN matrix defining the piecewise quadratic function
%       f(1,:) = quadratic coefficients (a)
%       f(2,:) = linear coefficients (b)
%       f(3,:) = constant coefficients (c)
%   pieces - breakpoint vector for the function
%   eps - tolerance for merging (pieces merged if L2 difference < eps)
%
% Outputs:
%   g - 3xM matrix defining the merged function (M <= N)
%   g_pieces - breakpoint vector for the merged function
%
% Example:
%   [rho, new_pieces, obj] = nearest_convex_function_variable_pieces_of_fixed_num(f, pieces, 20);
%   [simple_rho, simple_pieces] = simple_merging_based_on_values(rho, new_pieces, 1e-3);
%
% Author: Namrata Kundu

    g = [f(:,1)];
    g_pieces = [pieces(1)];
    r = size(pieces, 2);

    syms x
    for i=1:size(f,2)-1
        a1 = f(1,i);
        b1 = f(2,i);
        c1 = f(3,i);

        a2 = f(1,i+1);
        b2 = f(2,i+1);
        c2 = f(3,i+1);

        func = ((a1*x*x + b1*x + c1) - (a2*x*x + b2*x + c2))^2;
        if isinf(pieces(i)) 
            lb=-99999999;
        else
            lb = pieces(i);
        end
        if isinf(pieces(i+2))
            ub = 99999999;
        else
            ub = pieces(i+2);
        end
        str_symbolic_integral = int(func, [lb ub]);
        integral = eval(str_symbolic_integral);

        if integral<eps/r
            continue
%         if abs(a1 - a2) < eps &&  abs(b1 - b2) < eps && abs(c1 - c2) < eps
%             continue
        else
            g = [g, f(:,i+1)];
            g_pieces = [g_pieces, pieces(i+1)];
        end

    end
    g_pieces = [g_pieces, pieces(end)];
    
end


% legacy algo code
% function [g,g_pieces ] = simple_merging_based_on_values(f,pieces, eps)
%     g = [f(:,1)];
%     g_pieces = [pieces(1)];
%     r = size(pieces, 2);
% %     eps = 1e-7;
% 
%     
%     for i=1:size(f,2)-1
%         a1 = f(1,i);
%         b1 = f(2,i);
%         c1 = f(3,i);
% 
%         a2 = f(1,i+1);
%         b2 = f(2,i+1);
%         c2 = f(3,i+1);
% 
%         if abs(a1 - a2) < eps &&  abs(b1 - b2) < eps && abs(c1 - c2) < eps
%             continue
%         else
%             g = [g, f(:,i+1)];
%             g_pieces = [g_pieces, pieces(i+1)];
%         end
% 
%     end
%     g_pieces = [g_pieces, pieces(end)];
%     
% end
