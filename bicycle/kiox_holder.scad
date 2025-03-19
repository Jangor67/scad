// Bosch Kiox display holder

// point 0,0,0 is at the center of the magnetic part

// Some material definitions
// defaults in prusa slicer 0.15 height (0.2 first layer)
layer_1=0.2;
layer_n=0.15;

// overall (max measurements)
disp_w=46.4; // rough measurement
disp_l=67.8; // also rough measurement
// base
base_w=36.6;
base_l=52.8;

// oval part which holds the display in place
magnet_part_d1=8.4;
magnet_part_d2=20.4-magnet_part_d1;
magnet_part_h=1.7;

top_disp=24.4-magnet_part_d1/2; // from the top

// nodge to align the display at the bottom
nodge_th=2.3;
nodge_w=20.6;
base_a_disp=39.25+magnet_part_d1/2;
base_ab_disp=-3;
base_ac_disp=3.65-3.25;
base_ad_disp=3.65;
base_d_disp=base_a_disp+base_ad_disp;
height_a=magnet_part_h;
height_b=height_a+2;
height_c=height_a+10.85;
height_d=height_a+12.8;

module magnet_part(
        d1=magnet_part_d1+0.2,
        d2=magnet_part_d2,
        h=magnet_part_h,
        fix=0.1        
    ) {
    hull() {
        // make heigt a bit smaller to really have
        // the magnets stick (no air in between)
        translate([-d2/2,0,fix+0.001])
            cylinder(h=h-fix,d=d1);
        translate([d2/2,0,fix+0.001])
            cylinder(h=h-fix,d=d1);
    }
}

module magnets(
        d1=magnet_part_d1+0.2,
        d2=magnet_part_d2,
        h=magnet_part_h,
        fix=0.1,
        magnet_w=5,
        magnet_h=1+0.6 // plus double sided tape thickness
    ) {
    translate([0,-magnet_w/2,-magnet_h+fix+0.002-layer_n*1]) {
        translate([(-d2-magnet_w)/2,0,0])
            cube([magnet_w,magnet_w,magnet_h]);
        translate([( d2-magnet_w)/2,0,0])
            cube([magnet_w,magnet_w,magnet_h]);
    }
}

// model countersunk screw for 3d printing
// useful for creating attachement bores
// which fit these screws
// default values are for 3mm x 20mm screw with 6mm head (3.2mm bore for tolerance)
module screw_countersunk(
        z  = height_a, //displacement z
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
*translate([-disp_w/4,-10,0.1]) screw_countersunk();


module back_plate(
    ) {
    
    // a is base plane
    za=height_a;
    xa1=19.5/2; ya1=00.0;
    xa2=22.0/2; ya2=03.4; 
    xa3=25.0/2; ya3=ya2;
    xa4=31.4/2; ya4=24.2;
    xa5=35.8/2; ya5=ya4;
    xa6=32.8/2; ya6=53.0;
    points_a = [
        [-xa1,ya1,za],
        [-xa2,ya2,za],
        [-xa3,ya3,za],
        [-xa4,ya4,za],
        [-xa5,ya5,za],
        [-xa6,ya6,za],
        [ xa6,ya6,za],
        [ xa5,ya5,za],
        [ xa4,ya4,za],
        [ xa3,ya3,za],
        [ xa2,ya2,za],
        [ xa1,ya1,za]
    ];
    
    // c is just below display
    zc=height_c;
    xc3=35.0/2;   yc3=base_ab_disp;
    xc4=40.2/2;   yc4=base_ab_disp+16.65;
    xc5=xc4+2.45; yc5=yc4;
    xc6=41.5/2;   yc6=base_ab_disp+62.9;
    points_c = [
        [-xc3,yc3,zc],
        [-xc4,yc4,zc],
        [-xc5,yc5,zc],
        [-xc6,yc6,zc],
        [ xc6,yc6,zc],
        [ xc5,yc5,zc],
        [ xc4,yc4,zc],
        [ xc3,yc3,zc]
    ];

    // b is just a nodge above base plane
    zb=height_b;
    zab=za+(zb-za)*0.3; 
    xb1=xa1; yb1=ya1;
    xb2=xa2; yb2=ya2;
    points_b = [
        [-xb1,yb1,zab], 
        [-xb2,yb2,zb],
        [ xb2,yb2,zb],
        [ xb1,yb1,zab]
    ];
    
    // each layer has 12 points
    // when looking on the display with screen face down
    // faces go counter clockwise
    faces= [
      // a or bot 0-11
      [ for (i = [11:-1:0]) i ],
      // nodge
      [0,1,13,12],[10,11,15,14],[0,12,15,11],[12,13,14,15],
      // bottom
      [1,2,16,23,9,10,14,13],
      // right side
      [2,3,17,16],[3,4,18,17],[4,5,19,18],
      [5,6,20,19], //top
      [6,7,21,20],[7,8,22,21],[8,9,23,22],
      // c or top 16-23
      [ for (i = [16:23]) i ],
    ];
    
    difference() {
        translate([0,-base_a_disp,0])
            polyhedron(
                points=concat(points_a,points_b, points_c),
                faces=faces,
                convexity=1000);
    }
}

module kiox() {
    magnet_part();
    back_plate();
}

m=2.1; //material thickness
difference() {
    translate([-disp_w/2,-base_d_disp,-m])
        cube([disp_w,disp_l-13.5,m+height_c-1]);
    kiox();
    magnets();
    translate([-disp_w/4,-10,0.01]) screw_countersunk();
    translate([ disp_w/4,-10,0.01]) screw_countersunk();
    translate([        0,-35,0.01]) screw_countersunk();
}
