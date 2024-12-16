// Model to help drilling and cutting an existing pistol grip

out_d  = 50.5+0.3; out_r = out_d/2; // should fit around grip
sml_d  = 3.2;                       // size of the holes
sml_l  = 5;                         // distance between holes

// Some material definitions
// defaults in prusa slicer 0.15 height (0.2 first layer)
layer_1=0.2;
layer_n=0.15; l2=layer_n*2;
base_h=layer_1+layer_n*8 + 2; // 1.4 + 2
p=0.8; 2p=p*2; 4p=2*2p;

$fn=20;

// Some calculations
// calculate the half of the length offset in degrees
sml_lo = (360 / PI / out_d) * (sml_l / 2); 

// can be used to "drill" a single hole in the tube 
// at a particlar angle and height
module drill_single(
    d = 0,
    h = base_h
) {
    x = out_r * cos(d);
    y = out_r * sin(d);
    translate([x,y, h])
        rotate([90,0,90+d])
        translate([0,0,-4p])
        cylinder(h=3*4p,d=sml_d);
}

// can be used to "drill" two hole in the tube 
// at a particlar angle and height, it can
// also be used to clear the material between the
// holes
module drill_double(
    d = 0,        // degrees
    h = base_h, // height
    isHull = false
) {
    if (isHull) {
        hull() {
            drill_single(d+sml_lo,h);
            drill_single(d-sml_lo,h);
        }
    } else {
        drill_single(d+sml_lo,h);
        drill_single(d-sml_lo,h);
    }
}



difference() {
    // base cylinder
    cylinder(h=base_h+16,d=out_d+4p,$fn=120);
    // make a tube next
    translate([0,0,base_h])
        cylinder(h=base_h+16,d=out_d,$fn=120);
    // remove extra surplus material
    translate([0,0,-0.01])
        cylinder(h=base_h+16,d=out_d-4p,$fn=120);
    
    // now we start the "drilling"
    drill_double(  0, base_h+8, isHull=true);
    *drill_double(60, base_h+8);
    drill_double( 90, base_h+8, isHull=true);
    drill_double(180, base_h+8);
    drill_double(270, base_h+8);
    
    drill_single(45+000,base_h);
    drill_single(45+090,base_h);
    drill_single(45+180,base_h);
    drill_single(45+270,base_h);
}

