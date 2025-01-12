// Pi Zero Cam Holder
// The "Officiële Raspberry Pi Zero Behuizing"
// - os rounded, so thickness varies 

include <MCAD/boxes.scad>

box_th=15;    // starting at 13, 
              // biggest thickness in the middle (at the cam)
box_h=79;
box_w=37.7;
box_r=2;

// when box is upright pwr is on the right side
pwr_hs=12.5-0.4; // height start  
pwr_he=24+0.4;   // height end
pwr_cy=6.7;      // center pos
pwr_d=6.7+0.8; // including some clearing

cam_th=4;     // camera sticks out from the cover approx 4mm
cam_lens_d=8.5;      // cam hole diameter including spacing
cam_hous_w=11.0;
cam_hous_w2=cam_hous_w/2;


m=0.4*4; m2=m*2;

$fn=30;
  
// the basic box
difference() {
    union() {
      roundedBox(
        size=[box_w+m2, box_th+m2, box_h],
        radius=box_r,
        sidesonly=false);
      translate([
            -(cam_hous_w+2+m2)/2,
            box_th/2+m-0.01,
            cam_hous_w/2])
        cube([cam_hous_w+2+m2,m,box_h/2-box_r-m2]);
    }
    
    // make it a box instead of a block 
    // leaving a notch since the bottom part is 2mm less thick
    translate([0,0,m+4])
        cube(
            [box_w, box_th, box_h],
            center=true);
    // cut out a bit deeper (leaving 2 notches)
    translate([0,0,m])
        cube(
            [box_w, box_th-4, box_h],
            center=true);
    // remove back notch
    translate([0,-1,m])
        cube(
            [box_w, box_th-2, box_h],
            center=true);
    // peek into the box 
    *translate([4,-4,m])
        cube(
            [box_w, box_th-4, box_h],
            center=true);
            
    // remove top of the box
    translate([0,0,box_h/2-box_r+m])
        cube([box_w+m2+0.1,box_th+m2+m2+0.1, box_r+m+2], center=true);
        
    // create room for the bulky camera housing
    // we need a slot to slide it into its housing
    hull() {
      translate([0,box_th/2,0])
        cube([cam_hous_w+2,m2+0.01,cam_hous_w+2],center=true);
      translate([0,box_th/2,box_h/2])
        cube([cam_hous_w+2,m2+0.01,cam_hous_w+2],center=true);
    }
    // carve another slot because the camera sticks out even further
    hull() {
      translate([0,box_th/2,0])
        cube([cam_lens_d,m*4+0.01,cam_lens_d],center=true);
      translate([0,box_th/2,box_h/2])
        cube([cam_lens_d,m*4+0.01,cam_lens_d],center=true);
    }
    
    // create hole for power connector
    pwr_c_wi=10.8;
    pwr_c_th=6.7;
    pwr_c_le=20;
    pwr_c_sp=0.4; pwr_c_sp2=pwr_c_sp*2;
    
    translate([box_w/2-0.1,-box_th/2+3.4-pwr_c_sp,-box_h/2+12.4-pwr_c_sp])
      cube([m+0.2,pwr_c_th+pwr_c_sp2,pwr_c_wi+pwr_c_sp2]);
}

// serving 2 purposes
// - protect the camera which sticks out at the front and 
// - double-sided-tape-mount-pieces
module front_stickout(
  closed  = 1,
  width   = cam_hous_w
) {
  difference() {
    cam_th2=cam_th*2;
    roundedBox(
        size=[width+m2,box_th+m2+cam_th2,cam_hous_w+m2], 
        radius=2,
        sidesonly=false);
    if (closed == 0) {
      roundedBox(
        size=[width,box_th+m2+cam_th2,cam_hous_w], 
        radius=2,
        sidesonly=false);
      translate([0,0,cam_hous_w/2])
        cube([cam_lens_d,box_th+m2+cam_th2,cam_lens_d],center=true);
    }
    cube([box_w,box_th+m2-0.01,box_h],center=true);
    translate([0,-box_th,0])
        cube([box_w,box_th+0.1,box_h],center=true);
    translate([0,(box_th+m2+cam_th2)/2,0])
        cube([cam_hous_w+m2+0.1, 4, cam_hous_w+m2+0.1],center=true);
  }
}


off_x=box_w/2-cam_hous_w/2-m2;
off_y=box_h/2-cam_hous_w/2-m2-2;

front_stickout(closed=0);
translate([off_x,0,-off_y])
    front_stickout(closed=1);
translate([-off_x,0,-off_y])
    front_stickout(closed=1);
translate([off_x+cam_hous_w/4,0,off_y])
    front_stickout(closed=1, width=cam_hous_w/2);
translate([-off_x-cam_hous_w/4,0,off_y])
    front_stickout(closed=1, width=cam_hous_w/2);
