// PT100 A doorvoer hottub
// afdichtringen 3mm binnen_diameter 1mm dik
adr_bd=3;
adr_th=1;
adr_r=(adr_bd+adr_th)/2;

pvc_d=34.4;      // doorvoer diameter
pvc_r=pvc_d/2;

pvc_nd=4;        // 4 pukkeltjes van 4mm
pvc_nr=pvc_nd/2;

ptx_d=4;    // pt100 diameter 4mm
ptx_r=ptx_d/2;
ptx_l=30;   // length probe 30mm

total_l=ptx_l+10;

$fa=1;    // minimum angle for a fragment
$fs=0.15; // minimum size for a fragment

module conische_sparing() {
    hull() {
        translate([0,0,total_l])
            linear_extrude(0.1)
            circle(d=pvc_d-1.4);
        translate([0,0,10])
            sphere(d=ptx_d);
    }
}

module ring() {
    for (i=[90:1:270]) {
        x = adr_r * cos(i);
        y = adr_r * sin(i);
        translate([x,y,0])
            sphere(d=adr_th);
    }
}

module pins_outward() {
    translate([-2.6,pvc_r-5,7.5])
        rotate([0,90,0])
        cylinder(h=5,d=5);
    translate([-2.6,pvc_r-5,total_l-17.5])
        rotate([0,90,0])
        cylinder(h=5,d=5);
}
module pins_inward() {
    translate([-2.6,-pvc_r+5,7.5])
        rotate([0,90,0])
        cylinder(h=5,d=5);
    translate([-2.6,-pvc_r+5,total_l-17.5])
        rotate([0,90,0])
        cylinder(h=5,d=5.1);
}

pins_outward();

module doorvoer() {
    difference() {
        cylinder(h = total_l, r=pvc_r-0.1, center=false);
        // doorvoer
        translate([0,0,-0.1])
            cylinder(h = 10.3, r=ptx_r, center=false);
        translate([0,0,3.5])
            ring();
        translate([0,0,7.5])
            ring();
        // allow for contact with water
        conische_sparing();
        // 4 pukkeltjes (in de PVC doorvoer)
        for (i=[45:90:360]) {
            x = pvc_r * sin(i);
            y = pvc_r * cos(i);
            translate([-x,y,-0.1])
                cylinder(h=total_l+0.2,r=pvc_nr,center=false);
        }
        // mounting pins
        pins_inward();
        // print in 2 parts so cut off half
        translate([0,-pvc_d/2,-0.1])
            linear_extrude(total_l+0.2)
            square(pvc_d); 
    }
}


doorvoer();