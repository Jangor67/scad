// GasFornuis Landhorst knoppen
// Versie 1
//   - wand te dun
//   - braille is niet erg goed gelukt
// Versie 2
//   Aanpassingen
//   - Wand is nu aangepast (4x)
//   - braille wat aangepast
//   Test
//   - past niet op spindle
//   - spindle meet 6mm (platte stuk 4.5mm)
//   - hoogte knop is overigens met 19.5 nog een stukje hoger! 
// Versie 3
//   Aanpassingen
//   - extra gaatje "geboord" in het midden van 6mm

knop_links=true;
knop_voor=true;

knop_rechts=!knop_links;
knop_achter=!knop_voor;

wand=2.0; hwand=wand/2; dwand=wand*2;

knop_h=13+wand;
hoofd_d=38.5; hoofd_r=hoofd_d/2;
hoofd_h=5.5;
handvat_d=19.5; handvat_r=handvat_d/2;
handvat_h=knop_h-hoofd_h;

$fa=1; // min facet angle
$fs=1; // min facet size

module knop() {
    // basis
    difference() { 
        cylinder(h=hoofd_h, d=hoofd_d);
        translate([0,0,-wand])
            cylinder(h=hoofd_h, r=hoofd_r-wand);
        hull() {
            offset=(hoofd_d - handvat_d - hwand) / 2;
            translate([0,-offset,hoofd_h-wand-0.1])
                cylinder(h=handvat_h, d=handvat_d-dwand);
            translate([0, offset,hoofd_h-wand-0.1])
                cylinder(h=handvat_h, d=handvat_d-dwand);
        }
    }
    // ovale handvat
    difference() {
        hull() {
            offset=(hoofd_d - handvat_d) / 2;
            translate([0,-offset,hoofd_h-0.1])
                cylinder(h=handvat_h, d=handvat_d);
            translate([0, offset,hoofd_h-0.1])
                cylinder(h=handvat_h, d=handvat_d);
        };
        hull() {
            offset=(hoofd_d - handvat_d - hwand) / 2;
            translate([0,-offset,hoofd_h-wand-0.1])
                cylinder(h=handvat_h, d=handvat_d-dwand);
            translate([0, offset,hoofd_h-wand-0.1])
                cylinder(h=handvat_h, d=handvat_d-dwand);
        };
        braille(knop_links,knop_voor);
    }
    // add the smooth stuff
    intersection() {
        cylinder(h=knop_h, d=hoofd_d);
        smooth_handle();
    }
}

module asmontage() {
    // montage op de as
    width1=11.5; hwidth1=width1/2;
    width2=7.3;  hwidth2= width2/2;
    wall=1.55;   hwall=wall/2; dwall=wall*2;
    handvat_r2 = handvat_r - wand + 0.1;
    linear_extrude(knop_h-0.1) {
        difference() {
            // outside (including extra support)
            polygon(points=[
              [-hwidth2,      -hwidth1], // 0 bot left
              [  -hwall,      -hwidth1],
              [  -hwall,      -hwidth1-dwall],
              [   hwall,      -hwidth1-dwall],
              [   hwall,      -hwidth1],
              [ hwidth2,      -hwidth1], // 1 bot right
              [ hwidth2,      -hwidth2], // 2 nodge up
              [ hwidth1,      -hwidth2], // 3 nodge right
              [ hwidth1,      -hwall],
              [ handvat_r2,   -hwall],
              [ handvat_r2,    hwall],
              [ hwidth1,       hwall],
              [ hwidth1,       hwidth2], // 4 top right
              [ hwidth2,       hwidth2], // 5 nodge left
              [ hwidth2,       hwidth1], // 6 nodge up
              [   hwall,       hwidth1],
              [   hwall,       hwidth1+dwall],
              [  -hwall,       hwidth1+dwall],
              [  -hwall,       hwidth1],
              [-hwidth2,       hwidth1], // 7 top left
              [-hwidth2,       hwidth2], // 8 nodge down
              [-hwidth1,       hwidth2], // 9 nodge left
              [-hwidth1,       hwall],
              [-handvat_r2,    hwall],
              [-handvat_r2,   -hwall],
              [-hwidth1,      -hwall],
              [-hwidth1,      -hwidth2], //10 bot left
              [-hwidth2,      -hwidth2]  //11 nodge right
            ]);
            // inside
            polygon(points=[
              [-hwidth2+wall, -hwidth1+wall], // 0 bot left
              [        -hwall,-hwidth1+wall], // 1
              [        -hwall,-hwidth2+wall], // 2
              [        +hwall,-hwidth2+wall], // 3
              [        +hwall,-hwidth1+wall], // 4
              [ hwidth2-wall, -hwidth1+wall], // 5 bot right
              [ hwidth2-wall, -hwidth2+wall], // 6 nodge up
              [ hwidth1-wall, -hwidth2+wall], // 7 nodge right
              [ hwidth1-wall, -hwall       ], // 8
              [ hwidth2-wall, -hwall       ], // 9
              [ hwidth2-wall,  hwall       ], // 10
              [ hwidth1-wall,  hwall       ], // 11
              [ hwidth1-wall,  hwidth2-wall], // 12 top right
              [ hwidth2-wall,  hwidth2-wall], // 13 nodge left
              [ hwidth2-wall,  hwidth1-wall], // 14 nodge up
              [        -hwall, hwidth1-wall], // 15
              [        -hwall, hwidth2-wall], // 16
              [         hwall, hwidth2-wall], // 17
              [         hwall, hwidth1-wall], // 18
              [-hwidth2+wall,  hwidth1-wall], // 19 top left
              [-hwidth2+wall,  hwidth2-wall], // 20 nodge down
              [-hwidth1+wall,  hwidth2-wall], // 21 nodge left
              [-hwidth1+wall,  hwall       ], // 22
              [-hwidth2+wall,  hwall       ], // 23
              [-hwidth2+wall, -hwall       ], // 24
              [-hwidth1+wall, -hwall       ], // 25
              [-hwidth1+wall, -hwidth2+wall], // 26 bot left
              [-hwidth2+wall, -hwidth2+wall]  // 27 nodge right
            ]);
            // drill it a bit wider
            circle(d=6);
        }
    }
}

module smooth_handle() {
    //points are on x,z axis
    straal=4.5;
    offset=(hoofd_d - handvat_d) / 2;
    pnts = [
        [-handvat_r,0],
        for(i=[0:5:90]) ([
            sin(i) * straal - straal - handvat_r, 
            cos(i) * straal - straal
            //sin(i) * straal - straal - handvat_r, 
            //cos(i) * straal - straal
        ])
    ];
    for (pnt = pnts) echo(pnt); 
    echo(offset);
    translate([0,-offset,hoofd_h])
        rotate([-90,0,0])
        linear_extrude(2*offset)
        polygon(points=pnts);
    translate([0,offset,hoofd_h])
        rotate([180,0,0])
        rotate_extrude(angle=180)
        polygon(points=pnts);
    translate([0,-offset,hoofd_h])
        rotate([180,0,180])
        rotate_extrude(angle=180)
        polygon(points=pnts);
    translate([0,offset,hoofd_h])
        rotate([-90,0,180])
        linear_extrude(2*offset)
        polygon(points=pnts);
}

module braille(links,voor) {
    //braille_v1(links,voor);
    braille_v2(links,voor);
}

module braille_v1(links,voor) {
    punt_d=3;
    offset=hoofd_d/2 - punt_d - 1.5 - 12;
    offset2=punt_d/2+0.2;
    x = links ? offset2 : -offset2;
    y = voor  ? offset+offset2 : offset-offset2; 
    translate([x,y,knop_h])
        scale([1,1,0.4])
        sphere(d=punt_d,$fn=30);
}

module braille_v2(links,voor) {
    punt_d=4;
    offset=hoofd_d/2 - punt_d - 1.5;
    offset2=punt_d/2+0.4;
    x = links ? offset2 : -offset2;
    y = voor  ? offset+offset2 : offset-offset2; 
    translate([x,y,knop_h])
        scale([1,1,0.5])
        sphere(d=punt_d,$fn=30);
}

knop();
asmontage();

if (knop_rechts || knop_achter) braille(true,  true);
if (knop_rechts || knop_voor)   braille(true,  false);
if (knop_links  || knop_achter) braille(false,  true);
if (knop_links  || knop_voor)   braille(false, false);
