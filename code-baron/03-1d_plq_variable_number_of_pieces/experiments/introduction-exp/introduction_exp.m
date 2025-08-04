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
epsilon=0.0000005;
epsilon=1e-3;

envpieces = [-22, -5, 0, 5, 22];
fenv = [0, 0, 0, 0;
    -1, 0, 0, 1;
    -5, 0, 0, -5];

no_of_pieces = size(f,2)*3;%%Not working
[rho,new_pieces,  objective]  = nearest_convex_function_variable_pieces_of_fixed_num(f,pieces,no_of_pieces);
  [simple_rho,simple_rho_pieces ] = simple_merging_based_on_values(rho,new_pieces, epsilon);
 visualize(f, pieces, rho,new_pieces); 
 visualize(f, pieces, fenv,envpieces); 
   visualize(rho,new_pieces,simple_rho,simple_rho_pieces);

objective = 0;
for i=1:size(f,2) %total_number_of_pieces = size(new_f,2);
    af=f(1,i);
    bf=f(2,i);
    cf=f(3,i);
    a_var=fenv(1,i);
    b_var=fenv(2,i);
    c_var=fenv(3,i);
    func = ((af*x*x + bf*x + cf) - (a_var*x*x + b_var*x + c_var))^2;
    lower_bound =  pieces(i);
    upper_bound =  pieces(i+1);
    symbolic_integral = int(func, [lower_bound upper_bound]);
%     str_symbolic_integral = char(symbolic_integral);
%     str_symbolic_integral = strrep(str_symbolic_integral, 'a_var', strcat('a{',num2str(i),'}'));
%     str_symbolic_integral = strrep(str_symbolic_integral, 'b_var', strcat('b{',num2str(i),'}'));
%     str_symbolic_integral = strrep(str_symbolic_integral, 'c_var', strcat('c{',num2str(i),'}'));
%     integral = eval(str_symbolic_integral);
    objective = objective + symbolic_integral 
end

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
