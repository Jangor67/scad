// Pi 4 Holder
// "Aluminium Housing"

// This version can and should be made a bit more sturdy.
// One of the frame parts broke when i was clearing the supports 
// from the printed model...

include <MCAD/boxes.scad>

// box below refers to the housing 
// therefore it is NOT the case we build around it
// also allow for some spacing (0.4)
box_th_bare=32;
box_th=box_th_bare+0.4;
box_h=61+0.4;
box_w=96+0.4;
box_r=2;
frame_w=8;

// work with theme material thickness
m=0.4*4; m2=m*2;

$fn=50;

debug=0;

module mount() {
    s=11; s2=s/2;
    difference() {
        union() {
            cylinder(h=m,d=s);
            translate([-s2,0,0])
                cube([11,11,m]);
        }
        translate([0,0,-0.01])
        cylinder(h=m+0.02,d=3.9);
    }
}
translate([-box_w/2-11+m,+box_th/2+m,+box_h/2-11]) rotate([90,90,0]) mount();
translate([-box_w/2-11+m,+box_th/2+m,-box_h/2+11]) rotate([90,90,0]) mount();
translate([+box_w/2+11-m,+box_th/2  ,+box_h/2-11]) rotate([-90,90,0]) mount();
translate([+box_w/2+11-m,+box_th/2  ,-box_h/2+11]) rotate([-90,90,0]) mount();
  
// the basic box
difference() {
    roundedBox(
            size=[box_w+m2, box_th+m2, box_h+m2],
            radius=box_r,
            sidesonly=false);
    
    // make it a box instead of a block 
    cube(
        [box_w, box_th, box_h],
        center=true);
    // have windows on all sides
    cube([box_w+m2+0.1,  box_th-frame_w, box_h-frame_w], center=true);
    cube([box_w-frame_w, box_th+m2+0.1,  box_h-frame_w], center=true);
    cube([box_w-frame_w, box_th-frame_w, box_h+m2+0.1],  center=true);
    
    // remove top of the box
    translate([
            -box_w/2-m,
            -box_th/2-m,
            (box_h+m2)/2-max(box_r,m)-0.01])
        cube([
                box_w+m2+0.1,
                box_th+m2+0.01, 
                max(box_r,m)+0.02]);

    // peek into the box 
    if (debug) {
        translate([-4,-4,0])
            cube(
                [box_w, box_th-4, box_h+m2+0.01],
                center=true);
        translate([box_w/2,+10,0])
            cube(
                [box_w, box_th-4, box_h+m2+0.01],
                center=true);
    }
    
}
    
