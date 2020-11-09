subroutine readfile(fname, niv, nbcon, ncm, pj1, uj1, vj1, alt, tj1, qj1, hc)
      implicit none
      parameter(nlon = 180, nlat = 91)
      
      character*(*), intent(in) :: fname
      integer, intent(in) :: niv, nbcon, ncm
      
      real*8, intent(out) :: pj1(nlon,nlat)
      real*8, intent(out) :: tj1(nlon,nlat,niv)
      real*8, intent(out) :: uj1(nlon,nlat,niv)
      real*8, intent(out) :: vj1(nlon,nlat,niv)
      real*8, intent(out) :: alt(nlon,nlat,niv)
      real*8, intent(out) :: qj1(nlon,nlat,niv,nbcon)
      real*8, intent(out) :: hc(nlon,nlat,niv,ncm)     
      
      character*6  namexp      

      OPEN(20,FILE=fname,FORM='UNFORMATTED', ACCESS='SEQUENTIAL', CONVERT="BIG_ENDIAN")
      read(20) namexp, ian, imois, ijour, iheure, imin, pj1, uj1, vj1, alt, tj1, qj1, hc
      close(20)       
      write(*,13) ijour,imois,ian, ' ',iheure,'hr',imin,'m'
 13   format(i2,i2,i6,a2,i2,a2,i2,a1)
end subroutine
