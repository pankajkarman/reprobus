try:
    get_ipython().run_line_magic('load_ext', 'autotime')
    print('autotime loaded.')
except:
    print('autotime not loaded.')
    
try:
    get_ipython().run_line_magic('load_ext', 'watermark')
    print('watermark loaded.')
except:
    print('watermark not loaded.')
    
try:
    get_ipython().run_line_magic('load_ext', 'nb_black')
    print('black loaded.')
except:
    print('black not loaded.')
    
try:
    get_ipython().run_line_magic('load_ext', 'lab_black')
    print('black loaded.')
except:
    print('black not loaded.')

import warnings
warnings.filterwarnings('ignore')

#import cmaps
import h5py
import os, glob
import traceback
import numpy as np
import scipy as sp
import pandas as pd
import xarray as xr
import pickle as pkl
import geopandas as gpd
import matplotlib as mpl
from tqdm import tqdm
import matplotlib.pyplot as plt
from matplotlib.ticker import AutoMinorLocator
from matplotlib import ticker
import matplotlib.gridspec as gridspec

from mpl_toolkits.axes_grid1 import make_axes_locatable

import string
alphabets = list(string.ascii_lowercase)

try:
    os.environ["PROJ_LIB"] = os.path.join(os.environ["CONDA_PREFIX"], "share", "proj")
    from mpl_toolkits.basemap import Basemap, addcyclic, cm
    
except:
    print('Basemap Not loaded.')

try:
    from StringIO import StringIO as io## for Python 2
except ImportError:
    from io import StringIO as io## for Python 3


#plt.subplot_tool()
mpl.rcParams.update(mpl.rcParamsDefault) 
mpl.rcParams['figure.figsize'] = (8.27, 11.69)  # A4 papersize portrait mode
mpl.rcParams['figure.titlesize'] = 25
mpl.rcParams['font.size'] = 20
#mpl.rc('lines', linewidth=2)
mpl.rcParams['lines.linewidth'] = 2
mpl.rcParams['lines.markersize'] = 3

mpl.rcParams['axes.titlesize'] = 24
mpl.rcParams['axes.labelsize'] = 24
mpl.rcParams['axes.labelpad'] = 10
#mpl.rcParams['axes.labelweight'] = 'bold'
#mpl.rc('font', weight='bold')
#mpl.rcParams['axes.titleweight'] = 'bold'
mpl.rcParams["xtick.top"] = "on"
mpl.rcParams["xtick.bottom"] = "on"
mpl.rcParams["xtick.major.size"] = 10
mpl.rcParams["ytick.major.size"] = 10
mpl.rcParams["ytick.minor.size"] = 6
mpl.rcParams["xtick.minor.size"] = 6
mpl.rcParams["xtick.labelsize"]  = 22
mpl.rcParams["ytick.labelsize"]  = 22
mpl.rcParams['xtick.direction']  = 'in'
mpl.rcParams['ytick.direction']  = 'in' 

mpl.rcParams['legend.fontsize']  = 10
mpl.rcParams['legend.labelspacing'] = 0.1

mpl.matplotlib_fname()
#mpl.rcParams.keys()

def save_pickle(data, filename):
    with open(filename, "w") as df:
        pkl.dump(data, df)
