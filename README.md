         ## Particle Tracking Wizard
  
The Particle Tracking Wizard takes a stabilized image stack and then tracks a user selected # of points across the entire stack.

The user can select how many points to tracks and then when run, the Wizard will promt the user to select the points.

ROI (region of interest) size is the size of the region that the Wizard will look at when tracking each particle frame by frame.

Load stack will prompt you to select a .tif image in the stabilized image stack you wish to track.

You can look through the stack using the frame preview spinner, this also allows you to pick a new start frame for tracking.

Save displacments is checked by default as this will save the tracking data.

Remove points during tracking when checked, will ask the user if they would like to removed a particle
after each time the wizard cannot find said particle and asks the user to manually find it.

Start tracking begins the tracking, which will progress until completion or until the wizard cannot find a particle and asks the user to find it manually.

Open Analyisis opens the Tracking Analysis Wizard


        ## Tracking Analysis Wizard
        
The Tracking Analysis Wizard takes tracking data from either the Particle Tracking Wizard or from Mosaic and outputs plots and/or a video to visually represent the data.

IMPORTANT: make sure the tracking data is in the same folder as the image stack is corresponds with. When loading displacments it will prompt you to select either a mat or .csv file.

Using the matlab data you have the option of ignoring the transform, which ignores the transform from the video stabilization. For the video and the plots you can select if you would like to use true or smoothed data. 

Using the mosaic data you must define a frame threshold. This number is the minimum amount of frames you'd like a particle to appear in for it to be analyzed.

The rest of the options are available for both types of data.

Once displacments are loaded, you can view the image stack, as well as view the particles (in mosaic's case only the particles there in frame 1).

Remove points lets you remove as many points as you'd like. It will display selected points in green and remove them when execute is pushed. In mosaic's case some points might not
appear in frame 1 and therefore won't appear green in show points if selected for removal.

For the video you can choose if you would like arrows to represent total displacment from the origin in frame 1 or frame by frame displacment (for frame by frame displacment you can also set
a dilation factor which will stretch the arrow to make it more visible).

You can also chose either a frame by frame colour scale (the colour is scaled based on the largest frame by frame displacment in each frame) or 
a total displacment colour scale (colour is scaled based on the largest displacment from the origin in the entire video).

Arrow placments is what part of the arrow is on the particle which that arrow represents.

Checking work in background hides the frame by frame video preview.
