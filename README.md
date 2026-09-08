# SodSolver
SodSolver provides an exact solution to the Sod Shock tube problem.   The solver is written in modern Fortran and core arithmetic is carried out in quadruple precision to give at least 15 digits of accuracy making the solution usable as a verification test for double precision computational hydrodynamics codes.   

## The Sod shock tube problem

The Sod shock tube problem for the  1-D Euler equations of inviscid, compressible hydrodynamics posed as a verification test problem by Gary Sod (1978)[^1]is an example of an initial value Riemann Problem.
The solution of the problem is known exactly although it does require finding the root of a real nonlinear equation numerically.  
The problem as stated by Sod is specifies the values for the density $\rho$, the pressure $P$, and the velocity $v$ in left and right initial states surrounding the location of $x=0$.  The exact problem as specified by Sod is
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
for the right initial state where $x \ge 0$.   The problem is evolved forward in time.
The specification of the problem is completed by specifying an equation of state of the 
form  $P = K \rho^\gamma$
where $\gamma$ is the adiabatic index of the gas.  In his original paper Sod took the value of $\gamma = 1.4$,  appropriate for a diatomic ideal gas such as molecular oxygen or molecular nitrogen.  In practice the value of $\gamma=5/3$, reflective of a monatomic ideal gas, is used for numerical verification testing.

## The Exact Solution
For the exact solution of the weak form of the Euler equations we follow the notation
of LeVeque (2002)[^2]
The solution consists of a series of five regions which we list in order, from left to right:
- A constant reion with initial left state values for density, pressure, and velocity.
- A rarefaction wave
- A constant region bounded by a contact discontinuity on the right.
- A constant region bounded by a shock wave on the right.
- A constant reion with initial right state values of density, pressure, and velocity.
  The density in each of these regions is depicted as
  
  




[^1] Sod, G. A. (1978) "A Survey of Several Finite Difference Methods for Systems of Nonlinear Hyperbolic Conservation Laws" (PDF). J. Comput. Phys. 27 (1): 1–31. Bibcode:1978JCoPh..27....1S. doi:10.1016/0021-9991(78)90023-2. OSTI 6812922.

[^2} LeVeque, R.J. (2002) "Finite Volume Methods for Hyperbolic Problems", Cambridge University Press, ISBN-13 978-0-521-00924-9






$$
