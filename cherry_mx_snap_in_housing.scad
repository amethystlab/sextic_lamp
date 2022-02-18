

use <cherry_mx_bottom_half.scad>;


snap_in_housing();




module snap_in_housing(){
    rotate(180,[1,0,0])
    diff_applied_housing();
}


module diff_applied_housing(){
    difference() {
        color("Orchid")
        snap_in_housing_positive_cube();
			cherry_mx_bottom();
    }
}



module snap_in_housing_positive_cube(){
	
	translate([0,0,-panel_t/2]){
        cube([18,18,panel_t],center=true);
    }
}

module snap_in_housing_negative_cube(){
    translate([0,0,-(panel_t+1)/2 ]){
        cube([17,17,panel_t+1],center=true);
    }
}