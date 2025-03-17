// Bosch Kiox display holder

// point 0,0,0 is at the center of the magnetic part

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
        h=magnet_part_h-0.1        
    ) {
    hull() {
        translate([-d2/2,0,0])
            cylinder(h=h,d=d1);
        translate([d2/2,0,0])
            cylinder(h=h,d=d1);
    }
}

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
    zab=za+(zb-za)*0.3; //
    bf=(zb-za)/(zc-za);
    xb1=xa1;              yb1=ya1;
    xb2=xa2;              yb2=ya2;
    xb3=xa3+bf*(xc3-xa3); yb3=ya3+bf*(yc3-ya3);
    xb4=xa4+bf*(xc4-xa4); yb4=ya4+bf*(yc4-ya4);
    xb5=xa5+bf*(xc5-xa5); yb5=ya5+bf*(yc5-ya5);
    xb6=xa6+bf*(xc6-xa6); yb6=ya6+bf*(yc6-ya6);
    points_b = [
        [-xb1,yb1,zab], 
        [-xb2,yb2,zb],
        [-xb3,yb3,zb],
        [-xb4,yb4,zb],
        [-xb5,yb5,zb],
        [-xb6,yb6,zb],
        [ xb6,yb6,zb],
        [ xb5,yb5,zb],
        [ xb4,yb4,zb],
        [ xb3,yb3,zb],
        [ xb2,yb2,zb],
        [ xb1,yb1,zab]
    ];
    
    // each layer has 12 points
    // when looking on the display with screen face down
    // faces go counter clockwise
    faces= [
      [24,25,26,27,28,29,30,31],   // c or top 24-31
      
      // connect b with c
      [24,25,15,14],[25,26,16,15],[26,27,17,16], //right
      [27,28,18,17], // top
      [28,29,19,18],[29,30,20,19],[30,31,21,20], // left
      [24,14,13,22,21,31],

      // connect a with b
      [12,13,1,0],[13,14,2,1,],[14,15,3,2],[15,16,4,3],[16,17,5,4], // right
      [17,18,6,5], // top
      [18,19,7,6],[19,20,8,7],[20,21,9,8],[21,22,10,9],[22,23,11,10], // left
      [23,12,0,11], [22,23,12,13], // bottom
      
      [0,1,2,3,4,5,6,7,8,9,10,11], // a or bottom 0-11      
    ];
    
    difference() {
        translate([0,-base_a_disp,0])
            polyhedron(
                points=concat(points_a,points_b, points_c),
                faces=faces,
                convexity=10);
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
}
