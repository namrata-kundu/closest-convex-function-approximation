% Algorithm 3 Test Script
% Add examples directory to path
addpath('../../examples');

% Select test example
[pieces, f] = convex_function_examples(2);  % Multi-piece convex function

[rho,new_pieces, sol, objective] =   nearest_convex_function_variable_pieces_of_a_given_number(f,pieces)
visualize(f,pieces,rho,new_pieces);
epsilon=1e-3;
  [simple_rho,simple_rho_pieces ] = simple_merging_based_on_values(rho,new_pieces, epsilon);
[g,g_pieces, num_of_pieces] = decrease_pieces_of_convex_function(rho,new_pieces, epsilon, @works);

% [g, g_pieces, objective] = works(simple_rho,simple_rho_pieces, 3);
% [g, g_pieces, objective] = algo3_new_correct(simple_rho,simple_rho_pieces, 3);

visualize(f,pieces,g,g_pieces);