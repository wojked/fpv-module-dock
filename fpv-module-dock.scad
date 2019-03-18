/* [DOCK_BODY] */
DOCK_BODY_DEPTH = 14;
DOCK_BODY_HEIGHT = 40;
DOCK_BODY_WIDTH = 60;

DOCK_BACK_THICKNESS = 6;
DOCK_FRONT_THICKNESS = 2.5;
DOCK_WALL_THICKNESS = 3.5;

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
BUTTON_BOTTOM_WIDTH = 6.20;
BUTTON_BOTTOM_HEIGHT = 6.20;
BUTTON_BOTTOM_DISTANCE = 2;
BUTTON_CYLINDER_DIAMETER = 3.5;
BUTTON_CYLINDER_TO_WALL = (BUTTON_BOTTOM_WIDTH - BUTTON_CYLINDER_DIAMETER)/2;

BUTTON_RAIL_DEPTH = 4;
BUTTON_RAIL_WIDTH = 4.4;
BUTTON_RAIL_HEIGHT = (DOCK_BODY_DEPTH - BUTTON_BOTTOM_HEIGHT)/2;
BUTTON_RAIL_OFFSET = -(DOCK_BODY_DEPTH - BUTTON_RAIL_HEIGHT)/2;

/* [GOLDPIN POSITION] */
LID_OFFSET = 2.0;     // To be 2.27, safer to set 2.5 and taken 0.5 to front wall
GOLDPIN_RASTER_EDGE_DISTANCE = 25;

/* [GOLDPIN SIZE] */
RASTER_INTERPIN_DISTANCE = 2.54; // specs
RASTER_SLOT_HEIGHT = 8.45; // measured
RASTER_TOTAL_HEIGHT = 11.41; // measured
RASTER_PIN_WIDTH = 0.64 + 0.3;  //specs + 0.3
RASTER_PIN_DEPTH = 0.40 + 0.3;  //specs + 0.3
GOLDPIN_SHELF_BASE = 1.0;
GOLDPIN_SHELF_WALL_THICKNESS = 1.5;

//GOLDPIN_SHELF_MOUNT = 2;
GOLDPIN_SHELF_MOUNT_WIDTH = 2.5;
GOLDPIN_SHELF_MOUNT_HEIGHT = 4.95;

/* [POLOLU SIZE] */
POLOLU_SIDE = 17.87;
POLOLU_SHELF_THICKNESS = 2;
POLOLU_MINI_SHELF_SIDE = 4;
POLOLU_SCREW_DIAMETER = 2.27;

/* [MINIJACK PORT SIZE] */
MINIJACK_PORT_RADIUS = 7.1;

/* [DC PORT SIZE] */
DC_PORT_RADIUS = 7.8;  //11.5 body mounted

/* [MOUNTING ELEMS] */
SCREW_DIAMETER = 3; // M3 screw
SCREW_HEAD_DIAMETER = 6.4; // M3 screw
SCREW_HEAD_THICKNESS = 3.07; // M3 screw
SCREW_WALL_DISTANCE = 0;
SCREW_HEX_HEIGHT = 5.42;
SCREW_HEX_RADIUS = 6.20;
SCREW_HEX_THICKNESS = 2.42;

/* [VENTS] */
VENT_THICKNESS = 1.8;

/* [PROTECTORS] */
PROTECTOR_WIDTH = 2.0;
PROTECTOR_Z_OFFSET = 3.33 + 0.4;
PROTECTOR_Y_OFFSET = 4.7;
PROTECTOR_Y_OFFSET_TOP = -1.0;
PROTECTOR_STABILISER_WIDTH = 2;
PROTECTOR_STABILISER_HEIGHT = 4;
STABILISER_THICKNESS = 3;
STABILISER_HEIGHT = 4.44;
STABILISER_WIDTH = 9.0;
RIGHT_COVER_HEIGHT = 3.70;
RIGHT_COVER_WIDTH = 10;

/* [MISC] */
CORNER_CURVE_DIAMETER = 10;
TOLERANCE = 0.05;
EXPLODE_OFFSET = 20;  

DELTA = 0.001; // used for non-perfect diffs

/* [HIDDEN] */
$fn = 128;
fudge = 0.1;

//color("grey")
//dock_rim_with_buttons(DOCK_BODY_WIDTH, DOCK_BODY_HEIGHT, DOCK_BODY_DEPTH, DOCK_WALL_THICKNESS, BUTTON_BOTTOM_WIDTH, BUTTON_BOTTOM_DISTANCE, NUT_HOLDER_WALL_THICKNESS, NUT_HOLDER_BASE_THICKNESS);
//
//color("red")
//translate([0,0,(-DOCK_BODY_DEPTH-DOCK_BACK_THICKNESS)/2- EXPLODE_OFFSET])
//rotate([180,0,0])
//dock_back_wall(DOCK_BODY_WIDTH, DOCK_BODY_HEIGHT,  DOCK_BACK_THICKNESS);

//color("red")
//translate([0,0,(+DOCK_BODY_DEPTH+DOCK_FRONT_THICKNESS)/2 + EXPLODE_OFFSET ])
dock_front_wall(DOCK_BODY_WIDTH, DOCK_BODY_HEIGHT,  DOCK_FRONT_THICKNESS);

//curved_protector();

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

module dock_wall_base(width, height, depth){
   x_translate = width-CORNER_CURVE_DIAMETER;
   y_translate = height-CORNER_CURVE_DIAMETER;
        
   //TODO: refactor these 
   slot_diameter = SCREW_DIAMETER/2 + 1.0;
   washer_diameter = SCREW_DIAMETER/2 + 4.0;
   y_offset = max(DOCK_WALL_THICKNESS, DOCK_PROTECTOR_HEIGHT);    
   x_translation = (width-DOCK_WALL_THICKNESS)/2 - slot_diameter - SCREW_WALL_DISTANCE;    
   special_x_translation = x_translation - GOLDPIN_RASTER_EDGE_DISTANCE/2 - SCREW_DIAMETER/2;
   y_translation = (height-y_offset)/2 - slot_diameter - SCREW_WALL_DISTANCE;        
    
   difference(){
       hull(){
            translate([-x_translate/2, -y_translate/2, 0])
            cylinder(depth,CORNER_CURVE_DIAMETER/2, CORNER_CURVE_DIAMETER/2, true);    
            
            translate([-x_translate/2, y_translate/2, 0])
            cylinder(depth,CORNER_CURVE_DIAMETER/2, CORNER_CURVE_DIAMETER/2, true);

            translate([x_translate/2, y_translate/2, 0])
            cylinder(depth,CORNER_CURVE_DIAMETER/2, CORNER_CURVE_DIAMETER/2, true);        
            
            translate([x_translate/2, -y_translate/2, 0])
            cylinder(depth,CORNER_CURVE_DIAMETER/2, CORNER_CURVE_DIAMETER/2, true);        
        };          
        //substract screws           
        translate([special_x_translation, 0, 0])
        cylinder(DOCK_BACK_THICKNESS,SCREW_DIAMETER/2,SCREW_DIAMETER/2,true);             
        
        translate([x_translation, y_translation, 0])
        cylinder(DOCK_BACK_THICKNESS,SCREW_DIAMETER/2,SCREW_DIAMETER/2,true);        
    
        translate([-x_translation, y_translation, 0])
        cylinder(DOCK_BACK_THICKNESS,SCREW_DIAMETER/2,SCREW_DIAMETER/2,true);               
        
        translate([x_translation, -y_translation, 0])
        cylinder(DOCK_BACK_THICKNESS,SCREW_DIAMETER/2,SCREW_DIAMETER/2,true);                           
        
        translate([-x_translation, -y_translation, 0])
        cylinder(DOCK_BACK_THICKNESS,SCREW_DIAMETER/2,SCREW_DIAMETER/2,true);           
        
        //substract vents        
        translate([-18, 0, 0])
        cube([VENT_THICKNESS, DOCK_BODY_HEIGHT*2/3, DOCK_BACK_THICKNESS*2], true);                                      
        translate([-12, 0, 0])
        cube([VENT_THICKNESS, DOCK_BODY_HEIGHT*2/3, DOCK_BACK_THICKNESS*2], true);                              
        translate([-6, 0, 0])
        cube([VENT_THICKNESS, DOCK_BODY_HEIGHT*2/3, DOCK_BACK_THICKNESS*2], true);                        
        translate([0, 0, 0])
        cube([VENT_THICKNESS, DOCK_BODY_HEIGHT*2/3, DOCK_BACK_THICKNESS*2], true);
        translate([6, 0, 0])
        cube([VENT_THICKNESS, DOCK_BODY_HEIGHT*2/3, DOCK_BACK_THICKNESS*2], true);                          
   }     
}

module dock_back_wall(width, height, depth){
   x_translate = width-CORNER_CURVE_DIAMETER;
   y_translate = height-CORNER_CURVE_DIAMETER;
        
   //TODO: refactor these 
   slot_diameter = SCREW_DIAMETER/2 + 1.0;
   washer_diameter = SCREW_DIAMETER/2 + 4.0;
   y_offset = max(DOCK_WALL_THICKNESS, DOCK_PROTECTOR_HEIGHT);    
   x_translation = (width-DOCK_WALL_THICKNESS)/2 - slot_diameter - SCREW_WALL_DISTANCE;    
   special_x_translation = x_translation - GOLDPIN_RASTER_EDGE_DISTANCE/2 - SCREW_DIAMETER/2;
   y_translation = (height-y_offset)/2 - slot_diameter - SCREW_WALL_DISTANCE;        
    
   z_translation = 3.1;    
    
   echo("Back Z translation", z_translation);    
   difference(){
        dock_wall_base(width, height, depth);    
 
        //substract screw washer           
        translate([special_x_translation, 0, z_translation])
        cylinder(DOCK_BACK_THICKNESS,washer_diameter/2,washer_diameter/2,true);       
        
        translate([x_translation, y_translation, z_translation])
        cylinder(DOCK_BACK_THICKNESS,washer_diameter/2,washer_diameter/2,true);       
    
        translate([-x_translation, y_translation, z_translation])
        cylinder(DOCK_BACK_THICKNESS,washer_diameter/2,washer_diameter/2,true);       
        translate([x_translation, -y_translation, z_translation])
        cylinder(DOCK_BACK_THICKNESS,washer_diameter/2,washer_diameter/2,true);       
       
        translate([-x_translation, -y_translation, z_translation])
        cylinder(DOCK_BACK_THICKNESS,washer_diameter/2,washer_diameter/2,true);       
    }    
}

module m3_hex_screw(thicnkess){
        hexagon(SCREW_HEX_HEIGHT, thicnkess);    
}

module poly_rect9473(h)
{
  scale([25.4/90, -25.4/90, 1]) union()
  {
    difference()
    {
       linear_extrude(height=h)
         polygon([[-24.172366,-2.556547],[-24.053693,5.052953],[24.172365,4.968753],[19.041978,1.574736],[13.348651,-1.130563],[7.243469,-3.141025],[0.877514,-4.450528],[-5.598130,-5.052953],[-12.032380,-4.942178],[-18.274153,-4.112083],[-24.172366,-2.556547]]);
       translate([0, 0, -fudge])
         linear_extrude(height=h+2*fudge)
           polygon([[-18.031737,-2.380387],[-13.402091,-2.380387],[-13.402091,-0.467827],[-18.031737,-0.467827]]);
       translate([0, 0, -fudge])
         linear_extrude(height=h+2*fudge)
           polygon([[7.801564,0.608523],[12.599555,0.608523],[12.599555,2.644103],[7.801564,2.644103]]);
    }
  }
}

module protector_inkscape(h)
{
  SCALE = 3.58;
  scale([SCALE,SCALE,1])
  poly_rect9473(h);
}   

module curved_protector(){
    thickness = PROTECTOR_WIDTH;    
    z_offset = -4.0-2.65;    
    y_offset = thickness/2;
    
    translate([0,0,5.29+PROTECTOR_Z_OFFSET])    
    rotate([90,0,0])
    
    intersection(){
        union(){
                translate([0,z_offset,y_offset])
                cube([50,PROTECTOR_Z_OFFSET,thickness], true);
                protector_inkscape(thickness);
        };
        cube([44,30,20], true);         
    } 
}

module protector_stabiliser(){
    difference(){        
        cube([3,PROTECTOR_STABILISER_WIDTH,PROTECTOR_STABILISER_HEIGHT], true);       
        
        rotate([30,0,0])    
        translate([0,1.8,0])
        cube([4,2*PROTECTOR_STABILISER_WIDTH,PROTECTOR_STABILISER_HEIGHT*2], true);        
    }
//    color("red")
//    rotate([30,0,0])    
//    translate([0,2,0])
//    cube([4,2*PROTECTOR_STABILISER_WIDTH,PROTECTOR_STABILISER_HEIGHT*2], true);
}

module module_stabiliser(){
    cube([STABILISER_THICKNESS,STABILISER_WIDTH,STABILISER_HEIGHT], true);
}

module right_cover(){
    cube([STABILISER_THICKNESS,RIGHT_COVER_WIDTH,RIGHT_COVER_HEIGHT], true);    
}

module dock_front_wall(width, height, depth){
    x_translate = width-CORNER_CURVE_DIAMETER;
    y_translate = height-CORNER_CURVE_DIAMETER;
        
    //TODO: refactor these 
    slot_diameter = SCREW_DIAMETER/2 + 1.0;
    washer_diameter = SCREW_DIAMETER/2 + 4.0;
    y_offset = max(DOCK_WALL_THICKNESS, DOCK_PROTECTOR_HEIGHT);    
    x_translation = (width-DOCK_WALL_THICKNESS)/2 - slot_diameter - SCREW_WALL_DISTANCE;    
    special_x_translation = x_translation - GOLDPIN_RASTER_EDGE_DISTANCE/2 - SCREW_DIAMETER/2;
    y_translation = (height-y_offset)/2 - slot_diameter - SCREW_WALL_DISTANCE;      
    
    z_translation = 0.5;
    
    echo("Front Z translation", z_translation);
    union(){
        translate([0,(DOCK_BODY_HEIGHT-PROTECTOR_WIDTH)/2-PROTECTOR_Y_OFFSET_TOP,0])
        curved_protector();
        
        translate([0,-(DOCK_BODY_HEIGHT-PROTECTOR_WIDTH)/2+PROTECTOR_Y_OFFSET,0])
        curved_protector();

        translate([12,(DOCK_BODY_HEIGHT-PROTECTOR_WIDTH)/2-PROTECTOR_Y_OFFSET_TOP-3.3,(DOCK_FRONT_THICKNESS+PROTECTOR_STABILISER_HEIGHT)/2])
        rotate([0,0,180])
        protector_stabiliser();    
        
        translate([-3,(DOCK_BODY_HEIGHT-PROTECTOR_WIDTH)/2-PROTECTOR_Y_OFFSET_TOP-3.3,(DOCK_FRONT_THICKNESS+PROTECTOR_STABILISER_HEIGHT)/2])
        rotate([0,0,180])
        protector_stabiliser();         
    
        translate([-15,(DOCK_BODY_HEIGHT-PROTECTOR_WIDTH)/2-PROTECTOR_Y_OFFSET_TOP-3.3,(DOCK_FRONT_THICKNESS+PROTECTOR_STABILISER_HEIGHT)/2])
        rotate([0,0,180])        
        protector_stabiliser();          

        translate([12,-(DOCK_BODY_HEIGHT-PROTECTOR_WIDTH)/2+PROTECTOR_Y_OFFSET+PROTECTOR_STABILISER_WIDTH/2,(DOCK_FRONT_THICKNESS+PROTECTOR_STABILISER_HEIGHT)/2])
        protector_stabiliser();
        
        translate([-3,-(DOCK_BODY_HEIGHT-PROTECTOR_WIDTH)/2+PROTECTOR_Y_OFFSET+PROTECTOR_STABILISER_WIDTH/2,(DOCK_FRONT_THICKNESS+PROTECTOR_STABILISER_HEIGHT)/2])
        protector_stabiliser();        
        
        translate([-15,-(DOCK_BODY_HEIGHT-PROTECTOR_WIDTH)/2+PROTECTOR_Y_OFFSET+PROTECTOR_STABILISER_WIDTH/2,(DOCK_FRONT_THICKNESS+PROTECTOR_STABILISER_HEIGHT)/2])
        protector_stabiliser();        

        translate([-22,0,(DOCK_FRONT_THICKNESS+STABILISER_HEIGHT)/2])        
        module_stabiliser();
        translate([24,0,(DOCK_FRONT_THICKNESS+RIGHT_COVER_HEIGHT)/2])        
        right_cover();        
        
        intersection(){
            difference(){
                dock_wall_base(width, height, depth);        

                translate([(width-GOLDPIN_RASTER_EDGE_DISTANCE)/2,0,0])            
                rotate([0,0,90])
                raster_n_pins_wider(9);
        
                //substract screw washer           
                translate([special_x_translation, 0, z_translation])
                m3_hex_screw(DOCK_FRONT_THICKNESS);            
                
                translate([x_translation, y_translation, z_translation])
                m3_hex_screw(DOCK_FRONT_THICKNESS);            
            
                translate([-x_translation, y_translation, z_translation])
                m3_hex_screw(DOCK_FRONT_THICKNESS);            
                translate([x_translation, -y_translation, z_translation])
                m3_hex_screw(DOCK_FRONT_THICKNESS);
                
                translate([-x_translation, -y_translation, z_translation])
                m3_hex_screw(DOCK_FRONT_THICKNESS);            
            }    
            cube([width,height-DOCK_PROTECTOR_HEIGHT-TOLERANCE,10],true);
        }  
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

module cylindric_button() {
    cylinder(DOCK_WALL_THICKNESS*2, BUTTON_CYLINDER_DIAMETER/2, BUTTON_CYLINDER_DIAMETER/2, true);        
}

module button_rail() {
    button_support_thickness = 2.0;
    button_support_height = 10;
    cube([BUTTON_RAIL_DEPTH, BUTTON_RAIL_WIDTH, BUTTON_RAIL_HEIGHT], true);        

    translate([-button_support_thickness/2-BUTTON_RAIL_HEIGHT/2,0,-button_support_height/2+BUTTON_RAIL_HEIGHT/2])
    cube([button_support_thickness, BUTTON_RAIL_WIDTH, button_support_height], true);        
}



module button_row(button_body_width, button_bottom_distance){
    translate_step = BUTTON_BOTTOM_WIDTH + BUTTON_BOTTOM_DISTANCE;
    
    initial_translation = translate_step;
    translate([0, -initial_translation, 0])
    for (n = [0:1:2]){
        translate([0,n*translate_step, 0]) 
        rotate([0,90,0])
        cylindric_button();
    };     
}

module hulled_button_row(button_body_width, button_bottom_distance){
    translate_step = BUTTON_BOTTOM_WIDTH + BUTTON_BOTTOM_DISTANCE;
    
    initial_translation = translate_step;
    translate([0, -initial_translation, 0])
    for (n = [0:1:2]){
        translate([0,n*translate_step, 0]) 
        rotate([0,90,0])
        hull(){
            cylindric_button();            
            translate([10,0,0])
            cylindric_button();            
        }
    };     
}

module button_rail_row(){
    translate_step = BUTTON_BOTTOM_WIDTH + BUTTON_BOTTOM_DISTANCE;
    
    initial_translation = translate_step;
    translate([-BUTTON_RAIL_DEPTH/2-DOCK_WALL_THICKNESS/2, -initial_translation, -BUTTON_RAIL_OFFSET])
    for (n = [0:1:2]){
        translate([0,n*translate_step, 0]) 
        button_rail();
    };     
}


module goldpin_shelf(){    
    pins = 9;
    
    shelf_thickness = GOLDPIN_SHELF_WALL_THICKNESS;
    shelf_height = RASTER_SLOT_HEIGHT - LID_OFFSET - DOCK_FRONT_THICKNESS + GOLDPIN_SHELF_BASE;

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
}

module regulator_mini_shelf(){
    difference(){
        cube([POLOLU_MINI_SHELF_SIDE,POLOLU_MINI_SHELF_SIDE,POLOLU_SHELF_THICKNESS],true);
        cylinder(POLOLU_SHELF_THICKNESS*2, POLOLU_SCREW_DIAMETER/2, POLOLU_SCREW_DIAMETER/2, true);
    }    
}

module regulator_shelf(){
    translation_value = (POLOLU_SIDE - POLOLU_MINI_SHELF_SIDE) / 2;
    thinner_translation_value = (POLOLU_SIDE - POLOLU_MINI_SHELF_SIDE/2) / 2;

    translate([thinner_translation_value,translation_value,0])
    cube([POLOLU_MINI_SHELF_SIDE/2,POLOLU_MINI_SHELF_SIDE,2], true);

    translate([translation_value,-translation_value,0])
    regulator_mini_shelf();
    
    translate([-translation_value,translation_value,0])
    regulator_mini_shelf();    
    
}

function nut_cylinder_height(single_nut_height, base_thickness) = 2*(single_nut_height+base_thickness);
function nut_cylinder_radius(single_nut_width, nut_holder_wall_thickness) = single_nut_width + 2*nut_holder_wall_thickness;

module dock_rim_with_buttons(width, height, depth, wall_thickness, button_body_width, button_bottom_distance, nut_holder_wall_thickness, nut_holder_base_thickness) {

    button_translation = 4;
    
    cylinder_radius = nut_cylinder_radius(NUT_WIDTH, nut_holder_wall_thickness); 
    cylinder_height = nut_cylinder_height(NUT_HEIGHT, nut_holder_base_thickness); 

    edge_distance = width/3;

    slot_diameter = SCREW_DIAMETER/2 + 1.0;

    y_offset = max(wall_thickness, DOCK_PROTECTOR_HEIGHT);

    x_translation = (width-wall_thickness)/2 - slot_diameter - SCREW_WALL_DISTANCE;    
    special_x_translation = x_translation - GOLDPIN_RASTER_EDGE_DISTANCE/2 - SCREW_DIAMETER/2;
    y_translation = (height-y_offset)/2 - slot_diameter - SCREW_WALL_DISTANCE;

    echo(cylinder_height);

    union(){         
        difference(){
            dock_rim(width, height, depth, wall_thickness);

            // Placeholder for buttons
            translate([width/2,0,0])
//            button_row(button_body_width, button_bottom_distance);
            hulled_button_row(button_body_width, button_bottom_distance);            
            
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
        rotate([-90,180,0])
        screw_port(nut_holder_wall_thickness, nut_holder_base_thickness);    
        
        // TODO: Button rail is not a good idea, redesign a slide-in solution with a cover
        translate([width/2,0,0])
        button_rail_row();        
        
        // Construction screws
        translate([special_x_translation,0,0])    
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
        translate([(width-GOLDPIN_RASTER_EDGE_DISTANCE)/2,0, DOCK_BODY_DEPTH/2 - RASTER_SLOT_HEIGHT/2 + LID_OFFSET + DOCK_FRONT_THICKNESS])
        rotate([0,0,90])
        
        goldpin_shelf();
        
        // Shelf mount 1
        translate([(width - GOLDPIN_RASTER_EDGE_DISTANCE - GOLDPIN_SHELF_MOUNT_WIDTH - RASTER_INTERPIN_DISTANCE - TOLERANCE)/2,0,DOCK_BODY_DEPTH/2-GOLDPIN_SHELF_MOUNT_HEIGHT/2])                
        cube([GOLDPIN_SHELF_MOUNT_WIDTH,DOCK_BODY_HEIGHT,GOLDPIN_SHELF_MOUNT_HEIGHT],true);
        
        // Shelf mount 2        
        translate([(width - GOLDPIN_RASTER_EDGE_DISTANCE + GOLDPIN_SHELF_MOUNT_WIDTH + RASTER_INTERPIN_DISTANCE + TOLERANCE)/2,0,DOCK_BODY_DEPTH/2-GOLDPIN_SHELF_MOUNT_HEIGHT/2])        
        cube([GOLDPIN_SHELF_MOUNT_WIDTH,DOCK_BODY_HEIGHT,GOLDPIN_SHELF_MOUNT_HEIGHT],true);        
        
        // Regulator shelf
        translate([0.5,(DOCK_BODY_HEIGHT-DOCK_WALL_THICKNESS-POLOLU_SIDE)/2,2])
        regulator_shelf();
        
        // Additional block
        translate([-9.5,0,DOCK_BODY_DEPTH/2-GOLDPIN_SHELF_MOUNT_HEIGHT/2/2])   
        cube([GOLDPIN_SHELF_MOUNT_WIDTH,DOCK_BODY_HEIGHT,GOLDPIN_SHELF_MOUNT_HEIGHT/2],true);     
    }        
}

module raster_single_pin(){
    slot_height = RASTER_SLOT_HEIGHT;
    slot_width = RASTER_INTERPIN_DISTANCE + DELTA;  //specs
    slot_depth = RASTER_INTERPIN_DISTANCE + TOLERANCE + DELTA;  //specs
        
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

module raster_n_pins_wider(pins){
    initial_offset = (pins-1)*RASTER_INTERPIN_DISTANCE;
    
    translate([-initial_offset/2,0,0])    
    union(){            
        // Edge margin
        translate([-1,0,0])        
        raster_single_pin();
        
        for(n=[0:1:pins-1]){
            translate([n*RASTER_INTERPIN_DISTANCE,0,0])
            raster_single_pin();
        }

        // Edge margin        
        translate([(pins-1)*RASTER_INTERPIN_DISTANCE+1,0,0])
        raster_single_pin();
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

// Photo screw port
module screw_port(wall_thickness, base_thickness){
    cylinder_height = nut_cylinder_height(NUT_HEIGHT, base_thickness);    
    cylinder_radius = NUT_WIDTH + 2*wall_thickness - 0.1;
    
    inside_diameter = NUT_INSIDE_DIAMETER + TOLERANCE;
    
    difference(){
        // Main holder
        union(){
            cylinder(cylinder_height,cylinder_radius/2, cylinder_radius/2, true);
            translate([0,0,0])
            cube([cylinder_radius,cylinder_radius,cylinder_height],true);
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
