// Tool to unscrew bottom wristwatch Seiko 
// v1 fits badly
// v2 changed notches and make it fit in the bench vise

// measurements
d1=25;    // center glass piece
h1=0.3;
d2=27.5;    // guessing metal rim is 2mm smaller
d3=29.4;  // notches
wn=2.1;
d4=32;    // max D of the back cover
h2=3.4;   // notches bottom to center glass piece
h3=3.7;   // total height of backplate

// printer
l1=0.2;
ln=0.15;
nozzle=0.4;

$fn=180;

module two_notches(
    d=d3, // v4: from d3-0.4 to just d3
    nw=wn, 
    nd=(d4-d3+0.4)/2+0.4, 
    h=h2) {
  translate([d/2,-nw/2,0]) cube([nd,nw,h]);
  translate([-d/2-nd,-nw/2,0]) cube([nd,nw,h]);
}


module back_plate() {
  cylinder (d=d1+0.15,h=h1+0.002);
  translate([0,0,h1-0.001]) 
    difference() {
      hull() {
        cylinder(d=d2+0.15,h=1);
        translate([0,0,h3-0.5]) 
          cylinder(d=d4+0.15,h=0.5);
      }
      two_notches();
      rotate(a=60) two_notches();
      rotate(a=120) two_notches();    
    }
  
}
*rotate([180,0,0]) back_plate();

difference() {
  body=l1+ln*3+ln*10; // give body to material
  union() {
    dt=d4+nozzle*2;
    ht=h3+body;
    translate([-dt/2,-dt/2,0])
      cube([dt,dt,ht]);
    translate([-dt/2-5,-dt/2,ht-ln*5])
      cube([dt+10,dt,ln*5]);
    *cylinder(d=dt,h=ht);
    *for(i=[0:20:360]) {
      rotate([0,0,i]) 
      translate([dt/2,0,0]) 
      scale([1,2,1]) 
      cylinder(d=3,h=ht);
    }
  }
  translate([0,0,body])back_plate();
  // debug
  *translate([0,0,-0.1]) cube([d4,d4,h2+1]);
}

