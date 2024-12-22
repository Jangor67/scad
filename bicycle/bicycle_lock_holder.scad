// fietsslot houder
// maatvoering mm (105 is 105mm)
// 2024-08-18 v1
// 2024-09-17 v2

include <MCAD/boxes.scad>

//https://github.com/JohK/nutsnbolts.git
include <nutsnbolts/cyl_head_bolt.scad>
include <nutsnbolts/materials.scad>

print_afdichtdop=false;
print_onderkant=false;
print_bovenkant=!print_onderkant &&!print_afdichtdop;

if (print_onderkant) {
    echo("print onderkant");
}
if (print_bovenkant) {
    echo("print bovenkant");
}
if (print_afdichtdop) {
    echo("print afdichtdop");
}

// hoofdblok (maat komt van het slot)
//   voorzien van 
//     2 gaten voor de slotbeugel
hblk_b=105; // breedte
hblk_d=30;  // diepte
hblk_dk=30; // dikte

// beugel van het slot
bgl_d=17.5;   // diameter inclusief bescherming
              // 18-9-2024: 17 is te krap
              //            (17/2+0.1 is te krap) 
bgl_stk=60;   // steek
              // 27-9-2024: variatie 60.5-58.2
              // ofwel 0.5 - -1.8
              // bgl diameter kan dit gaan compenseren
bgl_hs=1.106; // 17 * 1.106 = 18.8 

// montageblok voorzien van
//   1 gat voor bagagedragerstang
//   4 montagegaten M4/M5
mblk_b=40;
mblk_d=hblk_d; // diepte
mblk_dk=15;    // dikte

mblk_z=(-hblk_dk-mblk_dk)/2+0.001;
echo("mblk_z: ", mblk_z);

// bagagedragerstang aka montagestang
//   dwarsstang is 1,7mm verzonken tov lengestangen
//   verder is deze stang 10.2mm (want powdercoated)
mstng_d=10.2;
mstng_disp=1.7;

// -  M4   M5
// dk 7,22 8,72 diameter-kop
// gangbare lengte (onder de kop) 16/20/25/30/35
m4bt_dk=7.42;
m4=4;

// moer:
// -        M4  M5
// dikte    3,5 3,5
// diameter 6,9 7,9
m4mr_dk=3.5;
m4mr_b=6.9;

afw_r=1.6; //afwatering gaatjes

$fa=1;
$fs=0.15;

module beugel_doorvoer() {
    straal=bgl_d/2;
    hoogte=hblk_d+1;
    rotate([90,0,0])
        scale([bgl_hs,1,1]) union() {
            cylinder(h=hoogte,r=straal,center=true);
            for (i=[0:36:360]) {
                x = straal * cos(i);
                y = straal * sin(i);
                translate([x,y,0])
                    cylinder(h=hoogte,r=1.2,center=true);
            rotate([-90,0,0])
                union() {
                    translate([straal*cos(72),0,-hblk_dk/2])
                    cylinder(h=hblk_dk,r=afw_r,center=true);
                    translate([straal*cos(108),0,-hblk_dk/2])
                    cylinder(h=hblk_dk,r=afw_r,center=true);
                }
            }
        }
}

flens=0.2+0.15*6; //eerste laag 0.2, volgende 0.15

module afdichtdop() {
    // flens uitsparing voor afdichtdopjes
    snug_fit=0.2;
    
    straal=m4bt_dk/2 - snug_fit;
        scale([1,1.3,1])
        cylinder(h=flens, r=straal, center=false);
    // snug fit hol
    difference() {
        cylinder(h=flens*4,r=straal, center=false);
        cylinder(h=flens*4+0.1,r=straal-0.4*2, center=false);
    }
}

module montage_gat() {
    union() {
        // verzonken kop
        rotate([0,0,90])
            cylinder(h=hblk_dk+0.01, r=m4bt_dk/2, center=true);
        // flens uitsparing voor afdichtdopjes
        translate([0,0,15.3-flens])
            rotate([0,0,90])
            scale([1,1.3,1])
            cylinder(h=flens+1, r=m4bt_dk/2, center=true);
        // doorvoer
        translate([0,0,mblk_z])
            rotate([0,0,90])
            cylinder(h=mblk_dk+8, r=m4/2, center=true);
        //afwatering
        r_afwatering=afw_r;
        translate([0,0,-14.22+r_afwatering/2])
            rotate([90,0,0])
            cylinder(h=hblk_dk+20,r=r_afwatering, center=true);
        //uitsparing moer
        translate([0,0,mblk_z-mblk_dk/2])
            rotate([180,0,0])       
            nutcatch_parallel("M4", clh=0.9);    
    }
}

// posities montagegaten
mx1=mblk_b/2-m4bt_dk;
my1=-mblk_d/2+m4bt_dk-0.5;
mx2=-mblk_b/2+m4bt_dk;
my2=mblk_d/2-m4bt_dk+0.5;

// hoofdblok
if (print_bovenkant) {
    difference() {
        roundedBox(size=[hblk_b,hblk_d,hblk_dk],radius=3,sidesonly=false);

        translate([bgl_stk/2,0,0])
            beugel_doorvoer();
        translate([-bgl_stk/2,0,0])
            beugel_doorvoer();
        
        // montage doorvoer M4 of M5
        // rechts voor
        translate([mx1,my1,0])
            montage_gat();
        // links voor
        translate([mx2,my2,0])
            montage_gat();
        // rechts achter
        translate([mx2,my1,0])
            montage_gat();
        // links achter
        translate([mx1,my2,0])
            montage_gat(); 
    }   
}


// montage blok bagagedrager
difference() {
    translate([0,0,mblk_z+4])
        roundedBox(size=[mblk_b,mblk_d,mblk_dk+8],radius=3,sidesonly=false);
    
    // montage doorvoer M4 of M5
    // rechts voor
    translate([mx1,my1,0])
        montage_gat();
    // links voor
    translate([mx2,my2,0])
        montage_gat();
    // rechts achter
    translate([mx2,my1,0])
        montage_gat();
    // links achter
    translate([mx1,my2,0])
        montage_gat();    
    
    // bagagedragerstang
    stang_z=(-hblk_dk-mstng_d)/2-mstng_disp;
    translate([0,0,stang_z])
      union() {
        rotate([0,90,0])
            cylinder(h=mblk_b+0.1,r=mstng_d/2,center=true);
        //afwateringsgaten
        afstand=(mblk_b-m4bt_dk)/4;
        translate([0,0,-mstng_d/2])
            cylinder(h=mstng_d,r=afw_r,center=true);
        translate([-afstand,0,-mstng_d/2])
            cylinder(h=mstng_d,r=afw_r,center=true);
        translate([afstand,0,-mstng_d/2])
            cylinder(h=mstng_d,r=afw_r,center=true);
      }     
    // wegsnijden onderkant/bovenkant voor printen in 2 delen
    if (!print_onderkant) {
        translate([0,0,stang_z-(mblk_dk+8)/2])
            cube([mblk_b+0.1,mblk_d+0.1,mblk_dk+8+0.1],center=true);
    } 
    if (!print_bovenkant) {
        translate([0,0,stang_z+(mblk_dk+8)/2])
            cube([mblk_b+0.1,mblk_d+0.1,mblk_dk+8+0.1], center=true);
    }
    
    echo("mblk_z+4: ", mblk_z+4);
    echo("mblk_dk+8: ", mblk_dk+8);
        translate([8,-3.5,mblk_z+4-(mblk_dk+8)/2-0.01])
            linear_extrude(0.4)
            rotate([0,180,0])
            union() {
                text("JG",size=9,spacing=0.6,direction="ltr");
                translate([0,-4.8,0])
                    text("2024 v2",size=4,spacing=0.9,direction="ltr");
            }
}

if (print_afdichtdop) {
    translate([0,0,0])
        afdichtdop();
    translate([0,10,0])
        afdichtdop();
    translate([10,0,0])
        afdichtdop();
    translate([10,10,0])
        afdichtdop();
}

       // translate([0,0,m-(mblk_dk+8)/2])

