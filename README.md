# Look@NanoSIMS

## Summary

Look@NanoSIMS (abbreviated as LANS) is a [free software](http://www.gnu.org/philosophy/free-sw.html) for the analysis of NanoSIMS data produced by the Cameca 50L instrument. Because LANS is developed in Matlab, you will need Matlab (core plus the image processing and statistical toolboxes) to run it. Additionally, you will need to have a LaTeX distribution installed on your computer to enable useful features such as export of images and graphs as PDF documents.

## Basic features

These features are available since the 1st release of the program in 2011, and are described in details in the manual

- Display of planes for detected masses
- Drift-corrected accumulation of planes
- Manual and semi-automated defition of ROIs (regions of interest)
- Definition of ROIs based on an external image (e.g. FISH or TEM) is also possible
- ROI classification (manual & automated)
- Quantification of elemental and isotopic composition
  - images
  - lateral profiles
  - depth profiles (in ROIs)
  - histograms
  - scatter plots
- RGB composition
- Statistical comparison of ROIs and ROI classes from one or multiple datasets
- Dead-time and QSA corrections

## Download & Install

Download the latest stable version of the program, manuals, and test-data.

To start the program, open Matlab and set the Matlab's working directory to the folder where you cloned the 'LAN' directory. In Matlab console type lookatnanosims. That's it.

Note: To ensure that `LANS` can export results into PDF, you must have LaTeX working on your computer (required executables include `epstopdf` and `pdflatex`, required packages include `graphicx`, `geometry` and `hyperref`). On Linux computers, this should be straight forward by simply installing the TeX live package for your Linux distribution. Windows users should install the MikTeX package, while MacOS users should install the MacTeX distribution. In case something does not work, you may need to inspect your system and edit the file `paths.m` in the LANS working directory to set the pathways to the LaTeX binaries accordingly.

## Citation

L. Polerecky, B. Adam, J. Milucka, N. Musat, T. Vagner, M. M. M. Kuypers (2012). Look@NanoSIMS – a tool for the analysis of nanoSIMS data in environmental microbiology. Environmental Microbiology 14 (4): 1009–1023 ([doi:10.1111/j.1462-2920.2011.02681.x](http://onlinelibrary.wiley.com/doi/10.1111/j.1462-2920.2011.02681.x/abstract))

The first author will highly appreciate the acknowledgement in your paper for the hard work that he has put into the development and improvement of the program over the years.

[E-mail](mailto:l.polerecky@uu.nl) us if you experience problems or if you would like to have new features added to the program.
