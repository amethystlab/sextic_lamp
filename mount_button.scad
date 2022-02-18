
include <NeoPixel RGBW Mini Button PCB.scad>

module mount()
{
  button_chip_mount_t = 3;
  translate([0,0,mount_t])
  {
    difference(){
      cylinder(r=mount_platform_dia/2,h=button_chip_mount_t);

      translate([0,0,0])
        mini_button_pcb();

      translate([0,0,-2*eps])
        mini_button_pcb();

      translate([0,0,button_chip_mount_t/2])
        cube([5,mount_platform_dia+5,button_chip_mount_t+1],center=true);

      translate([0,0,1.3/2-eps])
        cube([7,mount_platform_dia+5,1.3],center=true);
    }
  }
  
  difference()
  {
  cylinder(r=mount_platform_dia/2,h=mount_t);

  translate([0,0,-eps])
	cylinder(r=mount_platform_dia_inner/2,h=mount_t+2*eps);
	

  for (ii=[-1,1])
  {
	translate([ii*mount_screwhole_offset,0,-eps])
	  cylinder(r=mount_screwhole_dia/2,h=mount_t+2*eps);
	
	translate([0,ii*(mount_platform_dia/2+mount_platform_dia/2 - mount_squaring_d),mount_t/2])
	cube([mount_platform_dia,mount_platform_dia,mount_t+2*eps],center=true);
  }
  
  
  mount_wire_cutting_object();

  
  }

}

module mount_wire_cutting_object()
{
  translate([0,0,mount_t/3 - eps/2])
  cube([wire_cutout_width,mount_platform_dia*1.5,mount_wire_cutout_vertical_ratio*mount_t+eps],center=true);  
  
  // the above 10 is a large multiplicative factor, because i'm lazy
}



module cover_snaps(width, length, thickness)
{
  rotate(cover_snap_rotation,[0,0,1])
  translate([0,0,-dist_to_floor])
  
    for (a=[0,180])
  {
  
    difference(){

      rotate(a,[0,0,1])
        translate([mount_platform_dia/2-1,-width/2,0])
          cube([length,width,thickness]);


      rotate(a,[0,0,1])
        translate([mount_platform_dia/2 + 4,-width/2-0.5,1])
          rotate(45,[0,1,0])
            cube([length,width+1,thickness+3]);
    } // diff
  } // for
}



module slot_cutouts()
{ // magic constant in the rotate...
  translate([0,0,-1.8])
  rotate(90,[0,0,1])

    translate([0,0,mount_t/3 - eps/2])
  cube([snap_width+1,mount_platform_dia*1.6,mount_t+eps],center=true);

}