# Look@NanoSIMS

## Summary

Look@NanoSIMS (abbreviated as **LANS**) is a [free software](http://www.gnu.org/philosophy/free-sw.html) for the analysis of NanoSIMS data produced by the Cameca NanoSIMS 50L instrument. Because LANS is developed in Matlab and makes use of pdflatex, you will need Matlab (proprietary software) and LaTeX (free software) installed on your computer to run it.

## Features

- **Loading** of secondary ion counts (SIC) image data (Cameca *.im files)
  - all planes and masses
  - in blocks
  - selected planes and masses
  - merging of multiple *.im files into one
  - dead-time and QSA corrections applicable
  - support of zip-compressed input data (*.im.zip files)
- **Accumulation** of planes, with **drift-correction** applied
- Definition of **regions of interest (ROIs)**
  - manual and semi-automated
  - based on NanoSIMS images, or on an imported **external** image (e.g., FISH, TEM, SEM) with **alignment** done within LANS
  - ROI **classification** (manual & automated)
  - watershed segmentation of ROIs
- **Quantification** of isotopic and elemental **ratios**
- **Display and export** of results in **text** and **graphics** formats
  - images (various colormaps)
  - lateral and depth profiles
  - histograms
  - scatter plots (color-coded based on ROI classification)
  - overlays of nanoSIMS images in an RGB image
  - overlays of nanoSIMS and external images in an RGB image or a 3D surface plot
- **Statistical analysis** of data in ROIs 
  - comparison of ROIs
  - comparison of ROI classes
  - comparison of treatments or experimental time-points
- Tools for **processing and statistical analysis of multiple** nanoSIMS datasets

## Installation instructions

Download the latest stable version of the program, manuals, and test-data.

To start the program, open Matlab and set the Matlab's working directory to the folder where you cloned the 'LAN' directory. In Matlab console type lookatnanosims. That's it.

Note: To ensure that `LANS` can export results into PDF, you must have LaTeX working on your computer (required executables include `epstopdf` and `pdflatex`, required packages include `graphicx`, `geometry` and `hyperref`). On Linux computers, this should be straight forward by simply installing the TeX live package for your Linux distribution. Windows users should install the MikTeX package, while MacOS users should install the MacTeX distribution. In case something does not work, you may need to inspect your system and edit the file `paths.m` in the LANS working directory to set the pathways to the LaTeX binaries accordingly.

## Citation

L. Polerecky, B. Adam, J. Milucka, N. Musat, T. Vagner, M. M. M. Kuypers (2012). Look@NanoSIMS – a tool for the analysis of nanoSIMS data in environmental microbiology. Environmental Microbiology 14 (4): 1009–1023 ([doi:10.1111/j.1462-2920.2011.02681.x](http://onlinelibrary.wiley.com/doi/10.1111/j.1462-2920.2011.02681.x/abstract))

The first author will highly appreciate the acknowledgement in your paper for the hard work that he has put into the development and improvement of the program over the years.

[E-mail](mailto:l.polerecky@uu.nl) us if you experience problems or if you would like to have new features added to the program.
