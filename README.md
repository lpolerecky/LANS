# Look@NanoSIMS

Look@NanoSIMS (abbreviated as **LANS**) is a [free software](http://www.gnu.org/philosophy/free-sw.html) 
for the analysis of NanoSIMS image data acquired by the Cameca NanoSIMS 50L instrument. It is distributed 
as a Matlab code, thus it requires a working installation of Matlab (proprietary software) to run.

The software is written and maintained by Lubos Polerecky (LP). The development started in 2008, at the 
time when LP worked at the Max-Planck Institute for Marine Microbiology in Bremen, Germany. Since 2013, LP 
continues with the development of the program as part of his permanent employment at Utrecht University in the 
Netherlands.

**Current version: 2022-09-02**

## Features

1. **Loading** of secondary ion counts (SIC) image data (Cameca `im` files)
   
    - all planes and masses (default)
    - selected planes and masses
    - planes in blocks
    - merging multiple *.im files into one
    - corrections for dead-time and QSA
    - compressed data (`im.zip` files, roughly 10% size of the original `im` files)
    - data previously processed and exported by LANS (`mat`) 

2. **Accumulation** of planes, with **drift-correction** applied

    - Definition of **regions of interest (ROIs)**
    - manual and semi-automated
    - based on NanoSIMS images, or on an imported **external** image (e.g., FISH, TEM, SEM, AFM) with **alignment** done within LANS
    - ROI **classification** (manual & automated based on a logical expression)
    - watershed segmentation of ROIs

3. **Quantification** of isotopic and elemental **ratios** (defined through an arbitrary expression)
- **Display and export** of results in **text** and **graphics** formats
  - images (various colormaps, ROI outlines can be included, hue intensity can be modulated)
  - lateral and depth profiles
  - histograms
  - scatter plots (color-coded based on ROI classification)
  - overlays of nanoSIMS images in an RGB image
  - overlays of nanoSIMS and external images in an RGB image or a 3D surface plot
- **Statistical analysis** of data in ROIs 
  - comparison of ROIs
  - comparison of ROI classes
  - comparison of treatments or experimental time-points
- Tools for processing and statistical analysis of **multiple nanoSIMS datasets**
  - images
  - interactive scatter plots
  - statistical comparison of ROIs, ROI classes and treatments
  - depth profiles in ROIs
  - automated reprocessing of previously processed datasets

## How to install, run and use LANS

Instructions for installing, running and using LANS are documented on [this dedicated website](http://nanosims.geo.uu.nl/nanosims-wiki/doku.php/nanosims:lans) maintained by LP.

## Acknowledgement

Please include the following citation if you used LANS in your work. 

L. Polerecky, B. Adam, J. Milucka, N. Musat, T. Vagner, M. M. M. Kuypers (2012). 
Look@NanoSIMS – a tool for the analysis of nanoSIMS data in environmental microbiology. 
Environmental Microbiology 14 (4): 1009–1023.
[DOI:10.1111/j.1462-2920.2011.02681.x](http://onlinelibrary.wiley.com/doi/10.1111/j.1462-2920.2011.02681.x/abstract)

## Contact 

Over the years, many features have been added to LANS thanks to students, collaborators, and other NanoSIMS users 
from around the world. If you would like to have a new feature added to LANS, contact LP via email:
`l (dot) polerecky (at) uu (dot) nl`. 

If you experience problems or find bugs, please contact LP as well - he will be happy to help you out.
