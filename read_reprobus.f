      program  lec

      parameter(nlon = 180, nlat = 91, niv = 60)
      parameter(nlonp1 = nlon + 1)
      parameter(nbcon = 44, ncm = 15)
c
      real pj1(nlon,nlat)
      real tj1(nlon,nlat,niv)
      real uj1(nlon,nlat,niv)
      real vj1(nlon,nlat,niv)
      real alt(nlon,nlat,niv)
      real qj1(nlon,nlat,niv,nbcon), hc(nlon,nlat,niv,ncm)
c
      character*23 label_date
      character*7  label_niv
      character*6  namexp
      
      character*10 nommois(12)
      character*10 mois
      character*10 nomsta
c
      data nommois/'  JANUARY ',' FEBRUARY ','   MARCH  ','   APRIL  ',
     +             '    MAY   ','   JUNE   ','   JULY   ','  AUGUST  ',
     +             ' SEPTEMBER','  OCTOBER ',' NOVEMBER ',' DECEMBER '/
      
      OPEN(20,FILE='MODEL_history_2019050112_001410',
     + FORM='UNFORMATTED', ACCESS='SEQUENTIAL', CONVERT="BIG_ENDIAN")
     
      read(20) namexp, ian, imois, ijour, iheure, imin,
     +         pj1, uj1, vj1, alt, tj1, qj1, hc
     
      print*, 'reading restart experience ',namexp,' okay.'
      print*, 'shape=', pj1
      
      mois = nommois(imois)
      
      write(*,13) ijour,mois,ian,iheure,imin,'UT'
      call gregtojul(ian,imois,ijour,iheure,imin,day)
      print*, day
      
c      write(*,12) pj1
c
 13   format(i2,a12,i6,2x,2i2,a2)
 12   format(f10.5)
      close(20)

      stop
      end
      
      
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
