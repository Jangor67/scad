// Bracket to mount a fan board in the NVR

hdd25i_screw_d  = 2.9 + 0.4;
hdd25i_screw_hd = 6.9 + 0.4;

// Some material definitions
// defaults in prusa slicer 0.15 height (0.2 first layer)
layer_1=0.2;
layer_n=0.15;
base_h=layer_1+layer_n*8;
base_d=8;

$fn=20;

// Some functions (modules)

// a frame part will simply draw a connection between two
// mounting positions. 
module frame_part(
    m1, m2,
    d1 = hdd25i_screw_d, // screw hole
    d2 = hdd25i_screw_hd,  // screw head
    d3 = 8,    // frame width
    sheet = base_h
) {
    difference() {
        hull() {
            // mount 1
            translate(m1)
                cylinder(h=base_h,d=d3);
            // mount 2
            translate(m2)
                cylinder(h=base_h,d=d3);
        }
        // remove bigger part
        translate([0,0,-0.01]) {
            translate(m1)
                cylinder(h=base_h+0.02, d=d2-0.1, $fn=20);
            translate(m2)
                cylinder(h=base_h+0.02, d=d2-0.1, $fn=20);
        }
    }
    translate(m1)
        difference() {
            cylinder(h=sheet,d=d2,$fn=20);
            translate([0,0,-0.01])
                cylinder(h=sheet+0.02,d=d1,$fn=20);
        }
    translate(m2)
        difference() {
            cylinder(h=sheet,d=d2,$fn=20);
            translate([0,0,-0.01])
                cylinder(h=sheet+0.02,d=d1,$fn=20);
        }
}

// Now we can start constructing our custom bracket

// First some mounting position definitons (around the center)
m1=[ 0.0, 0.0];
m2=[53.0, 0.0];
mx=[21.5, 0.0];
m3=[21.5,42.5];

print_b      = 13+0.1;
print_l      = 53;
print_h      = 1.2+0.2; // print board thickness
print_clr    = 1.5+0.2; // soldered components stick out
print_hdr1_h = 6.5+0.2; // bigger header (2fan)
print_hdr1_w = 8.1+0.2;
print_hdr2_h = 5.8+0.2; // smaller header (2ntc)
print_hdr2_w = 7.5+0.2;

print_hdr1_hc = print_clr+print_h+print_hdr1_h;
print_hdr1_l  = (print_b - print_hdr1_w - 0.2) / 2;

print_hdr2_hc = print_clr+print_h+print_hdr2_h;
print_hdr2_l = print_b - print_hdr2_w - 0.2;

// Draw the frame parts
frame_part(m1,m2);
frame_part(m1,m3);
*frame_part(mx,m3,d3=4);
frame_part(m2,m3);

sheet=layer_n*7; // sheet material is mostly thin
sheet2=sheet*2;

module header(
    x     = 0,
    y     = 0,
    left  = 0,
    right = 0,
    b     = print_b,
    hdr_h = print_hdr1_hc,
    
) {
  difference() {
    translate([x       , y     , 0                 ])
        cube( [b+sheet2, 5     , base_h+hdr_h+sheet]);
    translate([x+sheet , y-0.01, base_h            ])
        cube( [b       , 5+0.02, hdr_h             ]);
  }
  clearance=print_clr+print_h+1;
  if (left != 0) {
    translate([x+left,y,base_h+clearance])
        cube([sheet,5,hdr_h-clearance]);
    translate([x,y,base_h+clearance])
        cube([left,5,sheet]);
  }
  if (right != 0) {
      translate([x+sheet+b-right,y,base_h+clearance])
        cube([sheet,5,hdr_h-clearance]);
      translate([x+sheet+b-right,y,base_h+clearance])
        cube([right+sheet,5,sheet]);
  }
}

translate([27,-7,0]) {
    header(
        y=0,        
        hdr_h=print_hdr1_hc,
        left=print_hdr1_l,right=print_hdr1_l);
    header(
        y=print_l-5,
        hdr_h=print_hdr2_hc,
        left=print_hdr2_l );
    // connection between the header
    railing=base_h+print_clr+print_h;
    difference() {
        cube([print_b/4,print_l,railing]);
        translate([sheet,-0.01,sheet])
            cube([print_b/4,print_l+0.02,railing]);
    }
    translate([print_b*3/4+sheet2,0,0]) {
        difference() {
            cube([print_b/4,print_l,railing]);
            translate([-sheet,-0.01,sheet])
                cube([print_b/4,print_l+0.02,railing]);
        }
    }
    // keeping print clearance
    bumper=base_h+print_clr;
    translate([0,0,0]) 
        cube([print_b/4,2,bumper]);
    translate([sheet2+print_b*3/4,0,0]) 
        cube([print_b/4,2,bumper]);
    translate([0,10,0]) 
        cube([print_b/4,2,bumper]);
    translate([sheet2+print_b*3/4,10,0]) 
        cube([print_b/4,2,bumper]);
    translate([0,print_l-15-2,0]) 
        cube([print_b/4,2,bumper]);
    translate([sheet2+print_b*3/4,print_l-15-2,0]) 
        cube([print_b/4,2,bumper]);
}