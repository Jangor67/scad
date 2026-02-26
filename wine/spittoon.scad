// spitoon
// v1 is goed gelukt maar draad van de
//   top moest worden afgevijld tot 39mm
// v2 nog niet geprint maar aangepast naar
//   1mm (dus gat - 1) 

// Some material definitions
// defaults in prusa slicer 0.15 height (0.2 first layer)
layer_1=0.2;
layer_n=0.15;
nozzle=0.4;
wall=nozzle*2;



// Prusa Mini kan max 180 x 180 x 180 printen
max=180;

// v1 is NIET waterdicht
// m=1.5 dus net GEEN 4 perimeter/nozzle
// - m2 is dus verdubbeld (handig met d=xxx)
// - slicer laat zien dat shell = 4 perimeters
//
// ChatGPT tips:
// 🧠 Vaak betere oplossing dan coaten
// Omdat PETG al waterdicht kan zijn:
//
// ✅ Print-instellingen aanpassen
// - Meer walls (≥ 4)
// - Hogere nozzle temp
// - Langzamer printen
// - 100% flow
// - Dikkere top/bottom layers
// 👉 Veel PETG-prints worden hiermee zonder coating al waterdicht
m=1.5;
m2=m*2;

debug=false;
peek=false;

resolution = debug ? 16 : 128; // ronde resolutie (meer = gladder, trager)
$fn = resolution;

// gekopieerd van dop.scad (module saw_thread)
// but it needed to be adjusted quite a bit...

wall_thickness = 2.9; // wanddikte buitenkant (mm)

num_turns = 3;        // aantal volledige windingen
pitch = 5;            // spoed (mm)
cap_height = 20;      // totale hoogte van de dop (mm)
thread_depth = 2.6;   // diepte van de draadprofiel (mm) (typisch ~pitch/2 voor grove draad)

module thread(
	orad=thread_OD,  // outer diameter of thread 
    t=num_turns,     // number of turns
	tl=cap_height,   // thread length
    td=thread_depth, // thread depth
	p=pitch,         // lead or pitch of thread
    outer=true,      // outer (or inner) thread
    soft_start=true) // soft_start thread_depth
{
   orar=orad/2;
   omtrek=PI*orad;
   pa=atan(p/omtrek);
   tooth_len=omtrek/resolution;
   // based on rotate -90,0,0 
   // x is outward and y downward 
   xb=orar+0.4;
   tooth  = outer ? 
   [
       [xb,      0  ],
       [xb-td,  -p/2+0.075],
       [xb-td,  -p/2-0.075],
       [xb,     -p  ]       ] :
   [
       [xb-td,   0  ],
       [xb,     -p/2+0.075],
       [xb,     -p/2-0.075],
       [xb-td,  -p  ]       ];
       
   end=360*min(t, tl/p)-1;
   maxbase=p/360*end;
   for (i=[0:360/resolution:end]) {
       base=p/360*i;
       if ((base < p) && soft_start) {
             xd=td/p*base;
             if (xd > 0.4) {
                 tooth1 = outer ?
                 [
                   [xb,    0],
                   [xb-xd, -base/2+0.075],
                   [xb-xd, -base/2-0.075],
                   [xb,    -base] ] :
                 [
                   [xb-td, 0],
                   [xb-td+xd,    -base/2+0.075],
                   [xb-td+xd,    -base/2-0.075],
                   [xb-td, -base] ];               
                 basec=(base+p)/2-p/2;
                 translate([0,0,basec])
                 rotate([-90+pa,0,i])
                 linear_extrude(height=tooth_len+0.1) 
                 polygon(tooth1);
             }
       }
       else {
           if ((base + p) <= maxbase) {
               translate([0,0,base-p/2]) 
               rotate([-90+pa,0,i]) 
               linear_extrude(height=tooth_len+0.1) 
               polygon(tooth);
           } else {
               rest=maxbase-base;
               if (rest > 0.4) {
                   xd=td/p*rest;
                   tooth2 = outer ?
                   [
                     [xb, 0  ],
                     [xb-xd,rest/2-0.075],
                     [xb-xd,rest/2+0.075],
                     [xb,   rest ]        ] :
                   [
                     [xb-td,    0  ],
                     [xb-td+xd, rest/2-0.075],
                     [xb-td+xd, rest/2+0.075],
                     [xb-td,    rest ]        ];
                   basec=(rest+p)/2+base;
                   translate([0,0,basec-p/2]) 
                   rotate([-90+pa,0,i]) 
                   linear_extrude(height=tooth_len+0.1) 
                   polygon(tooth2);
               }
           }
       }
   }
}

module dome (d=max, h=max, do=0) {
  sc=h*2/d;
  difference() {
    union() {
      scale([1,1,sc])
        sphere(d=d);
      translate([0,0,-m+0.01])
        cylinder(d=d,h=m);
    }
    translate([0,0,-m]) {
      scale([1,1,sc])
        sphere(d=d-m2);
      translate([0,0,-h])
        cylinder(d=d,h=h);
    }
    if (do!=0) {
      translate([0,0,h-m*8])
        cylinder(d=do,h=m*16);
    }
  }
}

*if (peek) translate([-max/2,-max/2,0])
  %cube([max,max,max]);
  
hb=125;
gat=40;

module base(max=max) {

    // bodem
    difference() {
      dome(max,9);
      if (peek) cube([90,90,hb]);
    }

    // buitenkant
    difference() { 
      dome(max,hb,gat);
      if (peek) cube([90,90,hb]);
    }

    // plaats waar we een gat maken om 
    // de fles te kunnen legen
    // waarschijnlijk tunen bij maatverandering!
    punch_h=1.0*pitch;
    punch_l=1.6*pitch;

    // schroefdraad
    translate([0,0,hb-5*pitch+pitch/2]) {
      difference() {
        cylinder(d=gat+wall_thickness*2,h=4*pitch);
        if (peek) cube([90,90,4*pitch]);
        translate([0,0,-0.1]) {
          cylinder(d=gat-0.1,h=4*pitch+0.2);
          translate([-2,-gat/2-wall_thickness*1.1,punch_h])
            cube([4,gat+wall_thickness*2.2,punch_l]);
        }
      }
      difference() {
          thread(gat,5);
          if (peek) cube([90,90,4*pitch]);
          translate([-2,-gat/2-wall_thickness*1.1,punch_h]) 
          cube([4,gat+wall_thickness*2.2,punch_l]);
      }
    }
}

module top (max=max, ho=65) {    
  gat2 = gat-thread_depth*2;
  
  // dome
  difference() {
    dome(max,ho,gat2);
    if (peek) cube([90,90,ho+4*pitch]);
  }
  // collar waarschijnlijk tunen bij maatverandering
  translate([0,0,ho-4.3]) difference() {
    cylinder(d=gat+wall_thickness*2,h=0.5*pitch);
    if (peek) translate([0,0,-0.1]) cube([90,90,4*pitch]);
    translate([0,0,-0.1]) {
      cylinder(d=gat-0.1-thread_depth*2,h=0.5*pitch+0.2);
    }
  }
  
  // thread
  translate([0,0,ho-3.9]) {
    difference() {
      union() {
        cylinder(d=gat2+0.1,h=4.5*pitch);
        translate([0,0,4.4*pitch])
          cylinder(d1=gat2+0.1,d2=20,h=1*pitch);
      }
      translate([0,0,-0.1]) {
        cylinder(d1=gat2,d2=20,h=5);
        cylinder(d1=gat2-wall_thickness*2,d2=20,h=10);
        cylinder(d=20,h=5.5*pitch+0.2);
      }
      if (peek) cube([90,90,ho+4*pitch]);
    }
    translate([0,0,pitch/2])
    // v1 = gat - 0.4 -> is niet genoeg!
    // na afvijlen lijkt 1mm voldoende!
    thread(gat-1,5,outer=false,soft_start=false);
  }   
    
}


base(130);
//translate([0,0,hb]) 
//rotate([180,0,0])
*top(130);