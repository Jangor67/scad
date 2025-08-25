$fs = 1;
$fa = 6;

qmod1=28.8+0.2; // quarter mount outer diameter (was 30)
qmod2=24.9+0.2; // quarter mount inner diameter (was 26)

module index(inflate = 0) {
    xoffset = 20;
    difference() {
        hull() {
            scale([1,1,1]) holderBody();
            translate([xoffset,0,0]) cylinder(d=10, h=10, center=false);
        }
        shell();
        translate([xoffset+1,0,0]) cylinder(d=3, h=100, center=true);
    }
}

module shell(inflate=0, height = 10) {
    cylinder(d=36 + inflate, h=height, center=false, $fn=60);
}
module bodyCutouts() {
    // form the lip that holds the cleat tabs
    translate([0,0,1.25]) cylinder(d=qmod1, h=100, center=false, $fn=60);
    // make the through-hole for the cleat body
    cylinder(d=qmod2, h=100, center=true, $fn=60);
    // make the cutout to insert the cleat tabs
    cleatTabs(5, 1.5, 5.1, cutout = 1);
}
module bodyAdditions() {
    // 24-8-2025 it looks like that
    // the additions each make a "dent" of 0.7mm  
    // 31-28.7=2.3mm
    bad=3; // body addition diameter
    bay=(qmod1+bad)/2-0.7; // instead of 31.25/2
    
    translate([0, bay, 0]) cylinder(d=bad, h=5, center=false, $fn=30);
    #translate([0, -bay, 0]) cylinder(d=bad, h=5, center=false, $fn=30);
}
module holderBody() {
    difference() {
        shell();
        bodyCutouts();
    }
    bodyAdditions();
}
module cleatSmallCyl(height=3, inflate = 0) {
    cylinder(d=inflate + 24.9, h=height, center=false, $fn=60);
}
module cleatLargeCyl(h=1.5, inflate = 0) {
    cylinder(d=inflate + 28.6, h=h, center=false, $fn=60);
}
module cleatTabs(inflateX = 0, inflateY = 0, height = 1.5, cutout = 0) {
    intersection() {
        translate([0, 0, -cutout]) cleatLargeCyl(height + cutout, inflateX);
        cube([100, 11 + inflateY, 100], center=true);
    }
}
module indent(depth = 1, inflateX= 0, inflateY = 0) {
    hull() {
        translate([11.95 + inflateX, 0, 0]) cube([0.1, 2.5 + inflateY, depth * 2], center=true);
        translate([0, 0, -1.1]) cube([1, 0.1, 0.1], center=true);
    }
}
module indents(depth = 1) {
    indent(depth);
    rotate([0, 0, 180]) indent(depth);
}
module cleat() {
    cleatSmallCyl(3);
    cleatTabs();
}

module insertIndent(depth = 1, inflateX= 0, inflateY = 0) {
    // indent is 2.7 wide at d=23.6
    inw1=2.7;
    icd1=23.6-0.2;
    // indent is 1.3 wide at d=15
    inw2=1.3;
    icd2=15.0+0.2;
    // construct
    rotate([0, 0, 90]) hull() {
        // start from the outside
        translate([icd1/2 + inflateX - 0.1, 0, 0]) {
            cube([0.1, inw1-0.4, (depth-0.0)*2], center=true);
            cube([0.1, inw1,     (depth-0.2) * 2], center=true);
        }
        // inside
        translate([icd2/2 + inflateX, 0, 0]) {
            cube([0.1, inw2-0.4, (depth-0.2)*2], center=true);
            cube([0.1, inw2,     (depth-0.4) * 2], center=true);
        }  
        // and round it off      
        translate([icd2/2-0.2, 0, 0]) { 
            cube([0.1, inw2-0.6, (depth-0.4) * 2], center=true);
            cube([0.1, inw2-0.2, (depth-0.6) * 2], center=true);
        }
    }
}

module insert() {
    // glue-in insert to secure the cleat
    difference() {
        union() {
            cleatSmallCyl(height = 2, inflate = -0.5);
            cleatTabs(4, 1.2, height = 2);
            rotate([0, 180, 0]) insertIndent(1, 0, -0.5);
            rotate([0, 180, 180]) insertIndent(1, 0, -0.5);
        }
        // make bendy wing things
        difference() {
            cube([9, 100, 100], center = true);
            cube([7.5, 100, 100], center = true);
            cube([100, 12, 100], center = true);
        }
        cylinder(d=4, h=10, center=true);
    }
}

*translate([0, 0, 2.75]) rotate([0, 180, 90]) difference() {
    cleat();
    indents(1);
}
holderBody();
!rotate([0, 180, 0]) insert();
