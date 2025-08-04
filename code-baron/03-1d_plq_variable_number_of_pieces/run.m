yalmip('clear')

% ========================================================================
% EXAMPLE SELECTION
% ========================================================================
% All test examples are in examples/ directory
% Use the examples below or call run_examples() for more options

% Quick example selection - uncomment one:
% [pieces, f] = w_function_examples(1);           % Standard W function
[pieces, f] = convex_function_examples(2);      % Multi-piece convex function
% [pieces, f] = linear_and_absolute_examples(1);  % Absolute value function
% [pieces, f] = special_cases_examples(1);        % Complex experimental function

% For more examples, use: run_examples('category', example_num, 'algorithm')
% Categories: 'w', 'convex', 'linear', 'special'
% See examples/run_examples.m for full documentation

% ========================================================================
% ALGORITHM EXECUTION
% ========================================================================

epsilon = 1e-3;

% Step 1: Visualize original function
visualize(f, pieces, f, pieces);

% Step 2: Find nearest convex function with many pieces
no_of_pieces = size(f,2) * 5;
[rho, new_pieces, objective] = nearest_convex_function_variable_pieces_of_fixed_num(f, pieces, no_of_pieces);

% Step 3: Simplify by merging similar pieces
[simple_rho, simple_rho_pieces] = simple_merging_based_on_values(rho, new_pieces, epsilon);

% Step 4: Visualize results
visualize(f, pieces, rho, new_pieces);
visualize(rho, new_pieces, simple_rho, simple_rho_pieces);

% Step 5: Further reduce pieces using binary search
[g, g_pieces, num_of_pieces] = decrease_pieces_of_convex_function(rho, new_pieces, epsilon, @get_nearest_convex_function_with_variable_pieces_of_given_num);
visualize(rho, new_pieces, g, g_pieces);
% [g,g_pieces, num_of_pieces] = decrease_pieces_of_convex_function(simple_rho,simple_rho_pieces, epsilon, @nget_nearest_convex_function_with_variable_pieces_of_given_num);

% Display results
fprintf('Original pieces: %d\n', size(pieces,2)-1);
fprintf('After optimization: %d pieces\n', size(new_pieces,2)-1);
fprintf('After simplification: %d pieces\n', size(simple_rho_pieces,2)-1);
fprintf('Final result: %d pieces\n', num_of_pieces);


% g_pieces = convert_to_values(g_pieces);
% rho_vals = convert_to_values_rho(g);


visualize(rho,new_pieces,g,g_pieces);


function val = convert_to_values(new_pieces)
    val = [];
    for i=1:size(new_pieces,2)
        val = [val value(new_pieces(i))];
    end        
end


function val = convert_to_values_rho(rho)
    val = [];
    for i=1:size(rho,1)
        val_row = [];
        for j=1:size(rho,2)
            val_row = [val_row value(rho(i,j))];
        end
        val = [val; val_row];
    end    
end
