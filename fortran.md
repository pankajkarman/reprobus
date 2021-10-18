See [this link](https://users.soe.ucsc.edu/~dongwook/wp-content/uploads/2016/ams209/lectureNote/_build/html/chapters/chapt02/ch02_fortran_flags.html#double-precision-flags) to learn about various fortran flags.

For example:

```fortran
f77 -fdefault-real-8 -fdefault-double-8 -o repro extract_theta_2007-1.f && ./repro && rm ./repro
```