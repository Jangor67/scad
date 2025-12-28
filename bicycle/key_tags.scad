// Sleutelhanger

// Some material definitions
// defaults in prusa slicer 0.15 height (0.2 first layer)
layer_1=0.2;
layer_n=0.15;
nozzle=0.4;
wall=nozzle*2;
$fn=50;

pt2size=3.937; 
charw=5;

text_size    = 25 / pt2size;
text_depth   = layer_n*4;   // hoogte van reliëftekst (raised)
line_spacing = 2.0;         // verticale ruimte tussen regels
margin_left  = 2.0;

plate_width  = 12;
plate_height = line_spacing*2+text_size;
plate_thick  = layer_1+layer_n * 7;

font_main    = "Liberation Sans:style=Bold";
font_small   = "Liberation Sans:style=Regular";

// -----------------------------
// **Raised text** (bovenop het bordje)
// -----------------------------
module tekst(
    icon_filename, 
    text, 
    text_size=text_size,
    text_depth=text_depth) {
    
  translate([margin_left,line_spacing,plate_thick-0.01]) {
    translate([0,-13,0]) 
      linear_extrude(text_depth)
        import(icon_filename);
    translate([text_size+1, 0, 0])
      linear_extrude(text_depth)
        text(text, size=text_size, font=font_main);
  }
}

module label(
  plate_height=plate_height,
  plate_width=plate_width,
  plate_thick=plate_thick) 
{
  translate([0,plate_height/2,0]) {
    translate([plate_height/2,0,0]) {
      // central plate
      hull() {
        cylinder(h=plate_thick,d=plate_height);
        translate([plate_width-plate_height,0,0])
          cylinder(h=plate_thick,d=plate_height);
      }
      // raised edges  
      difference() {
        hull() {
          cylinder(h=plate_thick+text_depth,d=plate_height);
          translate([plate_width-plate_height,0,0])
            cylinder(h=plate_thick+text_depth,d=plate_height);
        }
        translate([wall/4,wall/4,0]) hull() {
          cylinder(h=plate_thick+text_depth+0.01,d=plate_height-wall);
          translate([plate_width-plate_height+0.01,0,0])
            cylinder(h=plate_thick+text_depth,d=plate_height-wall);
        }      
      }
    }
    // keyring connection
    montage_ring_d=3.5+nozzle*2*4;
    translate([-3.5/2-nozzle,0,0]) difference() {
      hull() {
        cylinder(h=plate_thick,d=montage_ring_d);
        translate([5,0,0])
          cylinder(h=plate_thick,d=montage_ring_d); 
      }
      translate([0,0,-0.01])
      cylinder(h=plate_thick+0.02,d=3.5);
    }   
  }
}

spacing=plate_height+5;

data = [
 [ "Hido", "electric_bike_24dp_1F1F1F_FILL0_wght400_GRAD0_opsz24.svg", plate_width+charw*3.8 ],
 [ "Hido", "pedal_bike_24dp_1F1F1F_FILL0_wght400_GRAD0_opsz24.svg", plate_width+charw*3.8 ],
 
 [ "Idworx", "directions_bike_24dp_1F1F1F_FILL0_wght400_GRAD0_opsz24.svg", plate_width+charw*5.5 ],
 
 [ "Franka","styler_24dp_1F1F1F_FILL0_wght400_GRAD0_opsz24.svg", plate_width+charw*5.7],
[ "Franka","chef_hat_24dp_1F1F1F_FILL0_wght400_GRAD0_opsz24.svg", plate_width+charw*5.7],
 
 [ "Onno", "chess_knight_24dp_1F1F1F_FILL0_wght400_GRAD0_opsz24.svg", plate_width+charw*4.3 ],
 [ "Onno", "sports_mma_24dp_1F1F1F_FILL0_wght400_GRAD0_opsz24.svg", plate_width+charw*4.3 ],
 
 [ "Marleen", "rowing_24dp_1F1F1F_FILL0_wght400_GRAD0_opsz24.svg", plate_width+charw*6.5 ],
 [ "Marleen", "stethoscope_24dp_1F1F1F_FILL0_wght400_GRAD0_opsz24.svg", plate_width+charw*6.5 ],
 
 //[ "Test1", "air_24dp_1F1F1F_FILL0_wght400_GRAD0_opsz24.svg", plate_width ],
 //[ "Test2", "rheumatology_24dp_1F1F1F_FILL0_wght400_GRAD0_opsz24.svg", plate_width ],
 //[ "Test3", "rowing_24dp_1F1F1F_FILL0_wght400_GRAD0_opsz24.svg", plate_width+charw*4 ],
];

for (i=[0:len(data)-1]) {
  echo ("label: ", i, ": ", data[i][0]);
  translate([0,spacing*i,0]) {
    label(plate_width=data[i][2]);
    tekst(data[i][1],data[i][0]);
  }
}
  