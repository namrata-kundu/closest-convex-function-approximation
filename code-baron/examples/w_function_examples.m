function [pieces, f] = w_function_examples(example_num)
% W_FUNCTION_EXAMPLES - Collection of W function test cases
%
% Usage: [pieces, f] = w_function_examples(example_num)
%
% Input:
%   example_num - Integer specifying which W function example to return
%                 1: Standard W function (most common)
%                 2: W function with finite boundaries
%                 3: W function variant with different coefficients
%                 4: W function with modified right slope
%
% Output:
%   pieces - Breakpoint vector defining piecewise intervals
%   f      - 3xN matrix where each column defines a quadratic piece:
%            f(1,:) = quadratic coefficients (a)
%            f(2,:) = linear coefficients (b) 
%            f(3,:) = constant coefficients (c)
%
% Examples:
%   [pieces, f] = w_function_examples(1);  % Standard W function
%   visualize(f, pieces, f, pieces);       % Visualize the function

if nargin < 1
    example_num = 1;  % Default to standard W function
end

switch example_num
    case 1
        % Standard W function (most commonly used)
        pieces = [-inf(), -5, 0, 5, inf()];
        f = [0, 0, 0, 0;
            -1, 1, -1, 1;
            -5, 5, 5, -5];
            
    case 2
        % W function with finite boundaries
        pieces = [-22, -5, 0, 5, 22];
        f = [0, 0, 0, 0;
            -1, 1, -1, 1;
            -5, 5, 5, -5];
            
    case 3
        % W function variant with different coefficients
        pieces = [-inf(), -5, 0, 5, inf()];
        f = [0, 0, 0, 0;
            -1, 1, -1, -0.5;
            -5, 5, 5, -5];
            
    case 4
        % W function with modified boundary
        pieces = [-10, -5, 0, 5, inf()];
        f = [-1, 0, 0, 0;
            -1, 1, -1, 1;
            -5, 5, 5, -5];
            
    otherwise
        error('Invalid example number. Choose 1-4.');
end

% Display information about the selected example
fprintf('W Function Example %d loaded:\n', example_num);
fprintf('Pieces: [%s]\n', num2str(pieces));
fprintf('Function matrix f:\n');
disp(f);

end
