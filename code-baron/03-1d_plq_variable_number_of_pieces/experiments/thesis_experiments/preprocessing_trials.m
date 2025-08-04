
pieces = [-inf(), -10, -5, 0, 5, 10, inf()];
f = [0, 0, 0, 0, 0, 0;
    -1, -1, 1, -1, 1, 1;
    -5, -5, 5, 5, -5, -5];
epsilon = 0.5;

simplifiedFunction = reducePieces(pieces, f, epsilon);
disp(simplifiedFunction);

function simplifiedFunction = reducePieces(pieces, f, epsilon)
    numPieces = numel(pieces) - 1;
    
    % Initialize a table to store intermediate results
    minError = zeros(numPieces, numPieces);
    
    % Initialize a table to store the selected breakpoints
    selectedBreakpoints = cell(numPieces, numPieces);
    
    % Define the objective function for error calculation
    objectiveFunction = @(a, b, c) sum((a * pieces.^2 + b * pieces + c - f).^2);
    
    % Dynamic programming to find optimal subset of pieces
    for len = 1:numPieces
        for start = 1:(numPieces - len + 1)
            stop = start + len - 1;
            
            % Calculate error for the current subset
            a = polyfit(pieces(start:stop), f(1, start:stop), 2);
            b = polyfit(pieces(start:stop), f(2, start:stop), 2);
            c = polyfit(pieces(start:stop), f(3, start:stop), 2);
            error = objectiveFunction(a, b, c);
            
            % Check if the error is within epsilon
            if error <= epsilon
                minError(start, stop) = error;
                selectedBreakpoints{start, stop} = [pieces(start), pieces(stop + 1)];
            else
                % Find optimal merge point within the subset
                optMerge = inf;
                for merge = start:(stop - 1)
                    leftError = minError(start, merge);
                    rightError = minError(merge + 1, stop);
                    totalError = leftError + rightError;
                    
                    if totalError < optMerge
                        optMerge = totalError;
                        selectedBreakpoints{start, stop} = [selectedBreakpoints{start, merge}, selectedBreakpoints{merge + 1, stop}];
                    end
                end
                
                % Update the error for the current subset
                minError(start, stop) = optMerge;
            end
        end
    end
    
    % The selected breakpoints for the entire range
    selectedBreakpoints = selectedBreakpoints{1, numPieces};
    
    % Construct the simplified piecewise function
    simplifiedFunction = zeros(3, numel(selectedBreakpoints) - 1);
    for i = 1:(numel(selectedBreakpoints) - 1)
        pieceStart = selectedBreakpoints(i);
        pieceEnd = selectedBreakpoints(i + 1);
        
        % Fit a quadratic function within the selected range
        indices = find(pieces >= pieceStart & pieces <= pieceEnd);
        a = polyfit(pieces(indices), f(1, indices), 2);
        b = polyfit(pieces(indices), f(2, indices), 2);
        c = polyfit(pieces(indices), f(3, indices), 2);
        
        simplifiedFunction(:, i) = [a(1), b(1), c(1)]; % Store quadratic coefficients
    end
end
