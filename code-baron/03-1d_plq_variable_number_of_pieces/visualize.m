function  visualize(f,f_pieces, rho, rho_pieces)
% VISUALIZE - Plot and compare two piecewise quadratic functions
% Creates a visual comparison of the original and approximated functions
%
% This function plots both functions with different colors and line styles,
% including boundary points and a legend for easy comparison.
%
% Inputs:
%   f - 3xN matrix defining the original piecewise quadratic function
%       f(1,:) = quadratic coefficients (a)
%       f(2,:) = linear coefficients (b)
%       f(3,:) = constant coefficients (c)
%   f_pieces - breakpoint vector for the original function
%   rho - 3xM matrix defining the approximated function
%   rho_pieces - breakpoint vector for the approximated function
%
% Output:
%   Creates a MATLAB figure with both functions plotted
%   Original function: Blue line (thick)
%   Approximated function: Orange/Red line (medium thickness)
%   Boundary points: Marked with circles
%
% Example:
%   [pieces, f] = w_function_examples(1);
%   [rho, new_pieces, obj] = nearest_convex_function_variable_pieces_of_fixed_num(f, pieces, 8);
%   visualize(f, pieces, rho, new_pieces);

    piecewise_f = build_piecewise_function(f, f_pieces);
    h1 = fplot(piecewise_f, 'LineWidth', 3, 'Color', "#0072BD");
%     h1 = fplot(piecewise_f, 'LineWidth', 3.25, 'Color', "red");
    grid on;
%    xlim([-20 20]);
% ylim([-5 20]);
  % Plotting the boundary points for f
  hold on;
    plot_boundary_points(f, f_pieces, h1.Color);

    hold on;
    piecewise_rho = build_piecewise_function(rho, rho_pieces);

%     h2 = fplot(piecewise_rho, 'LineWidth', 1, 'Color', 	"#EDB120");
    h2 = fplot(piecewise_rho, 'LineWidth', 1.5, 'Color', 	"#D95319");
grid on;
    hold on;

    % Plotting the boundary points for rho
    plot_boundary_points(rho, rho_pieces, h2.Color);
end


% Helper function to plot boundary points
function plot_boundary_points(f, f_pieces, color)
    total_num_of_pieces = size(f_pieces, 2);

    for i = 1:total_num_of_pieces - 1
        left_bound = f_pieces(i);
        right_bound = f_pieces(i + 1);

        if ~isinf(left_bound)
            y_val = double(build_y_val(f(:, i), left_bound));
%             plot(left_bound, y_val, 'o', 'MarkerFaceColor', color, 'MarkerSize', 10);
            plot(left_bound, y_val, 'o', 'MarkerFaceColor', color );
                hold on;

        end

        if i == total_num_of_pieces - 1 && ~isinf(right_bound)
            y_val = double(build_y_val(f(:, i), right_bound));
%             plot(right_bound, y_val, 'o', 'MarkerFaceColor', color, 'MarkerSize', 9);
            plot(right_bound, y_val, 'o' , 'MarkerFaceColor', color);
                hold on;

        end
        
    end
end

% Helper function to compute the y value given f and x
function y = build_y_val(f_piece, x_val)
    a = f_piece(1);
    b = f_piece(2);
    c = f_piece(3);
    y = a * x_val^2 + b * x_val + c;
end