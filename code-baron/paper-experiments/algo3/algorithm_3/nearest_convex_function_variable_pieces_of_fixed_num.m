function [rho,new_pieces,  objective, sol ] = nearest_convex_function_variable_pieces_of_fixed_num(f,pieces,no_of_pieces)
% NEAREST_CONVEX_FUNCTION_VARIABLE_PIECES_OF_FIXED_NUM - Algorithm 3 variant
% Find nearest convex function with fixed number of pieces
%
% This is a variant of the main algorithm used in Algorithm 3 experiments
%
% Inputs:
%   f - 3xN matrix defining the original piecewise quadratic function
%   pieces - breakpoint vector for the original function
%   no_of_pieces - desired number of pieces in the result
%
% Outputs:
%   rho - 3xM matrix defining the resulting convex function
%   new_pieces - breakpoint vector for the resulting function
%   objective - optimal objective value
%   sol - solver solution object

    boundary_limits = 100;
    [row_size,col_size] = size(f);
    
    %Boundary pieces convexity check
%     if f(1,1)<0 || f(1,col_size)<0 %a1<0, an<0
%         disp("Infeasible problem: Boundary pieces are not convex")
%         return;
%     end
 
    if size(f,2)==1
        %check what needs to be done
    end
    
    %check if left tangent > right tangent
%     if isinf(pieces(1)) && isinf(pieces(end))
%         if 2*f(1,1)*pieces(2) + f(2,1) > 2*f(1,end)*pieces(end-1) + f(2,end)
%             disp("Infeasible problem: left boundary piece tangent > right boundary piece tangent")
%             return;
%         end
%     end
          
    % boundary_limits = f(1,col_size) - f(1,2); %f(1,col_size) will always be > f(1,2)
    if pieces(1) == -inf()
        left_boundary = pieces(2) - boundary_limits; 
    else
        left_boundary = pieces(1);
    end
    
    if pieces(end) == inf()
        right_boundary = pieces(end-1) + boundary_limits;
    else
        right_boundary = pieces(end);
    end
        
    
    bounds = [pieces(1,:)];
    bounds(1) = left_boundary;
    bounds(end) = right_boundary;
    
    % Generate new breakpoints and function pieces
    [new_pieces, new_f] = multiple_set_breakpoints_of_given_number(f, bounds, no_of_pieces);

    % Allocate optimization variables for the resulting function
    n = size(new_f,2);
    a = sdpvar(1,n);  % quadratic coefficients
    b = sdpvar(1,n);  % linear coefficients
    c = sdpvar(1,n);  % constant coefficients
    rho = [a;b;c];    % resultant function matrix
    
    %Find integrals - area using symbolic integrals
    objective = 0;
    syms a_var b_var c_var x lb ub
    for i=1:size(new_f,2) %total_number_of_pieces = size(new_f,2);
        af=new_f(1,i);
        bf=new_f(2,i);
        cf=new_f(3,i);
        func = ((af*x*x + bf*x + cf) - (a_var*x*x + b_var*x + c_var))^2;
        lower_bound = new_pieces(i);
        upper_bound = new_pieces(i+1);
        symbolic_integral = int(func, [lb ub]);
        str_symbolic_integral = char(symbolic_integral);
        str_symbolic_integral = strrep(str_symbolic_integral, 'a_var', strcat('a(',num2str(i),')'));
        str_symbolic_integral = strrep(str_symbolic_integral, 'b_var', strcat('b(',num2str(i),')'));
        str_symbolic_integral = strrep(str_symbolic_integral, 'c_var', strcat('c(',num2str(i),')'));
        str_symbolic_integral = strrep(str_symbolic_integral, 'lb', strcat('new_pieces(',num2str(i),')'));
        str_symbolic_integral = strrep(str_symbolic_integral, 'ub', strcat('new_pieces(',num2str(i),'+1)'));
        integral = eval(str_symbolic_integral);
        objective = objective + integral;
    end
    
    
    %Build constraints
    Constraints = [];
    Constraints1 = [];
    Constraints2 = [];
    Constraints3 = [];Constraints4 = [];
    Constraints5 = [];
    Constraints6 = [];
    Constraints7 = [];
    % Constraints9 = [];
    Constraints10 = [];
    Constraints11 = [];
    
    %constraints for boundary to new pieces
    epsilon = 0.00005;
    for i=1:size(new_pieces,2)-1
        con1= new_pieces(i) <= (new_pieces(i+1)-epsilon);
        Constraints1 = [Constraints1, con1]:'constraints1';
    end
    
    %a>=0
    for i=1:size(new_f,2)
        Constraints2 = [Constraints2, rho(1,i)>=0]:'constraints2';
    end
    
     
    %rho_i(x_(i+1))=rho_(i+1)(x_(i+1))
    % for i=1:size(new_f,2)-2
    for i=1:size(new_f,2)-1
        x_val = new_pieces(i+1);
        ai_val = rho(1,i);
        bi_val = rho(2,i);
        ci_val = rho(3,i);
        aiplus1_val = rho(1,i+1);
        biplus1_val = rho(2,i+1);
        ciplus1_val = rho(3,i+1);
        
        Constraints3 = [Constraints3, ai_val*x_val*x_val + bi_val*x_val + ci_val == aiplus1_val*x_val*x_val + biplus1_val*x_val + ciplus1_val ]:'constraints3';
    end
    
    
    
     
    % rho_i'(x_(i+1))<=rho_(i+1)'(x_(i+1))
    for i=1:size(new_f,2)-1
        x_val = new_pieces(i+1);
        ai_val = rho(1,i);
        bi_val = rho(2,i);
        aiplus1_val = rho(1,i+1);
        biplus1_val = rho(2,i+1);
        
        Constraints4 = [Constraints4, 2*ai_val*x_val + bi_val <= 2*aiplus1_val*x_val + biplus1_val ]:'constraints4';
    end

 
    
    
    %last pieces should have function same as boundary
    if isinf(pieces(1))
        constraint1 = [rho(1,1)==f(1,1), rho(2,1)==f(2,1), rho(3,1)==f(3,1)];
    %     constraint1 = [value(rho(1,1))==f(1,1), value(rho(2,1))==f(2,1), value(rho(3,1))==f(3,1)];
        Constraints5 = [Constraints5 constraint1]:'constraints5';
    end
    if isinf(pieces(end))
        constraint2 = [rho(1,end)==f(1,end), rho(2,end)==f(2,end), rho(3,end)==f(3,end)];
        Constraints6 = [Constraints6 constraint2]:'constraints6';
    end 
     
    % for i=1:size(new_pieces,2)
    %     if class(new_pieces(i)) == 'sdpvar'
    %         cons7 = new_pieces(i) ~= 0;
    %         Constraints7 = [Constraints7, cons7];
    %     end
    % end
    
    % Constraints7=[Constraints7, nnz(new_pieces(5)) <= 5]:'constraints7';
    % Constraints7=[Constraints7, nnz(new_pieces) >= 10]:'constraints7';

    % Constraints8=[];
    % Constraints8=[Constraints8, new_pieces(1)>=left_boundary, new_pieces(end)<=right_boundary];
    % 
    % for i=1:size(new_pieces,2)
    %     if class(new_pieces(i))=='sdpvar'
    %         Constraints10 = [Constraints10, left_boundary<=new_pieces(i), new_pieces(i)<=right_boundary];
    %     end
    % end
     
    % for i=1:size(new_pieces,2)
    %     if class(new_pieces(i)) == 'sdpvar'
    %         assign(new_pieces(i),1);
    %     end
    % end
    % 
    %  
    % for i=1:size(rho,1)
    %     for j=1:size(rho,2)
    %         if class(rho(i,j)) == 'sdpvar'
    %             assign(rho(i,j),0);
    %         end
    %     end
    % end  

    % Set variable bounds based on function characteristics
    [y_lower_bound, y_upper_bound] = find_y_bounds(f, bounds);
    left_tangent_intercept = tangent_y_intercept( f(:,1), bounds(1));
    right_tangent_intercept = tangent_y_intercept( f(:,end), bounds(end));
    c_lb = min(left_tangent_intercept, right_tangent_intercept);

    % Variable bounds with safety margins
    Constraints_bounds = [0-500<=rho(1,:)<=1+500, ...
                         min(f(2,1), f(2,end))-500<=rho(2,:)<=max(f(2,1), f(2,end))+500, ...
                         c_lb-500<=rho(3,:)<=y_upper_bound+500];

    % Combine all constraints
    Constraints = [Constraints1, Constraints2, Constraints3, Constraints4, ...
                   Constraints5, Constraints6, Constraints7, Constraints_bounds];
    
     % Solver configuration for Algorithm 3
     options = sdpsettings('solver','baron', 'verbose', 2, 'debug', 1);
     % Alternative configurations (uncomment if needed):
     % options = sdpsettings('solver','baron', 'verbose', 2, 'debug', 1, 'threads', 14);
     % options = sdpsettings('solver','baron', 'verbose', 2, 'debug', 1, 'baron.RelConFeasTol', 0.1);
    
    
    % Solve optimization problem
    sol = optimize(Constraints, objective, options);
    disp(value(objective))
    check(Constraints)

    if pieces(1) == -inf()
        new_pieces(1) = pieces(1) ; 
    end
    
    if pieces(end) == inf()
        new_pieces(end) = pieces(end);
    end
    
    % Convert YALMIP variables to numerical values
    new_pieces = convert_to_values(new_pieces);
    rho = convert_to_values_rho(rho);

    % Uncomment to visualize results:
    % visualize(f,pieces,rho,new_pieces);
    % visualize(new_f,new_pieces,rho,new_pieces);

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


