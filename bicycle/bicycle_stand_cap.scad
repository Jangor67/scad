// Bicycle Stand Cap


m=5;
d1=11;
d2=5;
d3=2.5;

$fn=60;

module half_cylinder(
  h=20,
  d=11) {
  difference() {
    cylinder(h=h,d=d);
    translate([-d/2,0,-0.1])
      cube([d,d,h+0.2]);
  }
}

module stand(h=20, d1=d1, d2=d2) {
    d3=2.5;
    hull() {
        half_cylinder(h=h,d=d1);
        translate([(d1-d3)/2,0,0])
          cylinder(h=h,d=d3);
        translate([(d2-d3)/2,(d1-d3)/2,0])
          cylinder(h=h,d=d3);
        translate([(d3-d2)/2,(d1-d3)/2,0])
          cylinder(h=h,d=d3);
        translate([-(d1-d3)/2,0,0])
          cylinder(h=h,d=d3);
    }
}

m2=m*2;
difference() {
    a=10;
    b=sqrt(a*a*2);
    depth=19;
    hull() {
        translate([  0,  0,10]) cylinder(h=18,d=d1+m2);
        translate([  0,-10, 0]) sphere(d=8);
        translate([ 10,  0, 5]) sphere(d=8);
        translate([-10,  0, 5]) sphere(d=8);
        translate([  0, 10,10]) sphere(d=8);
    }
    translate([0,0,28-depth])
    rotate([0,0,45])
      stand(h=depth+1);
}
