      program  mapplot

      parameter(nlon = 180, nlat = 91, niv = 60)
      parameter(nlonp1 = nlon + 1)
c
      parameter(ntheta = 3)
      parameter(nlong = 9, nshort = 2)
c
      parameter(nbcon = 44, ncm = 15)
c
      real pj1(nlon,nlat)
      real tj1(nlon,nlat,niv)
      real uj1(nlon,nlat,niv)
      real vj1(nlon,nlat,niv)
      real alt(nlon,nlat,niv)
      real qj1(nlon,nlat,niv,nbcon), hc(nlon,nlat,niv,ncm)
c
      real   theta(nlon,nlat,niv)
      real   pmb(nlon,nlat,niv)
      real   cinf(nlon,nlat)
      real   csup(nlon,nlat)
      real   aaa(niv), bbb(niv)
      real   aa(niv+1), bb(niv+1)
      real   gridfi(nlonp1,nlat)
      real   xtheta(ntheta),isotheta
c
      real   dthetadp(nlon,nlat)
      real   utheta(nlon,nlat)
      real   vtheta(nlon,nlat)
      real   dvdlam(nlon,nlat)
      real   dudphi(nlon,nlat)
      real   eta(nlon,nlat)
      real   pv(nlon,nlat)
      real   coriolis(nlat)
      real   cosphi(nlat)
c
      character*23 label_date
      character*7  label_niv
      character*6  namexp
      character*10 nommois(12)
      character*10 mois
c
      integer index(nlon,nlat)
      integer il(nlong), is(nshort)
      integer ian, imois, ijour, iheure, imin
c
      data rter/6.371229e+06/
      data gg /9.80665/
      data omega /7.292 e-05/
c
      data nommois/'  January ',' February ','   March  ','   April  ',
     $             '    May   ','   June   ','   July   ','  August  ',
     $             ' September','  October ',' November ',' December '/
c
      data xtheta
     $  / 435., 475., 550. / 
c
      data il/ 1, 13, 14, 21, 23, 24, 43, 44, 11/
      data is/ 5, 7 /
c
  121 format(i2,a10,i5,i4,'UT')
  122 format(i4,' K ')
  219 format(a14)
c
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     coefficients aaa et bbb des niveaux hybrides
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      open(unit = 10, file = 'ecmwf_60_levels.txt', form = 'formatted')
      OPEN(20,FILE='MODEL_history_2019050112_001410',FORM='UNFORMATTED',
     +     ACCESS='SEQUENTIAL', CONVERT="BIG_ENDIAN")
      open(unit=6, file="new.txt", status='unknown') 
      read(20) namexp, ian, imois, ijour, iheure, imin,
     +         pj1, uj1, vj1, alt, tj1, qj1, hc
      print*, 'lecture restart experience ',namexp,' okay.'
      print*, 'Shape=', alt
      close(20)
      write(6,101)' date modele : ',
     +            ian,imois,ijour,iheure,'h',imin,'mn'
 101  format(a15,i4,i3,i3,i4,a1,i3,a2)
c
      read(10,*)
      read(10,*)
      do iniv = 1,niv+1
         read(10,*) ibid, aa(iniv), bb(iniv)
      end do
      
      do iniv = 1,niv
         aaa(iniv) = (aa(iniv) + aa(iniv+1))*0.5*0.01
         bbb(iniv) = (bb(iniv) + bb(iniv+1))*0.5
      end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     isotheta: isentrope choisie pour le trace
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      rascp = 2./7.
      p0 = 1000.
c
      
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     boucle sur les isothetas
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      n_fich=24
c
      do ilevel = 1,ntheta
      n_fich=n_fich+1
c
      isotheta = xtheta(ilevel)
      print*, 'isotheta = ',isotheta,'K'
      print*, n_fich
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     calcul de theta a chaque point de grille
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      do iniv = 1,niv
         do ilat = 1,nlat
            do ilon = 1,nlon
               pmb(ilon,ilat,iniv) = aaa(iniv) 
     $                             + bbb(iniv)*pj1(ilon,ilat)
               theta(ilon,ilat,iniv) = tj1(ilon,ilat,iniv)
     $                     *((p0/pmb(ilon,ilat,iniv))**rascp)
            end do
         end do
      end do
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     detection des niveaux encadrant isotheta, et calcul des poids
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      do ilat = 1,nlat
         do ilon = 1,nlon
            do iniv = 2,niv
               if(theta(ilon,ilat,iniv).lt.isotheta) then
                  index(ilon,ilat) = iniv
                  cinf(ilon,ilat) = 
     $            (isotheta - theta(ilon,ilat,iniv))
     $           /(theta(ilon,ilat,iniv-1)-theta(ilon,ilat,iniv))
                  csup(ilon,ilat) = 1. - cinf(ilon,ilat)
                  goto 1000
               endif
            end do
 1000       continue
         end do
      end do
c                 
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     calcul de dthetadp aux niveaux qui encadrent isotheta,
c     puis interpolation verticale
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      do ilat = 1,nlat
         do ilon = 1,nlon
            dthetadpsup = 
     $       (theta(ilon,ilat,index(ilon,ilat)-2) 
     $       -theta(ilon,ilat,index(ilon,ilat))) 
     $      /((pmb(ilon,ilat,index(ilon,ilat)-2)
     $        -pmb(ilon,ilat,index(ilon,ilat)))*100.)
            dthetadpinf = 
     $       (theta(ilon,ilat,index(ilon,ilat)-1) 
     $       -theta(ilon,ilat,index(ilon,ilat)+1)) 
     $      /((pmb(ilon,ilat,index(ilon,ilat)-1)
     $        -pmb(ilon,ilat,index(ilon,ilat)+1))*100.)
            dthetadp(ilon,ilat) = dthetadpsup*cinf(ilon,ilat)
     $                          + dthetadpinf*csup(ilon,ilat)
         end do
      end do
      end do

      stop
      end
