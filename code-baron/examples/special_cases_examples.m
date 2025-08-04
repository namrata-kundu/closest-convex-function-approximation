function [pieces, f] = special_cases_examples(example_num)
% SPECIAL_CASES_EXAMPLES - Collection of special and experimental test cases
%
% Usage: [pieces, f] = special_cases_examples(example_num)
%
% Input:
%   example_num - Integer specifying which special case to return
%                 1: Complex experimental function (from experiments)
%                 2: High-precision function with many breakpoints
%                 3: Boundary test case
%                 4: Infeasible test case
%                 5: Edge case functions
%
% Output:
%   pieces - Breakpoint vector defining piecewise intervals
%   f      - 3xN matrix where each column defines a quadratic piece
%
% Examples:
%   [pieces, f] = special_cases_examples(1);
%   visualize(f, pieces, f, pieces);

if nargin < 1
    example_num = 1;
end

switch example_num
    case 1
        % Complex experimental function with many breakpoints
        pieces = [-inf(), 80, 100, 280, 300, 340, 360, 380, 400, inf()];
        f = [0.0025, -0.00250, 0, 0.0050, -0.0025, 0.0050, -0.005, -4.78350000000000e-16, 0.005004400;
             -0.40, 0.40, -0.1, -2.9, 1.6, -3.5, 3.7, -0.1, -4.103520;
             2329, 2297, 2322, 2714, 2039, 2906, 1610, 2331.99999999993, 3132.7040];
             
    case 2
        % Simple boundary test case
        pieces = [-inf(), -6, 9];
        f = [0, -1;
             12, 0;
             37, 1];
             
    case 3
        % Edge case with specific values
        pieces = [0, 3, 9, 10];
        f = [-1, -1, -1;
             0, 0, 0;
             0, 0, 0];
             
    case 4
        % Boundary case 2
        pieces = [-inf(), -60, -3, inf()];
        f = [0, -1, 1;
             101, -19, -19;
             3604, 4, -14];
             
    case 5
        % Modified boundary case
        pieces = [-inf(), -3, inf()];
        f = [-1, 1;
             -19, -19;
             4, -14];
             
    case 6
        % Simple boundary case
        pieces = [-10, 5, 10];
        f = [-1, -1;
             -19, -19;
             4, 4];
             
    case 7
        % Infeasible test case (may not have solution)
        pieces = [-inf(), 0, inf()];
        f = [1, 1;
             2, -2;
             0, 0];
             
    case 8
        % Conjecture test case 1
        pieces = [-inf(), -1, 0, 1, inf()];
        f = [1, 0, 0, 1;
             0, -1, 1, 0;
             0, 0, -1, 0];
             
    case 9
        % Conjecture test case 2
        pieces = [-inf(), 0, 2, inf()];
        f = [1, -1, 1;
             -4, 0, -4;
             4, 0, 4];
             
    otherwise
        error('Invalid example number. Choose 1-9.');
end

% Display information about the selected example
fprintf('Special Case Example %d loaded:\n', example_num);
fprintf('Pieces: [%s]\n', num2str(pieces));
fprintf('Function matrix f:\n');
disp(f);

end
