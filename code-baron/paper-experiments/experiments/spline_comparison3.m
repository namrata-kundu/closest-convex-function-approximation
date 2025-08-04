yalmip('clear')

pieces = [-22, 1, 2.5, 6, 22];
f = [
    (1/2), 0, 0, 0;
    0, 2, -1, 1;
    1, -(1/2), 7, -5];

% pieces = [-22, -5, 0, 5, 22];
% f = [0, 0, 0, 0;
%     -1, 1, -1, 1;
%     -5, 5, 5, -5];
epsilon=1e-3;
visualize(f, pieces, f,pieces); 
no_of_pieces = size(f,2)*2;
% no_of_pieces = size(f,2)*8;
[rho,new_pieces,  objective]  = nearest_convex_function_variable_pieces_of_fixed_num(f,pieces,no_of_pieces);
  [simple_rho,simple_rho_pieces ] = simple_merging_based_on_values(rho,new_pieces, epsilon);
 visualize(f, pieces, rho,new_pieces); 
   visualize(rho,new_pieces,simple_rho,simple_rho_pieces);
% [g,g_pieces, num_of_pieces] = decrease_pieces_of_convex_function(simple_rho,simple_rho_pieces, epsilon, @ngetexp_nearest_function_with_variable_pieces_of_given_num);
 [g,g_pieces, num_of_pieces, obj] = decrease_pieces_of_convex_function(simple_rho,simple_rho_pieces , epsilon, @baron_algo4_new_model);

%     g = convert_to_values_rho(g);
%     g_pieces = convert_to_values(g_pieces);
%  visualize( simple_rho,simple_rho_pieces,g,g_pieces);

 [g,g_pieces, num_of_pieces] = decrease_pieces_of_convex_function(simple_rho,simple_rho_pieces , epsilon, @gurobi_algo4_new_model);
visualize( rho,new_pieces,g,g_pieces);



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
