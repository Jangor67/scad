//
// Bordje 75 x 17 x 3 mm met twee tekstregels
// Tekst aanpasbaar bovenaan
//

// Some material definitions
// defaults in prusa slicer 0.15 height (0.2 first layer)
layer_1=0.2;
layer_n=0.15;
nozzle=0.4;
wall=nozzle*2;
$fn=50;


pt2size=3.937; 
// from pt to size divide by pt2size
// from size to pt multiply by pt2size

// 3.56mm=14pt, 
// 3.81mm=15pt is prima leesbaar maar misschien beter als text2
// 2.54mm=10pt maar komt niet leesbaar uit de verf

// -----------------------------
// Instelbare parameters
// -----------------------------
haak_d       = 3.5+0.2; // voeg wat marge toe
margin_left  = haak_d+wall*6; // margins (links en boven)
line_spacing = 2.0;   // verticale ruimte tussen regels

text1_size   = 30 / pt2size;
text2_size   = 20 / pt2size;  
text_depth   = layer_n*4;   // hoogte van reliëftekst (raised)

echo ("text1: ", text1_size);
echo ("text2: ", text2_size);

plate_width  = 150;
plate_height = line_spacing*3+text1_size+text2_size;
plate_thick  = layer_1+layer_n * 7;

font_main    = "Liberation Sans:style=Bold";
font_small   = "Liberation Sans:style=Regular";


// -----------------------------
// Model
// -----------------------------

module hole(h=plate_thick+0.01, d=haak_d) {
  hull() {
      cylinder(h=h,d=d);
      translate([0,-1.2,0])
        cylinder(h=h,d=d);
  }
}
module plaat() {
  difference() {
    // Plaat
    color("black", 1.0) 
      cube([plate_width, plate_height, plate_thick]);
    translate([margin_left/2,plate_height-margin_left/2,-0.01])
      hole();
    translate([plate_width-margin_left/2,plate_height-margin_left/2,-0.01])
      hole();
    
  }
}

module rand() {
  translate([0,0,plate_thick-0.001]) {
    color("white", 1.0)
      difference() {
        cube([plate_width, plate_height, text_depth+0.001]);
        translate([0.8,0.8,-0.1])
          cube([plate_width-1.6, plate_height-1.6, text_depth+0.2]);
      }
    color("white", 1.0)
    translate([margin_left/2,plate_height-margin_left/2,-0.01])
      difference() {
        hole(h=text_depth+0.001,d=haak_d+wall*2);
        translate([0,0,-0.1])
        hole(h=text_depth+0.2,d=haak_d);
      }
    color("white", 1.0)  
    translate([plate_width-margin_left/2,plate_height-margin_left/2,-0.01])
      difference() {
        hole(h=text_depth+0.001,d=haak_d+wall*2);
        translate([0,0,-0.1])
        hole(h=text_depth+0.2,d=haak_d);
      }
    //}
  }
}

// -----------------------------
// **Raised text** (bovenop het bordje)
// -----------------------------
module tekst(text1, text2) {
  translate([margin_left,plate_height,plate_thick-0.01]) {
    translate([0, -text1_size - 2, 0])
      linear_extrude(text_depth)
        color("red", 1.0)
        text(text1, size=text1_size, font=font_main);

    translate([0, -text1_size -text2_size - line_spacing - 2, 0])
      linear_extrude(text_depth)
        color("red", 1.0)
        text(text2, size=text2_size, font=font_main);
  }
}

plaat();
rand();
tekst("om te stoken", "indien leeg 1 vak naar rechts opschuiven");

translate([0,plate_height+10]) {
  plaat();
  rand();
  tekst("vullen", "indien vol 1 vak naar rechts opschuiven");
}