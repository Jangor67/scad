// Fix snoer USB kabel laptop voeding

sd=4;  // snoer-diameter
thd=7;  // thule-diameter
thl=9;

tl=30; // total-length
mw=10; // max-width

$fn=60;

module smooth_insert() {
  // smooth insert allow bending
  bh=4;
  translate([mw/2,thd/2,tl-bh]) {
    inc=(bh-0.1)/90;
    for(i=[0:3:90]) {
      i1=i*inc;
      i2=(1-cos(i))*4;
      translate([0,0,i1]) cylinder(h=inc+2,d=sd+i2);
    }
  }
}

module thule_and_wire() {
  // cutout thule and wire
  translate([mw/2,thd/2,-0.1]) {
    cylinder(h=tl+0.2,d=sd);
    cylinder(h=thl+10,d=sd+1);
    cylinder(h=thl,d=thd);
  }
}

module opening() {
  // create opening to insert wire
  translate([(mw-sd)/2,-1,-0.1]) {
    cube([sd,sd+0.3,tl+0.2]);
  }
}

module create () {
    difference() {
      union() {
        cube([mw,thd+1,thl+2]);
        translate([(mw-sd)/2,(thd+1)/2,0])
          cube([sd,(thd+1)/2,tl]);
        translate([mw/2,thd/2,0])
          cylinder(h=tl,d=sd+4);
      }
      thule_and_wire();
      smooth_insert();
      opening();
      
      // debug
      //translate([mw/2,-0.1,-0.1]) cube([mw+1,thd+2,tl+0.2]);
    }
}

create();
translate([10,0,10-tl]) difference() {
  opening();
  thule_and_wire();
  smooth_insert();
  translate([0,-2,-0.2])
  cube([mw,thd+1,tl-10+0.2]);
}