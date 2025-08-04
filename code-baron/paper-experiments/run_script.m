%W function
pieces = [-inf(), -5, 0, 5, inf()];
f = [0, 0, 0, 0;
    -1, 1, -1, 1;
    -5, 5, 5, -5];
% pieces = [-inf(), 1, 2.5, 6, inf()];
% f = [
%     (1/2), 0, 0, 0;
%     0, 2, -1, 1;
%     1, -(1/2), 7, -5];

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


% pieces = [-inf(), 1, 2.5, 6];
% f = [
%     (1/2), 0, 0;
%     0, 2, -1;
%     1, -(1/2), 7];
% pieces = [-inf(), 1, 2.5, 6, inf()];
% f = [
%     (1/2), 0, 0, 0;
%     0, 2, -1, 1;
%     1, -(1/2), 7, -5];

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
% [rho,new_pieces, sol, objective] =  qcqp_nearest_convex_function_variable_pieces_of_a_given_number(f,pieces)
% [rho,new_pieces, sol, objective] =  gurobi_algo2(f,pieces)
% 
% [rho,new_pieces, sol, objective] =  qcqp_norm_nearest_convex_function_variable_pieces(f,pieces)
[rho,new_pieces, sol, objective] =   nearest_convex_function_variable_pieces_of_a_given_number(f,pieces)

visualize(f,pieces,rho,new_pieces);