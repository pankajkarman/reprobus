      program  mapplot

      parameter(nlon = 180, nlat = 91, niv = 60)
      parameter(nbcon = 44, ncm = 15)
c
      real pj1(nlon,nlat)
      real tj1(nlon,nlat,niv)
      real uj1(nlon,nlat,niv)
      real vj1(nlon,nlat,niv)
      real alt(nlon,nlat,niv)
      real qj1(nlon,nlat,niv,nbcon)
      real hc(nlon,nlat,niv,ncm)
  
      call readfile('MODEL_history_2019050112_001410', 
     + niv, nbcon, ncm, pj1, uj1, vj1, alt, tj1, qj1, hc)
      print*, 'Pressure=', (pj1)  
      stop
      end 
      
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine readfile(fname, niv, nbcon, ncm, 
     + pj1, uj1, vj1, alt, tj1, qj1, hc)
c
      parameter(nlon = 180, nlat = 91)
      
      real pj1(nlon,nlat)
      real tj1(nlon,nlat,niv)
      real uj1(nlon,nlat,niv)
      real vj1(nlon,nlat,niv)
      real alt(nlon,nlat,niv)
      real qj1(nlon,nlat,niv,nbcon)
      real hc(nlon,nlat,niv,ncm)
      
      character*31 fname
      character*6  namexp
      
      character*10 nommois(12)
      character*10 mois
c
      data nommois/'  JANUARY ',' FEBRUARY ','   MARCH  ','   APRIL  ',
     +             '    MAY   ','   JUNE   ','   JULY   ','  AUGUST  ',
     +             ' SEPTEMBER','  OCTOBER ',' NOVEMBER ',' DECEMBER '/
c
      OPEN(20,FILE=fname,FORM='UNFORMATTED',
     +     ACCESS='SEQUENTIAL', CONVERT="BIG_ENDIAN")
      read(20) namexp, ian, imois, ijour, iheure, imin,
     +         pj1, uj1, vj1, alt, tj1, qj1, hc
      close(20) 
      
      mois = nommois(imois)
      
      write(*,13) ijour,mois,ian,iheure,imin,' UT'
 13   format(i2,a12,i6,2x,2i2,a3)
 
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
