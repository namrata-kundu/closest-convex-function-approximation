function [y_min,y_max] = find_y_bounds(f,pieces)

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

