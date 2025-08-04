function [y_min,y_max] = find_y_bounds(f,pieces)
% FIND_Y_BOUNDS - Calculate the minimum and maximum y-values of a piecewise quadratic function
% Finds the global minimum and maximum values by evaluating critical points and boundaries
%
% This function analyzes each piece of the piecewise quadratic function to find:
% 1. Critical points (turning points) within each interval
% 2. Function values at all breakpoints
% 3. Global minimum and maximum across all pieces
%
% Inputs:
%   f - 3xN matrix defining the piecewise quadratic function
%       f(1,:) = quadratic coefficients (a)
%       f(2,:) = linear coefficients (b)
%       f(3,:) = constant coefficients (c)
%   pieces - breakpoint vector defining the intervals
%
% Outputs:
%   y_min - global minimum value of the function
%   y_max - global maximum value of the function
%
% Example:
%   [pieces, f] = w_function_examples(1);
%   [y_min, y_max] = find_y_bounds(f, pieces);


    % Initialize vectors to store minima and maxima
    minima = [];
    maxima = [];
    
    % For each piece
    for i = 1:length(pieces)-1
        % Calculate the turning point
        x_turn = -f(2,i)/(2*f(1,i));
        
        % If the turning point is within the interval
        if x_turn >= pieces(i) && x_turn <= pieces(i+1)
            % Evaluate the function at the turning point
            y_turn = f(1,i)*x_turn^2 + f(2,i)*x_turn + f(3,i);
            
            % Add to minima and maxima
            minima = [minima, y_turn];
            maxima = [maxima, y_turn];
        end
        
        % Evaluate the function at the endpoints
        y_start = f(1,i)*pieces(i)^2 + f(2,i)*pieces(i) + f(3,i);
        y_end = f(1,i)*pieces(i+1)^2 + f(2,i)*pieces(i+1) + f(3,i);
        
        % Add to minima and maxima
        minima = [minima, y_start, y_end];
        maxima = [maxima, y_start, y_end];
    end
    
    % Find overall minimum and maximum
    y_min = min(minima);
    y_max = max(maxima);
%     disp(y_min)
%     disp(y_max)

piecewise_f = build_piecewise_function(f, pieces);
    fplot(piecewise_f)
        grid on;


end

