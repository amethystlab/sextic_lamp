
$fn = 40;

sextic_piece_filename = "prepped_for_lamp.stl";
connection_piece_filename = sextic_piece_filename;
make_hollow = true;

z_scale = 60; // the overall height of the object, top to bottom.
wall_thickness = 3;// only ever approximate, no promises, k?
wall_thickness_hook_part = 2;// only ever approximate, no promises, k?


interior_z_offset = 1.5; // adjust the interior smaller blob.  can help with bottom thickness problems.

connection_cyl_dia = 9;
connection_wall_thickness = 2;
connection_length = 5;

connection_overlap = 2.1; // how much the connection extends into the body.  this is because the points are there...

wire_hole_dia = 4;

connection_play = 0.45; // a gap between the plug and the socket



plug_tab_depth = 4; // also how long the tab wedge is.  this distance produces overage on how long the plug cylinder is, how long it extends beyond the socket.  
plug_tab_cutout_depth = 11; // includes the plug_tab_depth
plug_tab_cutout_thickness = 0; // the amount of material missing. the gap between the tab and the cylinder remnants
plug_tab_thickness = 1.3;

plug_wedge_h =3.1; // how much the tab protrudes above the cylinder is the difference between this number and plug_tab_thickness.  this number must exceed plug_tab_thickness for the tab to be visible.
plug_wedge_w = 2; // how wide the tab is.

plug_taper = .7;

plug_length_overage = 2.7; // a manual adjustment for making the plug long enough to snap in... this really should be automatically computed..






mount_t = 6;
mount_platform_dia = 22.5; //  spec says 22.95 for a neopixel jewel 7-led board
mount_base_dia = 27;
mount_platform_thickness = 1.6;
mount_platform_dia_inner = 15;

mount_screwhole_dia = 1.9;

mount_wire_cutout_vertical_ratio = 2/3;
wire_radial_cutout = 1.;
wire_cutout_width = 14;

cover_horizontal_offset = 0.8;
cover_vertical_offset = 0.4; // the additional gap between the cover and its mating surface on the body.
cover_aspect_ratio = 1;
coin_slot_depth = 3; // mm depth of how far the coin slot cuts into the cover

snap_length = 3.5;
snap_width = 6;
snap_thickness = 1.6;

snap_thickness_overage = 2; // an additional distance to cut out vertically for the snapping tabs which lock the cap to the body. 
snap_width_overage = 1;
snap_length_overage = 1;

snap_housing_wall_thickness = 3;
snap_housing_ceiling_thickness = 2;
snap_height_offset = 1.8; // adjust the vertical placement of the tab

hang_hook_dia = 20;
hang_hook_thickness = 12;
hang_hook_wall_thickness = 2;
hang_hook_height = .83*z_scale;

hang_hook_piece_num_plugs = 2;


electonics_parts_toggle = false;

