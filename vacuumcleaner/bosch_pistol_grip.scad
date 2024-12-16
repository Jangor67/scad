// Model to help drilling and cutting an existing pistol grip

out_d  = 50.5+0.3; out_r = out_d/2;
sml_d  = 3.2;
sml_l  = 5;
sml_lo = 360 * sml_l / 2 / (PI * out_d);

// Some material definitions
// defaults in prusa slicer 0.15 height (0.2 first layer)
layer_1=0.2;
layer_n=0.15; l2=layer_n*2;
base_h=layer_1+layer_n*8 + 2; // 1.4 + 2
p=0.8; 2p=p*2; 4p=2*2p;

$fn=20;

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

module drill(
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
    cylinder(h=base_h+16,d=out_d+4p,$fn=60);
    translate([0,0,base_h])
        cylinder(h=base_h+16,d=out_d,$fn=60);
    translate([0,0,-0.01])
        cylinder(h=base_h+16,d=out_d-4p,$fn=60);
    
    drill(  0, base_h+8, isHull=true);
    *drill(60, base_h+8);
    drill( 90, base_h+8, isHull=true);
    drill(180, base_h+8);
    drill(270, base_h+8);
    
    drill_single(45+000,base_h);
    drill_single(45+090,base_h);
    drill_single(45+180,base_h);
    drill_single(45+270,base_h);
}

