// V70 30756127 trekhaakafdekkap (Tow Bar Cover) 
// version 2 extra reinforcement and some fixes

m=1.5;
// base size and length
bs=27; bs2=bs/2;
bl=48.5+3;

// looking into bracket from behind, 
// 90 degrees counter clockwise
// drawing only half (mirror other half) 
p10=[
  // at the left inside going clockwise
  // higher and less deep nodge
  // select -Z to view this!
  [4.20,     0.000],
  [4.20,     4.850],
  [m,        4.850],
  [m,        8.400],
  [m+0.4,    8.400],
  [m+0.4,    9.400],
  [m,        9.400],
  [m,        bs2-m],
  [m+7,      bs2-m],
  [m+7,      bs2-2.2],
  [bs-m-7,   bs2-2.2],
  [bs-m-7,   bs2-m],
  [bs-m,     bs2-m],
  [bs-m,     9.400],
  [bs-m-0.4, 9.400],
  [bs-m-0.4, 8.400],
  [bs-m,     8.400],
  [bs-m,     3.550],
  [bs-6.2,   3.550],
  [bs-6.2,   0.000],
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

// cylinder diameter and height 
//for the half moons sideways
cd=18;
ch=17;

// spring on the right side
mx=2;
p20=[
  // spring between 15 and 74 mm and
  // spacing of 8
  [ 0, 40.0],
  [ m, 48.5],
  [ m, 74-m],
  // first bend
  [ 8-m, 74-m],
  [ 8-m, 48.5],
  [ 8,   40.0],
  [ 8, 13],
  [16, 13],
  [19, 12],
  // second bend (handle)
  [19+mx, 12+mx],
  [16+mx, 13+mx],
  [ 8+mx, 13+mx],
  // notch (keeping it in its place)
  [ 8+mx,     48.5],
  [ 8+mx+4.3, 48.5],
  [ 8+mx+4.3, 48.5+mx],
  [ 8+mx,     48.5+mx+4.3],
  // and go further up
  [ 8+mx, 74+mx],
  [ 0-m,  74+mx],
  [ 0-m,  48.5 ],
  [ 0-m,  40.0 ],  
];
// extra support
p21=[
  [ m,     64-m-m],
  [ m+m,   74-m-m],
  [ 8-m-m, 74-m-m],
  [ 8-m-m, 48.5],
  [ 8-m,   38.5],
  [ 8-m,   23  ],
  [ 8,     13  ],
  [16,     12  ],
  [19,     12  ],
  [16,     13+m],
  [ 8+m+m, 13+m],
  [ 8+m,   23  ],
  [ 8+m,   48.5],
  [ 8+m,   74-m],
  [ 0,     74-m],
  [ 0,     64-m]
];

// lip 1 (attached to the spring)
mxl=3;
p30z=72;
p30=[
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
p31=[
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

// lip 2 on the top side
// this piece is guessed from an internet image
// found here:
// https://zwedenparts.com/product/beugel-afdekplaat-afneembare-trekhaak-orig-volvo-xc60/
p40z=32;
p40=[
  // going up
  [  0,  -20   ],
  [  0,   40   ],
  [ -5,   45   ],
  [  0,   50   ],
  [-mx,   50+mx],
  [-mx-5, 45+mx],
  [-mx-5, 45   ],
  [-mx-5, 45-mx],
  [-mx  , 40-mx],
  [-mx  ,-20   ] 
];
// extra support
p41=[
  [  0,    -20   ],
  [  0,     40   ],
  [4.2-m,   20   ],
  [4.2-m,  -20   ]
];

module half() {
    translate([-bs2,0,0]) {
        difference() {
            linear_extrude(height=bl) {
              polygon(p10);
            }
            translate([0,-0.1,bl])
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
            polygon(p20);
    translate([bs2,0,0]) rotate([90,0,0])
        translate([0,0,-2])
        linear_extrude(height=2)
            polygon(p21);
            
    translate([bs2,0,p30z]) rotate([90,0,0]) {
        translate([0,0,-7]) 
          linear_extrude(height=7)
            polygon(p30);
        translate([0,0,-mxl/2])              
          linear_extrude(height=mxl/2)
            polygon(p31);    
      }
      
    translate([-bs2-m+mxl,0,p40z]) rotate([90,0,0]) {
      translate([0,0,-9])
        linear_extrude(height=9)
        polygon(p40);
      translate([0,0,-4.85])
        linear_extrude(height=4.85)
        polygon(p41);
    }
}

half();
mirror([0,1,0]) half();