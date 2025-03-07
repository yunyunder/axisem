!
!    Copyright 2013, Tarje Nissen-Meyer, Alexandre Fournier, Martin van Driel
!                    Simon Stähler, Kasra Hosseini, Stefanie Hempel
!
!    This file is part of AxiSEM.
!    It is distributed from the webpage <http://www.axisem.info>
!
!    AxiSEM is free software: you can redistribute it and/or modify
!    it under the terms of the GNU General Public License as published by
!    the Free Software Foundation, either version 3 of the License, or
!    (at your option) any later version.
!
!    AxiSEM is distributed in the hope that it will be useful,
!    but WITHOUT ANY WARRANTY; without even the implied warranty of
!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!    GNU General Public License for more details.
!
!    You should have received a copy of the GNU General Public License
!    along with AxiSEM.  If not, see <http://www.gnu.org/licenses/>.
!

!=========================================================================================
module discont_meshing

  use global_parameters
  use data_bkgrdmodel
  use data_spec
  use model_discontinuities, only : define_discont
  use background_models 
  use data_diag

  implicit none

  public :: create_subregions
  private

  contains

!-----------------------------------------------------------------------------------------
subroutine create_subregions

  real(kind=dp), allocatable                 :: rdisc_top(:), rdisc_bot(:)
  real(kind=dp), dimension(:), allocatable   :: ds_glob, radius_arr
  real(kind=dp), dimension(:), allocatable   :: vp_arr, vs_arr
  real(kind=dp)     :: ds, minh, maxh, aveh, dz, current_radius
<<<<<<< HEAD
  integer           :: idom, ic, icount_glob, iz_glob
  integer           :: ns_ref,  ns_ref_icb1, ns_ref_icb, ns_ref_surf
  logical           :: memorydz, current
=======
  integer           :: idom, ic, icount_glob, iz_glob, cl_last
  integer           :: ns_ref,  ns_ref_icb1, ns_ref_icb, ns_ref_surf
  logical           :: memorydz, current, solflu_bdry, cl_forbidden
>>>>>>> 572e2fc237182c0cc262ce1c5d2b10214c1f3b57
  integer, dimension(1)             :: iloc1, iloc2
  real(kind=realkind), dimension(1) :: rad1, rad2
  character(len=32) :: fmtstring

<<<<<<< HEAD
=======

>>>>>>> 572e2fc237182c0cc262ce1c5d2b10214c1f3b57
  !- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ! constraining factors/relations for mesh architecture:
  ! 1) number of coarsening levels:
  !    ncoars = log( vs(cmb)/vs(surf)*r(surf)/r(cmb) ) / log(2) = 3.2 (for PREM)
  ! 2) period/resolution: nlambda = period * min(vs/h)
  ! 3) time step:  dt < courant * min(h/vp)
  ! 3),4) ===> keep
  ! 4) resulting number of lateral elements ns(r) = nlambda * r / ( vp * period)
  ! ==> first "derive" global ns(r), ds(r) and from that define nz(r),dz(r)
  !     for each subdomain such that dz(r) varies less than ds(r)
  ! 5) additionally: number of linear central elements
  ! 6) number of lateral processor domains (cakepieces)
  ! 7) coarsening levels need to be between discontinuities
  ! ==> total number of subdomains: ndisc+ncoars
  !- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  ! Define background model discontinuities (e.g. PREM)
  ! & model specific boolean "solid" (fluid layers?) for each subdomain

   have_fluid = .false.
   have_solid = .true.
   nfluidregions = 0

   call define_discont

<<<<<<< HEAD
=======
   if (max_depth > 0.) then
      rmin = discont(1) - max_depth * 1e3
      do idom = 1, ndisc
        print *, idom, discont(idom)
        if (discont(idom) < rmin) exit
      end do 
      discont(ndisc) = rmin
      ndisc = idom - 1
      write(6,*) 
      write(6,*) 'Setting minimum radius to ', rmin, ' meter'
      write(6,*) 'Using only the first ', ndisc, 'layers'
      write(6,*) 
   end if

>>>>>>> 572e2fc237182c0cc262ce1c5d2b10214c1f3b57
   allocate(rdisc_top(ndisc), rdisc_bot(ndisc), solid_domain(ndisc)) 
   allocate(idom_fluid(ndisc))
   idom_fluid=0

   solid_domain(1:ndisc) = .true.
   do idom = 1, ndisc
      if (idom < ndisc) then
         rdisc_top(idom) = discont(idom)
         rdisc_bot(idom) = discont(idom+1)
      else
         rdisc_top(idom) = discont(idom)
         rdisc_bot(idom) = zero
      endif

      if (vs(idom,1) == 0.0d0 .and. vs(idom,2) == 0.0d0) then 
         nfluidregions = nfluidregions + 1
         have_fluid = .true.
         solid_domain(idom) = .false.
         idom_fluid(nfluidregions) = idom
      elseif( vs(idom,1)==0.0d0 .and. vs(idom,2)/=0.0d0 .or.  &
              vs(idom,1)/=0.0d0 .and. vs(idom,2)==0.0d0) then 
         write(6,*) 'ERROR in background model region:'
         write(6,*) 'Cannot have one region with fluid and solid parts...'
         write(6,*) 'upper radius/vs:', rdisc_top(idom), vs(idom,1)
         write(6,*) 'lower radius/vs:', rdisc_bot(idom), vs(idom,2)
<<<<<<< HEAD
=======
         stop
>>>>>>> 572e2fc237182c0cc262ce1c5d2b10214c1f3b57
      endif
      
      write(6,*) '#######################################################################'
      fmtstring = '("  ", A, I12, F12.2)'
      write(6,fmtstring)'discontinuities:    ', idom,real(discont(idom))
      fmtstring = '("  ", A, L12, I12)'
      write(6,fmtstring)'solid/fluid domain: ', solid_domain(idom),idom_fluid(idom)
      fmtstring = '("  ", A, F12.2, F12.2)'
      write(6,fmtstring)'upper/lower radius: ', real(rdisc_top(idom)),real(rdisc_bot(idom))
      write(6,fmtstring)'vs jump:            ', real(vs(idom,1)),real(vs(idom,2))
      write(6,*) '#######################################################################'
      write(6,*) 

   end do

   if (nfluidregions == ndisc) then 
      write(6,*) 'COMPLETELY acoustic domain!'
      have_solid = .false.
   endif
      
   write(6,"(10x,'Number of discontinuities/regions:     ',i3)") ndisc
   write(6,"(10x,'Number of fluid regions:               ',i3)") nfluidregions
 
   write(6,*)''
   write(6,*)'Constructing the mesh....'
   write(6,*)''

  ! Loop over discontinuities/subregions
  icount_glob = 0   ! element depth levels
  ic = 0            ! coarsening levels

  ! nc expected for PREM :
  ! nc = int( log( (r_surface/min_velocity_surface (S))/ &
  !                 (r_icb/min_velocity_icb (P)) ) )
  
  ! take surface/crustal values as constraint on ns resolution
  if (solid_domain(1)) then 
     ns_ref_surf = estimate_ns(pts_wavelngth, rdisc_top(1), vs(1,1), period)
  else ! top layer is a fluid
     ns_ref_surf = estimate_ns(pts_wavelngth, rdisc_top(1), vp(1,1), period)
  endif

  if (dump_mesh_info_screen) &
        write(6,*) 'ns_ref initial estimate from crust   :', ns_ref_surf
 
  ! take ICB value as constraint on ns resolution 
  if (solid_domain(ndisc)) then 
     ns_ref_icb1 = estimate_ns(pts_wavelngth, rdisc_top(ndisc), vs(ndisc,1), period) &
                        * 2 ** nc_init
  else ! bottom layer is a fluid
     ns_ref_icb1 = estimate_ns(pts_wavelngth, rdisc_top(ndisc), vp(ndisc,1), period) &
                        * 2 ** nc_init
  endif

  if (dump_mesh_info_screen) &
        write(6,*) 'ns_ref initial estimate from icb     :', ns_ref_icb1

  ! need to resolve the crust and icb
  ns_ref = max(ns_ref_icb1, ns_ref_surf)

  ! need to make sure that ns_ref is defined such that ns is even below 
  ! last coarsening level (fix to make sure nel and lnodes counts are correct)
  if ( mod(ns_ref, 2 ** nc_init * nthetaslices*2) /= 0 ) &
        ns_ref = (2 ** nc_init * nthetaslices * 2) &
                    * (ns_ref / (2 ** nc_init * nthetaslices * 2) + 1)

  if (dump_mesh_info_screen) &
        write(6,*) 'ns_ref fixed with procs & coarsenings:', ns_ref

  ns_glob = ns_ref
      
  ! DETERMINE rmin such that elements in central region are not too large.
  ! Assumptions taken here: 
  !  - velocities in lowermost layer very low such that they constrain the 
  !         amount of lateral elements needed at the surface
  !  - almost constant, non-decreasing velocities in the inner core 
  
  if (solid_domain(ndisc)) then 
     maxh_icb = period * vs(ndisc,1) / (pts_wavelngth * max_spacing(npol))
  else
     maxh_icb = period * vp(ndisc,1) / (pts_wavelngth * max_spacing(npol))
  endif

<<<<<<< HEAD
  !rmin = maxh_icb * (dble(ns_ref / dble(2. * dble(2**nc_init))) + 1.d0)
  rmin = maxh_icb * (ns_ref / (2.d0 * 2**nc_init) + 1)

  if (dump_mesh_info_screen) &
        write(6,*) 'actual ds at innermost discontinuity [km] :', &
                    0.5 * pi * rdisc_top(ndisc) / real(ns_ref) * real(2**nc_init) / 1000.
=======
  ! factor 0.8 to compensate for the deformation of the elements in the inner core
  if (max_depth<0) &
     rmin = 0.8 * maxh_icb * (ns_ref / (2.d0 * 2**nc_init) + 1)

  if (dump_mesh_info_screen) &
        write(6,*) 'actual ds at innermost discontinuity [km] :', &
                    local_lat_fac * rdisc_top(ndisc) / real(ns_ref) * real(2**nc_init) / 1000.
>>>>>>> 572e2fc237182c0cc262ce1c5d2b10214c1f3b57
  if (dump_mesh_info_screen) & 
        write(6,*) 'maximal dz at innermost discontinuity [km]:', maxh_icb / 1000.

  if (rmin > rdisc_top(ndisc) - maxh_icb * .9) then 
     ! at least the ICB....
     rmin = rdisc_top(ndisc) - maxh_icb * .9
  endif

  if (dump_mesh_info_screen) then
     write(6,*) 'CALCULATED RMIN=', rmin
     write(6,*) 'MAXH_ICB=', maxh_icb
     write(6,*) '# central region elements (incl. buffer, e.g. along axis):', &
            int(ns_ref / (2.* 2**nc_init) + 1.)
  endif
<<<<<<< HEAD

=======
     
>>>>>>> 572e2fc237182c0cc262ce1c5d2b10214c1f3b57
  rdisc_bot(ndisc) = rmin 

  ! trial loop to calculate global amount of radial layers icount_glob and 
  ! coarsening levels ic
<<<<<<< HEAD
=======
  icount_glob = 0
  cl_last = 0
>>>>>>> 572e2fc237182c0cc262ce1c5d2b10214c1f3b57
  do idom =1, ndisc
     current_radius = rdisc_top(idom)
     memorydz = .false.
     do while (current_radius > rdisc_bot(idom) ) 
<<<<<<< HEAD
        call compute_dz_nz(idom, rdisc_bot, current_radius, dz, ds, current, memorydz, &
                           icount_glob, ic, ns_ref)
=======
       if (current_radius==rdisc_top(idom).and.(idom>1)) then
         solflu_bdry = solid_domain(idom) .neqv. solid_domain(idom-1)
         if (solflu_bdry) &
           print *, 'Solid-Fluid boundary found at ', current_radius
       else 
         solflu_bdry = .false.
       end if
       cl_forbidden = solflu_bdry .or. (icount_glob - cl_last < 1)
       call compute_dz_nz(idom, rdisc_bot, current_radius, dz, ds, current, memorydz, &
                          icount_glob, ic, ns_ref, cl_forbidden)
       if (current) cl_last = icount_glob
>>>>>>> 572e2fc237182c0cc262ce1c5d2b10214c1f3b57
     end do
  enddo

  write(6,*)
  write(6,"(10x,'Spherical shell part of the mesh:')")
  write(6,"(10x,'Total number of depth levels:        ',i6)") icount_glob
  write(6,"(10x,'Actual number of coarsening levels:     ',i3)") ic
  write(6,"(10x,'Anticipated number of coarsening levels:',i3)") nc_init
  
  !TODO: MvD: can't this be automatized?
  if (nc_init /= ic) then 
     write(6,*) ' a bit of rethinking is needed for nc_init!',&
                  'Check your calculus'
     stop
  end if

  ! assign global values after counting 'em
  nz_glob = icount_glob
  nc_glob = ic
  allocate(dz_glob(nz_glob))
  allocate(iclev_glob(1:nc_glob))
  allocate(ds_glob(nz_glob), radius_arr(nz_glob))
  allocate(vp_arr(nz_glob), vs_arr(nz_glob))

  ! Final output needed to feed the skeleton (data_bkgrdmodel.f90):
  ! ns_glob, nz_glob counting all depth levels
  ! dz_glob(1:nz_glob)
  ! nc_glob number of coarsening levels
  ! iclev_glob(1:nc_glob)
  
  ns_ref = max(ns_ref_icb1, ns_ref_surf)

  ! need to make sure that ns_ref is defined such that ns is even below 
  ! last coarsening level (fix to make sure nel and lnodes counts are correct)
  if (mod(ns_ref, 2**nc_init*nthetaslices*2) /= 0 ) &
        ns_ref = (2**nc_init*nthetaslices*2)* ( ns_ref/(2**nc_init*nthetaslices*2) + 1 )

  if (dump_mesh_info_screen) &
        write(6,*) 'ns_ref fixed with # processors/coarsenings:' , ns_ref
  
  ns_glob = ns_ref
 
  ndisc = ndisc
  icount_glob = 0 
<<<<<<< HEAD
=======
  cl_last = 0
>>>>>>> 572e2fc237182c0cc262ce1c5d2b10214c1f3b57
  ic = 0 

  do idom=1, ndisc
     current_radius = rdisc_top(idom)
<<<<<<< HEAD
     memorydz = .false. 
     do while (current_radius > rdisc_bot(idom)) 
        call compute_dz_nz(idom, rdisc_bot, current_radius, dz, ds, current, memorydz, &
                           icount_glob, ic, ns_ref)
        ! Storing radial info into global arrays
        if (current) iclev_glob(ic) = nz_glob - icount_glob + 1
        dz_glob(icount_glob) = dz 
        ds_glob(icount_glob) = ds
        radius_arr(icount_glob) = current_radius
        vp_arr(icount_glob) = velocity(current_radius, 'v_p', idom, bkgrdmodel, &
                                       lfbkgrdmodel)
        vs_arr(icount_glob) = velocity(current_radius, 'v_s', idom, bkgrdmodel, &
                                       lfbkgrdmodel)
        if (vs_arr(icount_glob) < 0.1d0 * vs_arr(1)) & 
                vs_arr(icount_glob) = vp_arr(icount_glob)
=======
     ! print *, '-------------------------------------'
     ! print *, idom, rdisc_top(idom), rdisc_bot(idom)

     memorydz = .false. 

     do while (current_radius > rdisc_bot(idom)) 
       if (current_radius==rdisc_top(idom).and.(idom>1)) then
         solflu_bdry = solid_domain(idom) .neqv. solid_domain(idom-1)
         if (solflu_bdry) &
           print *, 'Solid-Fluid boundary found at ', current_radius
       else 
         solflu_bdry = .false.
       end if
       ! If there has been a CL in the previous layer or we are at a solid-fluid
       ! boundary, do not put a CL here
       cl_forbidden = solflu_bdry .or. (icount_glob - cl_last < 1)

       call compute_dz_nz(idom, rdisc_bot, current_radius, dz, ds, current, memorydz, &
                          icount_glob, ic, ns_ref, cl_forbidden)

       if (current) cl_last = icount_glob
       ! Storing radial info into global arrays
       if (current) then
         iclev_glob(ic) = nz_glob - icount_glob + 1
       end if

       if (current) &
         print *, 'Coarsening Layer at ', current_radius

       dz_glob(icount_glob) = dz 
       ds_glob(icount_glob) = ds
       radius_arr(icount_glob) = current_radius
       vp_arr(icount_glob) = velocity(current_radius, 'v_p', idom, bkgrdmodel, &
                                      lfbkgrdmodel)
       vs_arr(icount_glob) = velocity(current_radius, 'v_s', idom, bkgrdmodel, &
                                      lfbkgrdmodel)
       if (vs_arr(icount_glob) < 0.1d0 * vs_arr(1)) & 
               vs_arr(icount_glob) = vp_arr(icount_glob)
>>>>>>> 572e2fc237182c0cc262ce1c5d2b10214c1f3b57
     end do
  enddo

  ! scale for smallest grid spacing in GLL clustering
  call gll_spacing(npol,minh,maxh,aveh)

  dt = courant * min(minval(ds_glob/vp_arr), minval(dz_glob/vp_arr)) &
            / dble(npol) * minh/ aveh

  if (dump_mesh_info_screen) write(6,*) 'TIME STEP:', dt

  if (dump_mesh_info_files) then
     open(unit=667,file=diagpath(1:lfdiag)//'/period_courant_pts_wavelength.txt')
     write(667,11)period,courant,pts_wavelngth,dt
     write(667,11)minh,maxh,aveh,real(npol)
     open(unit=668,file=diagpath(1:lfdiag)//'/ds_dz.txt')
     iloc1=minloc(ds_glob/vp_arr) ; rad1=radius_arr(iloc1)
     iloc2=minloc(dz_glob/vp_arr) ; rad2=radius_arr(iloc2)
     write(668,11)minval(ds_glob/vp_arr),rad1, minval(dz_glob/vp_arr),rad2

    ! %%%%%%%%%%% for MATLAB %%%%%%%%%%%%%
     open(unit=666,file=diagpath(1:lfdiag)//'/ds_dz_matlab.txt')
<<<<<<< HEAD
     do iz_glob = 1, nz_glob
        write(666,11) radius_arr(iz_glob),dz_glob(iz_glob),ds_glob(iz_glob), &
=======
     do iz_glob = 1, nz_glob-1
        write(666,11) radius_arr(iz_glob),sum(dz_glob(iz_glob+1:))+radius_arr(nz_glob), &
             dz_glob(iz_glob),ds_glob(iz_glob), &
>>>>>>> 572e2fc237182c0cc262ce1c5d2b10214c1f3b57
             vs_arr(iz_glob)*period,vp_arr(iz_glob)/min(ds_glob(iz_glob), & 
             dz_glob(iz_glob))*dt*real(npol)/minh*aveh
     end do
11   format(40(1pe12.5,2x))
    ! %%%%%%%%%%% end MATLAB %%%%%%%%%%%%%

     close(666)
     close(667)
     close(668)
  end if

<<<<<<< HEAD
=======

>>>>>>> 572e2fc237182c0cc262ce1c5d2b10214c1f3b57
  if (dump_mesh_info_files) then
     open(unit=30,file=diagpath(1:lfdiag)//'/coarsening_radii.dat')
     do ic=1,nc_glob
        write(30,*)iclev_glob(ic),radius_arr(iclev_glob(ic))
     enddo
     close(30)
  end if

  ! INNER CORE

  ns_ref_icb = ns_ref
  minh_ic = vp(ndisc,1) * min(minval(ds_glob / vp_arr), minval(dz_glob / vp_arr)) &
              * minh / aveh

  if (solid_domain(ndisc)) then 
     ns_ref = estimate_ns(pts_wavelngth, discont(ndisc), vs(ndisc,1), period)
     maxh_ic = vs(ndisc,1) * max(maxval(ds_glob / vs_arr), maxval(dz_glob / vs_arr)) &
                    * maxh / aveh
  else
     ns_ref = estimate_ns(pts_wavelngth, discont(ndisc), vp(ndisc,1), period)
     maxh_ic = vp(ndisc,1) * max(maxval(ds_glob / vs_arr), maxval(dz_glob / vs_arr)) &
                    * maxh / aveh
  endif

  if (dump_mesh_info_screen) then
     write(6,*) ' NS_REF at ICB + from meshing ', ns_ref_icb
     write(6,*) ' WHAT WE WANT ', ns_ref
     write(6,*)
     write(6,*) 'MESH EFFICIENCY: smallest/largest spacing etc. '
     write(6,*) 'min (h_el/vp):   ', & 
          min(minval(ds_glob/vp_arr),minval(dz_glob/vp_arr))*minh/aveh
     write(6,*) 'dt/courant*npol: ',dt/courant*real(npol)
     write(6,*)
     write(6,*) 'max (h_el/vs):         ', &
          max(maxval(ds_glob/vs_arr),maxval(dz_glob/vs_arr))*maxh/aveh
     write(6,*) 'period/pts_Wavelength: ',period/pts_wavelngth
     write(6,*)
  end if
  
  if (dump_mesh_info_files) then 
     open(30,file=diagpath(1:lfdiag)//'/test_innercore_hminmax.dat')
     write(30,*) minh_ic, maxh_ic
     close(30)
  end if

  if (dump_mesh_info_screen) then
     write(6,*) 'Inner Core element sizes:'
     write(6,*) 'r_min=', rmin
<<<<<<< HEAD
     write(6,*) 'max h r/ns(icb):', pi * 0.5 * discont(ndisc) / real(ns_ref_icb)
=======
     write(6,*) 'max h r/ns(icb):', local_lat_fac * discont(ndisc) / real(ns_ref_icb)
>>>>>>> 572e2fc237182c0cc262ce1c5d2b10214c1f3b57
     write(6,*) 'precalculated max h:', maxh_icb
     write(6,*) 'max h:', maxh_ic
     write(6,*) 'min h:', minh_ic
  end if

  ! for mesh_params.h
  minhvp = min(minval(ds_glob / vp_arr), minval(dz_glob / vp_arr)) * minh / aveh
  maxhvs = max(maxval(ds_glob / vs_arr), maxval(dz_glob / vs_arr)) * maxh / aveh
<<<<<<< HEAD
  maxhnsicb = pi * 0.5d0 * discont(ndisc) / dble(ns_ref_icb)
=======
  maxhnsicb = local_lat_fac * discont(ndisc) / dble(ns_ref_icb)
>>>>>>> 572e2fc237182c0cc262ce1c5d2b10214c1f3b57

end subroutine create_subregions
!-----------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------
subroutine compute_dz_nz(idom, rdisc_bot, current_radius, dz, ds, current, memorydz,  &
<<<<<<< HEAD
                         icount_glob, ic, ns_ref)
=======
                         icount_glob, ic, ns_ref, cl_forbidden)
>>>>>>> 572e2fc237182c0cc262ce1c5d2b10214c1f3b57

  use data_grid, only: fluidfac

  integer, intent(in)           :: idom
  real(kind=dp), intent(in)     :: rdisc_bot(ndisc)
  real(kind=dp), intent(inout)  :: current_radius, dz, ds
  logical, intent(inout)        :: current, memorydz
  integer, intent(inout)        :: icount_glob, ic
  integer, intent(inout)        :: ns_ref
<<<<<<< HEAD
  
  real(kind=dp)                 :: dz_trial
  real(kind=dp)                 :: velo
  integer                       :: nz_trial,ns_trial
=======
  logical, intent(in)           :: cl_forbidden
  
  real(kind=dp)                 :: ds_ref, dz_trial, dz_buff, scaling, dz1, dz2
  real(kind=dp)                 :: velo
  real(kind=dp)                 :: nz_trial, ns_trial
>>>>>>> 572e2fc237182c0cc262ce1c5d2b10214c1f3b57
  
  current = .false.
  
  if (solid_domain(idom)) then 
     velo = velocity(current_radius,'v_s',idom,bkgrdmodel,lfbkgrdmodel)
  else
     ! add a prefactor here to make smaller elements in outer core and
     ! reduce dispersion error in outer core!
     ! Outer Core P-Waves see a lot more dispersion error than in the
     ! mantle, due to beeing on the resolution edge. But as the fluid is
     ! really cheap, we could just make the elements smaller...
     velo = fluidfac * velocity(current_radius,'v_p',idom,bkgrdmodel,lfbkgrdmodel)
  end if
  ns_trial = estimate_ns(pts_wavelngth,current_radius,velo,period)
  icount_glob = icount_glob+1

<<<<<<< HEAD
  if (ns_trial < ns_ref/2.and. (ic<nc_init) ) then
=======
  if (ns_trial < ns_ref / 2. .and. (ic < nc_init) .and. (.not.cl_forbidden) ) then
>>>>>>> 572e2fc237182c0cc262ce1c5d2b10214c1f3b57
     ! Is coarsening possible within this subregion 
     ! (<- are there at least two elemental 
     ! layers between the actual layer and the bottom of the subregion?)

<<<<<<< HEAD
     dz_trial = .5d0* pi * current_radius / dble(ns_ref)
     nz_trial = max(ceiling((current_radius-rdisc_bot(idom))/dz_trial),1)
     if (nz_trial >= 3) then
        ns_trial = ns_ref
=======
     dz_trial = local_lat_fac * current_radius / dble(ns_trial)
     ds_ref = local_lat_fac * current_radius / dble(ns_ref)

     nz_trial = (current_radius - rdisc_bot(idom)) / dz_trial

     ! first condition: avoid shallow layers
     ! second condition: if the elements are elongated vertically such that the time 
     ! step is not getting worse by adding the refinement, still put it here
     print *, idom, nz_trial, 0.5 / nz_trial, dz_trial / ds_ref
     if (nz_trial > 0.8 .or. 0.5 / nz_trial < dz_trial / ds_ref) then
>>>>>>> 572e2fc237182c0cc262ce1c5d2b10214c1f3b57
        ns_ref = ns_ref / 2
        ic = ic + 1
        memorydz = .true.
        current = .true. 
     end if 
  end if
<<<<<<< HEAD
  dz_trial = .5d0* pi * current_radius / dble(ns_trial)
  if (memorydz .and. .not. current) then
     dz_trial = .5d0* pi * current_radius / dble(2*ns_trial)
     memorydz = .false.
  end if
  nz_trial = max(ceiling((current_radius-rdisc_bot(idom))/dz_trial),1)
  dz = (current_radius-rdisc_bot(idom))/dble(nz_trial)
  ds = .5d0* pi * current_radius / dble(ns_ref)
  current_radius = current_radius -dz
=======

  ! find height of the element (dz)
  if (current) then
     ! first element of refinment layer
     
     dz_buff = local_lat_fac * current_radius / dble(ns_trial)
     nz_trial = ceiling((current_radius - rdisc_bot(idom)) / dz_buff)

     if (nz_trial > 1.) then
        ! if we can choose the element size freely, use maximum edgelength allowed and 
        ! 45 degree angle in the refinment
        dz = local_lat_fac * current_radius * (1d0 / dble(ns_trial) - 1d0 / dble(2*ns_ref))
        scaling = (current_radius - rdisc_bot(idom)) / dble(nz_trial) / dz_buff
        dz = dz * scaling
     else
        ! if we are close to the next discontinuity
        ! 1: half way to the next discontinuity
        dz1 = (current_radius - rdisc_bot(idom)) / 2.
        ! 2: 45 degree minimum angle in the refinement layer
        dz2 = (current_radius - rdisc_bot(idom)) - local_lat_fac * current_radius / (3. * ns_ref)
        ! for very thin layers use 1, defaults to 2
        dz = max(dz1, dz2)
     endif

  else if (memorydz .and. .not. current) then
     ! second element of refinment layer
     dz_trial = local_lat_fac * current_radius / dble(2 * ns_ref)
     memorydz = .false.

  else
     ! normal elements
     dz_trial = local_lat_fac * current_radius / dble(ns_trial)
  end if

  if (.not. memorydz) then
     ! the latter two cases
     nz_trial = max(ceiling((current_radius - rdisc_bot(idom)) / dz_trial), 1)
     dz = (current_radius - rdisc_bot(idom)) / dble(nz_trial)
  end if

  ds = local_lat_fac * current_radius / dble(ns_ref)
  current_radius = current_radius - dz
>>>>>>> 572e2fc237182c0cc262ce1c5d2b10214c1f3b57

end subroutine compute_dz_nz
!-----------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------
<<<<<<< HEAD
integer function estimate_ns(el_per_lambda,r,v,period)

  real(kind=dp) ,intent(in) :: el_per_lambda,r
  real(kind=dp)             :: v, period
=======
pure integer function estimate_ns(el_per_lambda,r,v,period)

  real(kind=dp), intent(in) :: el_per_lambda,r
  real(kind=dp), intent(in) :: v, period
>>>>>>> 572e2fc237182c0cc262ce1c5d2b10214c1f3b57
  real(kind=dp)             :: minh, maxh, aveh
  
  ! scaling for irregular GLL spacing
  call gll_spacing(npol, minh, maxh, aveh)
<<<<<<< HEAD
  estimate_ns=ceiling(el_per_lambda * .5d0 * pi * r / (v * period) * maxh / aveh)
=======
  estimate_ns = ceiling(el_per_lambda * local_lat_fac * r / (v * period) * maxh / aveh)
>>>>>>> 572e2fc237182c0cc262ce1c5d2b10214c1f3b57

end function estimate_ns
!-----------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------
subroutine spacing_info(npol)
  
  use splib
  
  integer, intent(in) :: npol
  real(kind=dp)       :: minh, maxh, aveh
  real(kind=dp),allocatable,dimension(:) :: eta, xi_k, dxi
  real(kind=dp),allocatable,dimension(:) :: spacing_eta, spacing_xi
  
  integer :: i
  
  allocate(eta(0:npol), xi_k(0:npol), dxi(0:npol))
  allocate(spacing_eta(1:npol), spacing_xi(1:npol))

  call ZELEGL(npol, eta, dxi)
  call zemngl2(npol, xi_k)

  ! spacing within [0,1]
  do i=0, npol-1
     spacing_eta(i+1) = dabs(eta(i) - eta(i+1)) / 2.d0
     spacing_xi(i+1) = dabs(xi_k(i) - xi_k(i+1)) / 2.d0
  enddo

  minh = min(minval(spacing_eta), minval(spacing_xi))  
  maxh = max(maxval(spacing_eta), maxval(spacing_xi))
  aveh = 1.d0 / dble(npol)

  write(6,*) '============================================================'
  write(6,*) 'GLL SPACING for polynomial order', npol
  write(6,*) '  AVERAGE SPACING:       ', aveh
  write(6,*) '  MINIMAL SPACING:       ', minh
  write(6,*) '  MAXIMAL SPACING:       ', maxh
  write(6,*) '  MIN/AVE, MAX/AVE:      ', minh / aveh, maxh / aveh
  write(6,*) '  MIN GLL,GLJ SPACING:   ', minval(spacing_eta), minval(spacing_xi)
  write(6,*) '  MAX GLL,GLJ SPACING:   ', maxval(spacing_eta), maxval(spacing_xi)
  write(6,*) '  MINGLL/AVE,MINGLJ/AVE: ', minval(spacing_eta) / aveh, &
                                          minval(spacing_xi) / aveh
  write(6,*) '  MAXGLL/AVE,MAXGLJ/AVE: ', maxval(spacing_eta) / aveh, &
                                          maxval(spacing_xi) / aveh
  write(6,*) '  VALUES GLL, GLJ in [0,1]:'
  
  do i=0, npol
     write(6,*) i, eta(i), xi_k(i)
  enddo
  write(6,*)'============================================================'
  
end subroutine spacing_info
!-----------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------
<<<<<<< HEAD
subroutine gll_spacing(npol, minh, maxh, aveh)
=======
pure subroutine gll_spacing(npol, minh, maxh, aveh)
>>>>>>> 572e2fc237182c0cc262ce1c5d2b10214c1f3b57

  use splib
  
  integer, intent(in)           :: npol
  real(kind=dp), intent(out)    :: minh, maxh, aveh
  real(kind=dp) :: spacing_eta(npol), spacing_xi(npol)
  real(kind=dp) :: eta(0:npol), xi_k(0:npol), dxi(0:npol)

  integer :: i

  call zelegl(npol, eta, dxi)
  call zemngl2(npol, xi_k)

  ! spacing within [0,1]
  do i=0, npol-1
     spacing_eta(i+1) = dabs(eta(i) - eta(i+1)) / 2.d0
     spacing_xi(i+1) = dabs(xi_k(i) - xi_k(i+1)) / 2.d0
  enddo

  minh = min(minval(spacing_eta), minval(spacing_xi))
  maxh = max(maxval(spacing_eta), maxval(spacing_xi))
  aveh = 1.d0 / dble(npol)
  
end subroutine gll_spacing
!-----------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------
real(kind=dp) function max_spacing(npol)

  use splib
  
  integer, intent(in) :: npol
  real(kind=dp) :: minh,maxh,aveh
  real(kind=dp) :: spacing_eta(npol), spacing_xi(npol)
  real(kind=dp) :: eta(0:npol), xi_k(0:npol), dxi(0:npol)
  
  integer :: i

  call ZELEGL(npol,eta,dxi)
  call zemngl2(npol,xi_k)

  ! spacing within [0,1]
  do i=0, npol-1
     spacing_eta(i+1) = dabs(eta(i) - eta(i+1)) / 2.d0
     spacing_xi(i+1) = dabs(xi_k(i) - xi_k(i+1)) / 2.d0
  enddo

  minh = min(minval(spacing_eta), minval(spacing_xi))
  maxh = max(maxval(spacing_eta), maxval(spacing_xi))
  aveh = 1.d0 / dble(npol)
 
  max_spacing = maxh / aveh 
end function max_spacing
!-----------------------------------------------------------------------------------------

end module discont_meshing
!=========================================================================================
