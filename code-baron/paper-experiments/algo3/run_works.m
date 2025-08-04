yalmip('clear')
% W function
pieces = [-22, -5, 0, 5, 22];
f = [0, 0, 0, 0;
    -1, 1, -1, 1;
    -5, 5, 5, -5];
% 
% pieces = [-inf(), 1, 2.5, 6, inf()];
% f = [
%     (1/2), 0, 0, 0;
%     0, 2, -1, 1;
%     1, -(1/2), 7, -5];
% 
% pieces = [-inf(), -6, 9];
% f = [
%     0, -1;
%     12, 0;
%     37, 1];

% pieces = [-inf(),0,2,inf()];
% f = [
%     1,-1,1;
%     -2,6,-2;
%     -1,-9,-1;
% ];


% % pieces = [-inf(), 1, 2.5, 6];
% % f = [
% %     (1/2), 0, 0;
% %     0, 2, -1;
% %     1, -(1/2), 7];
% pieces = [-inf(), -1, 0, 1, inf()];
% f = [
%    1, -1, -1, 1 ;
%     0, 1 ,-1, 0 ;
%     0, 0, 0, 0 ];
% pieces = [-inf(), 1, inf()];
% f = [
%     5, 0;
%     0, 2;
%     1, -(1/2)];


% epsilon=0.0000005;
% epsilon=1e-3;
% [rho,new_pieces,  objective]  = nearest_convex_function_variable_pieces_of_fixed_num(f,pieces, 8);
% visualize(rho,new_pieces,f,pieces);
% 
% pieces = [-inf(), -3.64, 3.64, inf()];
% f = [
%     1,0,1
%     16,0,-16
%     63,20,63
% ];

% pieces = [-inf(), 0, inf()];
% f = [
%     1,1
%     16,-16
%     63,63
% ];
% 
% 
% pieces = [-inf(), -10,0,10, inf()];
% f = [
%     1,1,1,1
%     16,16,-16,-16
%     63, 63,63,63
% ];

% f =[2.27088650383994,0,1
% 44.5426132101094,0,-16
% 223.258364220641,20,63];
% pieces = [0,3,9,10];
% f = [
%   -1,-1,-1;
%   0,0,0;
%   0,0,0;
% ];
% %case 2
% pieces = [-inf(),-60,-3,inf()];
% f = [
%     0,-1,1 ;
%     101, -19, -19;
%     3604, 4, -14;
% ];

% f = [
%     0,-1,1 ;
%     1, -19, -19;
%     -2456, 4, -14;
% ];
% pieces = [-inf(),-3,inf()];
% f = [
%     -1,1 ;
%     -19, -19;
%     4, -14;
% ];

% pieces = [-10,5,10];
% f = [
%     -1,-1 ;
%     -19,-19 ;
%     4,4 ;
% ];

% pieces= [-inf() 80 100 280 300 340 360	380	400	inf()];
% 
% f=[ 0.0025, -0.00250, 0, 0.0050,-0.0025, 0.0050, -0.005, -4.78350000000000e-16, 0.005004400;
% -0.40, 0.40, -0.1,-2.9, 1.6, -3.5, 3.7, -0.1, -4.103520;
%  2329, 2297, 2322, 2714, 2039, 2906, 1610, 2331.99999999993, 3132.7040;
% ];
pieces = [-inf(), 1, 2.5, 6, inf()];
f = [
    (1/2), 0, 0, 0;
    0, 2, -1, 1;
    1, -(1/2), 7, -5];
epsilon=0.0000005;
epsilon=1e-3;
% [rho,new_pieces]=get_nearest_convex_function_with_optimal_number_of_pieces(f,pieces);
visualize(f, pieces, f,pieces); 
% [rho,new_pieces,  objective]  = nearest_convex_function_variable_pieces(f,pieces);
no_of_pieces = size(f,2)*2;%%Not working
% % % no_of_pieces = size(f,2)*15; %Working = why? %%%PAPER - COMPLETES BUT WITH WEIRD RESULT - CHECK
[rho,new_pieces,  objective]  = nearest_convex_function_variable_pieces_of_fixed_num(f,pieces,no_of_pieces);
  [simple_rho,simple_rho_pieces ] = simple_merging_based_on_values(rho,new_pieces, epsilon);
% % %  visualize(f, pieces, rho,new_pieces); 
% % %    visualize(rho,new_pieces,simple_rho,simple_rho_pieces);
% visualize(rho,new_pieces,simple_rho,simple_rho_pieces);
[g,g_pieces, num_of_pieces] = decrease_pieces_of_convex_function(rho,new_pieces, epsilon, @get_nearest_convex_function_with_variable_pieces_of_given_num);
% % %  [g,g_pieces, num_of_pieces] = decrease_pieces_of_convex_function(simple_rho,simple_rho_pieces, epsilon, @nget_nearest_convex_function_with_variable_pieces_of_given_num);
% % [g,g_pieces, num_of_pieces] = decrease_pieces_of_convex_function(rho,new_pieces, epsilon, @algo3_new_correct);
% [g,g_pieces, num_of_pieces] = decrease_pieces_of_convex_function(simple_rho,simple_rho_pieces , epsilon, @algo3_new_correct);
%  [g,g_pieces, num_of_pieces] = decrease_pieces_of_convex_function(simple_rho,simple_rho_pieces , epsilon, @Copy_of_algo3_debug);
 [g,g_pieces, num_of_pieces] = decrease_pieces_of_convex_function(simple_rho,simple_rho_pieces , epsilon, @algo3_baron_call);
visualize( rho,new_pieces,g,g_pieces);

% [g,g_pieces, num_of_pieces] = decrease_pieces_of_convex_function(simple_rho,simple_rho_pieces, epsilon, @nget_nearest_convex_function_with_variable_pieces_of_given_num);
% visualize( rho,new_pieces,g,g_pieces);

% [g,g_pieces, num_of_pieces] = decrease_pieces_of_convex_function(rho,new_pieces, epsilon);

% disp(value(objective))
disp(size(new_pieces,2)-1)
% disp( num_of_pieces )


% g_pieces = convert_to_values(g_pieces);
% rho_vals = convert_to_values_rho(g);

g_pieces = [-inf(), -7.073385619767408,7.071067811798360, inf()];
g=[0,0,0;
    -1,0,1;
    -5,2.071067820771636,-5;
    ];

% visualize(rho,new_pieces,g,g_pieces);
visualize( g,g_pieces,g,g_pieces);


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
