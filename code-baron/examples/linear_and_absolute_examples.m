function [pieces, f] = linear_and_absolute_examples(example_num)
% LINEAR_AND_ABSOLUTE_EXAMPLES - Collection of linear and absolute value function test cases
%
% Usage: [pieces, f] = linear_and_absolute_examples(example_num)
%
% Input:
%   example_num - Integer specifying which example to return
%                 1: Absolute value function
%                 2: Linear function
%                 3: Piecewise linear with multiple segments
%                 4: Complex piecewise linear
%
% Output:
%   pieces - Breakpoint vector defining piecewise intervals
%   f      - 3xN matrix where each column defines a quadratic piece
%
% Examples:
%   [pieces, f] = linear_and_absolute_examples(1);  % Absolute value
%   visualize(f, pieces, f, pieces);

if nargin < 1
    example_num = 1;
end

switch example_num
    case 1
        % Absolute value function |x|
        pieces = [-inf(), 0, inf()];
        f = [0, 0;      % No quadratic terms
             -1, 1;     % Linear terms: -x for x<0, x for x>0
             0, 0];     % No constant terms
             
    case 2
        % Simple linear function
        pieces = [-inf(), 0, inf()];
        f = [0, 0;      % No quadratic terms
             1, 1;      % Constant slope of 1
             0, 0];     % No constant terms
             
    case 3
        % Piecewise linear with multiple segments
        pieces = [-inf(), -1, 0, 1, inf()];
        f = [1, -1, -1, 1;      % Quadratic terms
             0, 1, -1, 0;       % Linear terms
             0, 0, 0, 0];       % Constant terms
             
    case 4
        % Complex piecewise linear function
        pieces = [-inf(), 0, 2, inf()];
        f = [1, -1, 1;          % Quadratic terms
             -2, 6, -2;         % Linear terms
             -1, -9, -1];       % Constant terms
             
    case 5
        % Extended piecewise linear with many segments
        pieces = [-inf(), -5, 0, 5, 7, 9, 15, inf()];
        f = [0, 0, 0, 0, 0, 0, 0;       % No quadratic terms
             0, 0, 0, 0, 0, 0, 0;       % No linear terms
             -5, 5, 2, 4, 1, -2, 3];    % Only constant terms
             
    case 6
        % Symmetric piecewise linear
        pieces = [-inf(), -1, 0, 1, 2, inf()];
        f = [1, -1, 1, -1, 1;           % Quadratic terms
             1, 1, -1, -1, -1;          % Linear terms
             0, 0, 0, 0, 0];            % Constant terms
             
    otherwise
        error('Invalid example number. Choose 1-6.');
end

% Display information about the selected example
fprintf('Linear/Absolute Function Example %d loaded:\n', example_num);
fprintf('Pieces: [%s]\n', num2str(pieces));
fprintf('Function matrix f:\n');
disp(f);

end
