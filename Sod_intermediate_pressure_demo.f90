!-------------------------------------------------------------------------------
!
!  Program unit: sod_solve_demo
!  Type:         module
!  Purpose:      Demo the sod_solve subroutine
!  Author:       F. Douglas Swesty
!  Version:      1.0
!  Date:         9/2/2026
!
!  Note:         This code uses quadruple precision for all floating point
!                arithmetic
!
!-------------------------------------------------------------------------------

program sod_intermediate_pressure_demo

  use sod_module, only: sod_intermediate_pressure
  
  implicit none
  
  integer, parameter :: QK=kind(1.0q0)

  real(kind=QK) :: gamma=1.4q0 ! Adiabatic index (original value in Sod's paper)

  real(kind=QK) :: rhol = 1.0q0    ! Density on left side
  real(kind=QK) :: pl = 1.0q0      ! Pressure on left side
  real(kind=QK) :: rhor = 0.125q0  ! Density on right side
  real(kind=QK) :: pr = 0.1q0      ! Pressure on right side

  real(kind=QK) :: pstar           ! Pressure in constant states

  call sod_intermediate_pressure(gamma,rhol,pl,rhor,pr,pstar,.false.)

  write(*,*) 'sod_solve_demo: pstar = ',pstar

  stop 0
  
end program sod_intermediate_pressure_demo
  
