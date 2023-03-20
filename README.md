# SuperStitch
Automated Image Stitching

-=-Modules-=-

Stage Control:

Comminuication:

Stitching:
  SuperStitch.m - Responsible for organizing inputs and outputs and running stitching
  MergeSection.m - Responsible for merging two photots into the master photo
  FindAreaInterest.m - Finds the points in a given picture, which can be used to merge photos
  
Post Processing:
  FinalTouches.m - Corrects image to be optimal contrast value without losing information
Other Functions:
  Chop.m - Creates simulated pictures for which stitching can be ran on

