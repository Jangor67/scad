// Basis montageplaat network  video recorder (NVR)
// NVR 
// - base is 3mm lifted above
// - material is 1mm thick
// - montagepunten 5.9mm boven de tafel
// - note: other plating is 0.6mm thick

// Mount points 1 to 4 for disc are 4-8mm (8 allows head insert)
// Mount points 5 and 6 are screw holes (4mm)

base_d=10;
base_h=3;
sheet_metal=1;
mount_h=5.9;
mount_d=4;
offset=45.0; // offset measured from the frontside

// HDD 3.5 inch mounting definitions
// https://support.wdc.com/images/kb/2579-771970-A03.pdf
// bottom mount holes 4x
// - standard location 1 and 3
// - alternate location 2 and 3
hdd35i_1=44.45; // 1.75"
hdd35i_2=76.20; // 3.00"
hdd35i_3=95.25; // 3.75"

//https://github.com/JohK/nutsnbolts.git
// include <nutsnbolts/cyl_head_bolt.scad>
// include <nutsnbolts/materials.scad>

$fa=1; // min facet angle
$fs=1; // min facet size

module mount_pin() {
    difference() {
        union() {
            cylinder(h=mount_h+0.1,d=4-0.1);
            translate([0,0,mount_h])
                cylinder(h=2.5,d=8-0.1);
        }
        screw_countersunk(mount_h+2.5);
    }
}
*mount_pin();

module static_pin() {
    difference() {
        cylinder(h=mount_h-sheet_metal,d=8);
        screw_countersunk(mount_h+2.5);
    }
}
*static_pin();

// model countersunk screw for 3d printing
// useful for creating attachement bores
// which fit these screws
// default values are for 3mm x 20mm screw with 6mm head (3.2mm bore for tolerance)
module screw_countersunk(
        z  = base_h, //displacement z
        l  = 20,     //length
        dh =  6,     //head dia
        lh =  3,     //head length
        ds =  3.2,   //shaft dia
        )
{
    translate([0,0,z-lh+0.01])
        cylinder(h=lh, r1=ds/2, r2=dh/2, $fn=20);
    translate([0,0,z-lh+0.02-l])
        cylinder(h=l, d=ds, $fn=20);
}
*screw_countersunk();

// reference to front of the box

translate([  0.0, -base_d/6,0])
    cube([offset-2,base_d/3,2]);
translate([  0.0, hdd35i_2-base_d/6,0])
    cube([offset-2,base_d/3,2]);

// base strips are constructed first

difference() {
    hull() {
        // mount 1
        translate([ offset, 0.0,0])
            cylinder(h=base_h,d=base_d);
        // mount 2
        translate([ offset,hdd35i_1,0])
            cylinder(h=base_h,d=base_d);
    }
    translate([offset, 0.0,0])
        screw_countersunk(mount_h);
    translate([offset, hdd35i_1,0])
        screw_countersunk(mount_h);
    *translate([offset,10.0,0])
        screw_countersunk();
    *translate([offset,35.5,0])
        screw_countersunk();
}
difference() {
    hull() {
        // mount 3
        translate([offset+hdd35i_3, 0.0,0])
            cylinder(h=base_h,d=base_d);
        // mount 4
        translate([offset+hdd35i_3,hdd35i_1,0])
            cylinder(h=base_h,d=base_d);
    }
    translate([offset+hdd35i_3, 0.0,0])
        screw_countersunk(mount_h);
    translate([offset+hdd35i_3,hdd35i_1,0])
        screw_countersunk(mount_h);
    *translate([offset+hdd35i_3,10.0,0])
        screw_countersunk();
    *translate([offset+hdd35i_3,35.5,0])
        screw_countersunk();
}
difference() {
    hull() {
        // mount 1
        translate([ offset, 0.0,0])
            cylinder(h=base_h,d=base_d);
        // mount 3
        translate([offset+hdd35i_3, 0.0,0])
            cylinder(h=base_h,d=base_d);
    }
    translate([ offset, 0.0,0])
        screw_countersunk(mount_h);
    translate([offset+hdd35i_3, 0.0,0])
        screw_countersunk(mount_h);
    *translate([55.0,0.0,0])
        screw_countersunk();
    *translate([130.5,0.0,0])
        screw_countersunk();
}
difference() {
    hull() {
        // mount 2
        translate([ offset,hdd35i_1,0])
            cylinder(h=base_h,d=base_d);
        // mount 4
        translate([offset+hdd35i_3,hdd35i_1,0])
            cylinder(h=base_h,d=base_d);
    }
    translate([ offset,hdd35i_1,0])
        screw_countersunk(mount_h);
    translate([offset+hdd35i_3,hdd35i_1,0])
        screw_countersunk(mount_h);
    *translate([55.0,hdd35i_1,0])
        screw_countersunk();
    *translate([130.5,hdd35i_1,0])
        screw_countersunk();
}
difference() {
    hull() {
        // mount 2
        translate([ offset,hdd35i_1,0])
            cylinder(h=base_h,d=base_d);
        // mount 5
        translate([ offset,hdd35i_2,0])
            cylinder(h=base_h,d=base_d);
    }
    translate([ offset,hdd35i_1,0])
        screw_countersunk(mount_h);
    translate([ offset,hdd35i_2,0])
        screw_countersunk(mount_h);
    *translate([ offset,61.5,0])
        screw_countersunk();
}
difference() {
    hull() {
        // mount 4
        translate([offset+hdd35i_3,hdd35i_1,0])
            cylinder(h=base_h,d=base_d);
        // mount 6
        translate([offset+hdd35i_3,hdd35i_2,0])    
            cylinder(h=base_h,d=base_d);
    }
    translate([offset+hdd35i_3,hdd35i_1,0])
        screw_countersunk(mount_h);
    translate([offset+hdd35i_3,hdd35i_2,0])    
        screw_countersunk(mount_h);
    *translate([offset+hdd35i_3,61.5,0])
        screw_countersunk();
}
difference() {
    hull() {
        // mount 5
        translate([ offset,hdd35i_2,0])
            cylinder(h=base_h,d=base_d);
        translate([offset+22,hdd35i_2,0])
            cylinder(h=base_h,d=32);
        translate([offset+44,hdd35i_2,0])
            cylinder(h=base_h,d=base_d);
    }
    translate([ offset,hdd35i_2,0])
        screw_countersunk(mount_h);
    translate([offset+22,hdd35i_2,-0.1])
        cylinder(h=base_h+0.2,d=22);
}
difference() {
    hull() {
        translate([offset+44,hdd35i_2,0])
            cylinder(h=base_h,d=base_d);
        // mount 6
        translate([offset+hdd35i_3,hdd35i_2,0])    
            cylinder(h=base_h,d=base_d);
    }
    translate([offset+hdd35i_3,hdd35i_2,0])    
        screw_countersunk(mount_h);
    *translate([130.5,hdd35i_2,0]) //todo
        screw_countersunk();
}

    // mount 1
    //[ offset, 0.0,0]
    // mount 2
    //[ offset,hdd35i_1,0]
    // mount 3
    //[offset+hdd35i_3, 0.0,0]
    // mount 4
    //[offset+hdd35i_3,hdd35i_1,0]
    // mount 5
    //[ offset,hdd35i_2,0]
    // mount 6
    //[offset+hdd35i_3,hdd35i_2,0]    


// mount 1
translate([ offset, 0.0,0])
    mount_pin();
// mount 2
translate([ offset,hdd35i_1,0])
    mount_pin();
// mount 3
translate([offset+hdd35i_3, 0.0,0])
    mount_pin();
// mount 4
translate([offset+hdd35i_3,hdd35i_1,0])
    mount_pin();
// mount 5
translate([ offset,hdd35i_2,0])
    static_pin();
// mount 6
translate([offset+hdd35i_3,hdd35i_2,0])
    static_pin();
    
