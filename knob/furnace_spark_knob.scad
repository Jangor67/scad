// Fornuis Landhorst knopje
// 8-11-2024 geprint
//           - bovenkant naar onder werd niet erg fraai

lengte=17;
d=7.5;
button_height=3;
button_d=17;

$fa=5;
$fs=0.5;

module shaft() {
    cylinder(h=lengte,d=d);
    hull() {
        translate([0,0,lengte])
            linear_extrude(0.1)
            circle(d=d);
        translate([0,0,lengte+0.7])
            linear_extrude(0.1)
            circle(d=d/1.4);
    }
}

module button() {
    // basic button object
    translate([0,0,-button_height+0.1])
        cylinder(h=button_height,d=button_d);
    // add a smooth cap on the button
    translate([0,0,-button_height+0.1])
        scale([button_d,button_d,2])
        sphere(d=1,$fn=60);
}

shaft();
button();