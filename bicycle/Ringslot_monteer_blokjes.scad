// fiets-ring-slot montage blokjes
// let op: is voor groot slot (zoals de ABUS Amparo)

wall=0.4*7;
wall2=wall*2;

sd=14.2; // stand diameter including 0.2 spacing
nuts=5;
bout=5;

bw=wall+sd+wall+bout+wall;
bd=sd+wall;
bh=40;

echo ("Montage hartafstanden:");
disp=sd+wall2+bout;
echo ("80 + ", disp, " = ", 80+disp);

module thread(nuts=nuts) {
  rotate([-90,0,0]) cylinder(d=nuts,h=bh+1,$fn=60);
}
module ring(d=14.8+0.2, th=1.6+0.2) {
  rotate([-90,0,0]) cylinder(d=d,h=th);
}
module lockring(d=9.7+0.2,th=1.8+0.2) {
  rotate([-90,0,0]) cylinder(d=d,h=th);
}
module nut(d=8.2,h=4.2) {
  rotate([-90,30,0])
    // it looks like when d=8.2 it is too small
    cylinder(d=d*1.15, h=h, $fn=6);
}

//translate([-10,0,10]) {
//  translate([4.1,4.1,0.1]) nut();
//  cube([8.2,8.2,1]);
//}


module blok(disp=0) {
  difference() {
    cube([bw,bd,bh]);
    // cutout stand
    translate([wall+sd/2,sd/2,-0.1])
      hull() {
        cylinder(d=sd,h=bh+0.2); 
        translate([0,-sd/2,0]) cylinder(d=sd,h=bh+0.2); 
      }
    // cutout screw mounting hole and ...
    translate([wall+sd+wall+nuts/2,0,bh/2-nuts/2+disp]) {
      translate([0,-0.1,0]) thread();
      translate([0,5,0]) hull() {
        lockring();
        translate([nuts/2+wall,0,0]) lockring();
      }
      translate([0,5+2-0.01,0]) hull() {
        nut();
        translate([nuts/2+wall,0,0]) nut();
      }
    }
  }
}

blok(5);
translate([bw+10,0,0]) blok(-5);