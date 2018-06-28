DOCK_BODY_DEPTH = 10;
DOCK_BODY_HEIGHT = 30;
DOCK_BODY_WIDTH = 45;

DOCK_BACK_THICKNESS = 1;

DOCK_WALL_THICKNESS = 2;

CORNER_CURVE_DIAMETER = 10;

EXPLODE_OFFSET = 20;

$fn = 128;
dock_rim(DOCK_BODY_WIDTH, DOCK_BODY_HEIGHT, DOCK_BODY_DEPTH, DOCK_WALL_THICKNESS, CORNER_CURVE_DIAMETER);
translate([0,0,(-DOCK_BODY_DEPTH+DOCK_BACK_THICKNESS)/2- EXPLODE_OFFSET])
dock_back_wall(DOCK_BODY_WIDTH, DOCK_BODY_HEIGHT,  DOCK_BACK_THICKNESS, CORNER_CURVE_DIAMETER);

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
    dock_back_wall(width, height, depth, corner_curve_diameter);
}

module dock_rim(width, height, depth, wall_thickness, corner_curve_diameter) {
    
    curve_ratio = sqrt(pow(width-wall_thickness,2) + pow(height-wall_thickness,2)) / sqrt(pow(width,2) + pow(height,2));
    
    scaled_curve = corner_curve_diameter * curve_ratio;
    
    difference(){
        dock_body(width, height, depth, corner_curve_diameter);
        dock_body(width-wall_thickness, height-wall_thickness, 2*depth, scaled_curve);
    };
}