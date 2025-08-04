yalmip('clear')
pieces = [-inf(), 1, 2.5, 6, inf()];
f = [
    (1/2), 0, 0, 0;
    0, 2, -1, 1;
    1, -(1/2), 7, -5];
simple_rho = [0.500000000000000	0.00166484522351421	0.499999979780972	0	33.7484132398639	0;
0	-44.6853481029609	-7.59171515864534e-07	0.0444741032891344	-500	1;
1	-1000.72410129322	0.999995152913038	2.08569551562648	1854.35408443265	-5];

simple_rho_pieces = [-Inf	-44.8895414899199	-44.7795177879121	-1.42976352446400	7.40841459047669	7.42260280884623	Inf];
epsilon=1e-3;
% % %  [g,g_pieces, num_of_pieces] = decrease_pieces_of_convex_function(simple_rho,simple_rho_pieces, epsilon, @get_nearest_convex_function_with_variable_pieces_of_given_num);
%  [g,g_pieces, num_of_pieces] = decrease_pieces_of_convex_function(simple_rho,simple_rho_pieces , epsilon, @algo3_new_model);
 [g,g_pieces, num_of_pieces] = decrease_pieces_of_convex_function(simple_rho,simple_rho_pieces , epsilon, @gurobi_algo3_new_model);
visualize( simple_rho,simple_rho_pieces,g,g_pieces);



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
