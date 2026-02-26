// nemef entr remotecase

////////////// parameters (geschat) //////////////
clear = 0.4; // speling tussen elektronica en behuizing (mm)
lip = 2.0;   // rand rondom deksel (mm)

//////// Nagemeten op 17-12-2025 ////////
// diameter buitenkast
D1   = 33;   // ter verificatie email (nagemeten was 33.5); 
D2   = 27.5; 
wall = 1.45;
// totale lengte en hoogte
L = 59.0;   // ter verificatie email (nagemeten was 59.15);
H = 11.5;   // ter verificatie email (nagemeten was 11.1);

// diameter binnenkast
D1b   = 23.9; // binnenkast
D2b   = 18.7;
wallb = 1;
Lb = 39.25+wallb*2; // gokje

//kast heeft rechte rand 3.8mm hoog
//totale rand is 5mm hoog

nok_h=-4.4; //nokjes op 4.4 vanaf bovenkant
knop_h=1.5;

//sleutelhanger onderkant wall = 2.45
//sleutelhanger d1 = 4 d2 =576 hrs² 5.8 


//deksel moet in uitsparingen vallen, slots zijn 9mm lang
//deksel D1=31.2 D2=30 dik=2.2 D3=24.7

// nog nameten
rubber_h=0.5;

////////////// afgeleide maten //////////////
wall2 = wall * 2;
wall2b = wallb * 2;
R1=D1/2;
R2=D2/2;
R1b=D1b/2;
R2b=D2b/2;
sphere_distance = L-R1-R2;
cylinder_distance = Lb-R1b-R2b;

// actual module with battery and components
mod_d1=D1b-wall2b;
mod_d2=D2b-wall2b;
mod_l=39.25;

//// SETTINGS /////

$fn=60; 
 
////////////// modules //////////////

module knop(d1=27.9,d2=25.8,h1=0.8,h2=1.5) {
  difference() {
    union() {
      cylinder(d=d1,h=h1);
      cylinder(d=d2,h=h2);
    }
    // thin in the center
    translate([0,0,h2+h1])
      scale([1,1,h2*2/d1]) 
      sphere(d=d1);
    // lampvenster
    // d=1.5 l=3.1 
    // 1.9 vanaf de buitenste rand
    rotate([0,0,45])translate([0,(d1-1.5)/2-1.9,-0.01]) {
      hull() {
        cylinder(d=1.5,h=h2+0.02);
        translate([0,1.5-3.1,0])
        cylinder(d=1.5,h=h2+0.02);        
      }
    }
  }
}
translate([0,0,10]) %knop();

module remote_part(d1=mod_d1,d2=mod_d2,l=mod_l) {
  echo ("remote_part d1=", d1);
  echo ("remote_part d2=", d2);
  echo ("remote_part l= ", l);
  print_thick=1.2;
  cylinder(d=d1,h=print_thick);
  // CR2032+mount
  translate([0,-3.9+d1-21,-3.2]) {
    cylinder(d=21,h=3.2);
    translate([-7/2,-22/2,-0.2])
      cube([7,22,3.4]);
    translate([-7/2,-28/2,2.8])
      cube([7,28-1.6,0.4]);
  }
  hull() {
    cylinder(d=d2,h=print_thick);
    translate([-d2/2,d1/2-l,0])
      cube([d2,0.01,print_thick]);
  }
}
translate([0,0,8])%remote_part();

module keyb(d1,d2,l,h) {
  cylinder(d=d1,h=h);
  hull() {
    cylinder(d=d2,h=h);
    translate([-d2/2,d1/2-l,0])
      cube([d2,0.01,h]);
  }
}
module binnenkast(h=H) {  
    translate([0,0,-h]) difference() {
      keyb(D1b,D2b,Lb,h);
      translate([0,0,-0.01])
      keyb(D1b-wall2b,D2b-wall2b,Lb-wall2b,h+0.02);
    }
}

module key(d1,d2,l,h) {
  cylinder(d=d1,h=h);
  hull() {
    cylinder(d=d2,h=h);
    translate([0,(d1+d2)/2-l,0])
      cylinder(d=d2,h=h);
  }
}
module behuizing(h=H) {
  // opstaande rand
  rand=3.8;
  translate([0,0,-rand-0.01])difference() {
    key(D1,D2,L,rand+0.01);
    translate([0,0,-0.01])
      key(D1-wall2,D2-wall2,L-wall2,rand+0.03);
  }
  // bolle onderkant
  translate([0,0,-rand]) scale([1,1,(h-rand)/D2]) {
    difference() {
      sphere(d=D1);
      // remove inside
      scale([1,1,D2/(h-rand)]) remote_part();
      // sphere(d=D1-wall2);
      // remove top
      translate([-R1-0.1,-R1-0.1,0])
        cube([D1+0.2,D1+0.2,R1]);
      // open one side
      //translate([0,-D1,0]) scale([D2/D1,D2/D1,D2/D2]) hull() {
      //  sphere(d=D1-wall2);
      //  translate([0,D1*D1/D2,0])
      //    sphere(d=D1-wall2);
      //}
    }
    translate([0,-sphere_distance,0]) scale([D2/D1,D2/D1,1]) difference() {
      hull() { 
        sphere(d=D1);
        translate([0,sphere_distance*D1/D2,0]) sphere(d=D1);
      }
      // remove inside
      //hull() {
      //  sphere(d=D1-wall2);
      //  translate([0,sphere_distance*D1/D2,0]) sphere(d=D1-wall2);
      //}
      // remove the part which resides in the main sphere
      scale([D1/D2,D1/D2,1]) translate([0,sphere_distance,0]) sphere(d=D1-wall2);
      // remove top
      translate([-D1/2-0.1,-D1/2-0.1,0])
        cube([D1+0.2,R1+sphere_distance*D1/D2+R2+0.2,D1/2]);
    }
  }
}

////////////// constructie (centeren voor gemak) //////////////

// Helpful: export separate pieces by uncommenting:
behuizing();
translate([0,0,nok_h-1]) {
  #cube([5,5,1]);
}
translate([0,0,-knop_h-rubber_h]) {
  bkh=4.95;
  binnenkast(h=bkh);
  //translate([0,0,-bkh])  
  //  #binnenkast(h=0.5);
}
translate([D1,-L/2,0]) rotate([0,180,180]) {
  behuizing();
}