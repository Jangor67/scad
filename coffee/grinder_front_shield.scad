// Coffee Grinder front shield
// v1 was a bit too wide and side corners angled
// v2 is made slimmer and smaller and side corners parallel 

thick=9.6-3.6;  // correct the original thickness (slimmer look)
width=50-20;    // correct width as well (smaller looks better)
height=72-8;    // originele schild is minder hoog 
curve_d=140-20; // first print showed the the model warps and
                // we seem to need to compensate for this
curve_r1=curve_d/2;
curve_r2=curve_r1+thick;

mount_h=31-4;
mount_d1=6;
mount_d2=10.7;

// use to smoothen edges
smooth_r=3;

angle1 = 180 * width / PI / curve_r1;
angle2 = 180 * smooth_r / PI / curve_r1;
angle3 = angle2+angle1/2;

$fn=60;

// attached to the base object for smooth sides
module side(
    r1 = smooth_r,
    r2 = curve_r1,
    r3 = curve_r2,
    h  = height,
    a  = angle3
) {
  d1 = 2*r1;
  difference() {
    hull() {
        translate([r2,0,r1])
            sphere(r=r1);
        translate([r2,0,h-r1])
            sphere(r=r1);
        translate([r3-r1,0,r1]) {
            sphere(r=r1);
            rotate([0,0,a])
              translate([r2-r3,0,0])
                sphere(r=r1);
        }
        translate([r3-r1,0,h-r1]) {
            sphere(r=r1);
            rotate([0,0,a])
              translate([r2-r3,0,0])
                sphere(r=r1);
        }
    }
    translate([0,0,-0.1])
        cylinder(h=h+0.2, r=r2, $fn=180);
  }
}
*side();

// base object with smooth top and bottom
module base(
  r1 = smooth_r,
  r2 = curve_r1,
  r3 = curve_r2,
  h  = height,
  step = 90/30
) {
    points_cone = concat(
      // bottom inside
      [[r2,0]],
      // bottom corner
      [ for(i=[0:step:90]) [
          r3-r1+sin(i)*r1,
          r1-cos(i)*r1]],
      // top corner
      [ for(i=[0:step:90]) [
          r3-r1+cos(i)*r1,
          h-r1+sin(i)*r1]],
      [[r2,h]]
    );
    polygon(points_cone);
}
*base();

module pieSliceBase(
  a,  // angle
  r1, // inner radius
  r2, // outer radius
  h   // height
){
    rotate_extrude(angle=a, $fn=250) base();
}

rotate([0,0,-angle3]) difference() {
    union() {
        rotate([0,0,angle2])
            side();
        rotate([0,0,angle2])
            pieSliceBase(angle1, curve_r1, curve_r2, height);
        rotate([0,0,angle2+angle1])
            side(a=-angle3);
    }
    translate([0,0,mount_h])
        rotate([0,90,angle3])
        union() {
            cylinder(h=curve_r2+0.1,d=mount_d1);
            translate([0,0,curve_r1+4])
                cylinder(h=thick,d=mount_d2);
        }
}