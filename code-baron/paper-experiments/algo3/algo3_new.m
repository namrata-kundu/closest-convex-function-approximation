
function  [g, g_pieces, objective] = algo3_new(f, pieces, num_of_pieces)
%     yalmip('clear')
 
    boundary_limits = 10;
    g = [];
     
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

   if num_of_pieces==1 
        g_pieces = [left_boundary, left_boundary+0.0005, right_boundary-0.0005, right_boundary];
   elseif num_of_pieces==2
        g_pieces = [left_boundary, left_boundary+0.0005, sdpvar(1,1,'full'), right_boundary-0.0005,  right_boundary];
    else
        g_pieces = [left_boundary, sdpvar(1,num_of_pieces-1,'full'), right_boundary];
    end

    n = size(bounds,2)-1;
    r = size(g_pieces,2)-1;
%     coeffs = binvar(1,(r)*(n));

    a = sdpvar(1,r,'full');
    b = sdpvar(1,r,'full');
    c = sdpvar(1,r,'full');
    g = [a;b;c];

    objective = 0;
%     coeffs_iter=1;
    syms a_var b_var c_var x 
    for g_j=1:r
        for i=1:n  
            af=f(1,i);
            bf=f(2,i);
            cf=f(3,i);
            func = ((af*x*x + bf*x + cf) - (a_var*x*x + b_var*x + c_var))^2;
            lower_bound = bounds(i);
            upper_bound = bounds(i+1);
            symbolic_integral = int(func, [lower_bound upper_bound]);
            str_symbolic_integral = char(symbolic_integral);
            str_symbolic_integral = strrep(str_symbolic_integral, 'a_var', strcat('g(1,',num2str(g_j),')'));
            str_symbolic_integral = strrep(str_symbolic_integral, 'b_var', strcat('g(2,',num2str(g_j),')'));
            str_symbolic_integral = strrep(str_symbolic_integral, 'c_var', strcat('g(3,',num2str(g_j),')'));
            integral = eval(str_symbolic_integral);
            objective = objective + integral;
%             coeffs_iter=coeffs_iter+1;
        end
    end

    %Build constraints
    Constraints = [];
    
    %a>=0
    for i=1:size(g,2)
        Constraints = [Constraints, g(1,i)>=0];
    end

    %rho_i(x_(i+1))=rho_(i+1)(x_(i+1))
    for i=1:size(g_pieces,2)-2 %check 1 or 2
        x_val = g_pieces(i+1);
        ai_val = g(1,i);
        bi_val = g(2,i);
        ci_val = g(3,i);
        aiplus1_val = g(1,i+1);
        biplus1_val = g(2,i+1);
        ciplus1_val = g(3,i+1);
        
        Constraints = [Constraints, ai_val*x_val*x_val + bi_val*x_val + ci_val == aiplus1_val*x_val*x_val + biplus1_val*x_val + ciplus1_val ];
    end
 
    % rho_i'(x_(i+1))<=rho_(i+1)'(x_(i+1))
    for i=1:size(g_pieces,2)-2 %check 1 or 2
        x_val = g_pieces(i+1);
        ai_val = g(1,i);
        bi_val = g(2,i);
        aiplus1_val = g(1,i+1);
        biplus1_val = g(2,i+1);
        
        Constraints = [Constraints, 2*ai_val*x_val + bi_val <= 2*aiplus1_val*x_val + biplus1_val ];
    end

    ep = 0.005;
    for i=1:r
         Constraints = [Constraints, g_pieces(i) <= (g_pieces(i+1)-ep)] ;
    end



%         %Constraint to have n - zeroes within each consecutive set of ones
%         f_size_block = size(f,2); 
%         d1 = binvar(size(coeffs,2)-f_size_block-1,1);
%         for i=1:size(coeffs,2)-f_size_block-1
%              Constraints = [Constraints, implies(d1(i), coeffs(i)==1 & sum(coeffs(i+1:(i+f_size_block)))==0 & coeffs(i+f_size_block+1)==1)];
%         end
%         Constraints = [Constraints, sum(d1) == size(g,2)-1];
% 
%         %constraint to have atleast one 1 and atmost
%         %(size(f)-size(g)-1) 1 in each column 
%         d2 = binvar(size(coeffs,2)-f_size_block+1,1);
%         max_ones_in_each_ff_size_block = ((size(f,2)-1 )- (size(g,2)-1));
%         for i=1:size(coeffs,2)-f_size_block
%                 Constraints = [Constraints, implies(d2(i), max_ones_in_each_ff_size_block >=sum(coeffs(i:(i+f_size_block)))>=1)];
%         end
%         Constraints = [Constraints, sum(d2) == size(coeffs,2)-f_size_block];
% 
%         %constraint for first and last index of coeff[] = 1
%         Constraints = [Constraints, coeffs(1)==1, coeffs(end)==1];

% %         %constraint to keep breakpoints in g and subset of breakpoints in f
% %         for i=1:size(g_pieces,2)
% %             if class(g_pieces(i)) == 'sdpvar'
% %                 d3 = binvar(size(f,2)-2,1);
% %                 for k=1:size(f,2)-2
% %                     Constraints = [Constraints, implies(d3(k), g_pieces(i)==f(1+k))];
% %                 end
% %                 Constraints = [Constraints, sum(d3) == 1];
% % 
% %             end
% %         end

        Constraints = [Constraints, ismember(g_pieces(2:r), bounds(2:n))];


    u = binvar(n+2,r);
    v = intvar(n+1,r);
    w = binvar(n+1,r);
    Constraints = [Constraints, u(2,1)==1];
         Constraints = [Constraints, u(n+1,r)==1];
        
       for j=1:r
        Constraints = [Constraints, u(1,j)==0];
        Constraints = [Constraints, u(n+2,j)==0];
       end

      
       for i=2:n+1
            u_row_sum=0;
           for j = 1:r
                u_row_sum = u_row_sum + u(i,j);
           end
           Constraints = [Constraints, u_row_sum == 1];
       end

        for j = 1:r
            u_column_sum=0;
            for i=1:n+2
                u_column_sum = u_column_sum + u(i,j);
           end
           Constraints = [Constraints, u_column_sum >= 1];
        end

        for i=1:n+1
            for j=1:r
                v(i,j) = u(i+1,j)-u(i,j);
%                 Constraints = [Constraints, v(i,j) ==1 | v(i,j)==0 | v(i,j)==-1 ];
                Constraints = [Constraints, w(i,j) ==v(i,j)*v(i,j) ];
            end
        end

        for j = 1:r
            v_column_sum=0;
            w_column_sum=0;
            for i=1:n+1
                v_column_sum = v_column_sum + v(i,j);
                w_column_sum = w_column_sum + w(i,j);
           end
           Constraints = [Constraints, v_column_sum == 0];
           Constraints = [Constraints, w_column_sum == 2];
        end

        for i=2:n
            v_row_sum=0;
           for j = 1:r
                v_row_sum = v_row_sum + v(i,j);
           end
           Constraints = [Constraints, v_row_sum == 0];
       end


       Constraints = [Constraints, v(1,1) == 1];
       Constraints = [Constraints, v(n+1,r) == -1];


%        %total sum of coeff = size(f)
%     Constraints = [Constraints, sum(coeffs) == (size(f,2)-1 )];

    %last pieces should have function same as boundary if boundaries go to
    %infinity
%     if num_of_pieces>1
        if isinf(pieces(1))
            constraint1 = [g(1,1)==f(1,1), g(2,1)==f(2,1), g(3,1)==f(3,1)];
            Constraints = [Constraints constraint1];
        end
        if isinf(pieces(end))
            constraint2 = [g(1,end)==f(1,end), g(2,end)==f(2,end), g(3,end)==f(3,end)];
            Constraints = [Constraints constraint2];
        end
%     end


    UsedInObjective = allvariables(objective);
     [y_lower_bound, y_upper_bound] = find_y_bounds(f, bounds);
    
     c_lb = min(f(3,1), f(3,end));
     Constraints_more = [0<=g(1,:)<=1+1000, f(2,1)-1000<=g(2,:)<=f(2,end)+1000, c_lb-1000<=g(3,:)<=y_upper_bound+1000];
options = sdpsettings('solver','baron', 'baron.maxiter',1000, 'verbose',3);

    sol = optimize([Constraints,  Constraints_more ], objective, options)

    disp(value(objective));
    objective = value(objective);

    g = convert_to_values_rho(g);
    g_pieces = convert_to_values(g_pieces);
%     coeff_val=convert_to_values(coeffs);
%     check(Constraints)
     visualize(f,pieces,g,g_pieces);

end

function val = convert_to_values(g_pieces)
    val = [];
    for i=1:size(g_pieces,2)
        val = [val value(g_pieces(i))];
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

