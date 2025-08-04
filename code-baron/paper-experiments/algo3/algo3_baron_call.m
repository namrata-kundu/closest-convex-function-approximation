
function  [g, g_pieces, objective] = algo3_baron_call(f, pieces, num_of_pieces)
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

    a = sdpvar(1,size(g_pieces,2)-1,'full');
    b = sdpvar(1,size(g_pieces,2)-1,'full');
    c = sdpvar(1,size(g_pieces,2)-1,'full');
    g = [a;b;c];

    lambda = 1e-3; % Regularization parameter

    n = size(bounds,2)-1;
    r = size(g_pieces,2)-1;
%         Constraints = [Constraints, ismember(g_pieces(2:r), bounds(2:n))];

         u = binvar(n+2,r,'full');
    v = sdpvar(n+1,r,'full');
    w = binvar(n+1,r,'full');
    objective = 0;
%     check = '';
    syms a_var b_var c_var x lb ub
%     blas='';
%     for g_j=1:size(g_pieces,2)-1
%         for i=1:size(bounds,2)-1  
%             af=f(1,i);
%             bf=f(2,i);
%             cf=f(3,i);
%             func = ((af*x*x + bf*x + cf) - (a_var*x*x + b_var*x + c_var))^2;
%             lower_bound = bounds(i);
%             upper_bound = bounds(i+1);
%             symbolic_integral = int(func, [lower_bound upper_bound]);
%             str_symbolic_integral = char(symbolic_integral);
%             str_symbolic_integral = strrep(str_symbolic_integral, 'a_var', strcat('g(1,',num2str(g_j),')'));
%             str_symbolic_integral = strrep(str_symbolic_integral, 'b_var', strcat('g(2,',num2str(g_j),')'));
%             str_symbolic_integral = strrep(str_symbolic_integral, 'c_var', strcat('g(3,',num2str(g_j),')'));
%             integral = eval(str_symbolic_integral);
%             objective = objective + u(i+1,g_j)*integral;
%         end
%     end
%     %Build constraints
    Constraints = [];
    cl = [];
    cu = [];

    
    %a>=0
    for i=1:size(g,2)
        Constraints = [Constraints, g(1,i)];
        cl = [cl, 0];
        cu = [cu, Inf];
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
%         x2 = sdpvar(1,1,'full');
%         Constraints = [Constraints, x2==x_val*x_val]
        
        Constraints = [Constraints, ai_val*x_val*x_val + bi_val*x_val + ci_val -( aiplus1_val*x_val*x_val + biplus1_val*x_val + ciplus1_val )];
        cl = [cl,0];
        cu = [cu,0];
%         Constraints = [Constraints, ai_val*x2 + bi_val*x_val + ci_val == aiplus1_val*x2 + biplus1_val*x_val + ciplus1_val ];
    end
 
    % rho_i'(x_(i+1))<=rho_(i+1)'(x_(i+1))
    for i=1:size(g_pieces,2)-2 %check 1 or 2
        x_val = g_pieces(i+1);
        ai_val = g(1,i);
        bi_val = g(2,i);
        aiplus1_val = g(1,i+1);
        biplus1_val = g(2,i+1);
        
%         Constraints = [Constraints, 2*ai_val*x_val + bi_val <= 2*aiplus1_val*x_val + biplus1_val ];
Constraints = [Constraints,  2*aiplus1_val*x_val + biplus1_val - (2*ai_val*x_val + bi_val)  ];
cl = [cl, 0];
cu = [cu, Inf];
    end

    ep = 0.000005;
    for i=1:size(g_pieces,2)-1
%          Constraints = [Constraints, g_pieces(i) <= (g_pieces(i+1)-ep)] ;
        Constraints = [Constraints, (g_pieces(i+1)-ep) - ( g_pieces(i)) ] ;
        cl = [cl,0];
        cu = [cu,0];

    end



% 
%         for i=1:size(g_pieces,2)
%             if class(g_pieces(i)) == 'sdpvar'
% %                 Constraints = [Constraints, ismember(g_pieces(i),bounds(3:end-2))];
%                 d3 = binvar(size(bounds,2)-2,1);
%                 for k=1:size(bounds,2)-2
%                     co=[implies(d3(k), g_pieces(i)==bounds(1+k))]:'constraint:implies';
%                     Constraints = [Constraints, co];
%                 end
%                 c2=[sum(d3) == 1]:'sum=1';
%                 Constraints = [Constraints, c2];
% 
%     %         Constraints = [Constraints, sum(g_pieces(i),bounds(3:end-2))==1];
%             end
%         end


    co=[u(2,1)==1]:'constraints:u(2,1)==1';
    Constraints = [Constraints, u(2,1)-1];
    cl = [cl,0];
    cu = [cu,0];
    co=[u(n+1,r)==1]:'constraint:u(n+1,r)==1';
         Constraints = [Constraints,u(n+1,r)-1];
         cl = [cl,0];
    cu = [cu,0];
        
   for j=1:r
       c1=[ u(1,j)==0]:'c: u(1,j)==0';
    Constraints = [Constraints, u(1,j)];
    cl = [cl,0];
    cu = [cu,0];
    c2=[u(n+2,j)==0]:'c:u(n+2,j)==0';
    Constraints = [Constraints, u(n+2,j)];
    cl = [cl,0];
    cu = [cu,0];
   end

  
   for i=2:n+1
        u_row_sum=0;
       for j = 1:r
            u_row_sum = u_row_sum + u(i,j);
       end
       co=[u_row_sum == 1]:'c:u_row_sum == 1';
       Constraints = [Constraints, u_row_sum-1];
       cl = [cl,0];
    cu = [cu,0];
   end

    for j = 1:r
        u_column_sum=0;
        for i=1:n+2
            u_column_sum = u_column_sum + u(i,j);
        end
        co=[u_column_sum >= 1]:'c:u_column_sum >= 1';
       Constraints = [Constraints, u_column_sum - 1 ];
       cl = [cl,0];
    cu = [cu,Inf];
    end

    for i=1:n+1
        for j=1:r
            v(i,j) = u(i+1,j)-u(i,j);
%                 Constraints = [Constraints, v(i,j) ==1 | v(i,j)==0 | v(i,j)==-1 ];
% % %             c1=[ismember(v(i,j),[1,0,-1])]:'c:ismember(v(i,j),[1,0,-1])';
% % %             Constraints = [Constraints, c1 ];
%             w(i,j) =v(i,j)*v(i,j);
            c2=[ w(i,j) ==v(i,j)*v(i,j)]:'c: w(i,j) ==v(i,j)*v(i,j)';
% %             c2=[ w(i,j) == max(v(i,j), -1*v(i,j))]:'c: w(i,j) == max(v(i,j), -1*v(i,j))';
            Constraints = [Constraints,w(i,j) -v(i,j)*v(i,j) ];
            cl = [cl,0];
    cu = [cu,0];
        end
    end

    for j = 1:r
        v_column_sum=0;
        w_column_sum=0;
        for i=1:n+1
            v_column_sum = v_column_sum + v(i,j);
            w_column_sum = w_column_sum + w(i,j);
        end
        c1=[v_column_sum == 0]:'c:v_column_sum == 0';
       Constraints = [Constraints, v_column_sum];
        cl = [cl,0];
    cu = [cu,0];
       c2=[w_column_sum == 2]:'c:w_column_sum == 2';
       Constraints = [Constraints, w_column_sum-2];
       cl = [cl,0];
    cu = [cu,0];
    end

    for i=2:n
        v_row_sum=0;
       for j = 1:r
            v_row_sum = v_row_sum + v(i,j);
       end
       co=[v_row_sum == 0]:'c:v_row_sum == 0';
       Constraints = [Constraints,v_row_sum];
       cl = [cl,0];
    cu = [cu,0];
   end

        c1=[v(1,1) == 1]:'v(1,1) == 1';
       Constraints = [Constraints, v(1,1)-1];
        cl = [cl,0];
    cu = [cu,0];
       c2=[v(n+1,r) == -1]:'v(n+1,r) == -1';
       Constraints = [Constraints, v(n+1,r)+1];
       cl = [cl,0];
    cu = [cu,0];





    %last pieces should have function same as boundary if boundaries go to
    %infinity
%     if num_of_pieces>1
        if isinf(pieces(1))
            constraint1 = [g(1,1)==f(1,1), g(2,1)==f(2,1), g(3,1)==f(3,1)]:'equalityconstraint1';
            Constraints = [Constraints, g(1,1)-f(1,1), g(2,1)-f(2,1), g(3,1)-f(3,1)];
            cl = [cl,0,0,0];
    cu = [cu,0,0,0];
        end
        if isinf(pieces(end))
            constraint2 = [g(1,end)==f(1,end), g(2,end)==f(2,end), g(3,end)==f(3,end)]:'equalityconstraint2';
            Constraints = [Constraints, g(1,end)-f(1,end), g(2,end)-f(2,end), g(3,end)-f(3,end)];
            cl = [cl,0,0,0];
    cu = [cu,0,0,0];
        end
%     end

% gp_val=[-54.9623629675418	-1.42976353112106	7.41549091428581	17.4226028055639];
%     for i=1:size(g_pieces,2)
%         if class(g_pieces(i)) == 'sdpvar'
%             assign(g_pieces(i),gp_val(i));
%         end
%     end
%     
%      g_val=[0.500000000000000	0	0;
%             0	0.0444734562755510	1;
%             1	2.08569840334757	-5];
%     for i=1:size(g,1)
%         for j=1:size(g,2)
%             if class(g(i,j)) == 'sdpvar'
%                 assign(g(i,j),g_val(i,j));
%             end
%         end
%     end  
% 
%     u_val = [
%     0 0 0 ;
%     1 0 0;
%     1 0 0;
%     1 0 0;
%     0 1 0;
%     0 0 1;
%     0 0 1;
%     0 0 0;
%     ];
%     for i=1:size(u,1)
%         for j=1:size(u,2)
%             assign(u(i,j),u_val(i,j));
%         end
%     end  

%     check(Constraints)
%     t=sdpvar(1,1,'full');
%     slack_var = sdpvar(1,1,'full');
%     Constraints = [Constraints, t==objective+slack_var, slack_var>=0];

    UsedInObjective = allvariables(objective);
     [y_lower_bound, y_upper_bound] = find_y_bounds(f, bounds);
     Constraints=[Constraints, -10000<=UsedInObjective<=10000];
    
     c_lb = min(f(3,1), f(3,end));
     Constraints_more = [0<=g(1,:)<=1+1000, f(2,1)-1000<=g(2,:)<=f(2,end)+1000, c_lb-1000<=g(3,:)<=y_upper_bound+1000];
     Constraints = [Constraints, g(1,:), g(2,:), g(3,:)];
     cl = [cl , 0, f(2,1)-1000, c_lb-1000];
     cu = [cu, 1+1000, f(2,end)+1000,y_upper_bound+1000];

     objective = obj(g_pieces, f, bounds,g,u);
     nlcon = @(g, g_pieces, u, v, w) Constraints;
    x0 =  nan(1, 27);
%     options = sdpsettings('solver','baron', 'baron.maxiter',100, 'verbose',1, 'threads',14, 'LPSol',3);
     baron(@obj, [],[],[],[],[],nlcon,cl,cu,[],x0)
%  options = sdpsettings('solver','baron','usex0',1, 'verbose',1);

%  baron(objective,[Constraints,  Constraints_more ])
%     sol = optimize([Constraints,  Constraints_more ], objective, options)





    disp(value(objective));
    objective = value(objective);

    g = convert_to_values_rho(g);
    g_pieces = convert_to_values(g_pieces);
    check(Constraints)
     visualize(f,pieces,g,g_pieces);

end


 function objective = obj(g_pieces, f, bounds,g,u)
    objective = 0;
    for g_j=1:size(g_pieces,2)-1
        for i=1:size(bounds,2)-1  
            af=f(1,i);
            bf=f(2,i);
            cf=f(3,i);
            a_var = g(1,g_j);
            b_var = g(2,g_j);
            c_var = g(3,g_j);
            lb = bounds(i);
            ub = bounds(i+1);
            integral = (ub^5*(a_var - af)^2)/5 - (lb^5*(a_var - af)^2)/5 - lb^3*((2*(a_var - af)*(c_var - cf))/3 + (b_var - bf)^2/3) + ub^3*((2*(a_var - af)*(c_var - cf))/3 + (b_var - bf)^2/3) - lb*(c_var - cf)^2 + ub*(c_var - cf)^2 - (lb^4*(a_var - af)*(b_var - bf))/2 - lb^2*(b_var - bf)*(c_var - cf) + (ub^4*(a_var - af)*(b_var - bf))/2 + ub^2*(b_var - bf)*(c_var - cf);
            objective = objective + u(i+1,g_j)*integral;
        end
    end
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

