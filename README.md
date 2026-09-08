# SodSolver
SodSolver provides an exact solution to the Sod Shock tube problem.   The solver is written in modern Fortran and core arithmetic is carried out in quadruple precision to give at least 15 digits of accuracy making the solution usable as a verification test for double precision computational hydrodynamics codes.   

## The Sod shock tube problem

The Sod shock tube problem for the  1-D Euler equations of inviscid, compressible hydrodynamics posed as a verification test problem by Gary Sod (1978)[^1]is an example of an initial value Riemann Problem.
The solution of the problem is known exactly although it does require finding the root of a real nonlinear equation numerically.  The problem as stated by Sod is
```math
\left(
\begin{array}{l}
\rho_L\\
P_L\\
v_L
\end{array}
\right)
=
\left(
\begin{array}{l}
1.0 \\
1.0 \\
0
\end{array}
\right)
```
for the left initial state where $x < 0$ and
```math
\left(
\begin{array}{l}
\rho_R\\
P_R\\
v_R
\end{array}
\right)
=
\left(
\begin{array}{l}
0.125 \\
0.1 \\
0
\end{array}
\right)
```
for the right initial state where $x \ge 0$.

[^1] Sod, G. A. (1978) "A Survey of Several Finite Difference Methods for Systems of Nonlinear Hyperbolic Conservation Laws" (PDF). J. Comput. Phys. 27 (1): 1–31. Bibcode:1978JCoPh..27....1S. doi:10.1016/0021-9991(78)90023-2. OSTI 6812922.








$$
