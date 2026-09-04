!-------------------------------------------------------------------------------
!
!  Program unit: sod_solution_demo
!  Type:         module
!  Purpose:      Demo the sod_solution subroutine and produce a table
!                of the Sod solution versus poistion
!  Author:       F. Douglas Swesty
!  Version:      1.0
!  Date:         9/3/2026
!
!  Note:         This code uses quadruple precision for all floating point
!                arithmetic
!
!-------------------------------------------------------------------------------

program sod_solution_demo

  use sod_module, only: sod_solution
  
  implicit none
  
  integer, parameter :: QK=kind(1.0q0)

  real(kind=QK) :: gamma             ! Adiabatic index
  real(kind=QK) :: rhol = 1.0q0      ! Density on left side
  real(kind=QK) :: pl = 1.0q0        ! Pressure on left side
  real(kind=QK) :: rhor = 0.125q0    ! Density on right side
  real(kind=QK) :: pr = 0.1q0        ! Pressure on right side
  real(kind=QK) :: p_star            ! Pressure in constant states
  real(kind=QK) :: t                 ! Time
  real(kind=QK) :: x                 ! Position
  real(kind=QK) :: rho               ! Density
  real(kind=QK) :: p                 ! Pressure
  real(kind=QK) :: e                 ! Specific energy
  real(kind=QK) :: velocity          ! Velocity
  integer :: lun                     ! Logical unit number

  t = 0.7q0                          ! Initialize the time
  x = -2.0q0                         ! Initialize x location
  gamma = 5.0q0/3.0q0                ! Initialize adiabatic index

                                     ! Open the output file
  open(file='sod_exact.dat',newunit=lun,action='WRITE',status='replace')
  
  do while( x <= 2.0q0 )             ! Loop over range -2 < x < 2

                                     ! Get the exact solution
     call sod_solution(x,t,gamma,rhol,pl,rhor,pr,rho,p,e,velocity)

                                     ! Output solution to the file
     write(lun,'(5(es12.5,1x))') x,velocity,p,rho,e

     x = x+0.01q0                    ! Increment the position
     
  enddo
  
  close(unit=lun)                    ! Close the file
  
  stop 0
  
end program sod_solution_demo
  
