program  mapplot

      parameter(nlon = 180, nlat = 91, niv = 60)
      parameter(nbcon = 44, ncm = 15)
      real pj1(nlon,nlat)
      real tj1(nlon,nlat,niv)
      real uj1(nlon,nlat,niv)
      real vj1(nlon,nlat,niv)
      real alt(nlon,nlat,niv)
      real qj1(nlon,nlat,niv,nbcon)
      real hc(nlon,nlat,niv,ncm)
  
      call readfile('MODEL_history_2019050112_001410', niv, nbcon, ncm, pj1, uj1, vj1, alt, tj1, qj1, hc)
      print*, 'Pressure=', (pj1)  
end 
      
subroutine readfile(fname, niv, nbcon, ncm, pj1, uj1, vj1, alt, tj1, qj1, hc)
      parameter(nlon = 180, nlat = 91)
      
      real, intent(out) :: pj1(nlon,nlat)
      real, intent(out) :: tj1(nlon,nlat,niv)
      real, intent(out) :: uj1(nlon,nlat,niv)
      real, intent(out) :: vj1(nlon,nlat,niv)
      real, intent(out) :: alt(nlon,nlat,niv)
      real, intent(out) :: qj1(nlon,nlat,niv,nbcon)
      real, intent(out) :: hc(nlon,nlat,niv,ncm)
      
      character*(*), intent(in) :: fname
      integer, intent(in) :: niv, nbcon, ncm
      
      character*6  namexp      

      OPEN(20,FILE=fname,FORM='UNFORMATTED', ACCESS='SEQUENTIAL', CONVERT="BIG_ENDIAN")
      read(20) namexp, ian, imois, ijour, iheure, imin, pj1, uj1, vj1, alt, tj1, qj1, hc
      close(20)       
      write(*,13) ijour,imois,ian, ' ',iheure,'hr',imin,'m'
 13   format(i2,i2,i6,a2,i2,a2,i2,a1)
end subroutine
