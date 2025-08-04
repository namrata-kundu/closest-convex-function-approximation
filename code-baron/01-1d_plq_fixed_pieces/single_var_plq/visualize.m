% function  visualize(f,f_right_bound, rho, rho_right_bound)
function  visualize(f,f_pieces, rho, rho_pieces)
%     f_right_bound = f_pieces(end);
%     rho_right_bound = rho_pieces(end);
    piecewise_f = build_piecewise_function(f, f_pieces);
    fplot(piecewise_f)
    grid on;
    hold on;
    piecewise_rho = build_piecewise_function(rho, rho_pieces);

    fplot(piecewise_rho)
end

