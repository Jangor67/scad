// dop_S64x5.scad
// Parametrisch OpenSCAD-model voor een kunststof dop met interne schroefdraad 

// Zwarte HDPE 60L vat 
// Witte doppen zijn ongeveer S64x5 gemeten op het vat
// vat is verder ovaal opening is: D=60.5 tot 62.5
// thread_depth is 2.6 dus thread outer diameeter is 65.2 tot 67.8

// Let op: dit is een praktische benadering met een "blokjes"-draad (replicates thread teeth)
// Aanpassen van "clearance" is belangrijk voor pasvorm met 3D-print.

// -----------------------------
// Parameters
// -----------------------------
debug= 0;             // help to develop
create_hole=15.5;     // create a hole in the cap (waterslot), 
                      // set to desired mm or 0 to disable

thread_OD = 67.8;       // nominale buitendiameter van de draad (mm) gemeten op het vat
thread_depth = 2.6;   // diepte van de draadprofiel (mm) (typisch ~pitch/2 voor grove draad)
wall_thickness = 2.9; // wanddikte buitenkant (mm)

pitch = 5;            // spoed (mm)
num_turns = 3;        // aantal volledige windingen in de dop
cap_height = 20;      // totale hoogte van de dop (mm)

tooth_width = 2.7;    // axiale breedte van elke 'tand' (mm) origineel pitch * 0.7
resolution = debug ? 32 : 128; // ronde resolutie (meer = gladder, trager)

$fn = resolution;

// Derived
thread_ID = thread_OD - 2*thread_depth; // approximate minor diameter of male counterpart

// ----------------
// DEBUG
// ----------------

// Ovaal cilinder gecentreerd in z
module vat() {
  // thread_ID 
  // 64 - 5.2 = 59.8 
  // of
  // 60.5 (62.5) + 5.2 = 65.7 (67.7)???
  smal = 60.5;
  breed = 62.5;
  h = cap_height;
  ratio = breed/smal;
  r = smal/2;

  translate([0,0,wall_thickness])    // optioneel
    %difference() {
      scale([ratio,1,1])
        cylinder(r = r, h = h, center = false, $fn = 200);
      translate([0,0,-0.01])
        cube([thread_OD, thread_OD, cap_height+0.02]);
      translate([-thread_OD,-thread_OD,-0.01])
        cube([thread_OD, thread_OD, cap_height+0.02]);
    }
}

if (debug) vat();
    
// ----------------
// Thread
// ----------------

module saw_thread(
	orad=thread_OD,  // outer diameter of thread 
    t=num_turns,     // number of turns
	tl=cap_height,   // thread length
    td=thread_depth, // thread depth
	p=pitch)         // lead or pitch of thread
{
   orar=orad/2;
   omtrek=PI*orad;
   pa=atan(p/omtrek);
   tooth_len=omtrek/resolution;
   // based on rotate -90,0,0 
   // x is outward and y downward 
   xb=orar+0.4;
   tooth = [
     [xb,      0  ],
     [xb-td,   0  ],
     [xb-td,  -0.2],
     [xb,   -p+0.4] ];
   end=360*min(num_turns, tl/p)-1;
   for (i=[-360:360/resolution:end]) {
       base=p/360*i;
       if (base > -wall_thickness) {
           if ((base + p) <= (tl-wall_thickness)) {
               translate([0,0,p/360*i]) 
               rotate([-90+pa,0,i]) 
               linear_extrude(height=tooth_len+0.1) 
               polygon(tooth);
           } else {
               y2=tl-wall_thickness-base-0.4;
               xd=(td-0.4) * y2 / (p-0.4);
               x2=xb-xd;
               *echo("adapting tooth x2:", xb-td, "->", x2, " y2:", -p+0.4, "->", y2, " ...");
               translate([0,0,p/360*i]) 
               rotate([-90+pa,0,i]) 
               linear_extrude(height=tooth_len+0.1) 
               polygon([
                 [xb, 0  ],
                 [x2, 0  ],
                 [x2,-0.2],
                 [xb,-y2] ]);
                 
           }
       }
   }
}

translate([0,0,wall_thickness]) saw_thread();

// -----------------------------
// Modules
// -----------------------------

module cap_body() {
  cap_outer_dia = thread_OD + 2*wall_thickness;

  difference() {
        // buitenste cilinder
        cylinder(h = cap_height, d = cap_outer_dia, center = false);
        // holte binnenin
        translate([0,0,wall_thickness]) // leave a small base thickness
            cylinder(h = cap_height, d = thread_OD, center=false);
        // chamfer / rounding cap top inside
        translate([0,0,cap_height-1])
            cylinder(h=1.01,d=thread_OD+0.4,center=false);
        // conditionally create a hole
        if (create_hole) {
          translate([0,0,-0.1])
            cylinder(h=wall_thickness+0.2,d=create_hole);
        }
  }
    
    // help to keep an O-ring in place
    translate([0,0,wall_thickness-0.1]) difference() {
        cylinder(h=3.1, d=thread_ID-2*wall_thickness-0.2, center=false);
        translate([0,0,-0.1])
        cylinder(h=3.3, d=thread_ID-4*wall_thickness+0.2, center=false);
    }
    
    // add 8 notches, giving grip to tighten/loosen
    notches=8;
    for(d = [0:notches-1]) {
        rotate([0,0,d*360/notches])
        translate([cap_outer_dia/2,0,0])
            cylinder(h= cap_height, d=wall_thickness*1.5,   center= false);
    }
}

// combine and subtract thread from body
module dop() {
    difference() {
        cap_body();
        // debug helps to have a peek inside
        if (debug) {
            translate([0,0,-0.01])
                cube([thread_OD, thread_OD, cap_height+0.02]);
        }        
    }
}

// -----------------------------
// Render
// -----------------------------
// Usage:
// Pas parameters bovenaan aan: thread_OD (64), pitch (5)
// Printadvies: PETG, verticale oriëntatie, laaghoogte 0.2 mm, speling testen met test-ring +0.2 mm

dop();
