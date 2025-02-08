// small digital scale holder

thick=19.2+0.4;
width=76.3+0.4;
height=120/2;

m=0.4*4; m2=m*2;

difference() {
    cube([width+m2, thick+m2, height]);
    translate([m,m,m])
        cube([width, thick, height]);
}
