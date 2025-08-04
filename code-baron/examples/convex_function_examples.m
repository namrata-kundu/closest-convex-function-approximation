function [pieces, f] = convex_function_examples(example_num)
% CONVEX_FUNCTION_EXAMPLES - Collection of convex function test cases
%
% Usage: [pieces, f] = convex_function_examples(example_num)
%
% Input:
%   example_num - Integer specifying which convex function example to return
%                 1: Standard convex quadratic function
%                 2: Convex function with multiple pieces
%                 3: Convex function variant
%                 4: Complex convex function with many pieces
%
% Output:
%   pieces - Breakpoint vector defining piecewise intervals
%   f      - 3xN matrix where each column defines a quadratic piece
%
% Examples:
%   [pieces, f] = convex_function_examples(1);
%   visualize(f, pieces, f, pieces);

if nargin < 1
    example_num = 1;
end

switch example_num
    case 1
        % Standard convex quadratic function
        pieces = [-inf(), 1, inf()];
        f = [(1/2), 0;
             0, 2;
             1, -(1/2)];
             
    case 2
        % Convex function with multiple pieces
        pieces = [-inf(), 1, 2.5, 6, inf()];
        f = [(1/2), 0, 0, 0;
             0, 2, -1, 1;
             1, -(1/2), 7, -5];
             
    case 3
        % Convex function variant (incomplete boundary)
        pieces = [-inf(), 1, 2.5, 6];
        f = [(1/2), 0, 0;
             0, 2, -1;
             1, -(1/2), 7];
             
    case 4
        % Complex convex function with symmetric structure
        pieces = [-inf(), -3.64, 3.64, inf()];
        f = [1, 0, 1;
             16, 0, -16;
             63, 20, 63];
             
    case 5
        % Simple symmetric convex function
        pieces = [-inf(), 0, inf()];
        f = [1, 1;
             16, -16;
             63, 63];
             
    case 6
        % Extended convex function
        pieces = [-inf(), -10, 0, 10, inf()];
        f = [1, 1, 1, 1;
             16, 16, -16, -16;
             63, 63, 63, 63];
             
    otherwise
        error('Invalid example number. Choose 1-6.');
end

% Display information about the selected example
fprintf('Convex Function Example %d loaded:\n', example_num);
fprintf('Pieces: [%s]\n', num2str(pieces));
fprintf('Function matrix f:\n');
disp(f);

end
