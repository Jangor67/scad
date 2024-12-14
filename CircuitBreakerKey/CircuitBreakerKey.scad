// 14-10-2024 circuit breaker key Ida MG
// 08-11-2024 printed (zonder MG logo maar waarom)
//            - rendering duurde lang
//            - verdachte zijn de sharp corners vd handle
// Following helped a lot getting some measurements
// https://eleif.net/photomeasure

include <2024_MG_Logo_Polyhedron.scad>

key_cyl_len=28;
key_cyl_thk=9.5; // Emma measure 9.5
key_cyl_rad=key_cyl_thk/2;
key_beard_len=5.5; // Emma measured 5.55 so 5.5 is OK
key_beard_width=2;
key_beard_thk=3;
key_beard_disp_from_end=3.3;

key_ring_hole_d=4;
key_ring_hole_disp=6;
key_handle_width1=22;
key_handle_width2=13.5;
key_handle_rand_d=3;
key_handle_len=54;
key_handle_disp=16;
key_handle_sharp_corner_d=2;

$fa=1;    // minimum angle for a fragment
$fs=0.15; // minimum size for a fragment

debug=false;

module shaft () {
    cylinder(h=key_cyl_len, r=key_cyl_rad);
    zfe=key_cyl_len-key_beard_disp_from_end-key_beard_thk/2;
    zne=zfe-key_beard_len+key_beard_thk;
    //beard
    hull() {
        translate([0,0,zfe])
            rotate([0,90,0])
            cylinder(h=key_cyl_rad+key_beard_width,d=key_beard_thk);
        translate([0,0,zne])
            rotate([0,90,0])
            cylinder(h=key_cyl_rad+key_beard_width,d=key_beard_thk);    
    }
    // measure/debug
    if (debug) {
        translate([0,0,zfe+key_beard_thk/2])
            color("blue", 1.0)
            linear_extrude(key_beard_disp_from_end)
            square(size=10);
    }

    //tip of the key
    hull() {
        translate([0,0,key_cyl_len])
            linear_extrude(0.1)
            circle(r=key_cyl_rad);
        translate([0,0,key_cyl_len+0.7])
            linear_extrude(0.1)
            circle(d=3);
    }
    
    // integration with/into the handle
    hull() {
        linear_extrude(0.1)
            circle(r=key_cyl_rad);
        translate([0,0,-9])
            linear_extrude(0.1)
            polygon(points=[
                [key_cyl_rad/2,1],
                [key_cyl_rad/2,-1],
                [-key_cyl_rad/2,-1],
                [-key_cyl_rad/2,1]
            ]);
    }
}

module handle (create_edge) {
    x1=key_handle_len-key_handle_disp;
    x2=x1-key_handle_len;
    zc=key_handle_width1/2-2;
    z1=key_handle_width1/2-zc;
    z2=-key_handle_width1/2-zc;
    step=1;
    sharp=key_handle_sharp_corner_d;
    soft=key_handle_width2/2;
    points_handle = concat(
      //sharp corner around x1,z1
      [ for(i=[0:step:90]) [
          x1-sharp+sin(i)*sharp,
          z1-sharp+cos(i)*sharp]],
      // sharp corner around x1,z2
      [ for(i=[0:step:90]) [
          x1-sharp+cos(i)*sharp,
          z2+sharp-sin(i)*sharp]],
      // soft side
      [ for(i=[0:step:180]) [
          x2+soft-sin(i)*soft,
          -zc-cos(i)*soft]]
      );
    difference() {
        rotate([90,0,0])
            translate([0,0,-1])
            linear_extrude(2)
            polygon(points=points_handle);
        //hole for the key ring
        rotate([90,0,0])
            translate([
                x1-(key_ring_hole_disp),
                z2+(key_ring_hole_disp)
            ])
            rotate([0,0,90])
            cylinder(h=10,d=key_ring_hole_d,center=true);
    }
    if (create_edge) {
        for(i=[0:1:len(points_handle)-1]) {
            x=points_handle[i][0];
            z=points_handle[i][1];
            translate([x,0,z])
                sphere(d=key_handle_rand_d);
        }
        hypotenuse=key_handle_len-sharp-soft;
        opposite=(key_handle_width1-key_handle_width2)/2;
        hoek=asin(opposite/hypotenuse);
        echo("hoek is",hoek);
        translate([x1-sharp,0,z1])
            rotate([0,-90-hoek,0])
            linear_extrude(hypotenuse)
            circle(d=key_handle_rand_d);
        translate([x1,0,z1-sharp])
            rotate([0,180,0])
            linear_extrude(key_handle_width1-sharp-sharp)
            circle(d=key_handle_rand_d);
        translate([x1-sharp,0,z2])
            rotate([0,-90+hoek,0])
            linear_extrude(hypotenuse)
            circle(d=key_handle_rand_d);
    }
}

rotate([0,90,0])
    color("yellow", 1.0)
    shaft();
rotate([0,90,0])
    color("yellow", 1.0)
    handle(true);
rotate([90,0,0])
    translate([-10,-17,1])
    scale([0.5,0.5,0.6])
    rotate([0,0,90])
    mgLogo();
