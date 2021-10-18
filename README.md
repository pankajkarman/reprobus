## Scripts to read reprobus data

[Click here to see the species list from Reprobus](species.md)

## Usage

```python
from main import Reprobus

filename = 'MODEL_history_2020120412_001437'
ncfile = 'ex.nc'
bus = Reprobus(filename)
print(f"Saving %s" % ncfile)
bus.data[["Ozone", "POx"]].to_netcdf(ncfile)
```

![Reprobus Ozone 2020](./fig/reprobus_ozone.gif)

## For reading reprobus data in python

repro.f90 should be compiled with f2py using:

```python
f2py -c repro.f90 -m repro
```

and then readfile function can be used in python after importing repro as a module

**Note:** Reprobus codes should be compiled with 8-byte real numbers. So use appropriate flags for different compilers.

## Structure  

1. [Fortran subroutine for reading reprobus data.](./repro.f90)
2. [Example use and conversion to xarray in python](./repro.ipynb)
