// holder for the temperature sensor

include <MCAD/boxes.scad>

box_w  = 43+0.2;
box_h  = 43+0.2;
box_th = 12.5+0.2;
box_r  = 6.25;
border = 7.5;



// work with theme material thickness
m=0.4*4; m2=m*2;

$fn=25;

module front_side(
    n = m,
    b = 0,
    r= box_r
) {
    box_w2 = box_w/2;
    box_h2 = box_h/2;
    // top right
    p1x=box_w2;
    p1y=0;
    // corner 1
    p2x=box_w2;
    p2y=-box_h2;
    // corner 2
    p3x=-box_w2;
    p3y=-box_h2;
    // top left
    p4x=-box_w2;
    p4y=0;
    
    step = 3;
    r2=r/2;
    r3=r/3;

    points_front = concat(
    // top right outside
    [[p1x+n,p1y]],
    // bottom right corner
    [ for(i=[0:step:90]) [
        p2x+n-r+cos(i)*r,
        p2y-n+r-sin(i)*r]],
    // bottom left corner
    [ for(i=[0:step:90]) [
        p3x-n+r-sin(i)*r,
        p3y-n+r-cos(i)*r]],
    // top left outside - inside
    [[p4x-n,p4y]],
    [ for (i=[0:step:90]) [
        p4x+b-min(b,r2-sin(i)*r2),
        p4y-r2+cos(i)*r2]],
    // bottom left corner
    [ for(i=[90:-step:0]) [
        p3x+b+r3-sin(i)*r3,
        p3y+b+r3-cos(i)*r3]],
    // bottom right corner
    [ for(i=[90:-step:0]) [
        p2x-b-r3+cos(i)*r3,
        p2y+b+r3-sin(i)*r3]],
    // top right
    [ for (i=[90:-step:0]) [
        p1x-max(0,b-r2+sin(i)*r2),
        p1y-r2+cos(i)*r2]]
    );
    polygon(points_front);
}



difference() {
    union() {
        // corners are rounded but not the front
        rotate([90,0,0]) {
          height = box_th;
          linear_extrude(height+0.01) front_side(m,0);
          translate([0,0,height])
            linear_extrude(m) front_side(m,border);
          translate([0,0,-m])
            linear_extrude(m) front_side(m,15);
        }
        translate([-box_w/3,0,-box_h/3])
            cube([box_w/3*2,m,box_h/3*2]);
    }
    // hole in the bottom
    translate([-box_w/3,-box_th,-box_h/2-m-0.1])
        cube([box_w/3*2,box_th,box_h+m+0.2]);
}


