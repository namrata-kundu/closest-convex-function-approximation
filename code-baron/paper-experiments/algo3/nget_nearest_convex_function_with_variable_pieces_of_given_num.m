
function  [g, g_pieces, objective] = nget_nearest_convex_function_with_variable_pieces_of_given_num(f, pieces, num_of_pieces)
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

   if num_of_pieces==1 %TODO: giving NaN - check WHY!!!
        g_pieces = [left_boundary, left_boundary+0.0005, right_boundary-0.0005, right_boundary];
   elseif num_of_pieces==2
        g_pieces = [left_boundary, left_boundary+0.0005, sdpvar(1,1,'full'), right_boundary-0.0005,  right_boundary];
    else
        g_pieces = [left_boundary, sdpvar(1,num_of_pieces-1,'full'), right_boundary];
%         g_pieces = [left_boundary, bounds(2), sdpvar(1,num_of_pieces-1,'full'), bounds(end-1),  right_boundary];
    end
%     coeffs = binvar(1,size(pieces,2)-1);
%     coeffs = binvar(1,(size(g_pieces,2)-3)*(size(bounds,2)-3));
    coeffs = binvar(1,(size(g_pieces,2)-1)*(size(bounds,2)-1));

%     a = sdpvar(1,num_of_pieces,'full');
%     b = sdpvar(1,num_of_pieces,'full');
%     c = sdpvar(1,num_of_pieces,'full'); %Commenting this, because for
%     num_of_pieces =1,2,g_pieces is different
    a = sdpvar(1,size(g_pieces,2)-1,'full');
    b = sdpvar(1,size(g_pieces,2)-1,'full');
    c = sdpvar(1,size(g_pieces,2)-1,'full');
    g = [a;b;c];

    lambda = 1e-3; % Regularization parameter

    objective = 0;
    coeffs_iter=1;
%     check = '';
    syms a_var b_var c_var x 
    blas='';
    for g_j=1:size(g_pieces,2)-1
        for i=1:size(bounds,2)-1  
            af=f(1,i);
            bf=f(2,i);
            cf=f(3,i);
            func = ((af*x*x + bf*x + cf) - (a_var*x*x + b_var*x + c_var))^2;
            lower_bound = bounds(i);
            upper_bound = bounds(i+1);
            symbolic_integral = int(func, [lower_bound upper_bound]);
            str_symbolic_integral = char(symbolic_integral);
%             blas = append(blas,"+",str_symbolic_integral)
            str_symbolic_integral = strrep(str_symbolic_integral, 'a_var', strcat('g(1,',num2str(g_j),')'));
            str_symbolic_integral = strrep(str_symbolic_integral, 'b_var', strcat('g(2,',num2str(g_j),')'));
            str_symbolic_integral = strrep(str_symbolic_integral, 'c_var', strcat('g(3,',num2str(g_j),')'));
            integral = eval(str_symbolic_integral);
            objective = objective + coeffs(coeffs_iter)*integral;
%             check = strcat(check, "coeff_iter=", num2str(coeffs_iter)," ---- (", num2str(lower_bound),", ", num2str(upper_bound),") for f(",num2str(i),"), g(",num2str(g_j),")....\n");
            coeffs_iter=coeffs_iter+1;
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

    ep = 0.000005;
    for i=1:size(g_pieces,2)-1
         Constraints = [Constraints, g_pieces(i) <= (g_pieces(i+1)-ep)] ;
    end
% 
%         for i=1:size(g_pieces,2)
%             if class(g_pieces(i)) == 'sdpvar'
%     %             sdp_g_pieces = [sdp_g_pieces; g_pieces(i)];
%             Constraints = [Constraints, ismember(g_pieces(i),bounds(3:end-2))];
%     %             d = binvar(size(bounds,2)-4,1);
%     %             Constraints = [Constraints, [g_pieces(i)]==bounds(3:end-2)*d, sum(d)==1];
%     %         Constraints = [Constraints, sum(g_pieces(i),bounds(3:end-2))==1];
%             end
%         end
%     
%         for j =1:3
%             for i=1:size(g_pieces,2)-1
%         %             sdp_g_pieces = [sdp_g_pieces; g_pieces(i)];
%                 Constraints = [Constraints, ismember(g(j,i),f(j,:))];
%     %                 d = binvar(size(bounds,2)-1,1);
%     %                 Constraints = [Constraints, [g(j,i)]==f(j,:)*d, sum(d)==1];
%     %             Constraints = [Constraints, sum(g(j,i),f(j,:))==1];
%             end
%         end


        %the below constraint is to make sure g_pieces takes value from
        %discrete value of bounds (i'm assuming after 3 weeks of writing
        %this code)- but this should make this optimization combinatorial.
            f_size_block = size(f,2); 
% %         for i=2:size(coeffs,2)-f_size_block-1
%         for i=2:size(coeffs,2)-f_size_block 
%             d1 = binvar(f_size_block,1);
%             for k=1:size(d1,2)
% %                 Constraints = [Constraints, implies(d1(k), sum(coeffs(i:(i+f_size_block-1)))==0)];
%                 Constraints = [Constraints, implies(d1(k), sum(coeffs(i:(i+f_size_block)))<=1)];
%             end
%             Constraints = [Constraints, sum(d1) == 1];
% 
%         end

%         for i=2:size(coeffs,2)-f_size_block-1
% % % % %         d1 = binvar(size(coeffs,2)-f_size_block,1);
% % % % %         for i=1:size(coeffs,2)-f_size_block 
% % % % % %                 Constraints = [Constraints, implies(d1(k), sum(coeffs(i:(i+f_size_block-1)))==0)];
% % % % % %                 Constraints = [Constraints, implies(d1(i), sum(coeffs(i:(i+f_size_block)))<=1)];
% % % % %              Constraints = [Constraints, implies(d1(i), sum(coeffs(i:(i+f_size_block)))==1)];
% % % % %         end
% % % % %         Constraints = [Constraints, sum(d1) == size(g,2)+1];


        d1 = binvar(size(coeffs,2)-f_size_block-1,1);
        for i=1:size(coeffs,2)-f_size_block-1
%                 Constraints = [Constraints, implies(d1(k), sum(coeffs(i:(i+f_size_block-1)))==0)];
%                 Constraints = [Constraints, implies(d1(i), sum(coeffs(i:(i+f_size_block)))<=1)];
             Constraints = [Constraints, implies(d1(i), coeffs(i)==1 & sum(coeffs(i+1:(i+f_size_block)))==0 & coeffs(i+f_size_block+1)==1)];
        end
        Constraints = [Constraints, sum(d1) == size(g,2)-1];

%%%WRONG BELOW
% %         for i=2:size(coeffs,2)-f_size_block-1
%         for i=1:f_size_block :size(coeffs,2)
%             d1 = binvar(f_size_block,1);
%             for k=0:size(d1,2)-1
% %                 Constraints = [Constraints, implies(d1(k), sum(coeffs(i:(i+f_size_block-1)))==0)];
%                 Constraints = [Constraints, implies(d1(k), sum(coeffs(i+k:(i+k+f_size_block)))<=1)];
%             end
%             Constraints = [Constraints, sum(d1) == 1];
% 
%         end

        
%         for i=1:size(coeffs,2)-f_size_block
%             d2 = binvar(f_size_block+1,1);
%             for k=1:size(d2,2)
%                 Constraints = [Constraints, implies(d2(k), ((size(bounds,2)-1 )- (size(g,2)-1))>=sum(coeffs(i:(i+f_size_block)))>=1)];
%             end
%             Constraints = [Constraints, sum(d2) == 1];
% 
%         end

        d2 = binvar(size(coeffs,2)-f_size_block+1,1);
        max_ones_in_each_ff_size_block = ((size(bounds,2)-1 )- (size(g,2)-1));
        for i=1:size(coeffs,2)-f_size_block
                Constraints = [Constraints, implies(d2(i), max_ones_in_each_ff_size_block >=sum(coeffs(i:(i+f_size_block)))>=1)];
        end
%                     Constraints = [Constraints, sum(d2) == f_size_block];
        Constraints = [Constraints, sum(d2) == size(coeffs,2)-f_size_block];

        Constraints = [Constraints, coeffs(1)==1, coeffs(end)==1];

% %         for i=1:size(g_pieces,2)
% %             if class(g_pieces(i)) == 'sdpvar'
% % %                 Constraints = [Constraints, ismember(g_pieces(i),bounds(3:end-2))];
% %                 d3 = binvar(size(bounds,2)-4,1);
% %                 for k=1:size(bounds,2)-4
% %                     Constraints = [Constraints, implies(d3(k), g_pieces(i)==bounds(2+k))];
% %                 end
% %                 Constraints = [Constraints, sum(d3) == 1];
% % 
% %     %         Constraints = [Constraints, sum(g_pieces(i),bounds(3:end-2))==1];
% %             end
% %         end
        for i=1:size(g_pieces,2)
            if class(g_pieces(i)) == 'sdpvar'
%                 Constraints = [Constraints, ismember(g_pieces(i),bounds(3:end-2))];
                d3 = binvar(size(bounds,2)-2,1);
                for k=1:size(bounds,2)-2
                    Constraints = [Constraints, implies(d3(k), g_pieces(i)==bounds(1+k))];
                end
                Constraints = [Constraints, sum(d3) == 1];

    %         Constraints = [Constraints, sum(g_pieces(i),bounds(3:end-2))==1];
            end
        end

% % % % Constraint set 3: relation between g_pieces and bounds-replaced above
% % % % commented %%% code
% % % for i = 1:size(g_pieces, 2)
% % %     if class(g_pieces(i)) == 'sdpvar'
% % %         conditions=[];
% % %         for jj=3:size(bounds,2)-2
% % %             conditions = [conditions, g_pieces(i) == bounds(jj)];
% % %         end
% % %         Constraints = [Constraints, any(conditions)];
% % % %         Constraints = [Constraints, any(g_pieces(i) == bounds(2:end - 1))];
% % %     end
% % % end
    
%         for j =1:3
%             for i=1:size(g_pieces,2)-1
%         %             sdp_g_pieces = [sdp_g_pieces; g_pieces(i)];
% %                 Constraints = [Constraints, ismember(g(j,i),f(j,:))];
%                     d = binvar(size(bounds,2)-1,1);
%                     for k=1:size(bounds,2)-1
%                         Constraints = [Constraints, implies(d(i), g(j,i)==f(j,k))];
%                     end
%                     Constraints = [Constraints, sum(d) == 1];
% 
%     %             Constraints = [Constraints, sum(g(j,i),f(j,:))==1];
%             end
%         end

%     for j =1:3
%         Cons=[];
%         for i=1:size(g_pieces,2)-1
%     %             sdp_g_pieces = [sdp_g_pieces; g_pieces(i)];
%             for k=1:size(bounds,2)-1
%                 Cons = [Cons | (g(j,i)==f(j,k))];
%             end
%         end
%         Constraints = [Constraints, Cons];
%     end
% 
% 
%     for i=1:size(g_pieces,2)
%         if class(g_pieces(i)) == 'sdpvar'
%             Cons=[];
%             for j=2:size(bounds,2)-1
%     %             sdp_g_pieces = [sdp_g_pieces; g_pieces(i)];
%                 Cons = [Cons | (g_pieces(i)==bounds(j))];
%             end
%             Constraints = [Constraints, Cons];
% 
%         end
%     end

    Constraints = [Constraints, sum(coeffs) == (size(bounds,2)-1 )];

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
%     options = sdpsettings('solver','baron', 'baron.maxiter',100, 'verbose',1, 'threads',14, 'LPSol',3);
options = sdpsettings('solver','baron', 'bmibnb.maxiter',90000, 'verbose',1);
% options = sdpsettings('solver','bmibnb', 'bmibnb.maxiter',1000, 'verbose',1);
%     options = sdpsettings('solver','cplex', 'verbose',1);
% %     sol = optimize([Constraints,  -1000 <= UsedInObjective <= 1000], objective, options)
    sol = optimize([Constraints,  Constraints_more ], objective, options)
% sol = optimize([Constraints,  Constraints_more])
%     sol = optimize(Constraints, objective, options)
    disp(value(objective));
    objective = value(objective);

    g = convert_to_values_rho(g);
    g_pieces = convert_to_values(g_pieces);
    coeff_val=convert_to_values(coeffs);
    check(Constraints)
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

