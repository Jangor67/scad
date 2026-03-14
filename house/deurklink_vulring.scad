// Deurklink Monique OM16

d1=16+0.4;
d2=20-0.4;
d3=27-0.4;

layer_1=0.2;
layer_n=0.15;
first_3=layer_1+2*layer_n;

$fn=60;

module vul_ring(disp=0, h=7) {
    difference() {
      cylinder(h=h,d=d2);
      translate([disp,0,-0.1])
      cylinder(h=h+0.2,d=d1);
    }
    difference() {
      cylinder(h=first_3,d=d3);
      translate([0,0,-0.1])
      cylinder(h=10+0.2,d=d2-0.1);
    }
}

vul_ring(disp=0.2);
translate([d3+2,0,0]) vul_ring(disp=0.1);
translate([0,d3+2,0])vul_ring();