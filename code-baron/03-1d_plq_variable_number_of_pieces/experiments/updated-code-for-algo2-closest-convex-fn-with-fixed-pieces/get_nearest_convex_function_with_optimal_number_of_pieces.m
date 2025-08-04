function [g,g_pieces] = get_nearest_convex_function_with_optimal_number_of_pieces(f,pieces)

    n = length(f);
    optimal_n=2*n; %starting with 2n such that there is a decision breakpoint between every existing breakpoint
    [g,g_pieces,  obj1]  = nearest_convex_function_variable_pieces_of_fixed_num(f,pieces, optimal_n); 
    visualize(f,pieces,g,g_pieces);
    [g,g_pieces,  obj2]  = nearest_convex_function_variable_pieces_of_fixed_num(f,pieces,  2*optimal_n); 
    rounded_obj1 = round(value(obj1), 8);
    rounded_obj2 = round(value(obj2), 8);
    disp(rounded_obj1-rounded_obj2)
            visualize(f,pieces,g,g_pieces);

    k=2;
    epsilon=0.00000000000005;
    while value(obj1) - value(obj2) > epsilon
        obj1=obj2;
        [g1,g1_pieces,  obj1]  = nearest_convex_function_variable_pieces_of_fixed_num(f,pieces, (2^k)*optimal_n); 
        [g2,g2_pieces,  obj2]  = nearest_convex_function_variable_pieces_of_fixed_num(f,pieces, (2^(k+1))*optimal_n); 
        k=k+1;
        visualize(f,pieces,f,pieces);
        visualize(g1,g1_pieces,g2,g2_pieces);

    end
end

