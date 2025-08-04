function [answer, new_f] = multiple_set_breakpoints_of_given_number(f, pieces, n)
% MULTIPLE_SET_BREAKPOINTS_OF_GIVEN_NUMBER - Subdivide piecewise function into specified number of pieces
% Creates a finer discretization by splitting each original piece into multiple sub-pieces
%
% This function takes a piecewise quadratic function and creates a new representation
% with exactly n pieces by subdividing the original pieces. Each original piece is
% split into approximately equal sub-intervals, with the same quadratic coefficients
% applied to all sub-pieces within each original piece.
%
% Inputs:
%   f - 3xN matrix defining the original piecewise quadratic function
%       f(1,:) = quadratic coefficients (a)
%       f(2,:) = linear coefficients (b)
%       f(3,:) = constant coefficients (c)
%   pieces - breakpoint vector for the original function (length N+1)
%   n - desired total number of pieces in the result
%
% Outputs:
%   answer - new breakpoint vector (length n+1)
%   new_f - 3xn matrix defining the subdivided function
%
% Algorithm:
%   1. Distributes n pieces across original pieces as evenly as possible
%   2. Creates sub-breakpoints using linspace within each original piece
%   3. Assigns original coefficients to all sub-pieces within each piece
%   4. Handles remainder pieces by distributing them across original pieces
%
% Example:
%   [pieces, f] = w_function_examples(1);  % 4 pieces
%   [new_pieces, new_f] = multiple_set_breakpoints_of_given_number(f, pieces, 12);  % 12 pieces


    % Number of original pieces
    num_original_pieces = length(pieces) - 1;
    
    % Number of breakpoints for each original piece
    breakpoints_per_piece = floor(n / num_original_pieces);
    remainder_breakpoints = n - (breakpoints_per_piece * num_original_pieces);
    
    % Initialize new pieces
    new_pieces = [pieces(1)];
    
    % Split each original piece into equal sub-pieces
    for i = 1:num_original_pieces
        start_piece = pieces(i);
        end_piece = pieces(i + 1);
        new_pieces = [new_pieces, linspace(start_piece+0.000005, end_piece, breakpoints_per_piece + 1)];
    end
    
    % Remove duplicate breakpoints
    new_pieces = unique(new_pieces);
    
    % Randomly add remainder breakpoints
    for i = 1:remainder_breakpoints
        piece_idx = randi(num_original_pieces);
        start_piece = pieces(piece_idx);
        end_piece = pieces(piece_idx + 1);
        random_breakpoint = rand() * (end_piece - start_piece) + start_piece;
        new_pieces = sort([new_pieces, random_breakpoint]);
    end
    
    answer = [];
    new_f=[f(:,1)];
    for i=1:length(new_pieces)
        if ismember(new_pieces(i), pieces) 
            answer = [answer, new_pieces(i)];
        else
            answer = [answer, sdpvar(1,1)];
        end
    end
    
    f_idx=1;
    for i=2:length(answer)-1
        if class(answer(i)) == 'sdpvar'
            val = f(:,f_idx);
            new_f = [new_f, val];
        else
            f_idx = f_idx +1;
            val = f(:,f_idx);
            new_f = [new_f, val];
        end
    end
end