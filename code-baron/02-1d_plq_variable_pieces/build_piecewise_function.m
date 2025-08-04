function [y] = build_piecewise_function(f, f_pieces)

    syms x;
%     if extreme_right_bound == f(1,size(f,2))
%         total_num_of_pieces = size(f,2)-1;
%     else
%         total_num_of_pieces = size(f,2);
%     end
    total_num_of_pieces = size(f_pieces,2);
    
    pieces = [];
    for i=1:total_num_of_pieces-1
        left_bound = f_pieces(i);
        right_bound = f_pieces(i+1);
        if isinf(left_bound)
            if isinf(right_bound)
                boundary_condition = (left_bound<x);
            else
                boundary_condition = (left_bound<x)<right_bound;
            end
        elseif isinf(right_bound)
            boundary_condition = (left_bound<=x);
        else
            boundary_condition = (left_bound<=x)<right_bound;
        end
        
        a = value(f(1,i));
        b = value(f(2,i));
        c = value(f(3,i));
        func = a*x*x + b*x + c;
        pieces = [pieces, boundary_condition, func];
    end
%     left_bound = f(1,total_num_of_pieces);
%     right_bound = extreme_right_bound;
%     if isinf(left_bound)
%         if isinf(right_bound)
%             boundary_condition = (left_bound<x);
%         else
%             boundary_condition = (left_bound<x)<right_bound;
%         end
%     elseif isinf(right_bound)
%         boundary_condition = (left_bound<=x);
%     else
%         boundary_condition = (left_bound<=x)<right_bound;
%     end
% 
%     a = value(f(2,total_num_of_pieces));
%     b = value(f(3,total_num_of_pieces));
%     c = value(f(4,total_num_of_pieces));
%     func = a*x*x + b*x + c;
%     pieces = [pieces, boundary_condition, func];
    
    
    T = num2cell(pieces) ;
    y=piecewise(T{:});
%     y=piecewise(pieces);
%     fplot(y)
%     y = piecewise(x<-5,-x-5,(-5<=x)<0,x+5, (0<=x)<5, -x+5, (5<=x) , x-5);
end


        