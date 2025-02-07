// Pi Zero Cam Holder
// The "Officiële Raspberry Pi Zero Behuizing"
// - os rounded, so thickness varies 

include <MCAD/boxes.scad>

// box below refers to the housing 
// therefore it is NOT the case we build around it
// box thickness starts at 13 and is raised towards the middle
// rubbers add an additional 1.6mm
// also allow for some spacing (0.4)
rubber_th=1.6;
box_th_bare=14.6;
box_th_incl_rubber=box_th_bare+rubber_th;
box_th=box_th_incl_rubber+0.4;
box_h=79;
box_w=37.7;
box_r=2;

// camera sticks out from the cover approx 4mm
cam_lens_l_normal=3.6; // measured from top of the box cover
cam_lens_l_wide=4.5;   // this one is bigger
cam_lens_l=max(cam_lens_l_normal,cam_lens_l_wide);

// cam hole diameter including spacing
cam_lens_d=8.5; // the box comes with this hole  

// the housing is the metal box holding the lens
cam_hous_w=11.0;
cam_hous_w2=cam_hous_w/2;
cam_hous_th=0.7; // as measured from the top of the box cover

// work with theme material thickness
m=0.4*4; m2=m*2;

$fn=50;

debug=0;
cord=0;
  
//create room for the camera lens to fit inside of the box
lens_rm=4.8; half_rm=lens_rm/2;

module cord_holder() {
    cord_d=3.5;
    translate([
            cord_d/2+max(m,box_r),
            -cord_d/2,
            cord_d/2+m])
    difference() {
        translate([-cord_d/2-m,-cord_d/2-m,-cord_d/2-m])
            union() {
                cube([cord_d+m2, cord_d+m2, cord_d+m2]);
                cube([cord_d+m2, cord_d+m+max(m,box_r), m]);
            }
        rotate([0,90,0]) 
            translate([0,0,-cord_d/2-m-0.01])
            union() {
                cylinder(d=cord_d,h=cord_d+m2+0.02);
                hull() {
                    cylinder(d=cord_d-0.4,h=cord_d+m2+0.02);
                    translate([-3.5,0,0])
                        cylinder(d=cord_d-0.4,h=cord_d+m2+0.02);
                }
            }
    }
}
if (cord) {
  translate([-box_w/2,-box_th/2-m,-box_h/2-m]) cord_holder();
  translate([box_w/2-3.5-box_r-box_r,-box_th/2-m,-box_h/2-m]) cord_holder();
}

module draw_cam_module() {
    union() {
        // lens
        color("black",1.0) cylinder(d=8, h=cam_lens_l);
        translate([-cam_hous_w/2,-cam_hous_w/2])
        color("#c0c0c0",1.0) cube([cam_hous_w,cam_hous_w,cam_hous_th]);
    }
}
module draw_pi_housing() {
    hull() {
        translate([
                -box_w/2,
                -box_th_incl_rubber/2,
                -box_h/2])
            cube([box_w/2,13+rubber_th,box_h]);
        translate([
                -box_w/2,
                -box_th/2,
                -cam_hous_w/2])
            cube([box_w/2,box_th_incl_rubber,cam_hous_w]);
    }
}

if (debug) {
    color("red", 0.5) draw_pi_housing();

    // check to see if camera looks ok
    translate([
            0,
            -box_th/2 +           // from backside
            box_th_incl_rubber,   // on rubbers
            0]) 
        rotate([-90,0,0])
        draw_cam_module();
}

// the basic box
difference() {
    translate([0,half_rm,0])
        roundedBox(
                size=[box_w+m2, box_th+m2+lens_rm, box_h+m2],
                radius=box_r,
                sidesonly=false);
    
    // make it a box instead of a block 
    translate([0,half_rm,0])
        cube(
            [box_w, box_th+lens_rm, box_h],
            center=true);
    
    // remove top of the box
    translate([
            -box_w/2-m,
            -box_th/2-m,
            (box_h+m2)/2-max(box_r,m)-0.01])
        cube([
                box_w+m2+0.1,
                box_th+lens_rm+m2+0.01, 
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
    
    // help push the camera out of the box (hole in the bottom)
    roundedBox([16,11,box_h+m2+0.01+box_r*2],radius=box_r,sidesonly=false);            
        
    // the camera needs to look outside of the box
    hull() {
        translate([0,box_th/2+lens_rm-0.01,0]) 
            rotate([-90,0,0])
            cylinder(d=cam_lens_d, h=0.01);
        translate([0,box_th/2+lens_rm+m+0.01,0]) 
            rotate([-90,0,0])
            cylinder(d=cam_lens_d+3, h=20.01);
    }
    hull() {
      translate([0,box_th/2,0])
        cube([cam_lens_d,cam_lens_l+0.4,cam_lens_d],center=true);
      translate([0,box_th/2,box_h/2])
        cube([cam_lens_d,cam_lens_l+0.4,cam_lens_d],center=true);
    }
    
    // create hole for power connector
    // when box is upright pwr is on the right side
    pwr_c_wi=10.8;
    pwr_c_th=6.7;
    pwr_c_le=20;
    pwr_c_sp=0.8; pwr_c_sp2=pwr_c_sp*2;
    
    translate([
        box_w/2-0.1,
        -box_th/2+rubber_th+3.8-2-pwr_c_sp,
        -box_h/2+12.8-pwr_c_sp])
      cube([m+0.2,pwr_c_th+pwr_c_sp2,pwr_c_wi+pwr_c_sp2]);
}

// push back bars for the back side of the pi box
translate([
        -7,
        -box_th/2,
        -box_h/2])
    cube([
            m,
            rubber_th,
            box_h]);
translate([
        7-m,
        -box_th/2,
        -box_h/2])
    cube([
            m,
            rubber_th,
            box_h]);

// push back bars for the front side of the pi box
translate([
        -cam_hous_w/2-m-0.6,
        box_th/2,
        -box_h/2])
    cube([
            m,
            lens_rm+0.1,
            box_h]);
translate([
        cam_hous_w/2+0.6,
        box_th/2,
        -box_h/2])
    cube([
            m,
            lens_rm+0.1,
            box_h]);

// push back bars for the front side edge of the pi box
translate([
        -cam_hous_w/2-m-0.6,
        box_th/2-2,
        -box_h/2])
    hull() {
        cube([
            m,
            2+lens_rm,
            1]);
        translate([0,2,24])
            cube([
                m,
                lens_rm,
                2]);
    }
translate([
        cam_hous_w/2+0.6,
        box_th/2-2,
        -box_h/2])
    hull() {
        cube([
            m,
            2+lens_rm,
            1]);
        translate([0,2,24])
            cube([
                m,
                lens_rm,
                2]);
    }

// sample power plug    
if (debug) {
    translate([
            box_w/2,
            -box_th/2-m+3.6+1.6,
            -box_h/2-m+14.4])
        color("white") { 
            cube([21+m,6.5,11]);
            translate([0,3.25,5.5])
                rotate([0,90,0])
                cylinder(d=6,h=30+m);
    }
}
    
// beugeltje
translate([box_w/2,box_th/2+lens_rm,-box_h/2-m]) {
    translate([m-box_r-0.1,0,0])
        cube([50+box_r+0.1,m,14+11+10]);
    translate([0,m-box_r-0.1,0])
        cube([m,box_r+0.1,14+11+10]);
    translate([0,-box_th]) {
        hull() {
            cube([10+m,box_th,m]);
            translate([40+box_r,box_th-2,0])
                cube([m,m+2,m]);
        }
        cube([m,box_th,max(m,box_r)+0.1]);
        translate([m-box_r-0.1,0,0])
            cube([box_r+0.1,box_th,m]);
            
    }
}
    
