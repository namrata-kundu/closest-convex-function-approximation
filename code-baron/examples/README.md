# Test Examples Directory

This directory contains organized test examples for the nearest convex function algorithms.

## File Organization

### `w_function_examples.m`
Collection of W function test cases:
- Example 1: Standard W function (most commonly used)
- Example 2: W function with finite boundaries  
- Example 3: W function variant with different coefficients
- Example 4: W function with modified boundary

### `convex_function_examples.m`
Collection of convex function test cases:
- Example 1: Standard convex quadratic function
- Example 2: Convex function with multiple pieces
- Example 3: Convex function variant (incomplete boundary)
- Example 4: Complex convex function with symmetric structure
- Example 5: Simple symmetric convex function
- Example 6: Extended convex function

### `linear_and_absolute_examples.m`
Collection of linear and absolute value function test cases:
- Example 1: Absolute value function |x|
- Example 2: Simple linear function
- Example 3: Piecewise linear with multiple segments
- Example 4: Complex piecewise linear function
- Example 5: Extended piecewise linear with many segments
- Example 6: Symmetric piecewise linear

### `special_cases_examples.m`
Collection of special and experimental test cases:
- Example 1: Complex experimental function with many breakpoints
- Example 2: Simple boundary test case
- Example 3: Edge case with specific values
- Example 4-6: Various boundary cases
- Example 7: Infeasible test case (may not have solution)
- Example 8-9: Conjecture test cases

## Usage

### Quick Usage
```matlab
% Load a specific example
[pieces, f] = w_function_examples(1);           % Standard W function
[pieces, f] = convex_function_examples(2);      % Multi-piece convex
[pieces, f] = linear_and_absolute_examples(1);  % Absolute value
[pieces, f] = special_cases_examples(1);        % Complex experimental

% Visualize the function
visualize(f, pieces, f, pieces);
```

### Using the Master Runner
```matlab
% Run examples with different algorithms
run_examples('w', 1, 'visualize_only');        % Just visualize W function
run_examples('convex', 2, 'fixed');             % Run convex example with fixed pieces
run_examples('special', 1, 'variable');         % Run special case with variable pieces

% List all available examples
list_examples();
```

### Integration with Main Scripts
The main algorithm files use these organized examples:
- `run.m` - Uses convex function example 2 by default
- `run_script.m` - Uses W function example 1 by default
- `plq_1d_variable_pieces.m` - Uses W function example 1 by default

## Function Format

All examples return:
- `pieces`: Breakpoint vector defining piecewise intervals
- `f`: 3×N matrix where each column defines a quadratic piece:
  - `f(1,:)` = quadratic coefficients (a)
  - `f(2,:)` = linear coefficients (b)  
  - `f(3,:)` = constant coefficients (c)

Each piece represents: `f_i(x) = a_i*x^2 + b_i*x + c_i` for `x ∈ [pieces(i), pieces(i+1)]`

## Benefits of This Organization

1. **Easy testing**: Quick access to various function types for testing
2. **Organized by type**: Examples grouped by mathematical properties
3. **Documented**: Each example has clear description and usage
4. **Extensible**: Easy to add new examples in organized manner
5. **Comprehensive coverage**: Wide range of test cases for algorithm validation

## Adding New Examples

To add new examples:
1. Choose the appropriate category file
2. Add a new case to the switch statement
3. Update the function documentation
4. Test the new example with `run_examples()`

## Example Categories

The examples are organized into four main categories based on their mathematical properties:

- **W-Functions**: Standard test functions with W-shaped profiles commonly used in optimization research
- **Convex Functions**: Already convex functions for algorithm validation and baseline testing
- **Linear/Absolute**: Simple piecewise linear and absolute value functions for basic testing
- **Special Cases**: Complex experimental functions and edge cases for comprehensive algorithm testing
