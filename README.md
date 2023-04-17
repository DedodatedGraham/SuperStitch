# SuperStitch
Automated Image Stitching

-=-Modules-=-

Stage Control:

Camera Control:
  --binary made using '$ make' in /src/camera
RunCam.cpp - Will take X amount of pictures specified

Comminuication:

Stitching:
SuperStitch.m - Responsible for organizing inputs and outputs and running stitching
  "Test Case Run : testrun;"

LocalStitch.m - Responsible for merging photots into the master photo
  ran by "SuperStitch.m"
GetImgDir.m - Responsible for preventing messy calculations on useless data & decoding directional codes  

Post Processing:
FinalTouches.m - Corrects image to be optimal contrast value without losing information

Other Functions:
Chop.m - Creates simulated pictures for which stitching can be ran on
