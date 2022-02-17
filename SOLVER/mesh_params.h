! Proc 140: Header for mesh information to run static solver
! created by the mesher on 04/29/2021, at 23h 14min
 
!:::::::::::::::::::: Input parameters :::::::::::::::::::::::::::
!   Background model     :            prem_iso
!   Dominant period [s]  :    1.0000
!   Elements/wavelength  :    1.5000
!   Courant number       :    0.6000
!   Coarsening levels    :         3
!:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
 
 integer, parameter ::         npol =         4  !            polynomial order
 integer, parameter ::        nelem =     65504  !                   proc. els
 integer, parameter ::       npoint =   1637600  !               proc. all pts
 integer, parameter ::    nel_solid =     54672  !             proc. solid els
 integer, parameter ::    nel_fluid =     10832  !             proc. fluid els
 integer, parameter :: npoint_solid =   1366800  !             proc. solid pts
 integer, parameter :: npoint_fluid =    270800  !             proc. fluid pts
 integer, parameter ::  nglob_fluid =    175525  !            proc. flocal pts
 integer, parameter ::     nel_bdry =        48  ! proc. solid-fluid bndry els
 integer, parameter ::        ndisc =        12  !   # disconts in bkgrd model
 integer, parameter ::   nproc_mesh =       140  !        number of processors
 integer, parameter :: lfbkgrdmodel =         8  !   length of bkgrdmodel name
 
!:::::::::::::::::::: Output parameters ::::::::::::::::::::::::::
!   Time step [s]        :    0.0077
!   Min(h/vp),dt/courant :    0.0738    0.0515
!   max(h/vs),T0/wvlngth :    0.6667    0.6667
!   Inner core r_min [km]: 1000.9936
!   Max(h) r/ns(icb) [km]:    1.7131
!   Max(h) precalc.  [km]:    1.7843
!:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
 
