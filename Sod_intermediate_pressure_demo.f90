!-------------------------------------------------------------------------------
!
!  Program unit: sod_solve_demo
!  Type:         module
!  Purpose:      Demo the sod_solve subroutine
!  Author:       F. Douglas Swesty
!  Version:      0.1
!  Date:         9/2/2026
!
!  Note:         This code uses quadruple precision for all floating point
!                arithmetic
!
!-------------------------------------------------------------------------------

program sod_solve_demo

  use sod_module, only: sod_solve
  
  implicit none
  
  integer, parameter :: QK=kind(1.0q0)

  real(kind=QK) :: gamma=1.4q0 ! Adiabatic index (original value in Sod's paper)

  real(kind=QK) :: rho_left=1.0q0    ! Density on left side
  real(kind=QK) :: p_left=1.0q0      ! Pressure on left side
  real(kind=QK) :: rho_right=0.125q0 ! Density on right side
  real(kind=QK) :: p_right=.1q0      ! Pressure on right side

  real(kind=QK) :: p_star            ! Pressure in constant states

  call sod_solve(gamma,rho_left,p_left,rho_right,p_right,p_star,.false.)

  write(*,*) 'sod_solve_demo: p_star = ',p_star

  stop 0
  
end program sod_solve_demo
  
