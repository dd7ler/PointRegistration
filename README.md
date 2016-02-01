## Key Point Registration and Matching
This project is a repository of utilities for working with image data from life science and engineering research.
Broadly, these utilities can be used to match up key points in two images of a single sample from two different microscopes, or before-and-after images of a particular procedure.

The functions in this repository are all listed below, in the "Documentation" section.

### Status: Almost started
I haven't added all the functions yet. There are also no examples yet. Stay tuned!

### Dependencies
These utilities have been tested on MATLAB version 2015 on both Windows and OS X. That doesn't necessarily mean it won't work with earlier versions - if you've tried it, I'd be glad to hear from you.

These utilities use the MATLAB Image Processing Toolbox extensively, so you'll need that too.

### Getting started
Download and unpack the project somewhere convenient. The 'MATLAB' subdirectory in your 'Documents' folder is not a bad place. In any case you'll want to edit and save your MATLAB path to include this directory. One way to do this is by running this in your MATLAB command window:
```
addpath(genpath('/full/path/to/this/repository'));
```

### Documentation

```
function [delta,q] = phCorrReg(image1, image2, *expectationRadius)
```
Quick and accurate registration of highly-similar images using the [Phase Correlation algorithm](https://en.wikipedia.org/wiki/Phase_correlation).
Only translation (not rotation or distortion) is considered.


'delta' is the [row, column] displacement of image2 relative to image1. This function has sub-pixel resolution, so 'delta' are not necessarily integers.

'confidence' is a measure of the quality of the algorithm's final result Confidence decreases with increasing image noise or dis-similarity.

'expectationR' provides a radius of of expected pixels for alignment. The default is 100.