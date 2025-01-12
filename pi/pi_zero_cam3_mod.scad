// Boormal Pi Zero Cam3 casing mod

base_x=23.8;
base_y=25.0;
thick=1;

mount_dist_x=12.5;
mount_dist_y=21.0;
mount_d=2.2;
mount_off_x=1+mount_d/2;
mount_off_y=(base_y-mount_dist_y)/2;

cam_off_x=mount_off_x+mount_dist_x;
cam_off_y=base_y/2;
cam_lens_d=8.5;      // cam hole diameter including spacing
cam_hous_w=11.0;
cam_hous_w2=cam_hous_w/2;


$fn=50;

difference() {
    cube([base_x, base_y, thick]);

    translate([mount_off_x,mount_off_y,-0.01])
      cylinder(h=thick+0.02, d=mount_d);
    translate([mount_off_x+mount_dist_x,mount_off_y,-0.01])
      cylinder(h=thick+0.02, d=mount_d);

    translate([mount_off_x,mount_off_y+mount_dist_y,-0.01])
      cylinder(h=thick+0.02, d=mount_d);
    translate([mount_off_x+mount_dist_x,mount_off_y+mount_dist_y,-0.01])
      cylinder(h=thick+0.02, d=mount_d);
    
    translate([cam_off_x,cam_off_y,-0.01])
      cylinder(h=thick+0.02, d=cam_lens_d);

    translate([cam_off_x-cam_hous_w2,cam_off_y-cam_hous_w2,-0.01])
      cylinder(h=thick+0.02, d=1.2);
    translate([cam_off_x+cam_hous_w2,cam_off_y-cam_hous_w2,-0.01])
      cylinder(h=thick+0.02, d=1.2);
    translate([cam_off_x-cam_hous_w2,cam_off_y+cam_hous_w2,-0.01])
      cylinder(h=thick+0.02, d=1.2);
    translate([cam_off_x+cam_hous_w2,cam_off_y+cam_hous_w2,-0.01])
      cylinder(h=thick+0.02, d=1.2);
    
}