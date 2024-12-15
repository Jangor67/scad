// Mount an old Rapsberry Pi in Wooden casing to the wall

// Some material definitions
// defaults in prusa slicer 0.15 height (0.2 first layer)
layer_1=0.2;
layer_n=0.15;
base_h=layer_1+layer_n*8; // 1.4

// Some wood casing definitions
screws_apart_dist=94.3-3.1;
screws_disp=5; // this includes a little spacing between
               // the bracket and side wall of the case
casing_h=30;
m3_d=3.1; //screw hole

// Some more for the mounting bracket
combined_h=casing_h+base_h;

// Some helper modules

module washer() {
    difference() {
        cylinder(h=base_h,d=11);
        //screw_countersunk();
        raised_head_screw();
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

module raised_head_screw(
    z  = base_h, // displacement z
    l  = 22,     // length
    ds = 4.8     // shaft dia
){
    translate([0,0,0.01-l])
        cylinder(h=l+z+0.02, d=ds, $fn=20);
}

// a frame part will simply draw a connection between two
// mounting positions. 
module mount_frame_part(
    m1, m2,
    bottom_support = true,
    d1 = m3_d,   // screw hole m3 diameter
    d3 = 8,      // frame width
    height = 1.2 // nozzle is 0.4 -> so 3 perimeters
) {
    translate([0,-base_h+0.01,0])
    difference() {
        hull() {
            // mount 1
            translate(m1)
                cylinder(h=height,d=d3, $fn=20);
            // mount 2 = base mount
            translate(m2) translate([-d3/2,0])
                cube([d3,height,height]);
        }
        // drill hole at m1
        translate([0,0,-0.01]) {
            translate(m1)
                cylinder(h=height+0.8, d=d1, $fn=20);
        }
    }
    support_z= bottom_support ? -height : 0;
    hull() {
        translate(m1) translate([-d3/2,0])
            cube([height,height,height]);
        translate(m2) translate([-d3/2,-height,support_z])
            cube([height,height,height*2]);            
    }
    hull() {
        translate(m1) translate([d3/2-height,0])
            cube([height,height,height]);
        translate(m2) translate([d3/2-height,-height,support_z])
            cube([height,height,height*2]);            
    }
    support_z2= bottom_support ? -height : height;
    translate(m2) translate([-d3/2,-base_h,support_z2])
        cube([d3,base_h,height]);
}

module rear_frame_part(
    m1, m2,
    d3 = 8 // frame width
) {
    z1 = (m1.z > 0) ? m1.z-d3+base_h : m1.z;
    z2 = (m2.z > 0) ? m2.z-d3+base_h : m2.z;
    let(m1=[m1.x,m1.y,z1], m2=[m2.x,m2.y,z2]) {
        translate([-d3/2,-base_h,0]) hull() {
            translate(m1)
              cube([d3,base_h,d3]);
            translate(m2)
              cube([d3,base_h,d3]);
        }
    }
}

module rear_mount(
    point, rel,
    d3 = 4,  // frame width
    d4 = 11 // washer diameter
) {
    translate(point)
      translate(rel)
      rotate([90,0,0])
      washer();
    difference() {  
        hull() {
            translate(point)
                translate([-d3/2,-base_h,rel.z-d4/2])
                cube([d3,base_h,d4]);
            translate(point)
                translate(rel)
                rotate([90,0,0])
                cylinder(h=base_h,d=d4);
        }
        translate(point)
            translate(rel)
            rotate([90,0,0])
            raised_head_screw();
    }   
}


//
// 3D locations
// 

topleft_base=[0,0,combined_h];
topleft=[0,-screws_disp,combined_h];
topright_base=[screws_apart_dist,0,combined_h];
topright=[screws_apart_dist,-screws_disp,combined_h];

botleft_base=[0,0,0];
botleft=[0,-screws_disp,0];
botright_base=[screws_apart_dist,0,0];
botright=[screws_apart_dist,-screws_disp,0];

// connection with the casing
mount_frame_part(topleft,topleft_base,false);
mount_frame_part(topright,topright_base,false);
mount_frame_part(botleft,botleft_base);
mount_frame_part(botright,botright_base);

// rear frame
rear_frame_part(topleft_base,botleft_base);
rear_frame_part(topright_base,botright_base);
rear_frame_part(topleft_base,topright_base);
rear_frame_part(botleft_base,botright_base);

// mounting agains the wall
rear_mount(topleft_base,[-10,0,-6]);
rear_mount(topright_base,[+10,0,-6]);
rear_mount(botleft_base,[-10,0,+6]);
rear_mount(botright_base,[+10,0,+6]);
