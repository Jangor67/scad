// bottom tray alternative

// two rails or paws stretch out
rail_ox1=81/2;            // spacing between paws is 80
rail_w1=35;
rail_w2=42;
rail_ox2=rail_ox1+rail_w1; // tray slides on these first 2
rail_ox3=rail_ox1+rail_w2; // outermost part of the leg
rail_oy1=4;                // base mounting plate stick out
rail_d=137.9;              
rail_oy2=rail_oy1+rail_d;  // paws stick out to the front
rail_oz1=7.8;              // outermost part drops 7.8mm

// following the original tray measurements
m=2.5;           //tray material thickness
tray_ox1=78.6/2; //center waste coffee collector
tray_ox2=80/2; // only notches
tray_ox3=tray_ox1+40.8;
tray_fcr  =45; // corner at the front
tray_bcr  =6;  // corner at the back

tray_oy1=29;
// tray does not slide all the way to the back
tray_oy2=32.8-tray_oy1;  // corresponds to rail_oy1 0.2mm spacing
tray_oy3=tray_oy1+143.8;
tray_oy4=tray_oy3+10.3;

// coffee exit (from the dispensor)
exit_oy1=76;
exit_oy2=107;
exit_oyc=(exit_oy1+exit_oy2)/2;
exit_oycc=exit_oyc-tray_oy2;    // compensate for tray allignment

module slider_notch(
    x     = rail_ox1,
    y     = -10,
    z     = rail_oz1,
    depth = 10,
    m     = m,
) {
    m2=m*2;
    difference() {
        translate([depth/2,depth/2,rail_oz1/2])
            scale([1,1,2])
            sphere(d=depth,$fn=120);
        translate([m,-0.01,-0.01])
            cube([x-m2, depth+0.02, z+0.02]);
        translate([0,0,z])
            cube([depth,depth,z]);
        translate([0,0,-z])
            cube([depth,depth,z]);
        
    }
}
module slider_notch2(
    x     = rail_ox1,
    y     = -10,
    z     = rail_oz1,
    depth = 10,
    m     = m,
) {
    translate([-x,y-depth,0])
        slider_notch(x=x,y=y,z=z,depth=depth,m=m);
    rotate([0,0,180])
        translate([-x,-y,0])
        slider_notch(x=x,y=y,z=z,depth=depth,m=m);
}

// start with base which will slide on to the rails
translate([0,-tray_oy2,0]) {
    slider_notch2(y=-rail_oy1-20);
    slider_notch2(y=30-rail_oy2);
    translate([-rail_ox1+m,-rail_d,0])
        cube([m,rail_d,rail_oz1]);
    translate([rail_ox1-2*m,-rail_d,0])
        cube([m,rail_d,rail_oz1]);
}

translate([0,-tray_oy2,+rail_oz1+m-0.01]) {
    r1   = m;
    step = 90/120;
    points_body = concat(
      // bottom inside
      [
        [ rail_ox2,   -m],
        [ rail_ox2,   -rail_oz1-m],
        [ rail_ox2+m, -rail_oz1-m]
      ],
      // corner
      [ for(i=[0:step:90]) [
          rail_ox2+m-r1+cos(i)*r1,
          -r1+sin(i)*r1]
      ], 
      // next corner
      [ for(i=[0:step:90]) [
          -rail_ox2-m+r1-sin(i)*r1,
          -r1+cos(i)*r1]
      ], [
        [-rail_ox2-m, -rail_oz1-m],
        [-rail_ox2,   -rail_oz1-m],
        [-rail_ox2,   -m]
      ]
    );
    rotate([90,0,0])
    linear_extrude(height=rail_d, v = [0,0,1])
        polygon(points_body);
}    
 