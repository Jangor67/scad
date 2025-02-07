// Battery holder for the classic logitech k750 keyboard
// https://www.ifixit.com/Guide/Logitech+K750+Keyboard+Battery+Replacement/23376
// Perhaps it can be improved a bit more to create some
// lock notches that can also be operated from outside of the housing...
//

slot_w=30-0.4;
slot_d=29.6;
slot_t=4-0.2;

bat_d=20+0.4;
bat_t=3.2;

include <MCAD/boxes.scad>

$fn=50;

difference() {
    translate([slot_w/2,slot_d/2,slot_t/2])
        roundedBox(
                size=[slot_w,slot_d,slot_t],
                radius=1,
                sidesonly=false);
    * cube([slot_w,slot_d,slot_t]);
    // place for the battery 
    translate([slot_w/2,slot_d-bat_d/2,slot_t-bat_t+0.2])
        cylinder(d=bat_d,h=3.2);
    // don't fill up the entire slot
    translate([-0.01,slot_d-5,-0.01])
        cube([slot_w+0.02,5+0.01,slot_t+0.02]);
    // allow to remove it once it is placed in the keyboard
    translate([5,2,-0.01])
        cube([slot_w-10,3,slot_t+0.02]);
}