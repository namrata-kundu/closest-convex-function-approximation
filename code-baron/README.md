# Nearest Convex Function Algorithms

This repository contains MATLAB implementations of algorithms for finding the nearest convex function to a given piecewise quadratic function. The algorithms solve optimization problems to approximate non-convex piecewise quadratic functions with convex ones while minimizing the L2 norm difference.

## Overview

The problem addressed is: given a piecewise quadratic function that may not be convex, find the nearest convex piecewise quadratic function. This has applications in optimization, machine learning, and numerical analysis where convexity is required for theoretical guarantees or computational efficiency.

## Key Features

- **Multiple Algorithm Implementations**: Various approaches including BARON global optimization, Gurobi, and branch-and-bound methods
- **Flexible Piece Management**: Algorithms for both fixed and variable numbers of pieces
- **Comprehensive Examples**: Extensive collection of test functions including W-functions, convex functions, and special cases
- **Visualization Tools**: Built-in plotting capabilities for comparing original and approximated functions

## Repository Structure

```
code-baron/
├── 01-1d_plq_fixed_pieces/          # Fixed number of pieces algorithms
├── 02-1d_plq_variable_pieces/       # Variable pieces algorithms  
├── 03-1d_plq_variable_number_of_pieces/  # Main algorithms with piece optimization - use run.m
├── paper-experiments/               # Research experiments and algorithm variants
│   ├── algo3/                      # Algorithm 3 experimental implementations
│   └── experiments/                # Experimental configurations
├── examples/                       # Test function examples and runners
```

## Main Algorithms


Algorithms are located in  `01-1d_plq_fixed_pieces/`, `02-1d_plq_variable_pieces/` and `03-1d_plq_variable_number_of_pieces/`
- Finds nearest convex function with a predetermined number of pieces
- Optimizes both function coefficients and number of pieces
- Includes piece reduction strategies using binary search
- Handles non-convex optimization problems directly
- Use `03-1d_plq_variable_number_of_pieces/run.m` to execute the main algorithm 3

Some experimental research implementation with advanced configurations are located in `paper-experiments/`

## Quick Start

### Prerequisites
- MATLAB (tested with R2020a and later)
- YALMIP optimization toolbox
- Solvers:
  - BARON (recommended for global optimization)
  - Gurobi (commercial solver)
  - CPLEX (commercial solver)
  - SeDuMi (free SDP solver)


### Running Examples

The repository includes a comprehensive example system:

```matlab
% Run different example categories
run_examples('w', 1, 'fixed');           % W-function with fixed pieces
run_examples('convex', 2, 'variable');   % Convex function with variable pieces
run_examples('special', 1, 'visualize_only');  % Just visualize special case

% List all available examples
list_examples();
```

## Example Functions

### W-Functions (`examples/w_function_examples.m`)
- Standard W-shaped functions commonly used in testing
- Various boundary conditions and coefficients
- Examples 1-4 with different characteristics

### Convex Functions (`examples/convex_function_examples.m`)
- Already convex functions for algorithm validation
- Multi-piece convex functions
- Boundary case testing

### Linear and Absolute Value Functions (`examples/linear_and_absolute_examples.m`)
- Piecewise linear functions
- Absolute value functions
- Simple test cases

### Special Cases (`examples/special_cases_examples.m`)
- Complex experimental functions
- Edge cases and boundary conditions
- Research-specific test functions

## Algorithm Configuration

### Solver Selection
The algorithms support multiple solvers with different configurations:

```matlab
% BARON (global optimization)
options = sdpsettings('solver', 'baron', 'verbose', 2, 'debug', 1);

% Gurobi (commercial)
options = sdpsettings('solver', 'gurobi', 'verbose', 1);

% CPLEX (commercial)
options = sdpsettings('solver', 'cplex', 'verbose', 1);
```

### Performance Tuning
- Adjust solver parameters for speed vs. accuracy trade-offs
- Use different piece reduction strategies
- Configure tolerance levels for merging similar pieces

## Research Applications

This code is the implementation of the following research:

### Thesis
**"Algorithms for Finding the Nearest Convex Function"**  
University of British Columbia, 2024  
[https://open.library.ubc.ca/soa/cIRcle/collections/ubctheses/24/items/1.0438610](https://open.library.ubc.ca/soa/cIRcle/collections/ubctheses/24/items/1.0438610)

### Paper
**"Algorithms for Finding the Nearest Convex Function"**  
arXiv preprint, 2025  
[https://arxiv.org/pdf/2503.18164](https://arxiv.org/pdf/2503.18164)

## Key Functions

### Core Algorithms
- `nearest_convex_function_variable_pieces_of_fixed_num.m` - Main algorithm implementation
- `decrease_pieces_of_convex_function.m` - Piece reduction using binary search
- `simple_merging_based_on_values.m` - Merge similar adjacent pieces

### Utility Functions
- `visualize.m` - Plot and compare functions
- `find_y_bounds.m` - Calculate function bounds
- `multiple_set_breakpoints_of_given_number.m` - Subdivide function pieces

## Performance Considerations

- **BARON**: Best for global optimality guarantees, slower for large problems
- **Gurobi/CPLEX**: Fast for convex relaxations, may find local optima
- **Piece Reduction**: Use merging strategies to reduce computational complexity
- **Tolerance Settings**: Balance accuracy vs. computation time

## License

This code is provided for research and educational purposes under GPL license. Please cite the associated thesis and paper when using this code in your research.

## Contact

For questions about the algorithms or implementation details, please refer to the thesis and paper linked above.
