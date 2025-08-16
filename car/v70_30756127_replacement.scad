// V70 30756127 trekhaakafdekkap (Tow Bar Cover) 

m=1.5;
// base size and length
bs=27; bs2=bs/2;
bl=48.5+3;

// looking into bracket from behind, 
// 90 degrees counter clockwise
// drawing only half 
// print and glue 2 parts mirrored
p=[
  // at the left inside going clockwise
  [4.20,  0.000],
  [4.20,  4.850],
  [m,     4.850],
  [m,     bs2-m],
  [bs-m,  bs2-m],
  [bs-m,  3.550],
  [bs-6.2,3.550],
  [bs-6.2,0.000],
  // at the right side inside
  [bs-6.2+m,0.000  ],
  [bs-6.2+m,3.550-m],
  [bs,      3.550-m],
  [bs,      bs2    ],
  // begin of extra support rail?
  [bs-3.10 ,bs2    ],
  [bs-3.10 ,bs2+1.9],
  [bs-6.40 ,bs2+1.9],
  [bs-6.40 ,bs2    ],
  [6.40,    bs2    ],
  [6.40,    bs2+1.9],
  [3.10,    bs2+1.9],
  [3.10,    bs2    ],
  // end of extra support rail
  [0,       bs2    ],
  [0,       4.850-m],
  [4.20-m,  4.850-m],
  [4.20-m,  0.000  ]
];


cd=20;
ch=17;

// spring on the right side
mx=2;
p2=[
  // spring between 15 and 74 mm and
  // spacing of 8
  [ 0, 48.5],
  [ 0, 74  ],
  // first bend
  [ 8, 74],
  [ 8, 15],
  [16, 15],
  [19, 12],
  // second bend (handle)
  [19+mx, 12+mx],
  [16+mx, 15+mx],
  [ 8+mx, 15+mx],
  // notch (keeping it in its place)
  [ 8+mx,     48.5],
  [ 8+mx+4.3, 48.5],
  [ 8+mx+4.3, 48.5+mx],
  [ 8+mx,     48.5+mx+4.3],
  // and go further up
  [ 8+mx, 74+mx],
  [ 0-m,  74+mx],
  [ 0-m,  48.5 ]  
];

// lip (attached to the spring)
mxl=3;
p3=[
  // going up
  [      0,0     ],
  [      0,mxl   ],
  [     -7,mxl+ 5],
  [    -11,mxl+20],
  [    -22,mxl+26],
  [    -27,mxl+26],
  // going down
  [    -27,    26],
  [-mxl-22,    26],
  [-mxl-11,    20],
  [-mxl -7,     5],
  [-mxl   ,     0]
];
p4=[
  // going up
  [      0,   -23.5],
  [      0,mxl     ],
  [     -7,mxl+ 5  ],
  [    -11,mxl+20  ],
  [    -22,mxl+26  ],
  [    -27,mxl+26  ],
  // going down
  [      -27,    26  ],
  [-mxl-11-2,    19  ],
  [-mxl -7-3,     4  ],
  [-mxl   -4,    -1  ],
  [       -7,   -23.5]
];

// lip on the top side
p5z=35;
p5=[
  // going up
  [  0,    0   ],
  [  0,   40   ],
  [ -5,   45   ],
  [  0,   50   ],
  [-mx,   50+mx],
  [-mx-5, 45+mx],
  [-mx-5, 45   ],
  [-mx-5, 45-mx],
  [-mx  , 40-mx],
  [-mx  ,  0   ] 
];

module half() {
    translate([-bs2,0,0]) {
        difference() {
            linear_extrude(height=bl) {
              polygon(p);
            }
            translate([0,-0.1,48.5])
              rotate([-90,0,0])
              cylinder(h=bs2+1.9+0.2,d=bs);
        }
    }
    translate([0,bs2,0]) rotate([-90,0,0])
        difference() {
            cylinder(h=ch,d=cd-0.01);
            translate([-cd/2,0,-0.01]) cube([cd,cd/2,ch+0.02]);
        }

    translate([bs2,0,0]) rotate([90,0,0])
        translate([0,0,-7])
        linear_extrude(height=7)
            polygon(p2);
            
    translate([bs2,0,72]) rotate([90,0,0]) {
        translate([0,0,-7]) 
          linear_extrude(height=7)
            polygon(p3);
        translate([0,0,-mxl/2])              
          linear_extrude(height=mxl/2)
            polygon(p4);    
      }
      
    translate([-bs2-m+mxl,0,p5z]) rotate([90,0,0]) {
      translate([0,0,-9])
        linear_extrude(height=9)
        polygon(p5);
    }
}

half();
mirror([0,1,0]) half();