function [answer, new_f] = multiple_set_breakpoints_of_given_number(f, pieces, n)
    
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

    
%     disp('Answer:');
%     disp(answer);
%     % Expand the coefficient matrix by repeating the existing coefficients
%     f = repmat(f, 1, ceil(n / size(f, 2)));
%     f = f(:, 1:n);
%     
%     disp('New pieces:');
%     disp(new_pieces);
%     disp('New f:');
%     disp(new_f);
end

