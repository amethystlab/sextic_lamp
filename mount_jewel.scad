module mount()
{
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
  cube([wire_cutout_width,mount_platform_dia*10,mount_wire_cutout_vertical_ratio*mount_t+eps],center=true);  
  
  // the above 10 is a large multiplicative factor, because i'm lazy
}



module cover_snaps(width, length, thickness)
{
  rotate(cover_snap_rotation,[0,0,1])
  translate([0,0,-dist_to_floor])
  
    for (a=[0,180])
  {
  
  
    rotate(a,[0,0,1])
    translate([mount_platform_dia/2-1,-width/2,0])
    cube([length,width,thickness]);
}
}




module slot_cutouts()
{ // magic constant in the rotate...
  translate([0,0,-dist_to_floor+snap_thickness+snap_thickness_overage/2+snap_height_offset])
  rotate(some_unknown_rotation,[0,0,1])
  translate([0,0,-.20*z_scale])
 linear_extrude(height=.2*z_scale)
  projection()

  cover_snaps(width=snap_width+snap_width_overage, length=snap_length+snap_length_overage, thickness=snap_thickness); // no need to overage the thickness since projecting in that direction
  
  
  translate([0,0,-snap_thickness_overage/2+snap_height_offset])
   {
    cover_snaps(width=snap_width+snap_width_overage, length=snap_length+snap_length_overage, thickness=snap_thickness+snap_thickness_overage);
     rotate(-20,[0,0,1])
   cover_snaps(width=snap_width+snap_width_overage, length=snap_length+snap_length_overage, thickness=snap_thickness+snap_thickness_overage);
   }
}