// all units in mm
translate([0,8,0])
cherry_mx_bottom();
*posts_and_wire_cutouts();

diode_holes = false;
LED_holes = false;

total_depth = 5.6; // from the cherry documentation 

top_length_x = 13.8;//13.8;// measured
top_length_y = 13.75;//13.75; // measured
top_length_z = 1.35;// measure me

side_notch_length_x = 0.55; // measured
side_notch_length_y = 3.5; // measured 3.8

bottom_length_x = 13;//12.75;// measured
bottom_length_y = 14;//13.8;// measured

snap_dist_z = 0.5;// measure me
snap_angle = 25; // degrees
snap_tab_width = 2.5;

snap_bar_height = 1;
snap_bar_depth = 1;
snap_bar_length = 5.5;





switch_bottom_color = "DarkGray";



module cherry_mx_bottom(){
    translate([0,0,-top_length_z]){
    difference () {
        
        union (){
            color(switch_bottom_color)
            translate([0,0,top_length_z+0.01]/2){ cube([top_length_x, top_length_y, top_length_z+0.01],center=true);}
            color(switch_bottom_color)
            hull (){
                
                translate([0,0,0]){ // the top of the angled section
                    cube([top_length_x, top_length_y, 0.01],center=true);
                }
                
                
                translate([0,0,-(total_depth-top_length_z)]){ // the bottom of the angled section
                    cube([bottom_length_x, bottom_length_y, 0.01],center=true);
                }
            }
            
            translate([0,0,-total_depth - (2.54*10*post_height - 0.01)/2]){
                posts_and_wire_cutouts();
            }
            color(switch_bottom_color)
            snap_in_tabs();
        }
        color(switch_bottom_color)
        side_cutouts();
        
    }
    }
}
module side_cutouts(){
    translate ([top_length_x/2 -side_notch_length_x/2,0, (top_length_z - total_depth/2)  ]) {
        cube([side_notch_length_x + 0.01,side_notch_length_y + 0.01,total_depth + 0.03],center=true);
    }
    translate ([ -(top_length_x/2 -side_notch_length_x/2),0, (top_length_z - total_depth/2)  ]) {
        cube([side_notch_length_x + 0.01,side_notch_length_y + 0.01,total_depth + 0.03],center=true);
    }
}


module snap_in_tabs(){
    
    s = 2.6;
    
	d = -1.3;
    translate([0,top_length_y/2,snap_dist_z ]){
		translate([0,snap_bar_depth/2,d]){
            cube([snap_bar_length,snap_bar_depth,snap_bar_height],center=true);
        }
        
        
    }
    
	translate([0,top_length_y/2,top_length_z-s/2]){
		hull(){
            cube([snap_tab_width,0.01,s],center=true);
            rotate(-snap_angle,[1,0,0]){
                cube([snap_tab_width,0.01,s/cos(snap_angle)],center=true);
            }
        }
	}
	
	
    translate([0,-top_length_y/2,snap_dist_z ]){
		translate([0,-snap_bar_depth/2,d]){
            cube([snap_bar_length,snap_bar_depth,snap_bar_height],center=true);
        }
        
        
    }
    
	translate([0,-top_length_y/2,top_length_z-s/2]){
		hull(){
            cube([snap_tab_width,0.01,s],center=true);
            rotate(snap_angle,[1,0,0]){
                cube([snap_tab_width,0.01,s/cos(snap_angle)],center=true);
            }
        }
	}
    
    
}

 









post_height = 0.13; // from cherry corp documentation

center_post_diameter = 0.157; // from cherry corp documentation
guide_post_diameter = 0.067; // from cherry corp documentation
pin_diameter = 0.059; // from cherry corp documentation
diode_post_diameter = 0.039; // from cherry corp documentation

guide_post1_x_offset = -0.2; // from cherry corp documentation
guide_post2_x_offset = 0.2; // from cherry corp documentation

pin1_x_offset = -0.15; // from cherry corp documentation
pin1_y_offset = 0.1; // from cherry corp documentation

pin2_x_offset = 0.1; // from cherry corp documentation
pin2_y_offset = 0.2; // from cherry corp documentation


diode1_x_offset = -0.15; // from cherry corp documentation
diode1_y_offset = -0.2; // from cherry corp documentation

diode2_x_offset = 0.15; // from cherry corp documentation
diode2_y_offset = -0.2; // from cherry corp documentation

LED1_x_offset = -0.05; // from cherry corp documentation
LED1_y_offset = -0.2; // from cherry corp documentation

LED2_x_offset = 0.05; // from cherry corp documentation
LED2_y_offset = -0.2; // from cherry corp documentation

printed_size_compensation_factor = 1.2;


// produces a centered above-plane set of cutouts for a cherry mx switch
module posts_and_wire_cutouts(){
    s = 10*2.54;
    scale ([s,s,s]){
        color(switch_bottom_color) {
            translate ([0,0,0]){
                center_post();    
            }
            translate ([guide_post1_x_offset,0,0]){
                guide_post();
            }
            translate ([guide_post2_x_offset,0,0]){
                guide_post();
            }
        }
        color("Gold") {
            translate ([pin1_x_offset,pin1_y_offset,0]){
                pin();
            }
            translate ([pin2_x_offset,pin2_y_offset,0]){
                pin();
            }
			
			if (diode_holes){
				translate ([diode1_x_offset,diode1_y_offset,]){
					diode_lead();
				}
				translate ([diode2_x_offset,diode2_y_offset,]){
					diode_lead();
				}
			}
			
			if (LED_holes){
				translate ([LED1_x_offset,LED1_y_offset,]){
					diode_lead();
				}
				translate ([LED2_x_offset,LED2_y_offset,]){
					diode_lead();
				}
            }
        }
    }
}


module center_post(){
    cylinder(r=center_post_diameter/2*printed_size_compensation_factor, h = 0.13, $fn = 20);
}

module guide_post(){
    cylinder(r=guide_post_diameter/2*printed_size_compensation_factor, h = 0.13, $fn = 20);
}

module pin(){
    cylinder(r=pin_diameter/2*printed_size_compensation_factor, h = 0.13, $fn = 20);
}

module diode_lead(){
    cylinder(r=diode_post_diameter/2*printed_size_compensation_factor, h = 0.13, $fn = 20);
}


