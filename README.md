## Scripts to read reprobus data

**Note:** Reprobus codes should be compiled with 8-byte real numbers. So use appropriate flags for different compilers.

See [this link](https://users.soe.ucsc.edu/~dongwook/wp-content/uploads/2016/ams209/lectureNote/_build/html/chapters/chapt02/ch02_fortran_flags.html#double-precision-flags) to learn about various fortran flags.

For example:


```fortran
f77 -fdefault-real-8 -fdefault-double-8 -o repro extract_theta_2007-1.f && ./repro && rm ./repro
```

## Species list

 1. N2O
 2. CH4
 3. H2O       
 4. NOy
 5. HNO3       
 6. N2O5
 7. Cly
 8. Ox
 9. CO
10. OClO
11. Passive Ox
12. H2SO4       
13. HCl 
14. ClONO2
15. HOCl
16. Cl2         
17. H2O2
18. ClNO2
19. HBr
20. BrONO2
21. NOx 
22. HNO4 
23. ClOx
24. BrOx        
25. Cl2O2
26. HOBr
27. BrCl 
28. CH2O 
29. CH3O2 
30. CH3O2H      
31. CFC-11
32. CFC-12  
33. CFC-113
34. CCl4 
35. CH3CCl3*
36. CH3Cl
37. HCFC-22* 
38. CH3Br       
39. H-1211*
40. H-1301      
41. Bry 
42. CH2Br2* 
43. HNO3 GAS
44. SURFACE AREA          

45. O(1D)    
46. OH 
47. Cl
48. O(3P)
49. O3 
50. HO2  
51. NO2
52. NO 
53. Br
54. N  
55. ClO
56. BrO
57. NO3 
58. H
59. CH3


## For reading reprobus data in python

repro.f90 should be compiled with f2py using:

```python
f2py -c repro.f90 -m repro
```

and then readfile function can be used in python after importing repro as a module

## Structure  

1. [Fortran subroutine for reading reprobus data.](./repro.f90)
2. [Example use and conversion to xarray in python](./repro.ipynb)
