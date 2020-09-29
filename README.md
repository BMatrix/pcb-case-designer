# PCB Case Designer
Created in OpenScad, it allows you to make customizable cases to directly mount PCBs.
<img src="https://raw.githubusercontent.com/BMatrix/pcb-case-designer/master/images/img1.png">

## Features
* Custom cable openings, circular or rectangular
* Resizable PCB supports
* Custom cable routing space
* Lid customization: debossed SVG image, vents, viewing window (place to mount a piece of plexiglass)

## Usage
Download and install [OpenScad](http://www.openscad.org/downloads.html).</br>
Download pcb-case-designer.scad and open the file in OpenScad.


Go to "View", select "Hide editor" and "Hide console", and unselect "Hide Customizer".</br>
The right panel is the Customiser. Here are all the parameters that you can use to create your case.</br>
Customizer should auto-update your 3D model automatically. If it does not, use F5.


The model consists of 3 parts. The body, the lid, and the PCB holder block. The body is the primary part in which the PCB will be mounted. The lid is self-explanatory. The PCB holder blocks are an optional part used to clamp down the PCB with screws. If the PCB holder blocks are not used, the PCB is held in place by friction.


To add an image to the lid. Place your SVG file in the same folder as the .scad file, enter the name of the file in the "lid image file" textbox, and enable the lid with the checkbox.


To get an STL file press F6 to render your model, and F7 to export it. This can take a while depending on the settings used.</br>
Keep in mind that the 3 parts need to be exported individually.


## Extra images
<img src="https://raw.githubusercontent.com/BMatrix/pcb-case-designer/master/images/img2.png">
<img src="https://raw.githubusercontent.com/BMatrix/pcb-case-designer/master/images/img3.png">
<img src="https://raw.githubusercontent.com/BMatrix/pcb-case-designer/master/images/img4.png">