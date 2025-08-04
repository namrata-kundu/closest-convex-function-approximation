function run_examples(category, example_num, algorithm_choice)
% RUN_EXAMPLES - Master script to run any example with any algorithm
%
% Usage: run_examples(category, example_num, algorithm_choice)
%
% Input:
%   category - String specifying example category:
%              'w' or 'w_function' - W function examples
%              'convex' - Convex function examples  
%              'linear' - Linear and absolute value examples
%              'special' - Special cases and experimental examples
%   example_num - Integer specifying which example within category
%   algorithm_choice - String specifying which algorithm to run:
%                      'fixed' - Fixed number of pieces algorithm
%                      'variable' - Variable pieces algorithm
%                      'visualize_only' - Just visualize the function
%
% Examples:
%   run_examples('w', 1, 'visualize_only');           % Visualize W function
%   run_examples('convex', 2, 'fixed');               % Run convex example 2 with fixed pieces
%   run_examples('special', 1, 'variable');           % Run special case 1 with variable pieces
%   
%   % Quick access functions:
%   run_examples('w', 1);                             % Default to visualization
%   run_examples('convex');                           % Default to convex example 1

% Set defaults
if nargin < 1
    category = 'w';
end
if nargin < 2
    example_num = 1;
end
if nargin < 3
    algorithm_choice = 'visualize_only';
end

% Clear YALMIP
yalmip('clear');

% Load the appropriate example
switch lower(category)
    case {'w', 'w_function'}
        [pieces, f] = w_function_examples(example_num);
        category_name = 'W Function';
        
    case 'convex'
        [pieces, f] = convex_function_examples(example_num);
        category_name = 'Convex Function';
        
    case {'linear', 'abs', 'absolute'}
        [pieces, f] = linear_and_absolute_examples(example_num);
        category_name = 'Linear/Absolute Function';
        
    case {'special', 'experimental'}
        [pieces, f] = special_cases_examples(example_num);
        category_name = 'Special Case';
        
    otherwise
        error('Invalid category. Choose: w, convex, linear, or special');
end

fprintf('\n=== Running %s Example %d ===\n', category_name, example_num);

% Run the selected algorithm
switch lower(algorithm_choice)
    case 'visualize_only'
        fprintf('Visualizing function only...\n');
        visualize(f, pieces, f, pieces);
        
    case 'fixed'
        fprintf('Running fixed pieces algorithm...\n');
        epsilon = 1e-3;
        no_of_pieces = size(f,2) * 5;  % Default multiplier
        
        fprintf('Using %d pieces...\n', no_of_pieces);
        [rho, new_pieces, objective] = nearest_convex_function_variable_pieces_of_fixed_num(f, pieces, no_of_pieces);
        
        % Visualize results
        visualize(f, pieces, rho, new_pieces);
        
        % Display results
        fprintf('Objective value: %f\n', value(objective));
        fprintf('Number of pieces used: %d\n', size(new_pieces,2)-1);
        
    case 'variable'
        fprintf('Running variable pieces algorithm...\n');
        epsilon = 1e-3;
        
        % First get a solution with many pieces
        no_of_pieces = size(f,2) * 5;
        [rho, new_pieces, objective] = nearest_convex_function_variable_pieces_of_fixed_num(f, pieces, no_of_pieces);
        
        % Then reduce pieces
        [simple_rho, simple_rho_pieces] = simple_merging_based_on_values(rho, new_pieces, epsilon);
        
        % Visualize original and simplified
        visualize(f, pieces, rho, new_pieces);
        visualize(rho, new_pieces, simple_rho, simple_rho_pieces);
        
        % Display results
        fprintf('Original pieces: %d\n', size(new_pieces,2)-1);
        fprintf('Simplified pieces: %d\n', size(simple_rho_pieces,2)-1);
        
    otherwise
        error('Invalid algorithm choice. Choose: visualize_only, fixed, or variable');
end

fprintf('=== Example completed ===\n\n');

end

% Quick access functions for common examples
function run_w_function(example_num, algorithm)
    if nargin < 1, example_num = 1; end
    if nargin < 2, algorithm = 'visualize_only'; end
    run_examples('w', example_num, algorithm);
end

function run_convex_function(example_num, algorithm)
    if nargin < 1, example_num = 1; end
    if nargin < 2, algorithm = 'visualize_only'; end
    run_examples('convex', example_num, algorithm);
end

function list_examples()
    fprintf('\n=== Available Examples ===\n');
    fprintf('W Function Examples (1-4):\n');
    fprintf('  1: Standard W function\n');
    fprintf('  2: W function with finite boundaries\n');
    fprintf('  3: W function variant\n');
    fprintf('  4: W function with modified boundary\n\n');
    
    fprintf('Convex Function Examples (1-6):\n');
    fprintf('  1: Standard convex quadratic\n');
    fprintf('  2: Multi-piece convex function\n');
    fprintf('  3: Convex function variant\n');
    fprintf('  4: Complex symmetric convex\n');
    fprintf('  5: Simple symmetric convex\n');
    fprintf('  6: Extended convex function\n\n');
    
    fprintf('Linear/Absolute Examples (1-6):\n');
    fprintf('  1: Absolute value function\n');
    fprintf('  2: Simple linear function\n');
    fprintf('  3: Multi-segment piecewise linear\n');
    fprintf('  4: Complex piecewise linear\n');
    fprintf('  5: Extended piecewise linear\n');
    fprintf('  6: Symmetric piecewise linear\n\n');
    
    fprintf('Special Cases (1-9):\n');
    fprintf('  1: Complex experimental function\n');
    fprintf('  2: Simple boundary test\n');
    fprintf('  3: Edge case with specific values\n');
    fprintf('  4-6: Various boundary cases\n');
    fprintf('  7: Infeasible test case\n');
    fprintf('  8-9: Conjecture test cases\n\n');
    
    fprintf('Usage: run_examples(category, example_num, algorithm)\n');
    fprintf('Categories: ''w'', ''convex'', ''linear'', ''special''\n');
    fprintf('Algorithms: ''visualize_only'', ''fixed'', ''variable''\n');
end
