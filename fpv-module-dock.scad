/* [DOCK_BODY] */
DOCK_BODY_DEPTH = 16;
DOCK_BODY_HEIGHT = 40;
DOCK_BODY_WIDTH = 50;

DOCK_BACK_THICKNESS = 1;
DOCK_WALL_THICKNESS = 2;

DOCK_PROTECTOR_HEIGHT = 6;
DOCK_PROTECTOR_DEPTH = 12;

/* [PHOTO SCREW PORT] */
NUT_HEIGHT = 5.6;
NUT_WIDTH = 11.1;
NUT_INSIDE_DIAMETER = 6.350;
NUT_HOLDER_WALL_THICKNESS = 1;
NUT_HOLDER_BASE_THICKNESS = 2;

/* [BUTTONS] */
NUMBER_OF_BUTTONS = 3;
BUTTON_TOP_WIDTH = 4;
BUTTON_TOP_HEIGHT = 4;
BUTTON_BOTTOM_WIDTH = 6;
BUTTON_BOTTOM_HEIGHT = 6;
BUTTON_BOTTOM_DISTANCE = 2;

/* [GOLDPIN SIZE] */
GOLDPIN_RASTER_EDGE_DISTANCE = 10;
GOLDPIN_RASTER_HEIGHT = 2.48;
GOLDPIN_RASTER_WIDTH = 24.75;
GOLDPIN_RASTER_DEPTH = 7;
GOLDPIN_RASTER_INTERPIN_DISTANCE = 3.14;
GOLDPIN_THICKNESS = 0.63;


/* [MISC] */
CORNER_CURVE_DIAMETER = 10;
TOLERANCE = 0.05;
EXPLODE_OFFSET = 10;  


/* [HIDDEN] */
$fn = 128;

color("grey")
dock_rim_with_buttons(DOCK_BODY_WIDTH, DOCK_BODY_HEIGHT, DOCK_BODY_DEPTH, DOCK_WALL_THICKNESS, CORNER_CURVE_DIAMETER, BUTTON_BOTTOM_WIDTH, BUTTON_BOTTOM_DISTANCE, NUT_HOLDER_WALL_THICKNESS, NUT_HOLDER_BASE_THICKNESS);

color("red")
translate([0,0,(-DOCK_BODY_DEPTH+DOCK_BACK_THICKNESS)/2- EXPLODE_OFFSET])
dock_back_wall(DOCK_BODY_WIDTH, DOCK_BODY_HEIGHT,  DOCK_BACK_THICKNESS, CORNER_CURVE_DIAMETER);

color("red")
translate([0,0,(+DOCK_BODY_DEPTH-DOCK_BACK_THICKNESS)/2 + EXPLODE_OFFSET ])
dock_front_wall(DOCK_BODY_WIDTH, DOCK_BODY_HEIGHT,  DOCK_BACK_THICKNESS, CORNER_CURVE_DIAMETER);

module dock_body(width, height, depth, corner_curve_diameter) {
    x_translate = width-corner_curve_diameter;
    y_translate = height-corner_curve_diameter;
    
    hull(){
        translate([-x_translate/2, -y_translate/2, 0])
        cylinder(depth,corner_curve_diameter/2, corner_curve_diameter/2, true);    
        
        translate([-x_translate/2, y_translate/2, 0])
        cylinder(depth,corner_curve_diameter/2, corner_curve_diameter/2, true);

        translate([x_translate/2, y_translate/2, 0])
        cylinder(depth,corner_curve_diameter/2, corner_curve_diameter/2, true);        
        
        translate([x_translate/2, -y_translate/2, 0])
        cylinder(depth,corner_curve_diameter/2, corner_curve_diameter/2, true);        
    }
}

module dock_back_wall(width, height, depth, corner_curve_diameter){
    x_translate = width-corner_curve_diameter;
    y_translate = height-corner_curve_diameter;
        
    
   hull(){
        translate([-x_translate/2, -y_translate/2, 0])
        cylinder(depth,corner_curve_diameter/2, corner_curve_diameter/2, true);    
        
        translate([-x_translate/2, y_translate/2, 0])
        cylinder(depth,corner_curve_diameter/2, corner_curve_diameter/2, true);

        translate([x_translate/2, y_translate/2, 0])
        cylinder(depth,corner_curve_diameter/2, corner_curve_diameter/2, true);        
        
        translate([x_translate/2, -y_translate/2, 0])
        cylinder(depth,corner_curve_diameter/2, corner_curve_diameter/2, true);        
    }    
}

module dock_front_wall(width, height, depth, corner_curve_diameter){
    intersection(){
        difference(){
            dock_back_wall(width, height, depth, corner_curve_diameter);        
            translate([(width-GOLDPIN_RASTER_EDGE_DISTANCE)/2,0,0])
            pin_raster_slot(GOLDPIN_RASTER_HEIGHT, GOLDPIN_RASTER_WIDTH, GOLDPIN_RASTER_DEPTH);        
        }    
        cube([width,height-DOCK_PROTECTOR_HEIGHT-TOLERANCE,10],true);
    }
    //TODO: add shelve for the raster
}

module dock_rim(width, height, depth, wall_thickness, corner_curve_diameter) {
    
    curve_ratio = sqrt(pow(width-wall_thickness,2) + pow(height-wall_thickness,2)) / sqrt(pow(width,2) + pow(height,2));
    
    scaled_curve = corner_curve_diameter * curve_ratio;
    
    difference(){
        dock_body(width, height, depth, corner_curve_diameter);
        dock_body(width-wall_thickness, height-wall_thickness, 2*depth, scaled_curve);
    };
    
    translate([0,0,DOCK_PROTECTOR_HEIGHT/2])
    difference(){
        dock_body(width, height, depth+DOCK_PROTECTOR_HEIGHT, corner_curve_diameter);
        cube([width*2, height-DOCK_PROTECTOR_HEIGHT, depth*2], true);
    };
    
    //TODO: add slots for the screws
    
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

function nut_cylinder_height(single_nut_height, base_thickness) = 2*(single_nut_height+base_thickness);
function nut_cylinder_radius(single_nut_width, nut_holder_wall_thickness) = single_nut_width + 2*nut_holder_wall_thickness;

module dock_rim_with_buttons(width, height, depth, wall_thickness, corner_curve_diameter, button_body_width, button_bottom_distance, nut_holder_wall_thickness, nut_holder_base_thickness) {

    button_translation = 4;
    
    cylinder_radius = nut_cylinder_radius(NUT_WIDTH, nut_holder_wall_thickness); 
    cylinder_height = nut_cylinder_height(NUT_HEIGHT, nut_holder_base_thickness); 

    echo(cylinder_height);

    union(){
        difference(){
            dock_rim(width, height, depth, wall_thickness, corner_curve_diameter);
            translate([width/2,0,0])
            button_row(button_body_width, button_bottom_distance);
            
            translate([0,-height/2,0])        
            rotate([90,0,0])
            //Placeholder for the photo nut
            cylinder(height,cylinder_radius/2, cylinder_radius/2, true);            
        }
    
        translate([0,-height/2+cylinder_height/2,0])
        rotate([-90,0,0])
        screw_port(nut_holder_wall_thickness, nut_holder_base_thickness);    
    }        
    //TODO: add shelves for the bottons
}

module pin_raster_slot(width, height, depth, interpin_distance, pin_thickness){
    cube([width, height, depth], true);
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
        cylinder(cylinder_height,cylinder_radius/2, cylinder_radius/2, true);
        
        // Extra slot for sliding in the nut
        translate([0,0,NUT_HEIGHT/2])    
        photo_nut_insert(NUT_HEIGHT+TOLERANCE, NUT_WIDTH+TOLERANCE, 2);    

        // Extrude place for the photo nut
        translate([0,0,-NUT_HEIGHT/2])            
        photo_nut_insert(NUT_HEIGHT+TOLERANCE, NUT_WIDTH+TOLERANCE, 1);            
        cylinder(cylinder_height*2,inside_diameter/2, inside_diameter/2, true);
    }
}
