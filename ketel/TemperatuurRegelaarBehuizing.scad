// Brekttle temperature controller housing

peek_inside=0;
parkerSz=3.5; // best to keep this at 3.5
parkerHd=6.9+0.05;
parkerHh=2.5;

m=0.4*5; m2=m*2;
$fn=30;

// kettle diameter (onto which we mount the housing)
kd=385;

//panel size (installation hole size; square)
ps=48;
is=44.6; //instead of 45 it is more like 43.6;
ph=78;
sp1=9;  // default spacing
sp2=13; // spacing for wiring

// housing size; housing height
hs1=m+sp1+is+sp1+m;
hs2=m+sp2+is+sp2+m;
hh=          ph+sp1+m;

// ventilation holes
vh=1.4;

// Sensor wire passage
sd=6.5;         // to allow connectors to pass
sd1=1.8; sd2=3; // oval wire diameter

// TODO: klepje aan de onderkant

// pillars for mounting the bottom hatch
// pillars are shorter to allow for stronger hatch
mp=9; mp2=mp/2;  // mount pillar thickness
mh=parkerSz-1.3; // hole for parker to fixate
mh2=parkerSz;    // hole for parker to pass

pdx1=m-0.01; 
pdx2=hs1-m+0.01-mp;
pdy1=-hs2/2+m-0.01;
pdy2=hs2/2-m+0.01-mp;
pdh=hh-m2-0.01; pdh2=pdh+0.02;

// draw pillars
translate([pdx1,pdy1,m2]) 
  difference() {
    cube([mp,mp,pdh]);
    translate([mp2,mp2,-0.01])
      cylinder(h=pdh2,d=mh);
  }
translate([pdx1,pdy2,m2]) 
  difference() {
    cube([mp,mp,pdh]);
    translate([mp2,mp2,-0.01])
      cylinder(h=pdh2,d=mh);
  }
translate([pdx2,pdy2,m2]) 
  difference() {
    cube([mp,mp,pdh]);
    translate([mp2,mp2,-0.01])
      cylinder(h=pdh2,d=mh);
  }
translate([pdx2,pdy1,m2]) 
  difference() {
    cube([mp,mp,pdh]);
    translate([mp2,mp2,-0.01])
      cylinder(h=pdh2,d=mh);
  }
  
// Hatch
translate([0,-hs2*1.5-10,hh-m+0.1]) {
// translate([m,m-hs2/2,-m2]) {
    translate([-pdx1,-pdy1,0]) {
        translate([pdx1,pdy1,-m]) 
          difference() {
            translate([0.2,0.2,0]) cube([mp-0.4,mp-0.4,m+0.01]);
            translate([mp2,mp2,-0.01])
              cylinder(h=m+0.025,d=mh2);
            translate([mp2,mp2,m2-parkerHh])
              cylinder(h=parkerHh,d1=parkerSz,d2=parkerHd);
          }
        translate([pdx1,pdy2,-m]) 
          difference() {
            translate([0.2,0.2,0]) cube([mp-0.4,mp-0.4,m+0.01]);
            translate([mp2,mp2,-0.01])
              cylinder(h=m+0.025,d=mh2);
            translate([mp2,mp2,m2-parkerHh])
              cylinder(h=parkerHh,d1=parkerSz,d2=parkerHd);
          }
        translate([pdx2,pdy2,-m]) 
          difference() {
            translate([0.2,0.2,0]) cube([mp-0.4,mp-0.4,m+0.01]);
            translate([mp2,mp2,-0.01])
              cylinder(h=m+0.025,d=mh2);
            translate([mp2,mp2,m2-parkerHh])
              cylinder(h=parkerHh,d1=parkerSz,d2=parkerHd);
          }
        translate([pdx2,pdy1,-m]) 
          difference() {
            translate([0.2,0.2,0]) cube([mp-0.4,mp-0.4,m+0.01]);
            translate([mp2,mp2,-0.01])
              cylinder(h=m+0.025,d=mh2);
            translate([mp2,mp2,m2-parkerHh])
              cylinder(h=parkerHh,d1=parkerSz,d2=parkerHd);
          }
    }
    difference() {
        translate([0.2,0.2,0]) cube([hs1-m2-0.4,hs2-m2-0.4,m]);

        translate([-pdx1+mp2,-pdy1+mp2,m-parkerHh+0.01]) {
            translate([pdx1,pdy1,0]) 
              cylinder(h=parkerHh,d1=parkerSz,d2=parkerHd);
            translate([pdx1,pdy2,0]) 
              cylinder(h=parkerHh,d1=parkerSz,d2=parkerHd);
            translate([pdx2,pdy2,0]) 
              cylinder(h=parkerHh,d1=parkerSz,d2=parkerHd);
            translate([pdx2,pdy1,0]) 
              cylinder(h=parkerHh,d1=parkerSz,d2=parkerHd);
        }

        // safety holes
        translate([(hs1-m2-0.4)/2,(hs2-m2-0.4)/2,-0.05]) {
            for (a =[-5:2.5:5]) hull() {
                translate([ a, 5]) cylinder(h=m+0.1,d=vh);
                translate([ a,-5]) cylinder(h=m+0.1,d=vh);
            }
        }
        
    }
}

// Main housing object drawn now
translate([0,-hs2/2,0]) difference() {
  // allow 5mm extra to the  backside for round kettle
  translate([-5,0,0])
    cube([hs1+5,hs2,hh]);
    
  // cut away kettle material
  #translate([-kd/2,hs2/2,-0.01]) cylinder(h=100,d=kd, $fn=360);
  
  // mounting and connections onto the kettle
  mhd=14-1; // wires go through here
  shd=5;  // 5mm screw hole
  shy=23; // distance between screw holes
  shz=58/2;
  translate([m+0.1,(hs2-shy)/2,shz])
    rotate([0,-90,0]) cylinder(h=m+5.2,d=shd);
  translate([m+0.1,(hs2+shy)/2,shz])
    rotate([0,-90,0]) cylinder(h=m+5.2,d=shd);
  translate([m+0.1, hs2/2,    shz])
    rotate([0,-90,0]) cylinder(h=m+5.2,d=mhd);
    
  // screwdriver to allow mounting
  translate([hs1-m-0.1,(hs2-shy)/2,shz])
    rotate([0,90,0]) cylinder(h=m+0.2,d=7);
  translate([hs1-m-0.1,(hs2+shy)/2,shz])
    rotate([0,90,0]) cylinder(h=m+0.2,d=7);
  
  // clear the hatch
  translate([m,m,-0.01]) {
      cube([hs1-m2,hs2-m2,m+0.02]);
  }
  
  // ventilation
  for (a =[10:2.5:hs1-10]) {
      translate([a,-0.01,hh-30]) {
        cube([1.2,m+0.02,25]);
        translate([0,hs2-m,0])
          cube([1.2,m+0.02,25]);
      }
  }

  // panel including display
  #translate([m+sp1,m+sp2,m+sp1]) 
    cube([is,is,ph+0.01]);
  #translate([m+sp1-((ps-is)/2),
              m+sp2-((ps-is)/2),
              m+sp1+ph+0.01])
    cube([ps,ps,8.5]);
    
  // sensor wire
  #translate([m+sp1+16.2,m+sp2-((ps-is)/2)-(sd2-sd1/2),sp1+ph])
    hull() {
      cylinder(h=m+0.1,d=sd1);
      translate([0,sd2-sd1,0]) 
        cylinder(h=m+0.1,d=sd1);
      translate([0,10,0])
        cylinder(h=m+0.1,d=sd1);
        
    }
            
  // help with dismantling
  #translate([m+sp1-(ps-is)/2-0.4,hs2/2-6,sp1+ph])
     cube([(ps-is)/2+0.45,12,m+0.1]);
  #translate([hs1-m-sp1-0.05,hs2/2-6,sp1+ph])
     cube([(ps-is)/2+0.45,12,m+0.1]);
    
  // spacing between controler and housing
  translate([m,m,m]) 
    cube([hs1-m2,hs2-m2,hh-m2]);
    
  // peek inside
  if (peek_inside) {
    translate([hs1-15,-0.1,-0.05])
      cube([15.1,hs2+0.2,hh+0.1]);
    translate([0.1,hs2-15,-0.05])
      cube([hs1+5+0.2,15.1,hh+0.1]);
  }
  
}
