// Numatic HVR200
//
// handvat (zoals vastgemaakt aan de slang) 
//   - buitendiameter van 37mm 
//   - materiaal dikte varieert
//     - mondstuk zelf is ongeveer 2.5mm
//     - bredere stuk bij slang is bijna 4mm
//   - bredere stuk is 51.7mm
//     - overgang is 6mm
//     - lengte is 47 (incl overgang)
//     - uitsparingen voor nokjes
//       - d=3mm
//       - l=8.2
//       - afstand 6.5
// flexibele buis heeft opzetstuk van43.5mm (dat draait in het handvat)
// metalen buis
//   - buitendiameter 31.6
// borstelmondstuk 
//   - binnnendiameter 31.3mm
// verbindingsstuk verloopt van 30 tot 32.9

// First plan was to print a 
// - Sleeve to reinforce existing mouthpiece
// - Now the design is a complete rebuild of the entire mouth piece


$fn=60;

module tube(
    diameter=37,
    l=73,
    m=2.5
) {
    diameter2=diameter-m*2;
    difference() {
      cylinder(h=l,d=diameter);
      translate([0,0,-0.1])
      cylinder(h=l+0.2,d=diameter2);
    }
}

module slantedtube(
    diameter=37, 
    l=70, 
    m=2.5, 
    sleeve=1,
    debug=0) {
    
    d2=m*2; // verschil buiten en binnendiameter
    
    D = sleeve == 1 ? diameter + 0.2 : diameter - d2;
    D2= sleeve == 1 ? D+d2           : D+d2;
    D3= diameter + d2 + 0.2;
    difference() {
      cylinder(h=l+D3,d=D+d2);
      translate([0,0,-0.1])
        cylinder(h=l+D2+0.2,d=D);
      if (debug) {
        translate([0,-D2/2-0.1,0]) 
          cube([D2,D2+0.2,l+D2]);
      }
      translate([-D3/2-0.1,-D3/2-0.1,l])
        rotate([45,0,0])
        cube([D3+0.2,sqrt(D3*D3*2)+0.2,D3]);
    }
}

module massivebase(
    diameter=51.7,
    diameter2=37,
    l=46.5,
    l2=6
) {
    cylinder(h=l-l2,d=diameter);
    translate([0,0,l-l2-0.01])
    cylinder(h=l2+0.01,d1=diameter,d2=diameter2);
}

module base(
    diameter=51.7,
    diameter2=37,
    m=4,
    m2=2.5,
    l=47,
    l2=6,
    // uitsparingen of nokjes
    nd=3,
    nl=5.2,
    nz=8
    ) {
    
    d2=m*2;
    
    difference() {
      massivebase(l=l);
      translate([0,0,-2])
        massivebase(
          diameter=diameter-d2,
          diameter2=diameter2-d2,
          l=l);
      cylinder(h=l+0.1,d=diameter2);
      translate([-diameter/2-0.1,0,nz])
        rotate([0,90,0])
        hull() {
          translate([0,-nl/2,0])
            cylinder(h=diameter+0.2,d=nd);
          translate([0,nl/2,0])
            cylinder(h=diameter+0.2,d=nd);
        }
    }
}

//tube();
//translate([0,0,-5])

module mouthpiece() {
    l=48;
    base(l=l);
    translate([0,0,40.5])
      tube(l=80-40.5,m=3.5);
    translate([0,0,l-0.01])
      slantedtube(sleeve=0);
}

difference() {
  mouthpiece();
  cube([50,50,160]); }

// check 1 (mounting piece)
%difference() {
  cylinder(h=40,d=43.5);
  cube([50,50,150]);
}

// check 2 (metal tube)
% difference() {
  translate([0,0,80])
    cylinder(h=70,d=31.6);
  cube([50,50,160]);
}
