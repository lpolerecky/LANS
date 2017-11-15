# Look@NanoSIMS

## Summary

Look@NanoSIMS (abbreviated as **LANS**) is a [free software](http://www.gnu.org/philosophy/free-sw.html) for the analysis of NanoSIMS image data produced by the Cameca NanoSIMS 50L instrument. It is distributed as a Matlab code, thus requires Matlab (proprietary software) installed on your system to run.

## Features

- **Loading** of secondary ion counts (SIC) image data (Cameca *.im files)
  - all planes and masses (default)
  - in blocks
  - selected planes and masses
  - merging of multiple *.im files into one
  - dead-time and QSA corrections applicable
  - support of zip-compressed input data (*.im.zip files)
  - Matlab files (*.mat) produced by processing with LANS, without the need of the original *.im file. (Because this loads drift-corrected and accumulated data for each SIC image, analysis of depth profiles is not possible in this case.)
- **Accumulation** of planes, with **drift-correction** applied
- Definition of **regions of interest (ROIs)**
  - manual and semi-automated
  - based on NanoSIMS images, or on an imported **external** image (e.g., FISH, TEM, SEM, AFM) with **alignment** done within LANS
  - ROI **classification** (manual & automated based on a logical expression)
  - watershed segmentation of ROIs
- **Quantification** of isotopic and elemental **ratios** (defined through an arbitrary expression)
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

## Installation instructions

- Install **Matlab**. You will need the **core** Matlab and the **image processing and statistical toolboxes**. Presently, LANS requires **Matlab 2013b**. The use of a newer Matlab version is not recommended because some of the features introduced by the release of Matlab 2014a (a major overhaul of graphics) have not been fully implemented/updated in LANS.
- Install **LaTeX**. This is required to support export of graphical output as tagged PDF documents. 
  - required executables: `epstopdf` and `pdflatex`
  - required packages `graphicx`, `geometry` and `hyperref`
  - use LaTeX distributions: TeX live package (Linux), MikTeX (Windows), MacTex (MacOS)
- Install a program for **decompressing zip files**
  - 7-Zip (freeware) is recommended for Windows.
  - Linux and MacOS systems have it by default (unzip).
- Download the latest stable version of LANS from the **download** folder in this GitHub repository, and unzip it in a folder of your choice. 

## Running LANS

Before running LANS for the **first time**, it is recommended to read carefully the files `lookatnanosims.m` and `paths.m` to check system-specific settings.

Start Matlab and set Matlab's working directory to the folder where you unzipped LANS. In the Matlab console, type `pwd` and then `ls`, both followed by pressing the Enter key, to check that you are in the correct directory and to ensure that the `lookatnanosims.m` is present. Finally, type **lookatnanosims** and press the Enter key. That's it. This should start the graphical user interface (GUI) of the LANS program.

## Citation

Please include the following citation if you used LANS in your work. 

L. Polerecky, B. Adam, J. Milucka, N. Musat, T. Vagner, M. M. M. Kuypers (2012). Look@NanoSIMS – a tool for the analysis of nanoSIMS data in environmental microbiology. Environmental Microbiology 14 (4): 1009–1023 ([doi:10.1111/j.1462-2920.2011.02681.x](http://onlinelibrary.wiley.com/doi/10.1111/j.1462-2920.2011.02681.x/abstract))

Note that LANS is under **continuous development**, with bugs fixed and new features added every couple of months. This costs a lot of time, effort and energy. Thus, a little extra "thanks to LP" in the acknowledgement section of your paper will be highly appreciated and motivating.

## Contact

[E-mail](mailto:l.polerecky@uu.nl) the main developer (LP) if you experience problems, or if you would like to have new features added to, or participate in the development of, the program.
