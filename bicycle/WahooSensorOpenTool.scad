// Wahoo Speed Candence Sensor Casing Tool

// casing measurements
d1=23.3;
d2=25.7;
case_thick=8.5;

// slot measurements to insert the tool 
thick=2;
wide=9;

$fn=60;
debug=0;

// the part that fits into the slot
difference() {
  translate([0,-wide/2,0])
    cube([25,wide,thick]);
  translate([0,0,-0.01]) {
    cylinder(h=thick+0.02,d=d1);    
  }
}
// handle
translate([d2,0,0]) {
  difference() {
    cylinder(h=thick*2,d=25);
    translate([-d2+1,0,0])
      cylinder(h=thick*2+0.2,d=d2);
    
  }
}

// drawthe sensor itself
if (debug) {
  #translate([0,0,-case_thick/2])
    hull() {
    cylinder(h=case_thick,d=d2);
    translate([-35+d2,0,0])
    cylinder(h=case_thick,d=d2);
  }
}
