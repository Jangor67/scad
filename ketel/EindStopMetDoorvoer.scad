// 1/2" Eindstop / Afsluitdop voor thermokoppel chinese ketel
// version 2 with 0.2 marges to have better fit

// m6
m6d=6;
m6h=6; // height of locking nut

// m6 nut
m6nutd = 11.2+0.2; // steek 9.9+0.2=10.1;

// m6 thermokoppel (doorvoer mag 3mm dik zijn)
td1=m6d+0.2;
th=10;

// BSPP (Parallel) 1/2 inch 55 degrees angle
buitend = 20.995-0.3; // nameten 20.7
binnend = 18.631-0.3;
pitch   = 1.814;
gaugel  = 8.164; // not sure what this means

// draad 4.5 tot 5 wikkelingen
binnenl  = 12.2;
binnend2 = 25.7;
binnenl2 = 14.4+0.9;
// dop met buitendraad 5.25 wikkelingen
buitenl = 11;

//
pijpd = 15;


module pipe(d=15,d2=15-2, l=60) {
  translate([0,0,-l/2]) difference() {
    cylinder(d=d,h=l);
    translate([0,0,-0.01])
      cylinder(d=d2,h=l+0.02);
  }
}

// draad: male thread:
// - parallel threads
// - nominal diameter (crest-crest)
// - british standard pipe have 55 degrees angle 
debug= 1;             // help to develop

thread_OD = buitend;       // nominale buitendiameter van de draad (mm) gemeten op het vat
thread_depth = (buitend-binnend)/2;   // diepte van de draadprofiel (mm) (typisch ~pitch/2 voor grove draad)
wall_thickness = 2.9; // wanddikte buitenkant (mm)

num_turns = 6;     // aantal volledige windingen in de dop
cap_height = 20;      // totale hoogte van de dop (mm)
tooth_width = pitch * 0.7;    // axiale breedte van elke 'tand' (mm)

// resolution = debug ? 32 : 128; // ronde resolutie (meer = gladder, trager)
resolution = 64;

$fn = resolution;

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
   xb=orar+0.1;
   tooth = [
     [xb,      0  ],
     [xb-td,  -p/2],
     [xb,     -p  ] ];
   end=360*min(num_turns, tl/p)-1;
   for (i=[-360:360/resolution:end]) {
       translate([0,0,p/360*i]) 
       rotate([-90+pa,0,i]) 
       linear_extrude(height=tooth_len+0.1) 
       polygon(tooth);
   }
}



module T () {
  difference() {
    cylinder(d=binnend2,h=binnenl2);
    translate([0,0,binnenl2-binnenl])
      cylinder(d=buitend,h=binnenl+0.02);
    translate([0,0,-pijpd/2])
      cylinder(d=pijpd-1,h=pijpd);
  }
  %difference() {
    translate([0,0,binnenl2-binnenl])
      cylinder(d=buitend,h=binnenl);
    translate([0,0,binnenl2-binnenl-0.01])
      cylinder(d=binnend,h=binnenl+0.02);
  }
  difference() {
    translate([0,0,-pijpd/2+0.9]) rotate([90,0,0]) {
      pipe();
      pipe(d=19.3,d2=15,l=38);
    }
    translate([0,0,-pijpd/2])
      cylinder(d=pijpd-1,h=pijpd);
  }
  
}

//T();

module thermokoppel() {
  td2=11.2+0.8;
  nh1=4;
  nh2=4;
  cylinder(d=3,h=th+10);
  cylinder(d=m6d,h=th);
  translate([0,0,th-nh1]) cylinder(d=td2,h=nh1,$fn=6);
  cylinder(d=td2,h=nh2,$fn=6);
}


module eindstop() {
  // threads
  // soften begin (smaller crest-crest)
  difference() {
    cylinder(d1=binnend, d2=buitend,h=2);
    translate([0,0,-0.01])
      cylinder(d=binnend,h=buitenl+0.02);
    saw_thread();
  }
  // full size (crest-crest)
  difference() {
    translate([0,0,1.99])
      cylinder(d=buitend,h=buitenl-1.99);
    translate([0,0,-0.01])
      cylinder(d=binnend,h=buitenl+0.02);
    saw_thread();
  }
  // cylinder
  difference() {
    translate([0,0,buitenl-1.99])
      cylinder(d1=binnend,d2=buitend,h=2);
    translate([0,0,buitenl-2])
      cylinder(d=m6nutd,h=2.02, $fn=6);
  }
  difference() {
    cylinder(d=binnend,h=buitenl+0.01);
    translate([0,0,-0.01])
      cylinder(d=m6nutd,h=buitenl+0.03, $fn=6);
  }
  // bolt
  boltd=27.2; // standard size 24 > this one is too big 
  // boltd=23; // standard 21,5 > this one is too small
  difference() {
    translate([0,0,buitenl])
      cylinder(d=boltd,h=3,$fn=6);
    // gat voor het thermokoppel 
    translate([0,0,buitenl-0.01])
      cylinder(d=td1,h=3.02);
  }
  
}

projection(cut=true) {
  translate([ 0, 0,10]) rotate([180,0,0]) eindstop();
  translate([ 0,30,0]) rotate([90,0,0]) eindstop();
  translate([30, 0,-binnenl]) rotate([00,0,0]) eindstop();
}

//translate([0,0,45]) thermokoppel();

