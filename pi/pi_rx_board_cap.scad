// Dust cap
// 15-12-2024 Printed but brd_w=20+0.4 is a bit too tight!

// Some material definitions
// defaults in prusa slicer 0.15 height (0.2 first layer)
layer_1=0.2;
layer_n=0.15; l2=layer_n*2;
base_h=layer_1+layer_n*8; // 1.4
p=0.4; 2p=p*2; 4p=2*2p;

// Rx hat dimensions
brd_l=86+0.4; // print is 80 but antenna sticks out
space=1; space2=2*space;
brd_w=20+space2+0.4;
brd_h=28;
ant_d=10; ant_r=ant_d/2;
ant_d2=76; 

difference() {
    translate([-2p,-2p,0.01])
        cube([brd_w+4p,brd_l+4p,brd_h+l2]);
    cube([brd_w, brd_l, 28]);
    antenna();
}

module antenna(
    per  = 0,  // perimeter to use
    hght = 100
) {
    translate([ant_r+space,(brd_l-ant_d2)/2,0])
        cylinder(h=hght,r=ant_r+per,$fn=35);
    translate([ant_r+space,(brd_l+ant_d2)/2,0])
        cylinder(h=hght,r=ant_r+per,$fn=35);
}

translate([0,0,brd_h-0.01]) 
    difference() {
        antenna(per=2p,hght=10);
        translate([0,0,-0.01])
            antenna(hght=10+0.02);
    }
