## Scripts to read reprobus data

**Note:** Reprobus codes should be compiled with 8-byte real numbers. So use appropriate flags for different compilers.

See [this link](https://users.soe.ucsc.edu/~dongwook/wp-content/uploads/2016/ams209/lectureNote/_build/html/chapters/chapt02/ch02_fortran_flags.html#double-precision-flags) to learn about various fortran flags.

For example:


```fortran
f77 -fdefault-real-8 -fdefault-double-8 -o repro extract_theta_2007-1.f && ./repro && rm ./repro
```

## For reading reprobus data in python

repro.f90 should be compiled with f2py using:

```python
f2py -c repro.f90 -m repro
```

and then readfile function can be used in python after importing repro as a module

## Structure  

1. [Fortran subroutine for reading reprobus data.](./repro.f90)
2. [Example use and conversion to xarray in python](./repro.ipynb)
