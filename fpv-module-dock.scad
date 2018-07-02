/* [DOCK_BODY] */
DOCK_BODY_DEPTH = 14;
DOCK_BODY_HEIGHT = 40;
DOCK_BODY_WIDTH = 60;

DOCK_BACK_THICKNESS = 2;
DOCK_WALL_THICKNESS = 3;

//Protector should be a part of the front cover - it will be easier to print per module
DOCK_PROTECTOR_HEIGHT = 0;
DOCK_PROTECTOR_DEPTH = 0;

/* [PHOTO SCREW PORT] */
NUT_HEIGHT = 5.6;
NUT_WIDTH = 11.1;
NUT_INSIDE_DIAMETER = 6.350;
NUT_HOLDER_WALL_THICKNESS = 1.5;
NUT_HOLDER_BASE_THICKNESS = 1.5;

/* [BUTTONS] */
NUMBER_OF_BUTTONS = 3;
BUTTON_TOP_WIDTH = 4;
BUTTON_TOP_HEIGHT = 4;
BUTTON_BOTTOM_WIDTH = 6;
BUTTON_BOTTOM_HEIGHT = 6;
BUTTON_BOTTOM_DISTANCE = 2;

/* [GOLDPIN POSITION] */
LID_OFFSET = 2.5;     // To be 2.27, safer to set 2.5
GOLDPIN_RASTER_EDGE_DISTANCE = 25;

/* [GOLDPIN SIZE] */
RASTER_INTERPIN_DISTANCE = 2.54; // specs
RASTER_SLOT_HEIGHT = 8.45; // measured
RASTER_TOTAL_HEIGHT = 11.41; // measured
RASTER_PIN_WIDTH = 0.64 + 0.3;  //specs + 0.3
RASTER_PIN_DEPTH = 0.40 + 0.3;  //specs + 0.3
GOLDPIN_SHELF_BASE = 1.0;
GOLDPIN_SHELF_WALL_THICKNESS = 1.5;

GOLDPIN_SHELF_MOUNT = 2;

/* [MINIJACK PORT SIZE] */
MINIJACK_PORT_RADIUS = 7.2;

/* [DC PORT SIZE] */
DC_PORT_RADIUS = 7.2;  //11.5 body mounted

/* [MOUNTING ELEMS] */
SCREW_DIAMETER = 3; // M3 screw
SCREW_HEAD_DIAMETER = 6; // M3 screw
SCREW_HEAD_THICKNESS = 2.4; // M3 screw
SCREW_WALL_DISTANCE = 0;

/* [MISC] */
CORNER_CURVE_DIAMETER = 10;
TOLERANCE = 0.05;
EXPLODE_OFFSET = 0;  

DELTA = 0.001; // used for non-perfect diffs

/* [HIDDEN] */
$fn = 128;

//color("grey")
dock_rim_with_buttons(DOCK_BODY_WIDTH, DOCK_BODY_HEIGHT, DOCK_BODY_DEPTH, DOCK_WALL_THICKNESS, BUTTON_BOTTOM_WIDTH, BUTTON_BOTTOM_DISTANCE, NUT_HOLDER_WALL_THICKNESS, NUT_HOLDER_BASE_THICKNESS);
//
//color("red")
//translate([0,0,(-DOCK_BODY_DEPTH-DOCK_BACK_THICKNESS)/2- EXPLODE_OFFSET])
//dock_back_wall(DOCK_BODY_WIDTH, DOCK_BODY_HEIGHT,  DOCK_BACK_THICKNESS);
//
// color("red")
// translate([0,0,(+DOCK_BODY_DEPTH+DOCK_BACK_THICKNESS)/2 + EXPLODE_OFFSET ])
// dock_front_wall(DOCK_BODY_WIDTH, DOCK_BODY_HEIGHT,  DOCK_BACK_THICKNESS);


module dock_body(width, height, depth) {
    x_translate = width-CORNER_CURVE_DIAMETER;
    y_translate = height-CORNER_CURVE_DIAMETER;
    
    hull(){
        translate([-x_translate/2, -y_translate/2, 0])
        cylinder(depth,CORNER_CURVE_DIAMETER/2, CORNER_CURVE_DIAMETER/2, true);    
        
        translate([-x_translate/2, y_translate/2, 0])
        cylinder(depth,CORNER_CURVE_DIAMETER/2, CORNER_CURVE_DIAMETER/2, true);

        translate([x_translate/2, y_translate/2, 0])
        cylinder(depth,CORNER_CURVE_DIAMETER/2, CORNER_CURVE_DIAMETER/2, true);        
        
        translate([x_translate/2, -y_translate/2, 0])
        cylinder(depth,CORNER_CURVE_DIAMETER/2, CORNER_CURVE_DIAMETER/2, true);        
    }
}

module dock_back_wall(width, height, depth){
    x_translate = width-CORNER_CURVE_DIAMETER;
    y_translate = height-CORNER_CURVE_DIAMETER;
        
    
   hull(){
        translate([-x_translate/2, -y_translate/2, 0])
        cylinder(depth,CORNER_CURVE_DIAMETER/2, CORNER_CURVE_DIAMETER/2, true);    
        
        translate([-x_translate/2, y_translate/2, 0])
        cylinder(depth,CORNER_CURVE_DIAMETER/2, CORNER_CURVE_DIAMETER/2, true);

        translate([x_translate/2, y_translate/2, 0])
        cylinder(depth,CORNER_CURVE_DIAMETER/2, CORNER_CURVE_DIAMETER/2, true);        
        
        translate([x_translate/2, -y_translate/2, 0])
        cylinder(depth,CORNER_CURVE_DIAMETER/2, CORNER_CURVE_DIAMETER/2, true);        
    }    
}

module dock_front_wall(width, height, depth){
    
    intersection(){
        difference(){
            dock_back_wall(width, height, depth);        

            translate([(width-GOLDPIN_RASTER_EDGE_DISTANCE)/2,0,0])            
            rotate([0,0,90])
            raster_n_pins(9);            
        }    
        cube([width,height-DOCK_PROTECTOR_HEIGHT-TOLERANCE,10],true);
    }     
}

module screw_slot(height, diameter) {
    difference(){
        cube([2*diameter,2*diameter, height], true);              
        cylinder(height*2,SCREW_DIAMETER/2, SCREW_DIAMETER/2, true);  
    }
}

module dock_rim(width, height, depth, wall_thickness) {
    curve_ratio = sqrt(pow(width-wall_thickness,2) + pow(height-wall_thickness,2)) / sqrt(pow(width,2) + pow(height,2));
    
    scaled_curve = CORNER_CURVE_DIAMETER * curve_ratio;
    
    difference(){
        dock_body(width, height, depth);
        dock_body(width-wall_thickness, height-wall_thickness, 2*depth, scaled_curve);
    };
    
    translate([0,0,DOCK_PROTECTOR_DEPTH/2])
    difference(){
        dock_body(width, height, depth+DOCK_PROTECTOR_DEPTH);
        cube([width*2, height-DOCK_PROTECTOR_HEIGHT, depth*2], true);
    };
        
    //TODO: add grill for better air flow
}

module button() {
    cube([BUTTON_TOP_WIDTH, BUTTON_TOP_HEIGHT, 3], true);        
}

module button_row(button_bottom_width, button_bottom_distance){
    translate_step = button_bottom_width + button_bottom_distance;
    button_distance = 3;
    
    initial_translation = translate_step;
    translate([0, -initial_translation, 0])
    for (n = [0:1:2]){
        translate([0,n*translate_step, 0]) 
        rotate([0,90,0])
        button();
    };    
}


module goldpin_shelf(){    
    pins = 9;
    
    shelf_thickness = GOLDPIN_SHELF_WALL_THICKNESS;
    shelf_height = RASTER_SLOT_HEIGHT - LID_OFFSET - DOCK_BACK_THICKNESS + GOLDPIN_SHELF_BASE;

    echo("**");    
    echo(shelf_height);
   
    height = RASTER_INTERPIN_DISTANCE + 2*shelf_thickness;
    width = pins*RASTER_INTERPIN_DISTANCE;    

    difference() {
        translate([0,0,(-RASTER_SLOT_HEIGHT+shelf_height)/2 - GOLDPIN_SHELF_BASE])        
        cube([width,height,shelf_height],true);  
        color("red")
        raster_n_pins(pins);        
    };    
    
//    translate([0,0,(-RASTER_SLOT_HEIGHT+shelf_height)/2 - GOLDPIN_SHELF_BASE])        
//    cube([width,height,shelf_height],true);  
//    color("red")
//    raster_n_pins(pins);        
}

function nut_cylinder_height(single_nut_height, base_thickness) = 2*(single_nut_height+base_thickness);
function nut_cylinder_radius(single_nut_width, nut_holder_wall_thickness) = single_nut_width + 2*nut_holder_wall_thickness;

module dock_rim_with_buttons(width, height, depth, wall_thickness, button_body_width, button_bottom_distance, nut_holder_wall_thickness, nut_holder_base_thickness) {

    button_translation = 4;
    
    cylinder_radius = nut_cylinder_radius(NUT_WIDTH, nut_holder_wall_thickness); 
    cylinder_height = nut_cylinder_height(NUT_HEIGHT, nut_holder_base_thickness); 

    edge_distance = width/3;

    echo(cylinder_height);

    union(){
        difference(){
            dock_rim(width, height, depth, wall_thickness);

            // Placeholder for buttons
            translate([width/2,0,0])
            button_row(button_body_width, button_bottom_distance);
            
            // Placeholder for the photo nut            
            translate([0,-height/2,0])        
            rotate([90,0,0])
            cylinder(height,cylinder_radius/2, cylinder_radius/2, true);            
            
            // Placeholder for mini jack
            translate([-width/2,(height-MINIJACK_PORT_RADIUS-edge_distance)/2,0])            
            rotate([0,90,0])            
            cylinder(height,(MINIJACK_PORT_RADIUS+TOLERANCE)/2, (MINIJACK_PORT_RADIUS+TOLERANCE)/2, true);                            
            // Placeholder for DC
            translate([-width/2,-(height-DC_PORT_RADIUS-edge_distance)/2,0])            
            rotate([0,90,0])            
            cylinder(height,(DC_PORT_RADIUS+2*TOLERANCE)/2, (DC_PORT_RADIUS/2+2*TOLERANCE), true);                               
        }
    
        translate([0,-height/2+cylinder_height/2,0])
        rotate([-90,0,0])
        screw_port(nut_holder_wall_thickness, nut_holder_base_thickness);    
        
        //TODO: add shelves for the bottons        
        
        // Construction screws
        //DOING NOW! SCREWS
        slot_diameter = SCREW_DIAMETER/2 + 1;

        y_offset = max(wall_thickness, DOCK_PROTECTOR_HEIGHT);

        x_translation = (width-wall_thickness)/2 - slot_diameter - SCREW_WALL_DISTANCE;    
        y_translation = (height-y_offset)/2 - slot_diameter - SCREW_WALL_DISTANCE;

        translate([x_translation/3,0,0])    
        screw_slot(depth, slot_diameter);

        translate([x_translation,y_translation,0])    
        screw_slot(depth, slot_diameter);
        
        translate([-x_translation,y_translation,0])    
        screw_slot(depth, slot_diameter);
        
        translate([-x_translation,-y_translation,0])    
        screw_slot(depth, slot_diameter);     
        
        translate([x_translation,-y_translation,0])    
        screw_slot(depth, slot_diameter);         
        
        // Shelf
        translate([(width-GOLDPIN_RASTER_EDGE_DISTANCE)/2,0, DOCK_BODY_DEPTH/2 - RASTER_SLOT_HEIGHT/2 + LID_OFFSET + DOCK_BACK_THICKNESS])
        rotate([0,0,90])
        
        goldpin_shelf();
        
        // Shelf mount 1
        translate([(width-GOLDPIN_RASTER_EDGE_DISTANCE-2*GOLDPIN_SHELF_WALL_THICKNESS-GOLDPIN_SHELF_MOUNT)/2,0,DOCK_BODY_DEPTH/2-GOLDPIN_SHELF_MOUNT/2])                
        cube([GOLDPIN_SHELF_MOUNT,DOCK_BODY_HEIGHT,GOLDPIN_SHELF_MOUNT],true);
        
        // Shelf mount 2        
        translate([(width-GOLDPIN_RASTER_EDGE_DISTANCE+ 2*GOLDPIN_SHELF_WALL_THICKNESS + GOLDPIN_SHELF_MOUNT)/2,0,DOCK_BODY_DEPTH/2-GOLDPIN_SHELF_MOUNT/2])        
        cube([GOLDPIN_SHELF_MOUNT,DOCK_BODY_HEIGHT,GOLDPIN_SHELF_MOUNT],true);        
    }        
}

module raster_single_pin(){
    slot_height = RASTER_SLOT_HEIGHT;
    slot_width = RASTER_INTERPIN_DISTANCE + DELTA;  //specs
    slot_depth = RASTER_INTERPIN_DISTANCE + DELTA;  //specs
        
    pin_width = RASTER_PIN_WIDTH + TOLERANCE;
    pin_depth = RASTER_PIN_WIDTH + TOLERANCE; // using wider width
    pin_height = RASTER_TOTAL_HEIGHT - RASTER_SLOT_HEIGHT;

    union(){
        cube([slot_width, slot_depth, RASTER_SLOT_HEIGHT], true);
        translate([0,0,-RASTER_SLOT_HEIGHT/2-pin_height/2])
        cube([pin_width, pin_depth, pin_height], true);    
    }
}

module raster_n_pins(pins){
    initial_offset = (pins-1)*RASTER_INTERPIN_DISTANCE;
    
    translate([-initial_offset/2,0,0])    
    union(){            
        for(n=[0:1:pins-1]){
            translate([n*RASTER_INTERPIN_DISTANCE,0,0])
            raster_single_pin();
        }
    }
}

function edge_length(size) = size*0.5774;

module hexagon(size, depth) {
  angle_step = 60;
  // Iterate 3 times    
  for (n = [0:1:2]){
      rotate([0,0, n*angle_step]) 
      cube([edge_length(size), size, depth], true);
  }
}

module photo_nut(nut_height, nut_width, nut_inside_diameter, tolerance) {
    difference(){
        hexagon(nut_width, nut_height);
        cylinder(nut_height*2,nut_inside_diameter/2, nut_inside_diameter/2, true);         
    }
}

module photo_nut_insert(nut_height, nut_width, multiplier) {
    translation = nut_width*(multiplier-1);
    translate([0,-translation,0])
    hull(){
        photo_nut(nut_height, nut_width, 1);
        translate([0,translation,0])
        photo_nut(nut_height, nut_width, 1);    
        
    }
}

module screw_port(wall_thickness, base_thickness){
    cylinder_height = nut_cylinder_height(NUT_HEIGHT, base_thickness);    
    cylinder_radius = NUT_WIDTH + 2*wall_thickness;
    
    inside_diameter = NUT_INSIDE_DIAMETER + TOLERANCE;
    
    difference(){
        // Main holder
        union(){
            cylinder(cylinder_height,cylinder_radius/2, cylinder_radius/2, true);
            translate([0,cylinder_radius/4,0])
            cube([cylinder_radius,cylinder_radius/2,cylinder_height],true);
        }
        
        // Extra slot for sliding in the nut
        translate([0,0,NUT_HEIGHT/2])    
        photo_nut_insert(NUT_HEIGHT+TOLERANCE, NUT_WIDTH+TOLERANCE, 2);    

        // Extrude place for the photo nut
        translate([0,0,-NUT_HEIGHT/2])            
        photo_nut_insert(NUT_HEIGHT+TOLERANCE, NUT_WIDTH+TOLERANCE, 1);            
        cylinder(cylinder_height*2,inside_diameter/2, inside_diameter/2, true);
    }
}
