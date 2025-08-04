
function [rho,new_pieces, num_of_pieces,objective] = decrease_pieces_of_convex_function(f,pieces, epsilon, optimization_model_func)
% DECREASE_PIECES_OF_CONVEX_FUNCTION - Reduce number of pieces in convex function
% Uses binary search to find the minimum number of pieces that achieves desired accuracy
%
% Inputs:
%   f - 3xN matrix defining the original piecewise quadratic function
%   pieces - breakpoint vector for the original function
%   epsilon - tolerance for objective value
%   optimization_model_func - function handle for optimization model
%
% Outputs:
%   rho - 3xM matrix defining the resulting convex function
%   new_pieces - breakpoint vector for the resulting function
%   num_of_pieces - number of pieces in the result
%   objective - optimal objective value
global actual_mid;
global actual_rho;
global actual_new_pieces;
    r = size(pieces, 2);
    actual_mid=r;
%     [rho,new_pieces, mid, l, r] = binary_search(f, pieces, 1, r , epsilon, optimization_model_func);
    [rho,new_pieces, mid, l, r,objective] = binary_search(f, pieces, 1, r, epsilon, optimization_model_func);
% [rho,new_pieces, num_of_pieces] = linear_search(f, pieces, 3, r, epsilon);
    rho=actual_rho;
    new_pieces=actual_new_pieces;
    num_of_pieces= actual_mid;
end


function [rho,new_pieces, mid] = old_binary_search(f, pieces, l, r, epsilon)

    if r>=l
        mid = l + floor((r-l)/10);
        
%         [rho,new_pieces, objective] = get_nearest_convex_function_with_given_number_of_pieces(f, pieces, mid);
        [rho,new_pieces, objective] = get_nearest_convex_function_with_variable_pieces_of_given_num(f, pieces, mid);
        
        if objective <= epsilon
            %rho, new_pieces is our answer
%             [rho,new_pieces] = binary_search(f, pieces, 1, mid-1, epsilon);
        else
             [rho,new_pieces] = binary_search(f, pieces, mid+1, r, epsilon);
        end
    else
        rho = f;
        new_pieces = pieces;
    end
end

% NOTE: Alternative binary search implementation preserved for reference
% This was an experimental approach that has been replaced by the current implementation


% function [rho,new_pieces, mid] = binary_search(f, pieces, l, r, epsilon)
% 
%     opt_n = -1;
%     opt_obj = -inf;
% 
%     while r>=l
%         mid = l + floor((r-l)/2);
%         
%          [rho,new_pieces, objective] = get_nearest_convex_function_with_variable_pieces_of_given_num(f, pieces, mid);
%         
%         if objective <= epsilon
%             %rho, new_pieces is our answer
% %             [rho,new_pieces] = binary_search(f, pieces, 1, mid-1, epsilon);
%                 if objective > opt_obj 
%                     opt_obj = objective;
%                     opt_n = mid;
%                     rho = f;
%                     new_pieces = pieces;
%                 end
%                 l = mid + 1;
%         else
%              r = mid - 1;
%         end
%          
%     end
%     
% end


function [rho,new_pieces, mid, l, r,objective] = binary_search(f, pieces, l, r, epsilon, optimization_model_func)
global actual_mid;
global actual_rho;
global actual_new_pieces;
    rho = f;
    new_pieces = pieces;
    if l>r
        return;
    end
    
     while r>=l
        mid = l + floor((r-l)/2);
        
%          [rho,new_pieces, objective] = get_nearest_convex_function_with_variable_pieces_of_given_num(f, pieces, mid);
        [rho,new_pieces, objective] = optimization_model_func(f, pieces, mid);        
        if objective <= epsilon
            if mid<actual_mid
                actual_mid=mid;
                actual_rho = rho;
                actual_new_pieces = new_pieces;
            end
            %rho, new_pieces is our answer
            [rho_val,new_pieces_val, ret_mid, l, r] = binary_search_greater(f, pieces, l, mid-1, epsilon, rho,new_pieces, optimization_model_func);
            
            return;
%             if ret_mid==-1
%                 l=r+1;
%                 return;
%             else
%                 l=mid+1;
%             end

            
            

        else
%              r = mid - 1;
        l = mid + 1;
        end
         
    end
    
end

function [rho,new_pieces, mid, l, r] = binary_search_greater(f, pieces, l, r, epsilon, rho,new_pieces, optimization_model_func)
global actual_mid;
global actual_rho;
global actual_new_pieces;
    mid=-1;
    if l>r
        return;
    end
     while r>=l
        mid = l + floor((r-l)/2);
        
%          [rho,new_pieces, objective] = get_nearest_convex_function_with_variable_pieces_of_given_num(f, pieces, mid);
        [rho,new_pieces, objective] = optimization_model_func(f, pieces, mid);
        if objective > epsilon
            %rho, new_pieces is our answer
            l=mid+1;
            [rho_val,new_pieces_val, mid, l, r] = binary_search(f, pieces, l, r, epsilon,optimization_model_func);
            return;
 
        else
             r = mid - 1;
             if mid<actual_mid
                 actual_mid=mid;
                 actual_rho = rho;
                 actual_new_pieces = new_pieces;
             end
%              rho = f;
%              new_pieces = pieces;
        end
         
    end
    
end

function [rho,new_pieces, mid] = linear_search(f, pieces, l, r, epsilon)
    if r>=l
        for i=l:r
            mid=i;
%             [rho,new_pieces, objective] = get_nearest_convex_function_with_given_number_of_pieces(f, pieces, mid);
            [rho,new_pieces, objective] = get_nearest_convex_function_with_variable_pieces_of_given_num(f, pieces, mid);
%             [rho,new_pieces, objective] = get_nearest_function_with_variable_pieces_of_given_num(f, pieces, mid);
            
            if objective <= epsilon
                break;
            end
        end
    else
        rho = f;
        new_pieces = pieces;
    end
end
    