control_box(); 

use <cherry_mx_bottom_half.scad>;








base_x = 170;
base_y = 140;
base_z = 40;

wall_t = 2.5;
floor_t = 2;

roundedness = 4;
roundedness_fn = 30;



    panel_z_inset = 1;
    
    pillar_r = 4;
    pillar_x = base_x/2-pillar_r-2;
    pillar_y = base_y/2-pillar_r-2;
    
    screw_d = 3; // targeting m3 screws into a heat-set insert.
    heatset_insert_d = 5.3;
    heatset_insert_z = 3.8;
    



// some stuff about the internals of the control box

use_power_switch = true;
power_switch_h = base_z/2;

use_usb = false;
    usb_x = 19;
    usb_y = 26;
    usb_z = 5;
    usb_x_offset = base_x/2-usb_y-15;
    
    wire_x_offset = usb_x_offset-10;
    wire_z_offset = base_z/2;
    
// about the panel lid itself
    panel_t = 2;
// placement of various controls on the top of the panel


cherry_housing_t = 5.5;

// offsets measured from lower left
cherry_offset_x = 100;
cherry_offset_y = 30;

cherry_locs_x = [-25,0,25];
cherry_locs_y = [0];

// offsets measured from lower left

pot_offset_x = 98;
pot_offset_y = 75;
pot_locs_x = [-35, 0, 35];
pot_locs_y = [0];

tog_offset_x = 30;
tog_offset_y = base_y/2;
tog_locs_x = [0];
tog_locs_y = [-20,0,20];


enc_offset_x = 80;
enc_offset_y = 110;
enc_locs_x = [0];
enc_locs_y = [0];
//control_box(); 



eps = 1/10;

module control_box()
{
    translate([base_x/2, base_y/2,0])
    translate([0,base_y+5,0])
    base();
    
    
    
    translate([base_x/2, base_y/2,panel_t])
    rotate(180,[0,1,0])
    panel();
}



module panel()
{
    difference(){
        union(){
        difference(){
            panel_pos();
            panel_neg();
        }   
        
        
        
        buttons_pos();
        
        signature();
        }
        
        buttons_neg();
        pots_neg();
        encoders();
        toggle_switches();
        
        panel_screw_holes();
    } // diff
    
}


module panel_pos()
{
    r = roundedness;
    minkowski()
    {
        cube([base_x-2*r, base_y-2*r, panel_t], center=true);
        sphere(r=roundedness, $fn = roundedness_fn);
    }
    
}

module buttons_pos()
{
    for (p=cherry_locs_x){
        for (q = cherry_locs_y){
    translate([-base_x/2+cherry_offset_x+p,-base_y/2+cherry_offset_y+q,panel_t-eps])
    snap_in_housing();
        
    }} // d/uble for
}

module buttons_neg()
{
    for (p=cherry_locs_x){
        for (q = cherry_locs_y){
    translate([-base_x/2+cherry_offset_x+p,-base_y/2+cherry_offset_y+q,panel_t+eps])
        cherry_mx_bottom();
        }}
}





module snap_in_housing(){
    difference() {
        color("Orchid")
        snap_in_housing_positive_cube();
		cherry_mx_bottom();
    }
}






module snap_in_housing_positive_cube(){
	
	translate([0,0,-cherry_housing_t/2]){
        cube([18,18,cherry_housing_t],center=true);
    }
}

module snap_in_housing_negative_cube(){
    translate([0,0,-(cherry_housing_t+1)/2 ]){
        cube([17,17,cherry_housing_t+1],center=true);
    }
}


module toggle_switches()
{
    
    for (p=tog_locs_x)
    for (q=tog_locs_y)
        translate([-base_x/2+tog_offset_x+p,-base_y/2+tog_offset_y+q,0])
            toggle_switch();
}

module toggle_switch()
{
    r = 5.85;
    color("DarkBlue")
    translate([0,0,panel_t/2])
    rotate(90,[0,0,1])
    union()
    {
        cylinder(r=r/2, h=panel_t+2*eps,center=true,$fn=30);
        
        translate([0,9.7-r/2-.75/2,-panel_t/2])
        cube([2.15,0.75,panel_t/2],center=true);
    }
}

module pots_neg()
{
    for (p=pot_locs_x)
    for (q=pot_locs_y)
        translate([-base_x/2+pot_offset_x+p,-base_y/2+pot_offset_y+q,0])
            pot();
}

module pot()
{
    rotate(-90,[0,0,1])
    rotate([0,-90,0])
	{
		rotate([0,90,0])
			cylinder(r=3.5,h=15,center=true, $fn=30);
		
        q = panel_t*0.8;
		translate([0,0,3.4+4])
		rotate([0,90,0])
        translate([0,0,q/2-eps/2])
			cylinder(r=1.1,h=q+eps,center=true, $fn=30);
	}
    
}


module encoders()
{
    for (p=enc_locs_x)
    for (q=enc_locs_y)
        translate([-base_x/2+enc_offset_x+p,-base_y/2+enc_offset_y+q,0])
            rotary_encoder();
}

module rotary_encoder()
{
    rotate(-90,[0,0,1])
    translate([0,0,panel_t/2])
    intersection()
    {
    cylinder(r=9/2, h=panel_t+2*eps,center=true,$fn=30);
        cube([9,7.93,panel_t+2*eps],center=true); // 7.93 is measured.
    }
}

module panel_screw_holes()
{
    translate([0,0,panel_t])
    pillar_screwhole();
    for (ii=[-1,1])
        for (jj=[-1,1])
            translate([ii*pillar_x,jj*pillar_y, 0])
        translate([0,0,panel_t])
            pillar_screwhole();
}



module panel_neg()
{
    a_lot = 100;
           translate([0,0,-a_lot/2])
        cube([base_x+2*eps, base_y+2*eps, a_lot],center=true);
        
        translate([0,0,panel_t+a_lot/2])
        cube([base_x+2*eps, base_y+2*eps, a_lot],center=true);
        
    translate([0,0,-base_z+panel_z_inset])
       basic_case();
    
}






















module base()
{
    basic_case();
    
    if (use_usb){
    translate([usb_x_offset,-base_y/2+wall_t+usb_x,0])
    translate([0,0,floor_t])
    usb_support_platform();
    }
    
    pillars();
    
    little_walls();
}


module basic_case()
{
    
    difference()
    {
        base_pos();
        base_neg();
    }
    
}
module base_pos()
{
        difference(){
        minkowski()
        {
            r = roundedness;
            translate([0,0,base_z/2])
            cube([base_x-2*r, base_y-2*r, base_z],center=true);
            sphere(r=roundedness, $fn = roundedness_fn);
        }
        
        translate([0,0,-base_z/2])
        cube([base_x+2*eps, base_y+2*eps, base_z],center=true);
        
        translate([0,0,1.5*base_z])
        cube([base_x+2*eps, base_y+2*eps, base_z],center=true);
    }
    
}

//base_neg();
module base_neg()
{
    
    // first, the interior of the base
    translate([0,0,floor_t])
    difference(){
        minkowski()
        {
            r = roundedness;
            t = 2*(r)+2*wall_t;
            translate([0,0,base_z/2])
            cube([base_x-t, base_y-t, base_z],center=true);
            sphere(r=roundedness, $fn = roundedness_fn);
        }
        
        translate([0,0,-base_z/2])
        cube([base_x+2*eps, base_y+2*eps, base_z],center=true);
        
        translate([0,0,1.5*base_z])
        cube([base_x+2*eps, base_y+2*eps, base_z],center=true);
    }
    
    
    if (use_usb){
    // now the cutout for power and other cords.
    translate([usb_x_offset,-base_y/2+wall_t+usb_x,0])
    translate([0,0,floor_t])
    mini_usb_negative();
    }
    
    if (use_power_switch){
        translate([-base_x/2+20,-base_y/2+wall_t/2,power_switch_h])
        rotate(90,[0,1,0])
       power_switch();
    }
    
    translate([-base_x/2+50,-base_y/2+wall_t/2,power_switch_h])
        power_block();
    
    
    

    
    translate([15,0,0])
    wire_hole();
    
    translate([30,0,0])
    wire_hole();
    
    
    
}


module little_walls()
{
    
    p = 40;
    q = 60;
    z = base_z-panel_z_inset-eps;
    
    translate([-base_x/2+q,-base_y/2,eps])
    {
    
        difference(){
            cube([wall_t,p,z-eps]);
            
            translate([0,p/2,base_z/2])
            rotate(90,[0,1,0])
            translate([0,0,-wall_t/2])
            cylinder(r=7/2,h=wall_t*2,$fn=20);
            
        }
        
        translate([-q,p,eps])
        difference(){
            cube([q+wall_t,wall_t,z]);
            
            translate([q/2,0,base_z/2])
            rotate(90,[1,0,0])
            translate([0,0,-wall_t-1])
            cylinder(r=7/2,h=wall_t*2,$fn=20);
            
        }
        
    }
    
}



module wire_hole()
{
    translate([wire_x_offset,-base_y/2+wall_t/2,wire_z_offset])
    rotate(90,[1,0,0])
    cylinder(r=6.35/2, h = 2*wall_t, center=true, $fn=20); // a quartre inch, yo
}

module pillars()
{
    pillar();
    for (ii=[-1,1])
        for (jj=[-1,1])
            translate([ii*pillar_x,jj*pillar_y, 0])
        pillar();
}





module pillar(){
    h = base_z-panel_z_inset-eps;
    translate([0,0,h/2+eps/2])
    difference()
    {
    cylinder(r=pillar_r,h=h,center=true, $fn = 20);
        
        translate([0,0,h/2])
            pillar_screwhole();
        
        translate([0,0,h/2])
        translate([0,0,-heatset_insert_z/2+eps/2])
        cylinder(r=heatset_insert_d/2, h=heatset_insert_z+eps,center=true, $fn=20);
    }
}



module pillar_screwhole()
{
    h = 10;
    translate([0,0,-h/2+eps])
    cylinder(r=screw_d/2, h=h+2*eps,center=true, $fn = 20);
}



module power_block()
{
    cube([14.5,2*wall_t,12],center=true);
}


module power_switch()
{
    union(){
        cube([20,2*wall_t,5.3],center=true);
    cube([18.2,2*wall_t,12.6],center=true);
    }
}





module usb_support_platform()
{
    

    a = usb_x;
    b = usb_y;
    c = usb_z;
    
	rotate(90,[0,0,1])
    translate([-a/2,-b/2,0])

		{
            translate([0,0,c/2])
			difference(){
                
				cube([a,b,c],center=true);
				

				x = 7;
				y = 10.25;
				z = -5;
                
                for (ii=[-1,1])
                    for (jj=[-1,1])
                        translate([ii*x,jj*y,z])
                            usb_screwhole();
				

				usb_solder_cutout();
			}
		}
}

module usb_screwhole()
{
	cylinder(r=1.5,h=30, $fn=20);
}

module usb_solder_cutout()
{
	x = 5;
	translate([usb_x/2-x/2+eps,0,usb_z/2-1+eps])
		cube([x,usb_x-x,2],center=true);
}


module mini_usb_negative()
{
    translate([usb_y/2, -usb_x-wall_t/2,usb_z+4])
	rotate([180,0,0])
	mirror([0,1,0])
	rotate(180,[1,0,0])
	color("DarkGray")
	rotate(180,[0,0,1])
	rotate(90,[1,0,0])
	translate([0,0,0]){
		scale([0.9,0.9,1])
	linear_extrude(height=wall_t+2,scale=[1.8,2], center = true,twist=0,slices=10){
		usb_polygon();
		}
		
	}
}


module usb_polygon()
{
	a = 6;
	b = 4;
	c = 2;
	d = 1;
	
	p = (a-b)/2;
	
	translate([-a/2,c/2,0])
	offset(r=2,chamfer=true)
	polygon(
		points=[[0,0],[a,0],[a,-d],[p+b,-d],[p+b,-c],[p,-c],[p,-d],[0,-d]],
		paths=[[0,1,2,3,4,5,6,7,0]]);
}











module signature()
{
    
	f = "Courier";
    
    translate([-0,40,0.1])
	rotate([180,0,0])
	{
		scale([0.4,0.4,1])
		linear_extrude(height=0.3)
		{
			text("modeled by",font=f);
            translate([0,-12,0])
            text("silviana amethyst",font=f);
			translate([0,-24,0])
			text("version 20200603",font=f);
		}
	}
}












