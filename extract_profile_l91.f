cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      program extract
c
      parameter(nlon = 180, nlat = 91, niv = 91, nivbas = 63)
      parameter(nbcon = 44, ncm = 15)
c
      real*8 pj1(nlon,nlat)
      real*8 uj1(nlon,nlat,niv)
      real*8 vj1(nlon,nlat,niv)
      real*8 alt(nlon,nlat,niv)
      real*8 tj1(nlon,nlat,niv)
      real*8 qj1(nlon,nlat,niv,nbcon)
      real*8 hc(nlon,nlat,niv,ncm)
      real   long(nbcon,niv), short(nbcon,niv)
      real   sza(nlon,nivbas), hnm(niv), theta(niv), pmb(niv)
      real   aaa(niv), bbb(niv)
c
      character*6  namexp
      character*28 lab2
      character*12 lab3d(nbcon)
      character*12 labsh(ncm)
      character*10 nommois(12)
      character*10 mois
      character*10 nomsta
c
      data nommois/'  JANUARY ',' FEBRUARY ','   MARCH  ','   APRIL  ',
     +             '    MAY   ','   JUNE   ','   JULY   ','  AUGUST  ',
     +             ' SEPTEMBER','  OCTOBER ',' NOVEMBER ',' DECEMBER '/
c
      data lab3d/'N2O         ','CH4         ',
     +           'H2O         ','NOy         ',
     +           'HNO3        ','N2O5        ',
     +           'Cly         ','Ox          ',
     +           'CO          ','OClO        ',
     +           'Passive Ox  ','H2SO4       ',
     +           'HCl         ','ClONO2      ',
     +           'HOCl        ','Cl2         ',
     +           'H2O2        ','ClNO2       ',
     +           'HBr         ','BrONO2      ',
     +           'NOx         ','HNO4        ',
     +           'ClOx        ','BrOx        ',
     +           'Cl2O2       ','HOBr        ',
     +           'BrCl        ','CH2O        ',
     +           'CH3O2       ','CH3O2H      ',
     +           'CFC-11      ','CFC-12      ',
     +           'CFC-113     ','CCl4        ',
     +           'CH3CCl3*    ','CH3Cl       ',
     +           'HCFC-22*    ','CH3Br       ',
     +           'H-1211*     ','H-1301      ',
     +           'Bry         ','CH2Br2*     ',
     +           'HNO3 GAS    ','SURFACE     '/
c
      data labsh/'O(1D)       ','OH          ',
     +           'Cl          ','O(3P)       ',
     +           'O3          ','HO2         ',
     +           'NO2         ','NO          ',
     +           'Br          ','N           ',
     +           'ClO         ','BrO         ',
     +           'NO3         ','H           ',
     +           'CH3         '/
c
c     coefficients aaa et bbb des niveaux hybrides
c
      open(unit = 20, file = 'ecmwf_91_levels.txt', form = 'formatted')
c
      read(20,*)
      read(20,*)
      do iniv = 1,niv+1
         read(20,*) ibid, aa(iniv), bb(iniv)
      end do
      close(20)
c
      do iniv = 1,niv
         aaa(iniv) = (aa(iniv) + aa(iniv+1))*0.5*0.01
         bbb(iniv) = (bb(iniv) + bb(iniv+1))*0.5
      end do
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      open(15, form='formatted', file= 'input.txt')
      read(15,*) nomsta
      read(15,*) xlas
      read(15,*) xlos
      close(15)
c
      read(20) namexp, ian, imois, ijour, iheure, imin,
     $         pj1, uj1, vj1, alt, tj1, qj1, hc
      write(6,*) 'extraction pour ',nomsta
      write(6,*) 'xlat = ',xlas,' xlon = ',xlos
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     mise en forme de la date
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      mois = nommois(imois)
      write(lab2,13)ijour,mois,ian,iheure,imin,'UT'
c
 13   format(i2,a12,i6,2x,2i2,a2)
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     determination des indices de latitude et longitude
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      dlon = 360./real(nlon)
      dlat = 180./real(nlat - 1)
c
      ilon = nint(xlos/dlon) + 1
      ilat = nint((90. - xlas)/dlat) + 1
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     calcul de l'angle zenithal pour chaque station
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      call gregtojul(ian,imois,ijour,iheure,imin,day)
      call zenith2(ilat, day, sza)
      szasta = sza(ilon,1)
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     ecriture d'informations utiles
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      write(59,332) 'RUN ',namexp
      write(59,*)
      write(59,333)' REPROBUS JULIAN DAY = ',day
      write(59,*)
      write(59,335) lab2
      write(59,*)
      write(59,115) nomsta
      write(59,*)
      write(59,112)'LONGITUDE = ',xlos,
     $             ' LATITUDE = ',xlas
      write(59,114)'ILON      = ',ilon,
     $             ' ILAT     = ',ilat
      write(59,*)
      write(59,113)'SOLAR ZENITH ANGLE = ',szasta
      write(59,*)
c
 112  format(1x,a12,f8.3,a12,f8.3)
 113  format(1x,a21,f7.2)
 114  format(1x,a12,i8,a12,i8)
 115  format(1x,a10)
 332  format(1x,a4,a6)
 333  format(a23,f8.4)
 335  format(1x,a28)
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     calcul de la pression, concentration, et theta
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      do iniv = 1,niv
         pmb(iniv) = aaa(iniv) + bbb(iniv)*pj1(ilon,ilat)
      end do
c
      do iniv = 1,niv
         hnm(iniv)   =  pmb(iniv)
     $                  /(tj1(ilon,ilat,iniv)*1.38e-19)
         theta(iniv) =  tj1(ilon,ilat,iniv)
     $                  *(1000./pmb(iniv))**(2./7.)
      end do
      do iniv = 1,niv
         do is = 1,nbcon
            long(is,iniv)  = qj1(ilon,ilat,iniv,is)
         end do
         do is = 1,ncm
            short(is,iniv) = hc(ilon,ilat,iniv,is)
         end do
      end do
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     ecriture proprement dite, en colonnes
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      write(59,1000)'ALTITUDE    ',
     $              'PRESSURE    ',
     $              'TEMPERATURE ',
     $              'THETA       ',
     $              'DENSITY     ',
     $              (lab3d(is),is = 1,1)
      write(59,*)
      do iniv = 1,niv
         write(59,1001) alt(ilon,ilat,iniv),
     $                  pmb(iniv),
     $                  tj1(ilon,ilat,iniv),
     $                  theta(iniv),
     $                  hnm(iniv),
     $                  (long(is,iniv),is=1,1)
      end do
      write(59,*)
      write(59,1000)'PRESSURE    ',(lab3d(is),is = 2,6)
      write(59,*)
      do iniv = 1,niv
         write(59,1001) pmb(iniv),
     $                  (long(is,iniv),is=2,6)
      end do
      write(59,*)
      write(59,1000)'PRESSURE    ',(lab3d(is),is = 7,11)
      write(59,*)
      do iniv = 1,niv
         write(59,1001) pmb(iniv),
     $                  (long(is,iniv),is=7,11) 
      end do
      write(59,*)
      write(59,1000)'PRESSURE    ',(lab3d(is),is = 12,16)
      write(59,*)
      do iniv = 1,niv
         write(59,1001) pmb(iniv),
     $                       (long(is,iniv),is=12,16)
      end do
      write(59,*)
      write(59,1000)'PRESSURE    ',(lab3d(is),is = 17,21)
      write(59,*)
      do iniv = 1,niv
         write(59,1001) pmb(iniv),
     $                       (long(is,iniv),is=17,21)
      end do
      write(59,*)
      write(59,1000)'PRESSURE    ',(lab3d(is),is = 22,26)
      write(59,*)
      do iniv = 1,niv
         write(59,1001) pmb(iniv),
     $                       (long(is,iniv),is=22,26)
      end do
      write(59,*)
      write(59,1000)'PRESSURE    ',(lab3d(is),is = 27,31)
      write(59,*)
      do iniv = 1,niv
         write(59,1001) pmb(iniv),
     $                       (long(is,iniv),is=27,31)
      end do
      write(59,*)
      write(59,1000)'PRESSURE    ',(lab3d(is),is = 32,36)
      write(59,*)
      do iniv = 1,niv
         write(59,1001) pmb(iniv),
     $                       (long(is,iniv),is=32,36)
      end do
      write(59,*)
      write(59,1000)'PRESSURE    ',(lab3d(is),is = 37,41)
      write(59,*)
      do iniv = 1,niv
         write(59,1001) pmb(iniv),
     $                       (long(is,iniv),is=37,41)
      end do
      write(59,*)
      write(59,1000)'PRESSURE    ',(lab3d(is),is = 42,44)
      write(59,*)
      do iniv = 1,niv
         write(59,1001) pmb(iniv),
     $                       (long(is,iniv),is=42,44)
      end do
      write(59,*)
      write(59,1000)'PRESSURE    ',(labsh(is),is = 1,5)
      write(59,*)
      do iniv = 1,niv
         write(59,1001) pmb(iniv),
     $                       (short(is,iniv),is=1,5)
      end do
      write(59,*)
      write(59,1000)'PRESSURE    ',(labsh(is),is = 6,10)
      write(59,*)
      do iniv = 1,niv
         write(59,1001) pmb(iniv),
     $                       (short(is,iniv),is=6,10)
      end do
      write(59,*)
      write(59,1000)'PRESSURE    ',(labsh(is),is = 11,15)
      write(59,*)
      do iniv = 1,niv
         write(59,1001) pmb(iniv),
     $                       (short(is,iniv),is=11,15)
      end do
c
      close(59)
c
 1000 format(2x,6a12)
 1001 format(6e12.4)
c
      stop
      end
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine zenith2(ilat, day, sza )
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     calcul de l'angle zenithal solaire                                 c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      parameter(nlon = 180, nlat = 91, niv = 91, nivbas = 63)
c
      real sza(nlon,nivbas)
      real day,ut
      real rlt
      integer ilat
c
      REAL lbut,lzut
      REAL tz, rdecl, eqr, eqh, zpt
      REAL csz, zr
      REAL sintz, costz, sin2tz, cos2tz, sin3tz, cos3tz
c
      pi = 2.*asin(1.0)
c
      xlat = 90. - real(ilat - 1)*2.
c
      ut = (day - aint(day))*24.
      rlt = xlat*pi/180.
c
* Equation 3.8 for "day-angle"

      tz = 2.*pi*day/365.
c
* Calculate sine and cosine from addition theoremes for
* better performance;  the computation of sin2tz,
* sin3tz, cos2tz and cos3tz is about 5-6 times faster
* than the evaluation of the intrinsic functions
*
* It is SIN(x+y) = SIN(x)*COS(y)+COS(x)*SIN(y)
* and   COS(x+y) = COS(x)*COS(y)-SIN(x)*SIN(y)
*
* sintz  = SIN(tz)      costz  = COS(tz)
* sin2tz = SIN(2.*tz)   cos2tz = SIN(2.*tz)
* sin3tz = SIN(3.*tz)   cos3tz = COS(3.*tz)
*
      sintz = SIN(tz)
      costz = COS(tz)
      sin2tz = 2.*sintz*costz
      cos2tz = costz*costz-sintz*sintz
      sin3tz = sintz*cos2tz + costz*sin2tz
      cos3tz = costz*cos2tz - sintz*sin2tz

* Equation 3.7 for declination in radians

      rdecl = 0.006918 - 0.399912*costz  + 0.070257*sintz
     $                 - 0.006758*cos2tz + 0.000907*sin2tz
     $                 - 0.002697*cos3tz + 0.001480*sin3tz

* Equation 3.11 for Equation of time  in radians

      eqr   = 0.000075 + 0.001868*costz  - 0.032077*sintz
     $                 - 0.014615*cos2tz - 0.040849*sin2tz

* convert equation of time to hours:

      eqh = eqr*24./(2.*pi)
c
      do ilon = 1,nlon
c        calculate local hour angle (hours):
         lbut = 12. - eqh - real(ilon-1)*(360./real(nlon))*24./360.
c        convert to angle from UT
         lzut = 15.*(ut - lbut)
         zpt = lzut*pi/180.
c        Equation 2.4 for cosine of zenith angle
         csz = SIN(rlt)*SIN(rdecl) + COS(rlt)*COS(rdecl)*COS(zpt)
         zr = ACOS(csz)
         sza(ilon,1) = zr*180./pi
         sza(ilon,1) = max(sza(ilon,1),0.)
      end do
c
      do iniv = 2,nivbas
         do ilon = 1,nlon
            sza(ilon,iniv) = sza(ilon,1)
         end do
      end do
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine gregtojul(ian,imois,ijour,iheure,imin,jul)
c
c     calcul du jour julien decimal en fonction de la date
c     et de l'heure.
c     on utilise la convention suivante: 
c     1 janvier    0h tu =   0.0
c     31 decembre 24h tu = 365.0 (ou 366.0 si bissextile)
c
      real jul
c
      integer imn(12)
c
      data imn/31,28,31,30,31,30,31,31,30,31,30,31/
c
c     correction du format ecmwf/grib
c 
      if (ian .le. 100) then
         if (ian .le. 10) then
            ian = 2000 + ian
         else
            ian = 1900 + ian
         endif
      endif
c
c     annees bissextiles
c
      if (mod(ian,4) .eq. 0) then
         imn(2) = 29
      else
         imn(2) = 28
      endif
c
      jul = 0.
      do im = 1,imois - 1
         jul = jul + real(imn(im))
      end do  
      jul = jul + real(ijour - 1) + real(iheure)/24. 
     $    + real(imin)/1440.
c   
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
