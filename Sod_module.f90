!-------------------------------------------------------------------------------
!
!  Program unit: sod_module
!  Type:         module
!  Purpose:      Compute the exact solution of the Sod problem
!  Author:       F. Douglas Swesty
!  Version:      0.5
!  Date:         9/2/2026
!
!  Note:         This module uses quadruple precision for all floating point
!                arithmetic
!
!-------------------------------------------------------------------------------

module sod_module

  implicit none
  integer, parameter :: QK = kind(1.0q0)

  logical :: solved = .false.  
  
contains

  !+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ! This subroutine solves for the intermediate pressure in the central
  ! region of the solution
  subroutine sod_intermediate_pressure(gamma,rhol,pl,rhor,pr,pstar,debug)
  !+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    implicit none

    real(kind=QK), intent(in)  :: gamma       ! Adiabatic index
    real(kind=QK), intent(in)  :: rhol        ! Density on left side
    real(kind=QK), intent(in)  :: pl          ! Pressure on left side
    real(kind=QK), intent(in)  :: rhor        ! Density on right side
    real(kind=QK), intent(in)  :: pr          ! Pressure on right side
    
    real(kind=QK), intent(out) :: pstar       ! Pressure in constant states
    logical, intent(in) :: debug              ! Debuging flag
    
    real(kind=QK) :: gm1      ! Gamma - 1
    real(kind=QK) :: gp1      ! Gamma + 1
    real(kind=QK) :: beta     ! Exponential factor in equations
    real(kind=QK) :: mu       ! Multiplicative factor in equations

    real(kind=QK) :: f        ! Nonlinear equation for intermediate pressure
    real(kind=QK) :: fprime   ! Derivative of non-linear equation w.r.t. press.
    
    real(kind=QK) :: f_left   ! Portion of equation due to left state
    real(kind=QK) :: df_left  ! Derivative of left state equation
    real(kind=QK) :: f_right  ! Portion of equation due to right state
    real(kind=QK) :: df_right ! Derivative of left state equation

    real(kind=QK) :: cl       ! Sound speed in left initial state
    real(kind=QK) :: cr       ! Sound speed in right initial state
    
    
    real(kind=QK) :: p_new    ! New pressure
    real(kind=QK) :: delta_p  ! Change in pressure
    integer :: counter        ! Iteration counter

                              ! Convergence tolerance.  This value was chosen
                              ! to assure convergence to 15 decimal places
    real(kind=QK), parameter :: TOLER=1.0q-16

    
    if( solved ) return       ! If we have already solved for pressure return
    
    gm1 = gamma-1.0q0         ! Calculate gamma - 1
    gp1 = gamma+1.0q0         ! Calculate gamma + 1
    beta = gm1/(2.0q0*gamma)  ! Exponent in nonlinear equation 
    mu = gp1/(2.0q0*gamma)    ! Muliplicative factor in equation

    cl = sqrt(gamma*pl/rhol)  ! Speed of sound in left state
    cr = sqrt(gamma*pr/rhor)  ! Speed of sound in right state
        
    pstar = 0.5q0*(pl+pr)     ! Initial guess at pressure halfway between
                              ! the pressures in the left and right states
    
    delta_p = TOLER+1.0q0     ! Initialize dp to some value larger
                              ! than the convergence tolerance
      
    counter = 1               ! Initialize the iteration counter

    
    if( pl > pr ) then ! Shock wave is moving left to right
       
      !-------------------------------------------------------------------------        
      do while( delta_p > TOLER ) ! Newton-Raphson loop
      !-------------------------------------------------------------------------        
                                ! Left equation & derivative
        f_left = (2.0q0*cl/gm1)*( (pstar/pl)**beta -1.0q0 )
        df_left = (2.0q0*cl/gm1)*(pstar**(beta-1.0q0))/(pl**beta)
        
                                ! Right equation and derivative
        f_right = (pstar-pr)/(rhor*cr * sqrt(beta+mu*pstar/pr) )
        df_right = 1.0q0/(rhor*cr*sqrt(beta+mu*pstar/pr) )  &
                   -0.5q0 * (pstar-pr) * (mu/pr) / &
                   ( rhor*cr*( sqrt(beta+mu*pstar/pr)**3 ) )

        f = f_left+f_right      ! Total nonlinear equation
        
                                ! Derivative of total nonlinear equation with
                                ! respect to the intermediate pressure
        fprime = (df_left+df_right)
        
        delta_p = f/fprime      ! Newton-Raphson change in pressure

        p_new = pstar - delta_p! New pressure

        if( debug ) then   ! If debugging is on then output iteration
          write(*,'(t2,i5,3(1x,es12.5))') counter,pstar,p_new,delta_p
        endif
        
        pstar = p_new           ! Update the pressure for next iteration
        
        counter = counter+1     ! Increment iteration counter
        
      !-------------------------------------------------------------------------        
      enddo                       ! End of Newton-Raphson loop
      !-------------------------------------------------------------------------        

    else                        ! Shock wave is moving right to left

stop 1
       
    endif
    
    solved = .true.             ! Indicate we have solved for pressure
    
    return
  !+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  end subroutine sod_intermediate_pressure
  !+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  !+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ! This subroutine gives the exact solution to the Sod problem
  subroutine sod_solution(x,t,gamma,rhol,pl,rhor,pr,rho,p,e,velocity)
  !+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    implicit none

    real(kind=QK), intent(in) :: x          ! Position
    real(kind=QK), intent(in) :: t          ! Time
    real(kind=QK), intent(in) :: gamma      ! Adiabatic index
    real(kind=QK), intent(in) :: rhol       ! Density in left state
    real(kind=QK), intent(in) :: pl         ! Pressure in left state
    real(kind=QK), intent(in) :: rhor       ! Density in right state
    real(kind=QK), intent(in) :: pr         ! Pressure in right state
    
    real(kind=QK), intent(out) :: rho       ! Density
    real(kind=QK), intent(out) :: p         ! Pressure
    real(kind=QK), intent(out) :: e         ! Energy
    real(kind=QK), intent(out) :: velocity  ! Velocity
    
    real(kind=QK) :: xrhead       ! Position of rarefaction head
    real(kind=QK) :: xrtail       ! Position of rarefaction tail
    real(kind=QK) :: xcontact     ! Position of contact discontinuity
    real(kind=QK) :: xshock       ! Position of shock

    real(kind=QK) :: cl           ! Sound speed in left state
    real(kind=QK) :: cr           ! Sound speed in right state

    real(kind=QK) :: pstar        ! Pressure in regions III & IV
    real(kind=QK) :: vstar        ! Velocity in regions III & IV
    real(kind=QK) :: ctail        ! Speed of sound at tail of rarefaction

    real(kind=QK) :: mu           ! Multiplicative factor in Sod solution
    real(kind=QK) :: beta         ! Exponent in Sod solution
    real(kind=QK) :: gm1          ! Gamma - 1
    real(kind=QK) :: gp1          ! Gamma + 1

    gm1 = gamma-1.0q0             ! Calculate gamma - 1
    gp1 = gamma+1.0q0             ! Calculate gamma + 1
    beta = gm1 / ( 2.0q0*gamma )  ! Calculate exponent in Sod solution    
    mu = gp1/ ( 2.0q0*gamma )     ! Calculate multiplicative factor

    cl = sqrt( gamma*pl/rhol )    ! Calculate left state sound speed
    cr = sqrt( gamma*pr/rhor )    ! Calculate right state sound speed

    if( pl >= pr ) then  ! Left-moving shock

                                  ! If solver has not been called then call it
       if(.not.solved) then
          call sod_intermediate_pressure(gamma,rhol,pl,rhor,pr,pstar,.false.)
       endif
                                  ! Calculate velocity in regions III & IV
      vstar = ( 2.0q0*cl/gm1 )*(1.0q0-(pstar/pl)**beta )
                                  
      ctail = cl*(pstar/pl)**beta ! Speed of sound at tail of rarefaction
      
      xrhead = -cl*t              ! Position of rarefaction head
      
      xrtail = (vstar-ctail)*t    ! Position of rarefaction tail

      xcontact = vstar*t          ! Position of contact discontinuity

                                  ! Position of shock
      xshock = t*cr*sqrt(mu*(pstar/pr)+beta)

      !----------------------------------------------------------
      if( x <= xrhead ) then                       ! Region I
      !----------------------------------------------------------
         
        rho = rhol                     ! Density
        p = pl                         ! Pressure
        velocity = 0.0q0               ! Velocity

      !----------------------------------------------------------
      elseif( xrhead < x .and. x <= xrtail) then   ! Region II
      !----------------------------------------------------------

                                       ! Density
        rho = rhol*(2.0q0/gp1 - (gm1*x)/(gp1*cl*t) )**(2.0q0/gm1)
                                       ! Pressure
        p = pl*(2.0q0/gp1 - (gm1*x)/(gp1*cl*t))**(2.0q0*gamma/gm1)
        velocity = (2.0q0/gp1)*(cl+x/t)! Velocity
        
      !----------------------------------------------------------
      elseif( xrtail < x .and. x <= xcontact) then ! Region III
      !----------------------------------------------------------
         
                                       ! Density
        rho = rhol*(pstar/pl)**(1.0q0/gamma)
        p = pstar                      ! Pressure
        velocity = vstar               ! Velocity

      !----------------------------------------------------------
      elseif( xcontact < x .and. x <= xshock) then ! Region IV
      !----------------------------------------------------------

                                       ! Density  
        rho = rhor*(  (gp1*pstar+gm1*pr) / (gm1*pstar+gp1*pr) )
        p = pstar                      ! Pressure
        velocity = vstar               ! Velocity

      !----------------------------------------------------------
      else                                         ! Region V
      !----------------------------------------------------------
         
        rho = rhor                     ! Density
        p = pr                         ! Pressure
        velocity = 0.0q0               ! Velocity

      !----------------------------------------------------------
      endif
      !----------------------------------------------------------

      e = p/(rho*gm1)             ! Specific energy

      
    else                 ! Right moving shock
      
       stop 2                     ! Stop w/ error until implemented 

    endif
        
    return

  !+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  end subroutine sod_solution
  !+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


  !+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ! This subroutine is a double precision wrapper around the quadruple precision
  ! version thus allowing it to be called from a double precision code
  subroutine sod_solution_double(x,t,gamma,rhol,pl,rhor,pr,rho,p,e,velocity)
  !+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    implicit none

    integer, parameter :: DK=kind(1.0d0)    ! Double precision kind
    integer, parameter :: QK=kind(1.0q0)    ! Quadruple precision kind
    
    real(kind=DK), intent(in) :: x          ! Position
    real(kind=DK), intent(in) :: t          ! Time
    real(kind=DK), intent(in) :: gamma      ! Adiabatic index
    real(kind=DK), intent(in) :: rhol       ! Density in left state
    real(kind=DK), intent(in) :: pl         ! Pressure in left state
    real(kind=DK), intent(in) :: rhor       ! Density in right state
    real(kind=DK), intent(in) :: pr         ! Pressure in right state
    
    real(kind=DK), intent(out) :: rho       ! Density
    real(kind=DK), intent(out) :: p         ! Pressure
    real(kind=DK), intent(out) :: e         ! Energy
    real(kind=DK), intent(out) :: velocity  ! Velocity

    real(kind=QK) :: qx                     ! Position
    real(kind=QK) :: qt                     ! Time
    real(kind=QK) :: qgamma                 ! Adiabatic index
    real(kind=QK) :: qrhol                  ! Density in left state
    real(kind=QK) :: qpl                    ! Pressure in left state
    real(kind=QK) :: qrhor                  ! Density in right state
    real(kind=QK) :: qpr                    ! Pressure in right state
    
    real(kind=QK) :: qrho                   ! Density
    real(kind=QK) :: qp                     ! Pressure
    real(kind=QK) :: qe                     ! Energy
    real(kind=QK) :: qvelocity              ! Velocity

    
          ! Transfer double precision data into quadruple precision variables
    qx = x
    qt = t
    qgamma = gamma
    qrhol = rhol
    qpl = pl
    qrhor = rhor
    qpr = pr
    qvelocity = velocity
    
          ! Compute the solution in quadruple precision
    call sod_solution(qx,qt,qgamma,qrhol,qpl,qrhor,qpr,qrho,qp,qe,qvelocity)

          ! Transfer data into double precision variables via a narrowing
          ! conversion
    rho = qrho
    p = qp
    e = qe
    velocity = qvelocity 
    
    return
    
  !+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  end subroutine sod_solution_double
  !+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
end module sod_module
  
