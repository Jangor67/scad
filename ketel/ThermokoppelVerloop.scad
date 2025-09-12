// thermokoppel insert

// m6
m6d=6;
m6h=6; // height of locking nut

// kopper insert 1/2" (21,34mm outside diameter)
// start from outside big parts to inside the tube
d1=19-0.3;
h1=6.4;
d2=15-0.3;
h21=14.6;
h22=16.6;
d3=9;
h3=45.5; 

// locking screw
lsd=4;
lsh=3.5;

// m6 thermokoppel
td1=m6d;
td2=11.2+0.8; // nut needs 9.9-11.2mm spacing
th=10;
tnh=4;

// other definitions
$fn=60;
m=4;
debug=0;


difference() {
    union() {
        cylinder(h=h1, d=d1);
        cylinder(h=h22-th+m, d=d2);
    }
    
    // thermokoppel
    translate([0,0,-0,01])
        cylinder(h=h22-th+0.01,d=td2);
    cylinder(h=h21+0.02,d=td1);
    translate([0,0,h22-m6h-0.01])
        cylinder(h=m6h,d=td2);
    
    // locking screw
    translate([d1/2,0,h1/2])
        rotate([0,-90,0]) 
        cylinder(h=lsh, d=lsd);
    
    // debug peek inside
    if (debug) {
        translate([0,0,-0.1])
            cube([d1+0.1,d1+0.1,h3+0.2]);    
    }
}

if (debug) {
    translate([0,0,h22-th-tnh]) {
        #cylinder(h=tnh,d=11,$fn=6);
        translate([0,0,tnh+m])
            #cylinder(h=6,d=11,$fn=6);
        translate([0,0,4])
            #cylinder(h=th,d=td1);
        translate([0,0,-4])
        #cylinder(h=4+th+8,d=3.8);
        translate([0,0,th+6])
            #cylinder(h=2,d=4.5);
    }
}