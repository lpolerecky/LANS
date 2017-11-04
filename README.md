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
  - based on NanoSIMS images, or on an imported **external** image (e.g., FISH, TEM, SEM, AFM) with **alignment** done within LANS
  - ROI **classification** (manual & automated)
  - watershed segmentation of ROIs
- **Quantification** of isotopic and elemental **ratios**
- **Display and export** of results in **text** and **graphics** formats
  - images (various colormaps, ROI outlines can be included)
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

- Install **Matlab**. You will need the **core** Matlab and the **image processing and statistical toolboxes**. Presently, LANS requires **Matlab 2013b**. The use of newer Matlab versions is not recommended due to a major overhaul of graphics since Matlab 2014a.
- Install **LaTeX**. This is required to support export of graphical output as tagged PDF. 
  - required executables: `epstopdf` and `pdflatex`
  - required packages `graphicx`, `geometry` and `hyperref`
  - LaTeX distributions: TeX live package (linux), MikTeX (Windows), MacTex (MacOS)
- Install a program for **decompressing zip files**
  - 7-Zip is recommended for Windows.
  - Linux and MacOS systems have it by default.
- Download the latest stable version of LANS from the **src** folder in this GitHub repository. Unzip it in a folder of your choice. 

## Running LANS

Before running LANS for the first time, it is recommended to read carefully the first couple of lines in the files `lookatnanosims.m` and `paths.m` to check that your system settings are in order.

Start Matlab and set Matlab's working directory to the folder where you unzipped LANS. Type **lookatnanosims** in the Matlab console and press enter. That's it.

## Citation

Please include the following citation if you used LANS in your work. 

L. Polerecky, B. Adam, J. Milucka, N. Musat, T. Vagner, M. M. M. Kuypers (2012). Look@NanoSIMS – a tool for the analysis of nanoSIMS data in environmental microbiology. Environmental Microbiology 14 (4): 1009–1023 ([doi:10.1111/j.1462-2920.2011.02681.x](http://onlinelibrary.wiley.com/doi/10.1111/j.1462-2920.2011.02681.x/abstract))

Note that LANS is under continuous development, with bugs fixed and new features added every couple of months. This costs a lot of time, effort and energy. Thus, a little extra "thanks to LP" in the acknowledgement section of your paper will be highly appreciated.

## Contact

[E-mail](mailto:l.polerecky@uu.nl) the main developer (LP) if you experience problems or if you would like to have new features added to the program.
