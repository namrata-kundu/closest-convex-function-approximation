%W function
pieces = [-inf(), -5, 0, 5, inf()];
f = [0, 0, 0, 0;
    -1, 1, -1, 1;
    -5, 5, 5, -5];

pieces_modified_with_boundary=pieces;
if isinf(pieces(1))
    pieces_modified_with_boundary(1) = pieces(2)-20;
end

if isinf(pieces(end))
    pieces_modified_with_boundary(end) = pieces(end-1)+20;
end

mean_solver_time=[];
mean_total_time_with_yalmip = [];

min_solver_time=[];
min_total_time_with_yalmip = [];

obj=[];
for n=3:50
    new_p = [];
    new_f=[];
    p=[];
    sol_time_col = [];
    tot_time_col = [];
    for i=1:size(pieces_modified_with_boundary,2)-1
        left_bound=pieces_modified_with_boundary(i);
        right_bound = pieces_modified_with_boundary(i+1);
        
        
        p= linspace(left_bound,right_bound,n);
        a_row = [f(1,i)*ones(1,(n-1))]; 
        b_row = [f(2,i)*ones(1,(n-1))]; 
        c_row = [f(3,i)*ones(1,(n-1))];

        new_p = [new_p, p(1:end-1)]; 
        
        values = [a_row; b_row; c_row];
        new_f = [new_f values];
        
    end
    new_p = [new_p, p(end) ]; 
    for i=1:3
        [rho,new_pieces, sol, objective] = nearest_convex_function_variable_pieces_of_a_given_number(new_f,new_p)
        sol_time_col = [sol_time_col; sol.solvertime];
        tot_time_col = [tot_time_col; sol.solvertime+ sol.yalmiptime];
    end

    obj=[obj, value(objective)]
    mean_solver_time = [mean_solver_time, mean(sol_time_col)];
    mean_total_time_with_yalmip = [mean_total_time_with_yalmip, mean(tot_time_col) ];
    min_solver_time = [min_solver_time, min(sol_time_col)];
    min_total_time_with_yalmip = [min_total_time_with_yalmip, min(tot_time_col) ];
end

n=(3:50);
figure;

plot(n, mean_solver_time)
xlabel('n');
ylabel('mean_solver_time');
title('mean_solver_time  ');


figure;
plot(n, mean_total_time_with_yalmip)
xlabel('n');
ylabel('mean_total_time_with_yalmip');
title('mean_total_time_with_yalmip');

figure;
plot(n, min_solver_time)
xlabel('n');
ylabel('min_solver_time');
title('min_solver_time');

figure;
plot(n, min_total_time_with_yalmip)
xlabel('n');
ylabel('min_total_time_with_yalmip');
title('min_total_time_with_yalmip');


% new_pieces = convert_to_values(new_pieces);
%     rho_vals = convert_to_values_rho(rho);
    
%  visualize(f,pieces,rho,new_pieces);


% function val = convert_to_values(new_pieces)
%     val = [];
%     for i=1:size(new_pieces,2)
%         val = [val value(new_pieces(i))];
%     end        
% end
% 
% 
% function val = convert_to_values_rho(rho)
%     val = [];
%     for i=1:size(rho,1)
%         val_row = [];
%         for j=1:size(rho,2)
%             val_row = [val_row value(rho(i,j))];
%         end
%         val = [val; val_row];
%     end        
% end
