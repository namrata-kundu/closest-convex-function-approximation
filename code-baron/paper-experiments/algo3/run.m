pieces = [-inf(), -5, 0, 5, inf()];
f = [0, 0, 0, 0;
    -1, 1, -1, 1;
    -5, 5, 5, -5];

pieces = [-inf(), 1, 2.5, 6, inf()];
f = [
    (1/2), 0, 0, 0;
    0, 2, -1, 1;
    1, -(1/2), 7, -5];

[rho,new_pieces, sol, objective] =   nearest_convex_function_variable_pieces_of_a_given_number(f,pieces)
visualize(f,pieces,rho,new_pieces);
epsilon=1e-3;
  [simple_rho,simple_rho_pieces ] = simple_merging_based_on_values(rho,new_pieces, epsilon);
[g,g_pieces, num_of_pieces] = decrease_pieces_of_convex_function(rho,new_pieces, epsilon, @works);

% [g, g_pieces, objective] = works(simple_rho,simple_rho_pieces, 3);
% [g, g_pieces, objective] = algo3_new_correct(simple_rho,simple_rho_pieces, 3);

visualize(f,pieces,g,g_pieces);