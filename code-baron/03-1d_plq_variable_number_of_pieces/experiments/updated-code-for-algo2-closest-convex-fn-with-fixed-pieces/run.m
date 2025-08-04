yalmip('clear')
% W function
pieces = [-inf(), -5, 0, 5, inf()];
f = [0, 0, 0, 0;
    -1, 1, -1, 1;
    -5, 5, 5, -5];
% 
pieces = [-inf(), 1, 2.5, 6, inf()];
f = [
    (1/2), 0, 0, 0;
    0, 2, -1, 1;
    1, -(1/2), 7, -5];
% pieces = [-inf(), -1, 0, 1, inf()];
% f = [
%    1, -1, -1, 1 ;
%     0, 1 ,-1, 0 ;
%     0, 0, 0, 0 ];
% pieces = [-inf(), 1, inf()];
% f = [
%     (1/2), 0;
%     0, 2;
%     1, -(1/2)];
pieces = [-inf(), -3.64, 3.64, inf()];
f = [
    1,0,1
    16,0,-16
    63,20,63
];

% f =[2.27088650383994,0,1
% 44.5426132101094,0,-16
% 223.258364220641,20,63];


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
% visualize_road(f,pieces,f,pieces);
visualize(f,pieces,f,pieces);

epsilon=0.0000005;
epsilon=1e-3;
get_nearest_convex_function_with_optimal_number_of_pieces(f,pieces);
% [rho,new_pieces,  objective]  = nearest_convex_function_variable_pieces(f,pieces);