function [g,g_pieces ] = simple_merging_based_on_values(f,pieces, eps)
    g = [f(:,1)];
    g_pieces = [pieces(1)];
    r = size(pieces, 2);
%     eps = 1e-7;

    syms x
    for i=1:size(f,2)-1
        a1 = f(1,i);
        b1 = f(2,i);
        c1 = f(3,i);

        a2 = f(1,i+1);
        b2 = f(2,i+1);
        c2 = f(3,i+1);

        func = ((a1*x*x + b1*x + c1) - (a2*x*x + b2*x + c2))^2;
        if isinf(pieces(i)) 
            lb=-99999999;
        else
            lb = pieces(i);
        end
        if isinf(pieces(i+2))
            ub = 99999999;
        else
            ub = pieces(i+2);
        end
        str_symbolic_integral = int(func, [lb ub]);
        integral = eval(str_symbolic_integral);

        if integral<eps/r
            continue
%         if abs(a1 - a2) < eps &&  abs(b1 - b2) < eps && abs(c1 - c2) < eps
%             continue
        else
            g = [g, f(:,i+1)];
            g_pieces = [g_pieces, pieces(i+1)];
        end

    end
    g_pieces = [g_pieces, pieces(end)];
    
end


% 1st algo
% function [g,g_pieces ] = simple_merging_based_on_values(f,pieces, eps)
%     g = [f(:,1)];
%     g_pieces = [pieces(1)];
%     r = size(pieces, 2);
% %     eps = 1e-7;
% 
%     
%     for i=1:size(f,2)-1
%         a1 = f(1,i);
%         b1 = f(2,i);
%         c1 = f(3,i);
% 
%         a2 = f(1,i+1);
%         b2 = f(2,i+1);
%         c2 = f(3,i+1);
% 
%         if abs(a1 - a2) < eps &&  abs(b1 - b2) < eps && abs(c1 - c2) < eps
%             continue
%         else
%             g = [g, f(:,i+1)];
%             g_pieces = [g_pieces, pieces(i+1)];
%         end
% 
%     end
%     g_pieces = [g_pieces, pieces(end)];
%     
% end
