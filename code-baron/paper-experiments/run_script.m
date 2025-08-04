% ========================================================================
% PAPER EXPERIMENTS - EXAMPLE SELECTION
% ========================================================================
% All test examples are in ../examples/ directory

% Add examples directory to path
addpath('../examples');

% Select example for paper experiments
[pieces, f] = w_function_examples(1);  % Standard W function for paper experiments

% Alternative examples (uncomment to use):
% [pieces, f] = convex_function_examples(2);      % Multi-piece convex function
% [pieces, f] = special_cases_examples(1);        % Complex experimental function

% Run the main algorithm
[rho,new_pieces, sol, objective] = nearest_convex_function_variable_pieces_of_a_given_number(f,pieces);

% Alternative algorithms (uncomment to use):
% [rho,new_pieces, sol, objective] = qcqp_nearest_convex_function_variable_pieces_of_a_given_number(f,pieces);
% [rho,new_pieces, sol, objective] = gurobi_algo2(f,pieces);
% [rho,new_pieces, sol, objective] = qcqp_norm_nearest_convex_function_variable_pieces(f,pieces);

% Visualize results
visualize(f,pieces,rho,new_pieces);