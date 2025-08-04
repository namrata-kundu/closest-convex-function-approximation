yalmip('clear')
a = [-0.0019795	-0.0025	0	0.0025	-0.0025	0	0	0	0	0	0	0	0	0	0.005	-0.0025	-0.0025	0.005	-0.005	-4.7835e-16	0.0050044];
b = [0.07918	0	-0.1	-0.1	0	-0.1	-0.1	-0.1	-0.1	-0.1	-0.1	-0.1	-0.1	-0.1	-0.1	0.1	0	-0.1	0.1	-0.1	-0.1];
c = [2316.2	2317	2316	2314	2313	2312	2310	2308	2306	2304	2302	2300	2298	2296	2294	2294	2295	2294	2294	2294	2292];
pieces = [0	20	40	60	80	100	120	140	160	180	200	220	240	260	280	300	320	340	360	380	400 419.98];
 
A=[];
B=[];
C=[];
for i=1:size(a,2)
    A = [A, a(i)];
    B = [B, -2*a(i)*pieces(i) + b(i)];
    C = [C, a(i)*pieces(i)^2 - b(i)*pieces(i) + c(i)];
end
f=[A;B;C];
% pieces = [-22, 1, 2.5, 6, 22];
% f = [
%     (1/2), 0, 0, 0;
%     0, 2, -1, 1;
%     1, -(1/2), 7, -5];

% pieces = [-22, -5, 0, 5, 22];
% f = [0, 0, 0, 0;
%     -1, 1, -1, 1;
%     -5, 5, 5, -5];
epsilon=1e-3;
visualize(f, pieces, f,pieces); 
no_of_pieces = size(f,2)*2;
% no_of_pieces = size(f,2)*8;
% % % % [rho,new_pieces,  objective]  = nearest_convex_function_variable_pieces_of_fixed_num(f,pieces,no_of_pieces);
% % %   [simple_rho,simple_rho_pieces ] = simple_merging_based_on_values(f,pieces, epsilon);
% % %  visualize(f, pieces, rho,new_pieces); 
% % %    visualize(rho,new_pieces,simple_rho,simple_rho_pieces);
% % % % [g,g_pieces, num_of_pieces] = decrease_pieces_of_convex_function(simple_rho,simple_rho_pieces, epsilon, @ngetexp_nearest_function_with_variable_pieces_of_given_num);
% % %  [g,g_pieces, num_of_pieces, obj] = decrease_pieces_of_convex_function(simple_rho,simple_rho_pieces , epsilon, @baron_algo4_new_model);

tStarttic = tic;  
 [simple_rho,simple_rho_pieces ] = simple_merging_based_on_values(f, pieces, epsilon);
%  visualize(f, pieces,simple_rho,simple_rho_pieces); 
% % %    visualize(rho,new_pieces,simple_rho,simple_rho_pieces);
% visualize(f, pieces,simple_rho,simple_rho_pieces);
 [g,g_pieces, num_of_pieces] = decrease_pieces_of_convex_function(simple_rho,simple_rho_pieces, epsilon, @baron_algo4_new_model);

%   [g,g_pieces, num_of_pieces] = decrease_pieces_of_convex_function(simple_rho,simple_rho_pieces, epsilon, @nget_nearest_convex_function_with_variable_pieces_of_given_num);
 [g,g_pieces, num_of_pieces] = decrease_pieces_of_convex_function(simple_rho(1:3,1:6),simple_rho_pieces(1,1:7), epsilon, @baron_algo4_new_model);
[g,g_pieces, num_of_pieces] = decrease_pieces_of_convex_function(simple_rho(1:3,6:end),simple_rho_pieces(1,6:end), epsilon, @baron_algo4_new_model);
% [g,g_pieces, num_of_pieces] = decrease_pieces_of_convex_function(simple_rho ,simple_rho_pieces , epsilon, @ngetexp_nearest_function_with_variable_pieces_of_given_num);
endtic=toc(tStarttic)
disp(g_pieces)
disp(g)
% visualize(f, pieces,g,g_pieces);
%     g = convert_to_values_rho(g);
%     g_pieces = convert_to_values(g_pieces);
%  visualize( simple_rho,simple_rho_pieces,g,g_pieces);
% % % tStarttic = tic 
% % %  [simple_rho,simple_rho_pieces ] = simple_merging_based_on_values(f, pieces, epsilon);
% % % %  visualize(f, pieces,simple_rho,simple_rho_pieces); 
% % % % % %    visualize(rho,new_pieces,simple_rho,simple_rho_pieces);
% % % % visualize(f, pieces,simple_rho,simple_rho_pieces);
% % %  [g,g_pieces, num_of_pieces] = decrease_pieces_of_convex_function(simple_rho,simple_rho_pieces, epsilon, @gurobi_algo4_new_model);
% % % 
% % % %   [g,g_pieces, num_of_pieces] = decrease_pieces_of_convex_function(simple_rho,simple_rho_pieces, epsilon, @nget_nearest_convex_function_with_variable_pieces_of_given_num);
% % %  [g,g_pieces, num_of_pieces] = decrease_pieces_of_convex_function(simple_rho(1:3,1:6),simple_rho_pieces(1,1:7), epsilon, @gurobi_algo4_new_model);
% % % [g,g_pieces, num_of_pieces] = decrease_pieces_of_convex_function(simple_rho(1:3,6:end),simple_rho_pieces(1,6:end), epsilon, @gurobi_algo4_new_model);
% % % % [g,g_pieces, num_of_pieces] = decrease_pieces_of_convex_function(simple_rho ,simple_rho_pieces , epsilon, @ngetexp_nearest_function_with_variable_pieces_of_given_num);
% % % endtic=toc(tStarttic)
% % % disp(g_pieces)
% % % disp(g)
% % % visualize(f, pieces,g,g_pieces);
%  [g,g_pieces, num_of_pieces] = decrease_pieces_of_convex_function(simple_rho,simple_rho_pieces , epsilon, @gurobi_algo4_new_model);
% visualize( rho,new_pieces,g,g_pieces);



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
