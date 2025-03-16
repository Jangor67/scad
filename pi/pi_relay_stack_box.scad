// Pi Model 2 (MyFirstPi) relais setup box

// The top box is between 1 and 1.5mm bigger
// Still some room for improvements...

// material
m=2.3;
m2=m/2;

cbt=1.6; //circuit board thickness

// Pi Housing measurements
// base plate 
// ment to fit between the outbreak parts like
// - SD card 
// - USB port 
width=71.5;
length=94.5;
corner=5;

// Screw measurements
// sizes to allow room for head and thread
screw_head=5.3+1.2;
screw_thread=2.9+0.5;

// short side (on the ethernet port and usb side)
dist1=62.6-screw_thread;
// long side (hdmi port side)
dist2=77-screw_thread;
// long side (audio and video output)
dist3=84.5-screw_thread;

// Relay board measurements
// AliExpress 2020-12-01 2x2ch+2x4ch+2x6ch
ch_board_h=17.2;
ch_board_bs=1.8; //bottom spacing (soldering pins)
ch_board_c=5; // size of the corner stones

// 1 channel
ch1_board_w=17;
ch1_board_l=42.77;

ch1_board_v2_w=26.5;
ch1_board_v2_l=34.2;

// 2 channel
ch2_board_w=39;
ch2_board_l=51;

// 4 channel
ch4_board_w=55.3;
ch4_board_l=75.7;

// 6 channel
ch6_board_w=55.8;
ch6_board_l=106.3;

// Electrical wire outer dimensions
// Tweelingsnoer
twin_cord_thk=3.4;
twin_cord_wth=5.5;

usb_cord_thk=3.5;

$fn=50;

module qcorner(
    q=1,
    w=ch_board_c,
    bs=ch_board_bs,
    h=ch_board_bs+cbt
    ) {
    rotate([0,0,(q-1)*90])
    translate([-m2,-m2,0])
        difference() {
          cube([w,w,h]);
          translate([m2,m2,bs])
            cube([w,w,h]);
        }
}

module relay_mount(
    cs=ch_board_c,
    bs=ch_board_bs,
    w=ch1_board_v2_w,
    l=ch1_board_v2_l    
    ) {
    
    qcorner(1);
    translate([w,0,0])
        qcorner(2);
    translate([w,l,0])
        qcorner(3);
    translate([0,l,0])
        qcorner(4);
}

translate([
        (dist1-ch1_board_v2_w)/2,
        (dist3-ch1_board_v2_l)/2,
        m-0.01]) {
    relay_mount();
}

module twin_cord_slot(
        t=twin_cord_thk/2,
        w=twin_cord_wth
    ) {
        dist=w/2-t;
        dist2=(t+dist)*0.9;
        rotate([-90,0,0])
        hull() {
            translate([-dist,0,-0.01])
                cylinder(m+0.02,t,t);
            translate([ dist,0,-0.01])
                cylinder(m+0.02,t,t);
            translate([-dist2,-t-0.01,-0.01])
                cube([dist2*2,t,m+0.02]);
        }
    
}

module usb_cord_slot(
        t=usb_cord_thk/2
    ) {
        rotate([-90,0,0])
        hull() {
            translate([0,0,-0.01])
                cylinder(m+0.02,t,t);
            translate([-t*0.9,-t-0.01,-0.01])
                cube([t*1.8,t,m+0.02]);
        }
    
}


module qcylinder(
        q=1,
        height,
        r=corner/2
    ) {
    difference() {
        cylinder(height,r,r);
        translate([0,0,-0.01])
            cylinder(height+0.02,r-m2,r-m2);
        if (q!=1) translate([-r,0,-0.01])
            cube([r+0.01,r+0.01,height+0.02]);
        if (q!=2) translate([0,0,-0.01])
            cube([r+0.01,r+0.01,height+0.02]);
        if (q!=3) translate([0,-r,-0.01])
            cube([r+0.01,r+0.01,height+0.02]);
        if (q!=4) translate([-r,-r,-0.01])
            cube([r+0.01,r+0.01,height+0.02]);
    }
}

module base_plate(
        r1=corner/2,
        r2=screw_head/2,
        height=ch_board_h+ch_board_bs
    ) {
    rd=r2-r1+m2;
    rd2=rd*2;
    
    translate([-r2-m2,-rd,0])
        cube([m/2,dist3+rd2,height+m]);
        
    // long side (audio and video output)
    translate([dist1+r2,-rd,0])
        difference() {
            cube([m/2,dist3+rd2,height+m]);
            // control wires need to enter through here
            translate([-0.01,43,height+m-2])
                cube([m/2+0.02,34.5,2.01]);
        }
    // short side (on the ethernet port and usb side)
    translate([-rd,-r2-m2,0])
        difference() {
            cube([dist1+rd2,m/2,height+m]);
            // power wires need to enter through here
            translate([rd+dist1/2,0,height+m-twin_cord_thk/2]) {
                translate([-twin_cord_wth,0,0]) twin_cord_slot();
                translate([ twin_cord_wth,0,0]) twin_cord_slot();
            }
            translate([rd+dist1/2,0,height+m-usb_cord_thk/2]) {
                translate([-twin_cord_wth*3,0,0]) usb_cord_slot();
                translate([ twin_cord_wth*3,0,0]) usb_cord_slot();
            }
        }
    // short side (SD card and power cable)
    translate([-rd,dist3+r2,0])
        difference() {
            cube([dist1+rd2,m/2,height+m]);
            // power wires need to enter through here
            translate([rd+dist1/2,0,height+m-twin_cord_thk/2]) {
                translate([-twin_cord_wth,0,0]) twin_cord_slot();
                translate([ twin_cord_wth,0,0]) twin_cord_slot();
            }        
            translate([rd+dist1/2,0,height+m-usb_cord_thk/2]) {
                translate([-twin_cord_wth*3,0,0]) usb_cord_slot();
                translate([ twin_cord_wth*3,0,0]) usb_cord_slot();
            }
        }
        
    // corners (quarter cylinders)        
    translate([-rd,    dist3+rd,0]) 
        qcylinder(1,height+m);
    translate([dist1+rd,    dist3+rd,0]) 
        qcylinder(2,height+m);
    translate([dist1+rd,    -rd,0]) 
        qcylinder(3,height+m);
    translate([-rd,    -rd,0]) 
        qcylinder(4,height+m);
        
    difference() {
        hull() {
            translate([-rd,-rd,0])
                cylinder(m,r1,r1);
            translate([dist1+rd,-rd,0])     
                cylinder(m,r1,r1);
            translate([-rd,    dist3+rd,0]) 
                cylinder(m,r1,r1);
            translate([dist1+rd,dist3+rd,0]) 
                cylinder(m,r1,r1);
        }
        // screwdriver must pass free for (dis)mounting
        translate([0,0,-0.01]) {
                cylinder(h=m+0.02,r=r2);
            translate([dist1,0,0])     
                cylinder(h=m+0.02,r=r2);
            translate([0,    dist2,0]) 
                cylinder(h=m+0.02,r=r2);
            translate([dist1,dist3,0]) 
                cylinder(h=m+0.02,r=r2);
        }
    }    
}

module pilar(
        height=m+ch_board_h+ch_board_bs,
        r1=screw_head/2,
        r2=screw_thread/2
    ) {
    difference() {  
            cylinder(h=height, r=r1+m2);
        translate([0,0,-0.01])
            cylinder(h=height+0.01-m, r=r1);
        cylinder(h=height+0.01,r=r2);
    }
}

module pilars() {
    pilar();
    translate([dist1,0,0])     
        pilar();
    translate([0,    dist2,0]) 
        pilar();
    translate([dist1,dist3,0]) 
        pilar();
}

base_plate();
pilars();

