
function  [g, g_pieces, objective] = nget_nearest_function_with_variable_pieces_of_given_num(f, pieces, num_of_pieces)
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
%         g_pieces = [left_boundary, sdpvar(1,num_of_pieces-1,'full'), right_boundary];
%         g_pieces = [left_boundary, bounds(2), sdpvar(1,num_of_pieces-1,'full'), bounds(end-1),  right_boundary];
        g_pieces = [left_boundary, sdpvar(1,num_of_pieces-1,'full'), right_boundary];
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
    
%     %a>=0
%     for i=1:size(g,2)
%         Constraints = [Constraints, g(1,i)>=0];
%     end

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
 
%     % rho_i'(x_(i+1))<=rho_(i+1)'(x_(i+1))
%     for i=1:size(g_pieces,2)-2 %check 1 or 2
%         x_val = g_pieces(i+1);
%         ai_val = g(1,i);
%         bi_val = g(2,i);
%         aiplus1_val = g(1,i+1);
%         biplus1_val = g(2,i+1);
%         
%         Constraints = [Constraints, 2*ai_val*x_val + bi_val <= 2*aiplus1_val*x_val + biplus1_val ];
%     end

    % rho_i'(x_(i+1))=rho_(i+1)'(x_(i+1))
    for i=1:size(g_pieces,2)-2 %check 1 or 2
        x_val = g_pieces(i+1);
        ai_val = g(1,i);
        bi_val = g(2,i);
        aiplus1_val = g(1,i+1);
        biplus1_val = g(2,i+1);
        
        Constraints = [Constraints, 2*ai_val*x_val + bi_val == 2*aiplus1_val*x_val + biplus1_val ];
    end

    eps  = 0.000005;
    for i=1:size(g_pieces,2)-1
         Constraints = [Constraints, g_pieces(i) <= (g_pieces(i+1)-eps)] ;
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

% % %         for i=1:size(g_pieces,2)
% % %             if class(g_pieces(i)) == 'sdpvar'
% % % %                 Constraints = [Constraints, ismember(g_pieces(i),bounds(3:end-2))];
% % %                 d3 = binvar(size(bounds,2)-4,1);
% % %                 for k=1:size(bounds,2)-4
% % %                     Constraints = [Constraints, implies(d3(k), g_pieces(i)==bounds(2+k))];
% % %                 end
% % %                 Constraints = [Constraints, sum(d3) == 1];
% % % 
% % %     %         Constraints = [Constraints, sum(g_pieces(i),bounds(3:end-2))==1];
% % %             end
% % %         end
    
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

%             constraint1 = [g(1,1)==f(1,1), g(2,1)==f(2,1), g(3,1)==f(3,1)];
%             Constraints = [Constraints constraint1];
%             constraint2 = [g(1,end)==f(1,end), g(2,end)==f(2,end), g(3,end)==f(3,end)];
%             Constraints = [Constraints constraint2];


    UsedInObjective = allvariables(objective);
     [y_lower_bound, y_upper_bound] = find_y_bounds(f, bounds);
    
     c_lb = min(f(3,1), f(3,end));
     Constraints_more=[];
%      Constraints_more = [min(f(1,:))<=g(1,:)<=max(f(1,:)), min(f(2,:))<=g(2,:)<=max(f(2,:)), min(f(3,:))<=g(3,:)<=y_upper_bound];
Constraints_more = [(min(f(1,:))-1000)<=g(1,:)<=(max(f(1,:))+1000), (min(f(2,:))-1000)<=g(2,:)<=(max(f(2,:))+1000), (min(f(3,:))-9000)<=g(3,:)<=(y_upper_bound+9000)];

% rho_initial_vals =  [
% -0.00187180453029773	0.00150697494282584	-0.000638573039047973	-5.71113701398220e-06	0.000352098685273429	-0.00387073559843117	-0.00150814052433470	9.94120925109576e-05;
% 
% 0.0698300751231760	-0.259191396354797	0.0543244662125968	-0.0982139278359321	-0.216700084169407	2.47140123207511	1.09414777953930	-0.126863377023157;
% 
% 2316.28301728266	2324.03782901415	2312.95084999451	2321.87607037854	2326.99990406897	1900.62459475272	2095.77477787813	2326.99997506585
% ];

rho_initial_vals = [-0.00145835214644049	0.00146917734113687	-0.00192911365707481	9.43465148022147e-06	0.000104451505139121	0.000164573275665437	0.000164573168395771	-0.000573135332333733;
0.0375588068151480	-0.196643555073525	0.211151365314534	-0.0990163644973126	-0.118019735239048	-0.151687926726984	-0.151687849492825	0.408970610341310;
2316.47937585926	2321.16342315468	2308.92957552496	2321.33628473515	2322.28645327274	2327	2326.99998617795	2220.47487894632;];

% pieces_vals =  [0	40.0000005002634	60.0000000061720	99.9999999816888	280.000000190640	299.999999846601	340.000000746653	359.999999503576	419.980000000000];
% 

% pieces_vals=[0	40.0000004923066	60.0000000886708	80.0000001142717	100.000000052390	279.999999943440	360.000000000682	379.999999511807	419.980000000000];

pieces_vals= [0 40 60 80 100 280 300 340 360	380	400	419.980000000000];
% rho_initial_vals = [-0.00277799182228403,0, 0.0025, -0.00250, 0, 0.0050,-0.0025, 0.0050, -0.005, -4.78350000000000e-16, 0.005004400;
% 0.106127126175898,-0.1, -0.40, 0.40, -0.1,-2.9, 1.6, -3.5, 3.7, -0.1, -4.103520;
% 2316.05670993989,2320, 2329, 2297, 2322, 2714, 2039, 2906, 1610, 2331.99999999993, 3132.7040;
% ];


rho_initial_vals = [-0.00277799182228403,0, 0.0025, -0.00250, 0, 0.0050,-0.0025, 0.0050, -0.005, -4.78350000000000e-16, 0.005004400;
0.106127126175898,-0.1, -0.40, 0.40, -0.1,-2.9, 1.6, -3.5, 3.7, -0.1, -4.103520;
2316.05670993989,2320, 2329, 2297, 2322, 2714, 2039, 2906, 1610, 2331.99999999993, 3132.7040;
];

rho_initial_vals=[-0.0025,0, 0.0025, -0.00250, 0, 0.0050,-0.0025, 0.0050, -0.005, -4.78350000000000e-16, 0.005004400;
0.1 ,-0.1, -0.40, 0.40, -0.1,-2.9, 1.6, -3.5, 3.7, -0.1, -4.103520;
2316 ,2320, 2329, 2297, 2322, 2714, 2039, 2906, 1610, 2331.99999999993, 3132.7040;
];

pieces_vals =  [0,40.0, 60.0, 80.0, 102.5, 280.0, 300.0, 340.0, 360.0, 380.0, 396.66666666666663, 419.98];
% g = [
% -0.00233078693000000	-1.82776844000000e-05	0.00231028798000000	-0.00209793203000000	2.39807963000000e-06	0.00497806448000000	-0.00248524120000000	0.00494236197000000	-0.00486029698000000	-0.000454951304000000	0.00419333265000000;
%  0.0886575130000000	-0.0963432265000000	-0.375771107000000	0.329544095000000	-0.101023577000000	-2.88739676000000	1.59058665000000	-3.46018351000000	3.59773093000000	0.249668222000000	-3.43797038000000;
%  2316.16676000000	2319.86677000000	2328.24961000000	2300.03700000000	2322.10360000000	2712.19584000000	2040.49833000000	2899.12926000000	1628.70466000000	2264.83657000000	2996.21823000000;];
rho_initial_vals = [
-0.00233078693000000	-0.0000182776844000000 0.00231028798000000	-0.00209793203000000	0.00000239807963000000 0.00497806448000000	-0.00248524120000000	0.00494236197000000	-0.00486029698000000	-0.000454951304000000	0.00419333265000000;
0.0886575130000000	-0.0963432265000000	-0.375771107000000	0.329544095000000	-0.101023577000000	-2.88739676000000	1.59058665000000	-3.46018351000000	3.59773093000000	0.249668222000000	-3.43797038000000;
 2316.16676000000	2319.86677000000	2328.24961000000	2300.03700000000	2322.10360000000	2712.19584000000	2040.49833000000	2899.12926000000	1628.70466000000	2264.83657000000	2996.21823000000;];

% % %     for i=1:size(g_pieces,2)
% % %         if class(g_pieces(i)) == 'sdpvar'
% % %             assign(g_pieces(i),pieces_vals(i));
% % %         end
% % %     end
% % % 
% % %     for i=1:size(g,1)
% % %         for j=1:size(g,2)
% % %             if class(g(i,j)) == 'sdpvar'
% % %                 assign(g(i,j),rho_initial_vals(i,j));
% % %             end
% % %         end
% % %     end
    %'baron.maxtime',600, 
%          options = sdpsettings('solver','baron', 'baron.maxiter',1500, 'usex0',1,'verbose',1);
% %      options = sdpsettings('solver','baron', 'baron.maxtime',8000, 'usex0',1,'verbose',1,'threads',14, 'LPSol',3);
% %      options = sdpsettings('solver','baron', 'baron.maxtime',8000,  'verbose',1,'threads',14, 'LPSol',3);
      options = sdpsettings('solver','baron', 'baron.maxiter',2000, 'verbose',1,'threads',14, 'LPSol',3);
%       options = sdpsettings('solver','bmibnb', 'bmibnb.maxtime',1000, 'usex0',1,'verbose',1);
%      options = sdpsettings('solver','gurobi',   'usex0',1,'verbose',1);
%     options = sdpsettings('solver','baron', 'usex0',1, 'verbose',1);
%     options = sdpsettings('solver','', 'verbose',1);
% options = sdpsettings('solver','baron', 'baron.maxiter',60, 'usex0',1,'verbose',1);
%     sol = optimize([Constraints,  -5000 <= UsedInObjective <= 5000], objective, options)
    sol = optimize([Constraints, Constraints_more], objective, options)
%     sol = optimize(Constraints, objective, options)
%     sol = optimize([Constraints,  -10000 <= UsedInObjective <= 10000], objective, options)    

    disp(value(objective));
    objective = value(objective);

    g = convert_to_values_rho(g);
    g_pieces = convert_to_values(g_pieces);
    coeff_val=convert_to_values(coeffs);
    check(Constraints)
%      visualize(f,pieces,g,g_pieces);
%      visualize(g,g_pieces,g,g_pieces);

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

