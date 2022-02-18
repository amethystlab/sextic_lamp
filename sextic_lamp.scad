// This work is licensed under the 
// Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
// To view a copy of this license, 
// visit http://creativecommons.org/licenses/by-nc-sa/4.0/ 
// or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.


// This code has the following known issues: (not exhaustive at all, ha.  good luck.)
//
// • scaling causes the quarter cutout not to be placed correctly.  but it's close-ish

include <parameters_no_electronics_tpu_small.scad>;
//include <parameters_electronics_tpu.scad>;
//include <parameters_electronics_pla.scad>;
//include <parameters_no_snaps_small.scad>;
//include <parameters_wireframe.scad>;
//
eps = 0.01; // a very small number.  improves differences with coplanar faces


// viewing and testing parameters

cut_with = "nothing"; // options are "cube", "sphere". anything else will result in no cutting

cutting_sphere_center = z_scale*[.30,.55,.42];
cutting_sphere_r = z_scale*.50;


////////////////////////////////

//non-user-set parameters

pi = acos(-1);
angle_dihedral = acos(-sqrt(5)/3)*180/pi;

inner_blob_scale = (z_scale-2*wall_thickness)/z_scale; // the scale of the inner blob, duh
inner_blob_scale_hook = (z_scale-2*wall_thickness_hook_part)/z_scale;

plug_and_socket_translation = connection_overlap-connection_length;

// these could probably be improved.  the two-digit numbers i provided are almost certainly wrong; they were eyeballed.  
dist_to_points = 0.41*z_scale; // the distance from the origin to the points of the triangle, in the projection
dist_to_floor = 0.04*z_scale; // distance to the interior floor of the object
dist_to_bottom = 0.11*z_scale; // distance to the interior floor of the object

////////////////////////////////////////////////////

//difference(){
//  union(){
//	translate([50,0,0])
//rotate(90,[1,0,0])
//cover();
//hook_piece_placed();
//

//
//intersection()
//{
//hook_piece(hang_hook_piece_num_plugs);
//hook_piece_placed();
//
//piece(1);
//cylinder(r=20,h=20,center=true);
//}
//}
//translate([-50,0,-50])
//cube([100,100,100]);
//}

//difference(){
//  union(){
//	translate([50,0,0])
//rotate(90,[1,0,0])
//cover();
//hook_piece_placed();
//
pieces_placed([0,3]);

//intersection()
//{
//piece(3);
//cylinder(r=20,h=20,center=true);
//}
//}
//translate([-50,0,-50])
//cube([100,100,100]);
//}

//rotate(90,[1,0,0])
//cover();
//piece_cut(0);
//pieces_assembled();
//

//piece_A_cut();




module hook_piece_placed()
{
  
  t = .8;
  difference(){
  hook_piece(hang_hook_piece_num_plugs);
	
	cutting_object();
  }
  
  if (electonics_parts_toggle)
	translate([0,-t*z_scale,0])
	cover();
}


module pieces_placed(nums)
{
t = .8;
for (ii=[0:len(nums)-1]){
    translate([ii*t*z_scale,0,0]){
      piece_cut(nums[ii]);
    }
    }
}




module cutting_object()
{
  if (cut_with=="cube")
	cutting_cube	();
  else if(cut_with=="sphere")
	cutting_sphere();

}


module cutting_cube()
{
  translate([0,0,0-100])
  cube([200,200,200]);
}
module cutting_sphere()
{
  	translate(cutting_sphere_center)
	sphere(r=cutting_sphere_r);
}



module piece_cut(num_plugs)
{
	difference()
  {

  piece(num_plugs);
  cutting_object();
  }
  
//  if (electonics_parts_toggle)
//  {
//	translate([0,.50*z_scale,0])
//	rotate(90,[1,0,0])
//	  cover();
//  }
}



module pieces_assembled()
{
  difference()
  { 
	union()
	{
  piece(1);
	  if (electonics_parts_toggle)
  {cover();}


  translate([.61*z_scale,0,-.235*z_scale])
  {

	rotate((180-angle_dihedral),[0,1,0])
  rotate(180,[0,0,1])
	
	rotate(-240,[0,0,1])
	{
  piece(2);
	  if (electonics_parts_toggle)
  {
	  cover();}
	}

  }

	}
	cube([200,200,200]);
  }


}




module hook_piece(num_plugs=2)
{
  difference()
  {
	main_blob(num_plugs, inner_scale = inner_blob_scale_hook);
	 
	hook_neg();

  }
  
  hook_pos();
}




module piece(num_plugs)
{
  main_blob(num_plugs=num_plugs, inner_scale = inner_blob_scale);
}



module main_blob(num_plugs, inner_scale)
{
  
  
  main_blob_pos(num_plugs, inner_scale);
  
  if (num_plugs>0)
    for (ii=[0:num_plugs-1])
	{
	  rotate(ii*120,[0,0,1])
	  plug_pos();
	  
	}
  
	if (num_plugs<3)
   for (ii=[num_plugs:2])
   {
	socket_pos(ii*120);
   }
   

}





module main_blob_pos(num_plugs, inner_scale)
{
  difference()
  {
	union()
	{
        if (make_hollow){
            sextic_blob_hollow(s=inner_scale,filename=sextic_piece_filename);
        }
        else{
            sextic_blob_solid(sextic_piece_filename);
        }
	if (electonics_parts_toggle)
	 {
	   cover_interior_parts();
	 }
	} // union
	
	// negative below here
	if (electonics_parts_toggle)
	{
	  if (num_plugs>0)
	  for (ii=[0:num_plugs-1])
	  rotate(ii*120,[0,0,1])
		plug_neg();
	}
  
	if (num_plugs<3)
   for (ii=[num_plugs:2])
	rotate(ii*120,[0,0,1])
	  socket_neg();
   
   if (electonics_parts_toggle)
   {
	 translate([0,0,cover_vertical_offset])
	 cover_cone(inset=cover_horizontal_offset);
	 
	 	slot_cutouts();
	

	 
	 translate([0,0,-mount_wire_cutout_vertical_ratio*mount_t])
	  intersection()
	 {
	   cylinder(r=mount_platform_dia/2+cover_horizontal_offset+wire_radial_cutout, h = mount_wire_cutout_vertical_ratio*mount_t + eps);
	   mount_wire_cutting_object();
	 } // intersection
   } // if electronics
   
  } // difference
  
  


  

  
  
}


module cover_interior_parts()
{

  
    //beware, there are magic constants in here
  difference()
  {
	intersection()
	{
	  translate([0,0,-.20*z_scale])
	  cylinder(r=mount_platform_dia/2+snap_length+snap_length_overage+snap_housing_wall_thickness,h=.18*z_scale+snap_thickness_overage+snap_housing_ceiling_thickness);
	  sextic_blob_solid(sextic_piece_filename);
		
	} // isect
	
	// cut out from the middle the hole for the mount
	translate([0,0,-.13*z_scale])
	cylinder(r=mount_platform_dia/2+cover_horizontal_offset,h=.18*z_scale);
	
		 translate([0,0,-2])
	 mount_wire_cutting_object();
	
  } // diff
}









module sextic_blob_hollow(s, filename)
{
 
  difference()
  {
	sextic_blob_solid(filename);
	inner_blob(s, filename);
  }
}


module inner_blob(s, filename)
{	
	translate([0,0,interior_z_offset])
	  scale([s,s,s])
		sextic_blob_solid(filename);
}


module sextic_blob_solid(filename)
{
  resize([0,0,z_scale], auto=true)
//  import("lamp_one_piece.stl");
  
  rotate(90,[0,0,1])
  import(filename);
  
}









module socket_neg()
{
  translate([dist_to_points,0,0])
  
  rotate((90-angle_dihedral/2),[0,1,0])
  rotate(-90,[0,1,0])
  translate([0,0,-plug_and_socket_translation-100])
	cylinder(r=connection_cyl_dia/2-connection_wall_thickness, h=connection_length+100+eps);
}



module socket_pos(angle)
{
  s =0.995;
 intersection(){

scale([s,s,s])
sextic_blob_solid(connection_piece_filename);
	
rotate(angle,[0,0,1])
  translate([dist_to_points,0,0])
  rotate((90-angle_dihedral/2),[0,1,0])
  rotate(-90,[0,1,0])
  translate([0,0,-plug_and_socket_translation])
  
  difference(){
	cylinder(r=connection_cyl_dia/2, h=connection_length);
 translate([0,0,-eps])
	cylinder(r=connection_cyl_dia/2-connection_wall_thickness, h=connection_length+2*eps);
  } // diff
  
  
  } // isect
}










module plug_neg()
{
  
  cutting_r = wire_hole_dia/2;
  translate([dist_to_points,0,0])
  rotate((90-angle_dihedral/2),[0,1,0])
  rotate(-90,[0,1,0])
  translate([0,0,plug_and_socket_translation])
 
	
	translate([0,0,-eps])
	cylinder(r=cutting_r, h=connection_length+plug_tab_depth+plug_length_overage+2*eps);
}




module plug_pos()
{
  
  plug_r = connection_cyl_dia/2-connection_wall_thickness - connection_play;
	
  tapered_r = plug_r - plug_taper;

  translate([dist_to_points,0,0])
  rotate((90-angle_dihedral/2),[0,1,0])
  rotate(-90,[0,1,0])
  translate([0,0,plug_and_socket_translation-plug_length_overage]) 
  
union(){
  
  difference()
  {
	union()
	{
	  translate([0,0,plug_tab_depth])
	  cylinder(r=plug_r, h=connection_length+plug_length_overage);
	  cylinder(r2=plug_r, r1= plug_r-plug_taper, h=plug_tab_depth);
	}
	cutting_r = wire_hole_dia/2;
	
	if (electonics_parts_toggle)
	{
	if (cutting_r >= plug_r)
	  echo("check your dims, cutting radius", cutting_r, "larger than plug radius",plug_r);
	translate([0,0,-eps])
	cylinder(r=cutting_r, h=connection_length+plug_tab_depth+plug_length_overage+2*eps);
	}
	
	
	
	// the tab cutouts
	ell = plug_r-plug_tab_thickness - plug_tab_cutout_thickness/2;
	for (ii=[-1,1]) // do it to both sides!
	{
	  translate([0,ii*ell,plug_tab_cutout_depth/2])
		cube([plug_r*2,plug_tab_cutout_thickness,plug_tab_cutout_depth+eps],center=true);
	  
	
	  
	} // for
	
	
  } // diff
  
  for (ii=[-1,1]){
	
	
	
	translate([0,ii*( plug_r-plug_tab_thickness ),plug_tab_depth])
	rotate(ii*90,[0,0,1])

		wedge(l=plug_tab_depth,w=plug_wedge_w,h=plug_wedge_h);
	  
  }
  
  
} // union after translating into place
}





module wedge(l,w,h)
{
	
	rotate(-90,[1,0,0])
  translate([0,0,-w/2])
  linear_extrude(height=w)
  polygon(
	points = [ [0,0], [0,l], [h,0] ], 
	paths = [ [0,1,2,0]], 
	convexity = 1);
}















module cover()
{

	translate([0,0,-dist_to_floor])
	  mount();
  
	difference(){
	  
	// the positive part
	intersection(){
	  sextic_blob_solid(connection_piece_filename);
	  cover_cone(inset = cover_horizontal_offset);
	}
  
  // still negative
  translate([0,0,-dist_to_bottom+coin_slot_depth])
	  a_quarter();
  }
  
translate([0,0,snap_height_offset])
cover_snaps(width=snap_width, length=snap_length, thickness=snap_thickness);

}



module a_quarter()
{
  translate([0,0,-6.5])
  	rotate(90,[0,1,0])
  translate([0,0,-0.9]) // center the mofo
  cylinder(r=13,h=1.8); // the size of a quarter
}


// cover_snaps are defined in the mount file



module cover_cone(inset = 0)
{
  	q = 90;  
  
  top_r = mount_base_dia/2 + inset;
  bottom_r = mount_base_dia/2+cover_aspect_ratio*q + inset;
  

	translate([0,0,-dist_to_floor-q])
	 cylinder(r1=bottom_r,r2=top_r,h=q);
  
}




module torus(R,r,fn=$fn)
{

    rotate_extrude(angle = 360, convexity = 2, $fn=fn)
    {
        translate([R, 0, 0])
        circle(r=r);
    }
}


module hollow_torus(R,r, wall_thickness, fn=$fn)
{
  difference()
  {
	torus(R,r,fn);
	torus(R,r-wall_thickness,fn);
  }
}




module hook_neg()
{

  translate([0,0,hang_hook_height])
	rotate(90,[1,0,0])
  scale([1,1.5,1])
	  torus(R=hang_hook_dia/2,r=hang_hook_thickness/2-eps); // -eps since we-re cutting out with it
  
  

}


module hook_pos()
{
  
  difference()
  {
    translate([0,0,hang_hook_height])
  
	
	 scale([1,1,1.5])
	{
	  difference()
  {
  
	  rotate(90,[1,0,0])
  hollow_torus(R=hang_hook_dia/2,r=hang_hook_thickness/2,wall_thickness=hang_hook_wall_thickness, fn = 2*$fn);
	
	  q = hang_hook_dia/2;
	translate([0,0,q])
	cylinder(h=hang_hook_dia,r=hang_hook_thickness/2-hang_hook_wall_thickness);
	

	  
	}//diff
} //scale 


inner_blob(s=inner_blob_scale_hook, filename=connection_piece_filename);
}// outer diff

}