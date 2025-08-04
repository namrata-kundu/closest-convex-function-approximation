function [rho_vals,new_pieces, sol, objective] = nearest_convex_function_variable_pieces_of_a_given_number(f,pieces)
    yalmip('clear')
 
    boundary_limits = 10;
    upper_boundary = inf();
   
    
    [row_size,col_size] = size(f);
    
    %Boundary pieces convexity check
    if f(1,1)<0 || f(1,col_size)<0 %a1<0, an<0
        disp("Infeasible problem: Boundary pieces are not convex")
        return;
    end
    
    
    % left_slope = f(1,1)*pieces(2) + f(2,1);
    % right_slope = f(1,end)*pieces(end-1) + f(2,end);
    % if left_slope > right_slope
    %     disp("Infeasible problem: Seems like boundary pieces make the function nearly concave overall")
    %     return;
    % end
    
    
    if size(f,2)==1
        %check what needs to be done
    end
    
    %check if left tangent > right tangent
    if isinf(pieces(1)) && isinf(pieces(end))
        if 2*f(1,1)*pieces(2) + f(2,1) > 2*f(1,end)*pieces(end-1) + f(2,end)
            disp("Infeasible problem: left boundary piece tangent > right boundary piece tangent")
            return;
        end
    end
    
    number_of_function_pieces = col_size;
    new_number_of_function_pieces = number_of_function_pieces*10; %each piece will be divided into 10 pieces
    
    rho=[]; %resultant function matrix
    new_f = []; %(f divided into multiple pieces)
    
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
    
    new_pieces = [];
    granularity_of_pieces = 3; %(default to 1 - for having piece every 1 point)
    % construct new_f (f divided into multiple pieces)
    for i=1:size(bounds,2)-1
        left_bound = bounds(i);
        right_bound = bounds(i+1)-0.005; %Added 0.005 to not have repetative boundary points
        if (right_bound - left_bound) <= 1 && granularity_of_pieces== 1
            granularity_of_pieces =2;
        end
%         num_of_pieces = ceil(right_bound - left_bound)*granularity_of_pieces;
    num_of_pieces = granularity_of_pieces;
    %     num_of_pieces = round((right_bound - left_bound)/3);
        first_bound_row = linspace(left_bound,right_bound,(num_of_pieces));
        a_row = [f(1,i)*ones(1,(num_of_pieces))]; 
        b_row = [f(2,i)*ones(1,(num_of_pieces))]; 
        c_row = [f(3,i)*ones(1,(num_of_pieces))];
        
    %     new_np = cell(num_of_pieces-1,1);
        new_pieces = [new_pieces, left_bound]; 
        newp = [];
        for j = 1:num_of_pieces-2
    %         newp = [newp, sdpvar(1,1)];
            new_pieces = [new_pieces, sdpvar(1,1)];
        end
        new_pieces = [new_pieces, right_bound]; 
    %     new_pieces = [new_pieces newp];
            
    %     new_pieces = [new_pieces first_bound_row];
    %     values = [first_bound_row; a_row; b_row; c_row];
        values = [a_row; b_row; c_row];
        new_f = [new_f values];
    end
    
    new_pieces = [new_pieces right_boundary];
    
    Constraints9=[];
    
    % Allocate sdpvar variables
     
    n = size(new_f,2);
    a = sdpvar(1,n);
    b = sdpvar(1,n);
    c = sdpvar(1,n);
    rho = [a;b;c];
    % for i=1:n
    %     Constraints9 = [Constraints9, a(i)<=50, a(i)>=-50, b(i)<=50, b(i)>=-50, c(i)<=50, c(i)>=-50];
    % end
    
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
    
    %constraints for boundary to new pieces
%     epsilon = 0.00005;
%     for i=1:size(new_pieces,2)-1
%         con1= new_pieces(i) <= (new_pieces(i+1)-epsilon);
% %         Constraints1 = [Constraints1, con1]:'constraints1';
%         Constraints1 = [Constraints1, con1] ;
%     end

    epsilon = 0.00005;
    for i=2:size(new_pieces,2)-1
        con1= new_pieces(i) <= (new_pieces(i+1)-epsilon);
%         Constraints1 = [Constraints1, con1]:'constraints1';
        Constraints1 = [Constraints1, new_pieces(i-1) <= (new_pieces(i)-epsilon), new_pieces(i) <= (new_pieces(i+1)-epsilon)] ;
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
     
    for i=1:size(new_pieces,2)
        if class(new_pieces(i)) == 'sdpvar'
            assign(new_pieces(i),0);
    %         Constraints = [Constraints,left_boundary<= new_pieces(i),new_pieces(i) <=right_boundary];
        end
    end
    
     
    for i=1:size(rho,1)
        for j=1:size(rho,2)
            if class(rho(i,j)) == 'sdpvar'
                assign(rho(i,j),0);
    %             Constraints = [Constraints,-50<= rho(i,j), rho(i,j) <=50];
            end
        end
    end  
    
    Constraints=[Constraints1, Constraints2,Constraints3, Constraints4, Constraints5,Constraints6];%,  Constraints7,Constraints8, Constraints9, Constraints10];
    % check(Constraints)
    
    %  options = sdpsettings('solver','baron','baron.maxiter',10 ,'verbose', 2,'debug',1);
     options = sdpsettings('solver','baron','baron.maxiter',2  ,'verbose', 2, 'usex0',1,'debug',1);
    
    
    %Feed into solver
     
    sol = optimize([Constraints1, Constraints2,Constraints3, Constraints4, Constraints5,Constraints6,Constraints7],objective, options)
    disp(value(objective))
    % check(Constraints)
    
    new_pieces = convert_to_values(new_pieces);
    rho_vals = convert_to_values_rho(rho);
    
    % visualize(f,pieces,rho,new_pieces);
     
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


