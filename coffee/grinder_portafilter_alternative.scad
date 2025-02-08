// Grinder porta filter holder replacement
// Original porta filter is not compatible with Quickmill
// I also use a small glass jar instead

// Work in progress...


width=34;   width2=width/2;
depth=15.5; depth2=depth/2; // or thick :-)
height=29;  height2=height/2;

smooth_r=3; smooth_r2=smooth_r/2;

pin_d=3.5;
pin_offset=1.9+pin_d/2;

hole_d=5;
hole_d2=12.5;
hole_h=6;

ring_d1=45;         ring_r1=ring_d1/2;
ring_d2=ring_d1+12;
ring_offset=68.5+ring_r1;
ring_h1=4.5;
ring_h2=ring_h1*2;

exit_o1=76;
exit_o2=107;
exit_oc=(exit_o1+exit_o2)/2;

$fn=120;

include <MCAD/boxes.scad>

translate([0,-depth2+smooth_r2,0]) difference() {
    roundedBox(size=[width,depth+smooth_r,height],radius=smooth_r,sidesonly=false);
    // side facing the wall should not be rounded
    translate([-width2,depth2-smooth_r2,-height2])
        cube(size=[width,smooth_r+0.01,height]);
    // cut the hole for screw
    translate([0,-depth2-smooth_r-0.1,0])
        rotate([-90,0,0]) {
            cylinder(h=depth+smooth_r+0.2,d=hole_d);
            //cylinder(h=hole_h,d=hole_d2);
        }
}
// extra pin to prevent rotation
translate([-width2+pin_offset,0,height2-pin_offset])
    rotate([-90,0,0]) {
        cylinder(h=3.3,d=pin_d);
    }

module portaholder() {    
    translate([0,-ring_offset,height2-ring_h2]) {
        translate([0,0,ring_h1]) difference() {
            cylinder(h=ring_h1,d=ring_d2);
            translate([0,0,-0.1])
                cylinder(h=ring_h1+0.2,d=ring_d1);
        }
        difference() {
            cylinder(h=ring_h2,d=ring_d2);
            translate([0,0,-0.1])
                cylinder(h=ring_h2+0.2,d=ring_d2-ring_h1);
        }
    }
}
*portaholder();

translate([0,-exit_oc,0])
        cylinder(h=1,r=1);
