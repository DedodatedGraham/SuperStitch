# SuperStitch
Automated Image Stitching

-=-Modules-=-

Stage Control:

Comminuication:

Stitching:
SuperStitch.m - Responsible for organizing inputs and outputs and running stitching
  "Test Case Run : SuperStitch('brokenImg/',38,12);"
LocalStitch.m - Responsible for merging photots into the master photo
  ran by "SuperStitch.m"
  
Post Processing:
FinalTouches.m - Corrects image to be optimal contrast value without losing information
Other Functions:
Chop.m - Creates simulated pictures for which stitching can be ran on

