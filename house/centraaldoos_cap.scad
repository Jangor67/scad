// centraaldoos afdekplaat met extra ruimte
l=69;    // length of square sides
x=81.5;  // diagonal distance mounting holes
cd=11.2; // corner diameter
t=2.5;   // material thickness

//schroef m4 (bolkop met ring)
m4_1=4;
m4_2=8; // bolkop diameter

//flat screwdriver measures requires spacing of 6.4 

// Some calculations
cr=cd/2;
a=sqrt(x^2/2); // calculate sides based on diagonal
b=(l-a)/2;     // displacement from side of the base cover

// Some material definitions
// defaults in prusa slicer 0.15 height (0.2 first layer)
layer_1=0.2;
layer_n=0.15;
nozzle=0.4;
wall=nozzle*2;
$fn=60;

// HD2200 plafond dimmer (hornbach)
// https://malmbergsprod.blob.core.windows.net/web/documents/0f9b67d8-f236-4d78-a88f-390aa3bb2485.pdf
dim_d=56;
dim_h=22;

// https://github.com/openscad/MCAD/blob/master/boxes.scad
// roundedCube([x, y, z], r, sidesonly=true/false, center=true/false)
include <MCAD/boxes.scad>;

//one of the products available from the market is the
// attema cover 
// - this is a round cover
// - it measures almost 125mm diameter 

// helps to debug to see how this looks like
module standard_cover() {
    difference() {
      roundedCube([l,l,t], cr, sidesonly=true);
      translate([b,b,-0.005]) {
        cylinder(h=t+0.01,d=m4_1);
        translate([a,a,0])
          cylinder(h=t+0.01,d=m4_1);
      }
    }
}

module mount_pillar(h=10) {
    difference() {
      cylinder(h=h,d=m4_2+0.4+nozzle*4);
      translate([0,0,t]) 
        cylinder(h=h,d=m4_2+0.4);
      translate([0,0,-0.05])
        cylinder(h=h,d=m4_1);
    }
}

module pin(h=25) {
  translate([0,0,-h])
  difference() {
    // the pin will have diameter slightly smaller
    // than the mount_pillar which has m4_2+0.4
    cylinder(h=h+0.01,d=m4_2+0.3);
    // also cut out which will make the pin slide
    // into the mount pillar
    translate([-0.2,-m4_2,-1])
      cube([0.8,m4_2*2,h]);
  }
}

module bigger_cover(pin_h=25, overlap=20) {
  d=sqrt(l^2*2)+overlap;
  translate([0,0,-t]) {
    translate([a/2,a/2,0])
      cylinder(h=t,d=d);
    pin(pin_h);  
    translate([a,a,0]) pin(pin_h);
  }
}

// 1 hoog overoop needs a height of 31.2
module plat_afdek() {
  h1=31.2-t;
  h2=28.8-t;
  mount_pillar(h1);
  translate([a,a,0]) mount_pillar(h2);

  *translate([0,0,max(h1,h2)]) 
    bigger_cover(pin_h=min(h1,h2)-t*2);
  translate([40,10,0]) rotate([180,0,0])
    bigger_cover(pin_h=min(h1,h2)-t*2);

  %translate([-b,-b,-t-1]) standard_cover();
}


module dimmer(h=dim_h, cover=false) {
  // 6 sides are approx 20
  // 2 sides are approx 28
  ss=20; // short side
  //ls=28; // long side
  x1=27.5;
  y1=ss/2; // half short side
  dentd=8; //8.5 was too big
  termw=23;
  termh=11;
  
  ssxy=sqrt(pow(ss,2)/2);
  x2=x1-ssxy;
  y2=y1+ssxy;
  p = [
    [ x1,-y1], [ x1, y1],
    [ x2, y2], [-x2, y2],
    [-x1, y1], [-x1,-y1],
    [-x2,-y2], [ x2,-y2] ];
  if (cover) {
    // make cover for dimmer instead of dimmer itself
    translate([0,0,h])
        difference() {
            linear_extrude(layer_n*5) polygon(p);
            translate([0,0,-0.1])
              scale([0.65,0.65,1])
                linear_extrude(layer_n*5+0.2) polygon(p);
            // control knob location    
            rotate([0,0,360/8])
              translate([0,17,-0.1])
                cylinder(h=layer_n*5+0.2,r=2.8);
        }
    // circular dents
    translate([x1+0.4,0,0])
      difference() {
        cylinder(h=h+layer_n*5,d=dentd);
        translate([0,0,-0.1])
          #cylinder(h=h+0.1,d=dentd-t);
      }
    translate([-x1-0.4,0,0])
      difference() {
        cylinder(h=h+layer_n*5,d=dentd);
        translate([0,0,-0.1])
          #cylinder(h=h+0.1,d=dentd-t);
      }
  } else {
      difference() {
        linear_extrude(h) polygon(p);
        // circular dents
        translate([x1,0,-0.1])
          cylinder(h=h+0.2,d=dentd);
        translate([-x1,0,-0.1])
          cylinder(h=h+0.2,d=dentd);
        // electrical terminals (just show dent)
        translate([-termw/2,-y2-0.1,-0.1])
          cube([termw,1+0.1,h+0.2]);
        // check side2side
        // dimmer_d=53; // side2side=53;
        *rotate([0,0,360/8]) 
          translate([-dimmer_d/2,0,-0.1])
          cube([dimmer_d,1,h+0.2]);
        // control knob location    
        rotate([0,0,360/8])
          translate([0,17,h-2])
            cylinder(h=2.5,r=2.8);
      }
  }
}

module dome (d=60, h=25, do=0, m=1.6, massive=false) {
  sc=h*2/d;
  difference() {
    union() {
      translate([0,0,m]) 
        scale([1,1,sc])
          sphere(d=d);
      cylinder(d=d,h=m+0.001);
      translate([0,0,-h+0.01])
        cylinder(d=d,h=h+0.02);
    }
    if (!massive) {
        translate([0,0,0]) {
          scale([1,1,sc])
            sphere(d=d-m*2);
          translate([0,0,-h])
            cylinder(d=d+m,h=h);
        }
    }
    if (do!=0) {
      translate([0,0,h-m*8])
        cylinder(d=do,h=m*16);
    }
  }
}

// 1 hoog bathroom
module dome_met_dimmer(overlap=20) {
    h3=15;
    mountx=42.53;
    mounty=9.2;
    testh=layer_1+layer_n*5;
    
    %dimmer(15);
    translate([0,0,15])
      dimmer(layer_n*15,true);

    // use l (length of sides of standard_cover)
    d=sqrt(l^2*2)+overlap;
    * difference() {
      dome(d,22);
      translate([0,-d,-25])
        cube([d*1,d*2,50]);
    }

    *difference() {
      hull () {
        cylinder(d=65,h=testh);
        translate([mountx, mounty])
          cylinder(d=10,h=testh);
      }
      // cutout dimmer 
      // - dimmer is partly sunken in 
      // - leaving 15mm to cover
      scale=1+1/53; //scale to 1mm bigger
      translate([0,0,-0.1]) 
        scale([scale,scale,1])dimmer(15);
      // cutout screw 
      translate([mountx, mounty,-0.1])
        cylinder(d=5,h=testh+0.2);

      cylinder(h=20,d=1);
    }
    // show standard cover as well
    translate([mountx,mounty,0])
      rotate([0,0,148])
        translate([-b,-b,0])
        %standard_cover();
}

dome_met_dimmer();
*translate([0,65,0]) mount_pillar();