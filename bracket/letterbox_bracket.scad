// To fit a brass letterbox flap on a "blind" door

// It should fit between the 2 glasing bars (glaslatten)
br_d=12.5+0.1+1.2; //depth with a little spacing
br_h=59.6-0.4; //height with a little bit more spacing
br_w=40;   // We need 2 smaller brackets each width

// Bracket needs mounting holes to attach the flap
mnt_d1=13.5;    // the base is a bit wider
mnt_d2=11;      // the end a bit more slim
mnt_d3=6.3+0.4; // thread diameter which goes all the way through
mnt_h=8.8+0.4;  // height of the mount (from d1-d2)
mnt_off=26.7;   // offset from the edge til the center

lb_h=61.5;   // height is just slightly bigger than bracket
lb_r=6; lb_d=lb_r*2; // rounded corner radius
lb_fh=40;    // flap height
lb_fd=3.2+2; // flap depth + extra room

// Squar nut 
nut_d=16.4+4;
nut_h=4.5;

module screw(
    z=-6.5
) {
    translate([0,0,-3-z]) {
        cylinder(h=3,d2=2.5,d1=7,$fn=30);
        cylinder(h=25,d=2.5,$fn=30);
    }
    // allow screw hole to be sunken
    translate([0,0,-13-z])
        cylinder(h=10.01,d=7,$fn=30);
}

// diff between bracket and letterbox height
lb_br_hd = (lb_h-br_h) / 2; 

difference() {
    union() {
      // rounded corners
      hull() {
        translate([br_w-lb_r, lb_r-lb_br_hd, 0])
            cylinder(h=br_d,r=lb_r,$fn=30);
        translate([br_w-lb_r, br_h-lb_r+lb_br_hd, 0])
            cylinder(h=br_d,r=lb_r,$fn=30);
      }  
      // rest of the cubic shapes
      cube([br_w-lb_r,br_h,br_d]);
      translate([0,4,-1])
        cube([br_w-4,br_h-8,br_d+1]);
    }
    // bracket must not exceed height
    translate([0,-lb_br_hd,-0.1])
        cube([br_w,lb_br_hd,br_d+0.2]);
    translate([0,br_h,-0.1])
        cube([br_w,lb_br_hd,br_d+0.2]);
    // clearance for the flap
    translate([-0.1,br_h/2-lb_fh/2,-1.1])
        cube([4,lb_fh,lb_fd]);
    // create mount next
    translate([br_w-mnt_off,br_h/2,-1.1])
        union() {
            // bottom cone shaped
            cylinder(h=mnt_h+0.2,d1=mnt_d1,d2=mnt_d2,$fn=30);
            // threaded part
            cylinder(h=br_h+0.2,d=mnt_d3,$fn=30);
            // nut
            translate([0,0,br_d+1-nut_h]) //was 4
                hull() {
                    cylinder(h=nut_h+0.2,d=nut_d,$fn=40);
                    translate([-br_w+mnt_off-nut_d,-nut_d/2,0])
                        cube([nut_d,nut_d,nut_h+0.2]);
                }
        }
    // drill some holes to mount it on the door
    translate([br_w,lb_r+3.5,5])
        rotate([0,-45,0])
        screw();
    translate([br_w,br_h-lb_r-3.5,5])
        rotate([0,-45,0])
        screw();

}