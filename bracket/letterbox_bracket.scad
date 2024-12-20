// To fit a brass letterbox flap onn a blind door

// It should fit between the 2 glaslatten
br_d=12.5+0.1;
br_h=59.6-0.4;

// We need 2 smaller brackets each are wide
br_w=38-0.4;

// Bracket needs mounting holes
mnt_d1=11.6+0.4;
mnt_d2=10+0.4;
mnt_h=8.8+0.4;
mnt_off=21.6+(11.6/2);

// Squar nut 
nut_d=16.4+4;
nut_h=4;

mnt_d3=6.3+0.4;

difference() {
    union() {  
      cube([br_w,br_h,br_d]);      
      cube([br_w-4,br_h,br_d+1]);
    }
    translate([br_w-mnt_off,br_h/2,-0.1])
        union() {
            cylinder(h=mnt_h+0.2,d1=mnt_d1,d2=mnt_d2,$fn=30);
            cylinder(h=br_h+0.2,d=mnt_d3,$fn=30);
            translate([0,0,br_d+1-4])
                hull() {
                    cylinder(h=nut_h+0.2,d=nut_d,$fn=40);
                    translate([-br_w+mnt_off-nut_d,-nut_d/2,0])
                        cube([nut_d,nut_d,nut_h+0.2]);
                }
        }
}