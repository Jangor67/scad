// Bracket to mount a 2.5" in a 3.5" location
//
// Printed on 7-12-2024
// Changed threaded mount a bit for future prints

// HDD 3.5 inch bottom mounting position definitions
// -----------------------------------------------------
// https://support.wdc.com/images/kb/2579-771970-A03.pdf
// bottom mount holes 4x
// - standard location 1 and 3
// - alternate location 2 and 3
hdd35i_1=44.45; // 1.75"
hdd35i_2=76.20; // 3.00"
hdd35i_3=95.25; // 3.75"

// HDD 3.5 inch mounting (british!) screw definitions
// -----------------------------------------------------
// 6-32UNC X 1/8” (3.8 threads engagement)
// Research
// - Bronnen
//   - https://www.golantec.be/Engelse%20bouten.html
// - Notities
//   - UNC - An acronym for Unified National Coarse.
//     An imperial thread standard that is part of UTS,
//     and defines screw threads with a coarse pitch. 
//   - 3.5mm buitenmaat schacht
//   - British Standard Withworth
//     - 1/8" angle of thread 55 graden
//     - tapping drill size  	
//     - Number Drill 39 (2.55 mm)
//   - andere maten
//     - 3.175 diameter buiten (mm)
//     - 2.36  kerngat diameter (mm)
//     - 40 gangen per inch
//     - 0.635 stijging (mm)
// - Afgeleiden
//   - schroefdiepte 1" / 40 * 4 = 25.4 / 10 = 2.54mm
unc_1_8_outer_d=3.175;
unc_1_8_outer_pitch=25.4/40;

// Chassis mounting definitions 
hdd35i_screw_d=4;   // holes for mounting
hdd35i_screw_hd=10; // room for the head (this is not the head size)

// We are going to use this library  for help with creating
// threads
// https://github.com/revarbat/BOSL
include <BOSL/threading.scad>
*trapezoidal_threaded_rod();
*trapezoidal_threaded_rod(l=2.54,d=unc_1_8_outer_d,pitch=unc_1_8_outer_pitch,internal=true);


// HDD 2.5 inch bottom mounting position definitions
// ----------------------------------------------------
// https://www.intel.com/content/dam/www/public/us/en/documents/product-specifications/ssd-530-sata-specification.pdf
hdd25i_1=90.60-14;
hdd25i_3=61.72;
hdd25i_screw_d=2.9+0.2;
hdd25i_screw_hd=6.9+0.4;

// Some material definitions
// defaults in prusa slicer 0.15 height (0.2 first layer)
layer_1=0.2;
layer_n=0.15;
base_h=layer_1+layer_n*8;
sheet_h=layer_1+layer_n*4; // the sheet should be thin, max 0.95mm
base_d=8;

$fn=20;

// Some functions (modules)

// Create a mount which will hold a HDD screw
module threaded_mount(
    position = [0,0,0],
    outer_d = unc_1_8_outer_d,
    ptch    = unc_1_8_outer_pitch,
    length  = 2.54                 // 4 threads 1/8" 
) {
    translate(position)
        difference() {
            cylinder(h=length, d=base_d, $fn=20);
            internal_rod(outer_d=outer_d,ptch=ptch,length=length);
            *cylinder(h=length+0.02, d=outer_d*0.98, $fn=20);
        }    
}

module internal_rod(
    outer_d = unc_1_8_outer_d,
    ptch    = unc_1_8_outer_pitch,
    length  = 2.54
) {
    translate([0,0,-0.01])
        trapezoidal_threaded_rod(l=3*length+0.02,d=outer_d,pitch=ptch,internal=true);
}

// a frame part will simply draw a connection between two
// mounting positions. 
module frame_part(
    m1, m2,
    d1 = hdd25i_screw_d, // screw hole
    d2 = hdd25i_screw_hd,  // screw head
    create_threaded_mount = false,
    d3 = 8    // frame width
) {
    difference() {
        hull() {
            // mount 1
            translate(m1)
                cylinder(h=base_h,d=d3);
            // mount 2
            translate(m2)
                cylinder(h=base_h,d=d3);
        }
        if (create_threaded_mount) {
            // remove a smaller part
            translate([0,0,-0.01]) {
                translate(m1)
                    cylinder(h=base_h+0.02, d=d1, $fn=20);
                translate(m2)
                    cylinder(h=base_h+0.02, d=d1, $fn=20);
            }
        } else {
            // remove bigger part
            translate([0,0,-0.01]) {
                translate(m1)
                    cylinder(h=base_h+0.02, d=d2-0.1, $fn=20);
                translate(m2)
                    cylinder(h=base_h+0.02, d=d2-0.1, $fn=20);
            }
        }
    }
    // add the mounting parts
    if (create_threaded_mount) {
        threaded_mount(m1);
        threaded_mount(m2);
    } else {
        translate(m1)
            difference() {
                cylinder(h=sheet_h,d=d2,$fn=20);
                translate([0,0,-0.01])
                    cylinder(h=1+0.02,d=d1,$fn=20);
            }
        translate(m2)
            difference() {
                cylinder(h=sheet_h,d=d2,$fn=20);
                translate([0,0,-0.01])
                    cylinder(h=sheet_h+0.02,d=d1,$fn=20);
            }
    }
}

// Now we can start constructing our custom bracket

// First some mounting position definitons (around the center)
hdd25i_m1=[+hdd25i_1/2,+hdd25i_3/2];
hdd25i_m2=[+hdd25i_1/2,-hdd25i_3/2];
hdd25i_m3=[-hdd25i_1/2,-hdd25i_3/2];
hdd25i_m4=[-hdd25i_1/2,+hdd25i_3/2];

hdd35i_m1=[+hdd35i_1/2,+hdd35i_3/2];
hdd35i_m2=[+hdd35i_1/2,-hdd35i_3/2];
hdd35i_m3=[-hdd35i_1/2,-hdd35i_3/2];
hdd35i_m4=[-hdd35i_1/2,+hdd35i_3/2];

// Draw the frame parts
frame_part(hdd25i_m1,hdd25i_m2);
frame_part(hdd25i_m2,hdd25i_m3);
frame_part(hdd25i_m3,hdd25i_m4);
frame_part(hdd25i_m4,hdd25i_m1);

frame_part(hdd35i_m1,hdd35i_m2,hdd35i_screw_d,hdd35i_screw_hd,true);
frame_part(hdd35i_m2,hdd35i_m3,hdd35i_screw_d,hdd35i_screw_d,true);
frame_part(hdd35i_m3,hdd35i_m4,hdd35i_screw_d,hdd35i_screw_d,true);
frame_part(hdd35i_m4,hdd35i_m1,hdd35i_screw_d,hdd35i_screw_d,true);