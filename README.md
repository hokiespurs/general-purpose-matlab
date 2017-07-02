# general-purpose-matlab
This repository hosts a handful of generic matlab functions as well as the associated example scripts and documentation.

## coordtransform
- **1D/changescale** converts a matrix of data from one set of limits to another
- **1D/num2ind** converts a matrix of data to indices given a set of limits and number of indices
- **rotations/euler2dcm** converts from euler angles to a direction cosine matrix

## gridding
- **idw** performs idw gridding
- **interp1nan** interpolates across nans
- **interp1nanthresh** interpolates across nans if the x and y gaps are below threshholds
- **roundgridfun** performs a nearest neighbor type gridding (FAST)

## ischecks
- **iswithin** reports if a matrix of points is within a lower and upper bound (inclusive)

## leastsquares
- **lsr** all encompassing least squares function (OLS,GLS,WLS,Nonlinear, Nonlinear Weighted, TLS, Robust)

## plothelpers
- **axgrid** gives you more control over subplot spacing
- **bigcolorbar** places a colorbar on the figure at a given position by using an invisible axes
- **bigcolorbarax** places a colorbar at a position to the right of the position of a given set of axes handles
- **bigtitle** places a title on the figure at a given position by using an invisible axes
- **bigtitleax** places a title at a position centered and above the position of a given set of axes handles
- **figfigstr** is a basic function to replace underscores in title names
- **linkax** allows you to link axes properties between multiple axes handles (not just x and y)
- **maxpos** returns the position of a box that encompasses all of the given axes handles

## Statistics
- **chi2invos** simple function to do chi2inv without the statistics and machine learning toolbox

## Utilities
- **dirname** returns filenames and foldernames as a structure (option to search within folders)
- **loopstatus** prints some info to the screen estimating a loops finish time
- **makefunctionh1** makes it easy to make the header comment block for a function
- **v2vars** is a lazy way to break a matrix into multiple variables
- **mddir** makes an ascii formatted folder directory tree suitable for markdown 
- **mdstruct** makes an ascii formatted tree of a structure suitable for markdown 

## Visualization
- **colorbarangle** makes a circular colorbar to depict angles
- **corrplotheatmap** makes a correlation plot between datasets
- **heatmapscat** makes a heatmap of regularly spaced data
- **makeMovie** helps turn images into gifs or avis
- **pcolorCenter** is a slightly dangerous function to try to center pcolor (use in rare occasions)
- **plotRect** plots a 2D or 3d rectangle using a center point as input rather than the corner
