// bicycle dimensions
rim_height=22.5;
rim_width=22;
tyre_width=28;

// stick dimensions
stick_d=25;

// dimensions mount
mount_width=25; 
arm_d=stick_d+8;
arm_l=100;

// screws 5 x 100 (plug fisher duo power 6x50)
screw_d=5;
screw_hd_d=9.5; //(some screws have a smaller head though)
screw_hd_h=3;
drill_d=6;
plug_d=9;

$fn=60;

// moduled after my shimano 105 rims
module tyre_and_rim() {
    translate([-0.1,-tyre_width/2+8,mount_width+tyre_width/2])
    rotate([0,90,0])
    union() {
      hull() {
        cylinder(h=arm_d+20.2,d=tyre_width);
        translate([-rim_width/2,-tyre_width/2-0.1,0])
        cube([rim_width,0.1,arm_d+20.2]);
      }
      translate([-rim_width/2,-tyre_width/2-10,0])
        cube([rim_width,10,arm_d+20.2]);
      translate([0,-tyre_width/2,0])
        hull() {
          translate([0,-rim_height+11.5/2,0]) {
            cylinder(h=arm_d+20.2,d=11.5);
          }
          translate([-rim_width/2,-10,0])
            cube([rim_width,0.1,arm_d+20.2]);
        }
    }
}

// connector for the 2 parts
module connector(side=0) {
    d=0.2; d2= d*2;
    t_base_h= side==0 ? 4.0 + d  : 4.0;
    t_base_w= side==0 ? 4.0      : 4.0 + d2;
    t_top_h=  side==0 ? 6.0 - d2 : 6.0;
    t_top_w=  side==0 ? 6.0      : 6.0 + d2;
    l=        side==0 ? arm_d+20 : arm_d+20.2;
    translate([0,-t_base_w/2,-0.01])
      cube([l,t_base_w,t_base_h+0.02]);
    translate([0,-t_top_w/2,t_base_h])
      cube([l,t_top_w,t_top_h]);
}

module screw_hole(
    d=screw_d, 
    hd_d=screw_hd_d, 
    hd_h=screw_hd_h) {
    
  // start with big hole (make it little bigger)
  hd_d2=hd_d+1;
  translate([0,0,-10])
    cylinder(h=10.1,d=hd_d2);
    
  // rest screw head
  temp1=(hd_d-d)/2;
  temp2=(hd_d2-d)/2;
  hd_h2=sqrt(temp1 ^ 2 + hd_h ^ 2 - temp2 ^ 2);
  translate([0,0,-10-hd_h2])
    cylinder(h=hd_h2, d1=d, d2=hd_d2);
  
  // screw shaft
  translate([0,0,-18.1])
    cylinder(h=8.2,d=d);
}

module drill_template(pd=plug_d) {
    l=mount_width*2+tyre_width;
    difference() {
      cube([20,4,l]);
      translate([10,0,0]) rotate([90,0,0]) {
          translate([0,10,-4.1])
            cylinder(h=4.2,d=pd);
          translate([0,l-10,-4.1])
            cylinder(h=4.2,d=pd);
      }
    }
}

module half_mount(side=0) {
    // arm
    difference() {
      hull() {
        cylinder(h=mount_width,d=arm_d);
        translate([-arm_d/2,arm_l,0])
        cube([arm_d,1,mount_width]);
      }
      translate([0,0,-0.1]) {
        for(i=[0:stick_d/1.9:arm_l-stick_d/2-8]) {
          translate([0,i,0])
          cylinder(h=mount_width+0.2,d=stick_d);
        }
      }
    }

    // wall piece
    extra_displacement = side == 0 ? 0 : 20;
    translate([-arm_d/2-extra_displacement,arm_l,0]) {
      difference() {
        cube([arm_d+20,18,mount_width+tyre_width/2]);
        hole_disp = side == 0 ? arm_d : 0; 
        translate([hole_disp+10,0,10])
          rotate([90,0,0])
          screw_hole();
        tyre_and_rim();
        if (side==1) {
          translate([arm_d+20.1,16/2+8/2,mount_width+tyre_width/2])
          rotate([0,180,0])
          connector(side);
        }
      }
      // connector
      if (side==0) {
          translate([0,16/2+8/2,mount_width+tyre_width/2])
            connector();
      }
      
      // transparent/debug
      if (side==0)
        %tyre_and_rim();
    }
}

//rotate([0,-90,0]) {
  half_mount(0);
  translate([0,0,mount_width*2+tyre_width+0])
  rotate([0,180,0]) 
    % half_mount(1);
  translate([mount_width*2+tyre_width,0,0])
    half_mount(1);
//}
translate([arm_d/2,arm_l-6,0])
  %drill_template();
translate([arm_d/2+10,mount_width*2+tyre_width,0])rotate([90,0,0])
  drill_template();
