/*
    Created by Ben Vinck 
    2020/9/3
*/

/* [Model] */
CREATE = "body"; //[body:Body, lid:Lid, block:PCB holder block]

/* [Hidden] */
render_offset = 0.1;

/* [PCB params] */
pcb_length = 66.6;
pcb_width = 46.2;

/* [Case params] */
// Height from the inside bottom to the top edge of the body
case_inside_height = 15;
// Thickness of the body, lid and holder block
case_thickness = 2;
// Spacing behind the PCB holders  Top, right, bottom, left
cable_spaceing = [2,2,2,2];
// Axis on which the cable opening will be
cable_opening_side = "x"; //[none,x,y]
// Shape of the cable opening
cable_opening_shape = "rectangle"; //[rectangle:Rectangle, circle:Circle]
// Dimentions of the rectangular cable opening
cable_opening_dimentions = [25,10];
// Diameter of the circular cable opening
cable_opening_diameter = 3;
// Ammount of circular cable openings
cable_opening_ammount = 2;
// Distance between circular cable opening
cable_opening_spaceing = 2;
// Cable opening offset from its center position
cable_opening_offset = [0,0];

/* [Corner support params] */
// Size of PCB clamps
holder_spacing = 2;
// Size of platfrom supporting the PCB
holder_width = 5;
// Height that the PCB will be held
holder_height = 3;
// Height of the PCB clamps
holder_grip_height = 1.4;
// Offset of the PCB clamps. 0 = PCB width and height, >0 = looser fit, <0 = tighter fit. This value depends on your 3D printer
holder_offset = 0.4; //Ultimaker 2
// Hole in the PCB clamps. This is meant to screw the holder blocks in place. 0 for no hole
holder_hole_diameter = 1;
//Height of the holder block
holder_block_height = 2;

/* [Center support params] */
//Will enable a support in the center. Provides extra support in the center of large PCBs
center_support_enable = false;
// X and Y dimentions of the center support
center_support_size = [20,25];
// Offset from the bottom left PCB corner
center_support_offset = [20,10];

/* [Lid params] */
lid_height = case_thickness;
// Distance that the lid locks into the body
lid_depth = 2;
// Offset between the body and lid. 0 = perfect fit, >0 = looser fit, <0 = tighter fit.
lid_offset = 0.3; //Ultimaker 2
// Enable the viewing window
lid_window = false;
// Size of the window supports. 0 to disable
lid_window_support_size = 5;

/* Modules */
module true_mirror(m, o){
    children();
    translate(o){
        mirror(m){
            children();    
        }
    }
}

module dual_true_mirror(m1, o1, m2, o2){
    true_mirror(m1, o1){
        true_mirror(m2, o2){
            children();
        };
    };
}


if(CREATE == "body"){
//Case
difference(){
    translate([-case_thickness,-case_thickness,-case_thickness]){
        cube([
            pcb_length+cable_spaceing[3]+cable_spaceing[1]+case_thickness*2+holder_spacing*2,
            pcb_width+cable_spaceing[0]+cable_spaceing[2]+case_thickness*2+holder_spacing*2,
            case_inside_height+case_thickness
        ]);
    }
    cube([
        pcb_length+cable_spaceing[3]+cable_spaceing[1]+holder_spacing*2,
        pcb_width+cable_spaceing[0]+cable_spaceing[2]+holder_spacing*2,
        case_inside_height+render_offset
    ]);
    
    //Cable opening
    if(cable_opening_side == "x"){
        if(cable_opening_shape == "rectangle"){
            translate([
                (pcb_length+holder_spacing*2+cable_spaceing[1]+cable_spaceing[3])/2-cable_opening_dimentions[0]/2 + cable_opening_offset[0],
                -case_thickness - render_offset/2,
                cable_opening_offset[1]
            ]){
                cube([cable_opening_dimentions[0], case_thickness + render_offset, cable_opening_dimentions[1]]);
            }
        }
        else if (cable_opening_shape == "circle"){
            rotate([90,0,0]){
                for(i = [0:cable_opening_ammount-1]){
                    translate([
                        (pcb_length+holder_spacing*2+cable_spaceing[1]+cable_spaceing[3])/2 + cable_opening_offset[0] - (cable_opening_ammount-1)*(cable_opening_diameter/2)-cable_opening_spaceing/2*cable_opening_ammount + i*cable_opening_diameter+i*cable_opening_spaceing,
                        cable_opening_diameter/2 + cable_opening_offset[1],
                        -render_offset/2
                    ]){
                        cylinder(case_thickness + render_offset, d=cable_opening_diameter,$fn=50);
                    }
                }
            }
        }
    }
    else if(cable_opening_side == "y"){
        if(cable_opening_shape == "rectangle"){
            translate([
                -case_thickness - render_offset/2,
                (pcb_width+holder_spacing*2+cable_spaceing[0]+cable_spaceing[2])/2-cable_opening_dimentions[0]/2 + cable_opening_offset[0],
                cable_opening_offset[1]
            ]){
                cube([case_thickness + render_offset,cable_opening_dimentions[0],cable_opening_dimentions[1]]);
            }
        }
        else if (cable_opening_shape == "circle"){
            rotate([0,-90,0]){
                for(i = [0:cable_opening_ammount-1]){
                    translate([
                        cable_opening_diameter/2 + cable_opening_offset[1],
                        (pcb_width+holder_spacing*2+cable_spaceing[0]+cable_spaceing[2])/2 + cable_opening_offset[0] - (cable_opening_ammount-1)*(cable_opening_diameter/2)-cable_opening_spaceing/2*cable_opening_ammount + i*cable_opening_diameter+i*cable_opening_spaceing,
                        -render_offset/2
                    ]){
                        cylinder(case_thickness + render_offset, d=cable_opening_diameter,$fn=50);
                    }
                }
            }
        }
    }
}



//Corner support
translate([cable_spaceing[3], cable_spaceing[2], 0]){
    dual_true_mirror([0,1,0], [0,holder_spacing*2 + pcb_width,0], [1,0,0], [holder_spacing*2 + pcb_length,0,0]){
        difference(){
            //Cube
            union(){
                cube([holder_spacing-holder_offset,holder_spacing + holder_width,holder_height + holder_grip_height]);
                cube([holder_spacing + holder_width,holder_spacing-holder_offset,holder_height + holder_grip_height]);
                cube([holder_spacing + holder_width,holder_spacing + holder_width,holder_height]);
            }
            //Hole
            translate([holder_spacing/2,holder_spacing/2,0]){
                cylinder(holder_height + holder_grip_height + render_offset,d=holder_hole_diameter,$fn=25);
            }
        }
    }
}


//Center support
if(center_support_enable){
translate([
        cable_spaceing[3]+holder_spacing+center_support_offset[0],
        cable_spaceing[2]+holder_spacing+center_support_offset[1],
        0
    ]){
    cube([center_support_size[0],center_support_size[1],holder_height]);
}
}
}



if(CREATE == "lid"){
//Lid
difference(){
    union(){
        //Height
        translate([-case_thickness,-case_thickness,-lid_height]){
            cube([
                pcb_length+cable_spaceing[3]+cable_spaceing[1]+case_thickness*2+holder_spacing*2,
                pcb_width+cable_spaceing[0]+cable_spaceing[2]+case_thickness*2+holder_spacing*2,
                lid_height
            ]);
        }
        //Depth
        translate([lid_offset,lid_offset,0]){
            cube([
                pcb_length+cable_spaceing[3]+cable_spaceing[1]-lid_offset*2+holder_spacing*2,
                pcb_width+cable_spaceing[0]+cable_spaceing[2]-lid_offset*2+holder_spacing*2,
                lid_depth
            ]);
        }
    }
    //Hollow
    translate([case_thickness+lid_offset,case_thickness+lid_offset,-lid_height+case_thickness]){
        cube([
            pcb_length+cable_spaceing[3]+cable_spaceing[1]-case_thickness*2-lid_offset*2+holder_spacing*2,
            pcb_width+cable_spaceing[0]+cable_spaceing[2]-case_thickness*2-lid_offset*2+holder_spacing*2,
            lid_depth+lid_height-case_thickness + render_offset
        ]);
    }
    //Window
    if(lid_window){
        translate([case_thickness+lid_offset,case_thickness+lid_offset,-lid_height-render_offset/2]){
            cube([
                pcb_length+cable_spaceing[3]+cable_spaceing[1]-case_thickness*2-lid_offset*2+holder_spacing*2,
                pcb_width+cable_spaceing[0]+cable_spaceing[2]-case_thickness*2-lid_offset*2+holder_spacing*2,
                case_thickness+render_offset
            ]);
        }
    }
}
//Window Support
if(lid_window == true){
    translate([case_thickness+lid_offset,case_thickness+lid_offset,-lid_height+case_thickness]){
        dual_true_mirror(
            [0,1,0],
            [0,pcb_width+cable_spaceing[3]+cable_spaceing[1]+holder_spacing-lid_offset*2-case_thickness*2+holder_spacing*2,0],
            [1,0,0],
            [pcb_length+cable_spaceing[3]+cable_spaceing[1]-lid_offset*4-case_thickness+holder_spacing*2,0,0]
        ){
            cube([lid_window_support_size,lid_window_support_size,lid_depth]);
        }
    }
}
}



if(CREATE == "block"){
difference(){
    //Cube
    cube([holder_spacing+holder_width,holder_spacing+holder_width,holder_block_height]);
    //Hole
    translate([holder_spacing/2,holder_spacing/2,-render_offset/2]){
        cylinder(holder_block_height+render_offset,d=holder_hole_diameter,$fn=25);
    }
}
}