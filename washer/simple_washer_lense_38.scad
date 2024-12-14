// Washers
// 7-12-2024 Geprint voor montage NVR

// Some material definitions
// defaults in prusa slicer 0.15 height (0.2 first layer)
layer_1=0.2;
layer_n=0.15;
base_h=layer_1+layer_n*20; // 3.2mm

$fa=1; // min facet angle
$fs=1; // min facet size

module washer() {
    difference() {
        cylinder(h=base_h,d=11);
        screw_countersunk();
    }
}
*washer();

// model countersunk screw for 3d printing
// useful for creating attachement bores
// which fit these screws
// default values are for 3mm x 20mm screw with 6mm head (3.2mm bore for tolerance)
module screw_countersunk(
        z  = base_h, //displacement z
        l  = 22,     //length
        dh =  7.3,   //head dia
        db =  3.3,   //base dia (smaller icw ds)
        lh =  2.2,   //head length
        ds =  3.9,   //shaft dia
        )
{
    translate([0,0,z-lh+0.01])
        cylinder(h=lh, r1=db/2, r2=dh/2, $fn=20);
    translate([0,0,z-lh+0.02-l])
        cylinder(h=l, d=ds, $fn=20);
}
*screw_countersunk();

translate([0,0,0]) washer();    
