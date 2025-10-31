// Mylaps transponder battery replacement housing 
// v2 geprint 
// v3 verstevigd en ook geprint
// v4 big bad bat is the winner and is fine-tuned
//    me and jeroen have v4 but battery fit was a bit too tight
// v5 

trpndr_d1=37; trpndr_r1=trpndr_d1/2;
trpndr_dx=2.8;
trpndr_d2=trpndr_d1-trpndr_dx*2; trpndr_r2=trpndr_d2/2;
trpndr_bh=11.5; // body without the label
trpndr_bw=24.5; // body with 
trpndr_bw2=trpndr_bw/2;
trpndr_label_t=1.62;

tywrap_w=2.5+0.2; // width
tywrap_h=1+0.2;   // height

wire_d=2.1+0.1; // computer disc power supply wiring 

$fn=90;

// Some material definitions
// defaults in prusa slicer 0.15 height (0.2 first layer)
layer_1=0.2;
layer_n=0.15;

// v2 was wll toch net even te weinig stevigheid.
// - wall=nozzle*3 vervangen door wall5
nozzle=0.4; wall=nozzle*3; wall2=wall*2; wall4=wall*4; wall5=nozzle*5;

module trpndr_outer_ring(ring_h=3.5, extend=false) {
    difference() {
      union() {
        cylinder(h=ring_h, d=trpndr_d1);
        if (extend) {
          dx=5; dy=25.2+wall2;
          // extend base plate
          translate([trpndr_r2-dx,-dy/2,0])
            cube([dx+trpndr_dx+1,dy,ring_h]);
          // add support
          translate([trpndr_r1-5,-dy/2,ring_h-0.01])
            difference() {
              cube([5,wall2,5.02]);
              translate([0,wall2+0.5,5])
              rotate([90,0,0])
              cylinder(h=wall2+0.6,r=5);
            }
          // add support
          translate([trpndr_r1-5,dy/2-wall2,ring_h-0.01])
            difference() {
              cube([5,wall2,5.02]);
              translate([0,wall2+0.5,5])
              rotate([90,0,0])
              cylinder(h=wall2+0.6,r=5);
            }
        }
      }
      translate([0,0,-0.1])
        cylinder(h=ring_h+0.2, d=trpndr_d2);  
    }
}

module trpndr_body() {
    trpndr_bh=11.5;
    difference() {
      cylinder(h=trpndr_bh,d=trpndr_d1);
      translate([-trpndr_r1,-trpndr_r1,-0.01])
        cube([trpndr_d1,trpndr_r1-trpndr_bw2,trpndr_bh+0.02]);
      translate([-trpndr_r1,+trpndr_bw2,-0.01])
        cube([trpndr_d1,trpndr_r1-trpndr_bw2,trpndr_bh+0.02]);
    }
}

module trpndr(ring_h=3.5) {
  trpndr_outer_ring(ring_h);
  trpndr_body();
  // label
  translate([-29/2,-10/2,11.5-0.01])
    cube([29,10,1.62]);
}

module wiring(wire_d=wire_d, hull=true) {
    rotate([0,90,0]) {
      translate([-wire_d/2,wire_d,0])
        hull() {
          cylinder(h=10,d=wire_d);
          if (hull) {
            translate([-trpndr_bh-5,0,0])
            cylinder(h=10,d=wire_d);
          }
        }
      translate([-wire_d/2,-wire_d,0])
        hull() {
          cylinder(h=10,d=wire_d);
          if (hull) {
            translate([-trpndr_bh-5,0,0])
            cylinder(h=10,d=wire_d);
          }
        }
    }
}

module tywraps(w=tywrap_w,h=tywrap_h) {
    translate([-trpndr_r1-wall4,0,h*2]) {
      rotate([0,90,0]) {
        translate([0,trpndr_bw/2-4,0])
          hull() {
            translate([0,-w/2,0])
            cylinder(h=trpndr_d1+10,d=h);
            translate([0,w/2,0])
            cylinder(h=trpndr_d1+10,d=h);
          }
        translate([0,-trpndr_bw/2+4,0])
          hull() {
            translate([0,-w/2,0])
            cylinder(h=trpndr_d1+10,d=h);
            translate([0,w/2,0])
            cylinder(h=trpndr_d1+10,d=h);
          }
      }
    }
}

module basicframe(height=3.5, wiring=false, topmount=false) {
    difference() {
      union() {
        difference() {
          trpndr_outer_ring(height, wiring && !topmount);
          if (wiring) 
            translate([trpndr_d2/2-1,0,0.35]) wiring();
        }
        // next we create body (using 2 bars) 
        // this is creating the velcrow windows
        translate([-trpndr_d1/2+5,trpndr_bw/2-trpndr_dx,0])
          cube([trpndr_d1-10,trpndr_dx,height]);
        translate([-trpndr_d1/2+5,-trpndr_bw/2,0])
          cube([trpndr_d1-10,trpndr_dx,height]);
        if (topmount) {
          // build walls to mount battery on top 
          // with tywraps
          tot_h=height+trpndr_bh+trpndr_label_t+tywrap_h*2;
          difference() {
            union() {
              // base plate connecting walls with base frame
              cylinder(h=height,r=trpndr_r1+0.16);
              // cylinder defining the actual walls
              cylinder(h=tot_h,r=trpndr_r1+wall5+0.15);
            }
            // leave base plate open as it was before
            translate([0,0,-0.1])
              cylinder(h=tot_h+0.2,r=trpndr_r2+0.15);
            // cut out the center to create the wall
            translate([0,0,height])
              cylinder(h=tot_h+0.2,r=trpndr_r1+0.15);
            // cut out the sides outside of the transponder body
            translate([-trpndr_r1-wall5/2-0.15,0,0]) {
              translate([0,-trpndr_r1-wall5-0.15,-0.1])
                cube([trpndr_d1+wall2+0.3,(trpndr_d1-trpndr_bw)/2+wall5+0.3,tot_h+0.2]);
              translate([0,trpndr_bw/2,-0.1])
                cube([trpndr_d1+wall2+0.3,(trpndr_d1-trpndr_bw)/2+wall5+0.3,tot_h+0.2]);
            }
            // remove the wall between wires
            translate([0,-wire_d*1.5,height])
              cube([trpndr_r1+wall5+0.16,wire_d*3,trpndr_bw]);
            // not sure where this error of 0.4 originates...
            translate([0,0,trpndr_bh+trpndr_label_t+0.4])
              tywraps();
            if (wiring) 
              translate([trpndr_d2/2-1,0,0.35]) wiring();
          }
          // repeat to allow wires to be less visible
          difference() {
            cylinder(h=tot_h,r=trpndr_r1+wire_d+wall+0.15);
            // leave base plate open as it was before
            translate([0,0,-0.1])
              cylinder(h=tot_h+0.2,r=trpndr_r1+wire_d-0.3);
            // cut out the center to create the wall
            translate([0,0,height])
              cylinder(h=tot_h+0.2,r=trpndr_r1+wire_d+0.15);
            // cut out the sides outside of the transponder body
            translate([-trpndr_r1-wire_d-wall-0.16,0,0]) {
              translate([0,-trpndr_r1-wire_d-wall-0.16,-0.1])
                cube([trpndr_d1+wire_d*2+wall2+0.32,
                      trpndr_r1-wire_d*0.5,tot_h+0.2]);
              translate([0,wire_d*1.5+wall+0.16,-0.1])
                cube([trpndr_d1+wire_d*2+wall2+0.32,
                      trpndr_r1-wire_d*0.5,tot_h+0.2]);
              // only have wiring cover on 1 side
              translate([0,-trpndr_bw/2,-0.1])
                cube([trpndr_r1,trpndr_bw,tot_h+0.2]);
            }
            // remove the wall between wires
            translate([0,-wire_d*1.5,height])
              cube([trpndr_r1+wall5+0.16,wire_d*3,trpndr_bw]);
            // not sure where this error of 0.4 originates...
            translate([0,0,trpndr_bh+trpndr_label_t+0.4])
              tywraps();
          }
          // close the 0.15mm gap
          translate([trpndr_r1,0,0]) {
            translate([0,-wire_d*1.5-wall-0.15,0])
              cube([wire_d+wall-0.6,wall+0.15,tot_h]);
            translate([0,wire_d*1.5,0])
              cube([wire_d+wall-0.6,wall+0.15,tot_h]);
          }
        }
      }
    }
}

module bat_housing(bat_d=21, bat_h=3.5) {
    difference() {
      union() {
        basicframe(bat_h);
        translate([trpndr_bw/2-trpndr_dx-4,-trpndr_d1/2+8])
          cube([trpndr_dx,trpndr_d1-16,min(bat_h,2)]);
        translate([-trpndr_bw/2+4,-trpndr_d1/2+8])
        cube([trpndr_dx,trpndr_d1-16,min(bat_h,2)]);
      }
      // cutout spacing for battery
      // leave 1.2mm to guard battery and
      // keep it in its housing
      translate([0,0,1.2])
        #cylinder(h=bat_h+0.1, d=bat_d+0.1);
    }
}

module bat(bat_d=21, bat_h=3.5, 
           bat_lip_l=14,
           bat_lip_w=1.5,
           bat_lip_spacing=7) {
  translate([0,(bat_lip_spacing-bat_lip_w)/2,0])
    cube([bat_lip_l,bat_lip_w,0.15]);
  translate([0,0,0.15])
    cylinder(h=3.5, d=bat_d);
  translate([0,-bat_lip_spacing/2-bat_lip_w,0.15+bat_h])
    cube([bat_lip_l,bat_lip_w,0.15]);
}

// This is housing2 which situates battery on top (sandwich)
module bat_housing2(bat_d=21, bat_h=3.5,
                    bat_lip_l=14+1,
                    bat_lip_w=1.5,
                    bat_lip_spacing=7) {
    // 0.3 for solder lips 2x0.15
    // additional 1 room for sealing component
    base_h=layer_n*6; //bottom does not need to be very thick
    tot_h=base_h+bat_h+0.3+1; 
    bat_r=bat_d/2;
    // circular part
    difference() {
      cylinder(h=tot_h, d=bat_d+wall2+0.3);
      translate([0,0,base_h])
        cylinder(h=tot_h, d=bat_d+0.3);
      translate([bat_r-3,-7+-wall,0])
        translate([-0.01,wall,base_h])
          cube([5,14,tot_h]);
    }
    // connections part
    difference() {
      cylinder(h=tot_h, r=bat_lip_l+wall+0.15);
      translate([0,0,base_h])
        cylinder(h=tot_h, r=bat_lip_l+0.15);
      translate([-bat_lip_l-wall-0.16,0,-0.1]) {
        translate([0,-bat_lip_l-wall-0.16,0])
          cube([(bat_lip_l+wall+0.16)*2,
                 bat_lip_l-bat_lip_spacing+0.15,tot_h+0.2]);
        translate([0,bat_lip_spacing+wall,0])
          cube([(bat_lip_l+wall+0.16)*2,
                 bat_lip_l-bat_lip_spacing+0.16,tot_h+0.2]);
        translate([0,-bat_lip_l-wall-0.16,0])
          cube([bat_lip_l,bat_lip_l*2+wall2,tot_h+0.2]);
      translate([bat_lip_l*2,0,1.5])
        wiring(hull=false);
      } 
    }
    translate([bat_r-2.25,0,0]) {
      translate([0,-bat_lip_spacing-wall,0])
        cube([bat_lip_l-bat_r+wall,wall,tot_h]);
      translate([0,bat_lip_spacing,0])
        cube([bat_lip_l-bat_r+wall,wall,tot_h]);
    }
    translate([0,0,tot_h+2])
      %bat(bat_d, bat_h);
}

module topmount_housing() {
      // build walls to mount battery on top 
      // with tywraps
      tywrap_h2=tywrap_h*2;
      tot_h=trpndr_label_t+tywrap_h2;
      difference() {
        cylinder(h=tot_h,r=trpndr_r1);
        trpndr_label();
        translate([0,0,trpndr_label_t])
          cylinder(h=tot_h+0.2,r=trpndr_r1-wall*2);
        translate([-trpndr_r1-wall-0.15,0,0]) {
          translate([0,-trpndr_r1-wall-0.15,-0.1])
            cube([trpndr_d1+wall2+0.3,(trpndr_d1-trpndr_bw)/2+wall+0.3,tot_h+0.2]);
          translate([0,trpndr_bw/2,-0.1])
            cube([trpndr_d1+wall2+0.3,(trpndr_d1-trpndr_bw)/2+wall+0.3,tot_h+0.2]);
        }
        // remove bit between wires
        translate([-trpndr_r1-wall,-wire_d*1.5,trpndr_label_t])
          cube([trpndr_d1+wall2+0.32,wire_d*3,trpndr_bw]);
        translate([trpndr_r1-wall*5,-wire_d*1.5,-trpndr_label_t])
          cube([10,wire_d*3,trpndr_label_t+2]);
        tywraps(tywrap_w);
      }
}

module topmount_bat_housing() {
  topmount_housing();
  translate([-2.5,0,trpndr_label_t-0.01])
  bat_housing2();
}

module trpndr_label() {
    translate([-29/2,-10/2,-0.01])
      cube([29,10,trpndr_label_t+0.02]);
}
module trpndr_holder() {
  //tot_h=13.5;
  tot_h=14.5+0.4+3+wall2+0.5-cr2032_h;

  difference() {
    union() {
      cylinder(h=tot_h+cr2032_h,d=trpndr_d2-0.05);
      cylinder(h=1.6,d=trpndr_d1);
      // extra support blocks 
      translate([-2,-trpndr_d1/2+0.1,0])
        cube([4,4,8.8]);
      translate([-2,trpndr_d1/2-4.1,0])
        cube([4,4,8.8]);
    }
    // blunt cutout transponder body
    translate([-trpndr_d2/2,-trpndr_bw/2,1.6])
      cube([trpndr_d2,trpndr_bw+0.05,tot_h+0.02+cr2032_h]);
    trpndr_label();
  }
}

// printer circuit board pin
module pin(thick=0.3, width1=0.4, width2=0.7, length=4) {
  #hull () {
    cube([width2,length-1.2,thick]);
    translate([(width2-width1)/2,0,0]) 
      cube([width1,length,thick]);
  }
}

// 1/2 AA battery
module AA2() {
  // dimensions (DxH): 14,5 x 25 mm, weight: 9 gram 
  aad=14.5;
  aah=25;
  // pins contacts
  pct=0.3; // thickness
  pcw1=0.4;
  pcw2=0.7;
  pcl=4;
  pcpitch=7.6;
  
  translate([-aad/4,0,0]) {
    cube([pcpitch,aad/2,pct]);
    translate([aad/4,aad/2,0])
      pin(pct,pcw1,pcw2,pcl);
  }
  translate([0,0,pct]) {
    cylinder(h=aah,d=aad);
    translate([-aad/4,0,aah]) {
      cube([pcpitch,aad/2,pct]);
      translate([0,aad/2,0])
        pin(pct,pcw1,pcw2,pcl);
      translate([aad/2-pcw1,aad/2,0])
        pin(pct,pcw1,pcw2,pcl);
    }
  }
}

module AA2_box(wire_d=wire_d) {
  spacing=0.8; // spacing on all sides of the battery 
  // afmetingen (DxH): 14,5 x 25 mm, gewicht: 9 gram 
  // v5 actual height is 25.4!!!
  aad=14.5+spacing; aado=aad+wall4;
  aah=25.4+spacing; aaho=aah+wall4;
  extra_spacing=3; // extra spacing for wires/soldering contacts
  translate([0,-aaho/2,0]) {
      difference() {
        union() {
            // suncen cover to allow sealing
            cube([aado,aaho,wall+0.5]);
            // rest of the box
            translate([0,0,wall+0.49]) hull() {
              cube([aado,aaho,extra_spacing]);
              // correction to have a ceiling thickness of 
              // wall only
              translate([aado/2,0,extra_spacing+aad/2-wall]) 
                rotate([-90,0,0])
                cylinder(h=aaho,d=aado);
            }
        }
        translate([wall,wall,-0.01]) {
          // suncen cover 
          cube([aado-wall2,aaho-wall2,wall+0.5]);
          // rest of the box
          translate([wall,wall,wall+0.49]) hull() {
              cube([aad,aah,extra_spacing]);
              translate([aad/2,0,aad/2+extra_spacing]) 
                rotate([-90,0,0])
                cylinder(h=aah,d=aad);
            }
        }
        // wires
        translate([-1.1,(aah+wall4)/2,wall-0.3]) {
            rotate([0,90-20,0]) {
              translate([-wire_d/2,wire_d,0])
                #cylinder(h=wall2+4.2,d=wire_d);
              translate([-wire_d/2,-wire_d,0])
                cylinder(h=wall2+4.2,d=wire_d);
            }
        }
      }
      // battery
      %translate([aado+5,0,0]) // place battery outside of the box
        translate([wall2,wall2,wall+0.5])
          translate([aad/2,0.2,extra_spacing+aad/2]) 
            rotate([-90,25,0]) AA2();
  }
  
  // cover
  x=aado-wall2-0.2;
  y=aaho-wall2-0.2;
  translate([1*(aado+5)+wall,-aaho/2+wall,0])
    difference() {
      union () {
        cube([x,y,wall]);
        // raise the middle a bit to level with the box
        translate([wall,wall,0]) cube([x-wall2,y-wall2,wall+0.5]);
      }
      translate([(x-5)/2,-0.1,-0.1])
        cube([5,wall/2+0.2,wall+0.2]);
      translate([(x-5)/2,y-wall/2,-0.1])
        cube([5,wall/2+0.1,wall+0.2]);
    }
}


// most powerfull battery housing, small base plate
translate([0,-2*(trpndr_d1+5),0]) {
  basicframe(2.6,true);
  difference() {
    translate([trpndr_d1/2,0,0]) AA2_box();
    // debug
    *translate([trpndr_d1/2+5+7.25,-25,0.20+0.15*7])
      cube([100,100,100]);
    *cube([100,100,100]);  
  }
  translate([0,0,2.6+2]) %trpndr();
}

// small base plate, 
// relaxed fit original battery 
// or external battery
// wire_d=2.1 -> 14 layers 0.2+13*0.15
*translate([0,-1*(trpndr_d1+5),0]) {
  //h=3.5-3.7+1.2; 
  //bat_housing(20,h);
  h=wire_d+0.3; //v3 adding some extra 2 layers
  basicframe(h,true,true);
  translate([0,0,h]) {
    %trpndr();
    translate([0,0,trpndr_bh]) 
      %topmount_bat_housing();
  }
  
}
*translate([0,0,0]) {
  translate([0,0,-trpndr_bh])
    %trpndr();
  topmount_bat_housing();
}

// base plate for original battery
cr2032_d=20+1;
cr2032_h=3.5;
//cr2032_b=26;
*bat_housing(cr2032_d, cr2032_h);
*translate([0,0,cr2032_h+2]) %trpndr();

// base plate for large button cell
*translate([0,trpndr_d1+5,0]) {
  // CR2477
  bat_housing(24.5, 7.7);
  translate([0,0,7.7+2]) %trpndr();
}

// small tool to help grinding and mounting
translate([0,-1*(trpndr_d1+5),0]) {
  trpndr_holder();
  *rotate([180,0,0]) translate([0,0,-11.5-1.6]) %trpndr();
}
// debug: show battery  
// translate([0,0,1])
// cylinder(h=cr2032_h, d=cr2032_d);