// Copied from 
// https://github.com/chadkirby/quarter-turn-mount
// Adjustments
// - make holderAssembly more tight
// - make nodges in the base plate a bit bigger/wider
// Further adjustments
// - move/bend arm approx 13.5mm to the left
// - move arm 7mm outward (update computerDims)
// Notes
// - shell is the outer ring of the holderAssembly

// control what to create and print
createArm=1;
createHolderAssembly=1;
createInsert=0;
showComputer=0; // make it visible for debugging

use <outer.scad>

// gangbare diameters
// racefiets/mtb 31.8 (25.4/26.0 oudere fietsen)
// aero/gravel/high-end 35
// oude mtbs 25.4

// notabene (32.2-31.8) * pi = 1,25 dus met gap van 1mm is dit dus ok

handleBarD = 32.2; // checked and OK for Braun (actual indeed 31.8)!
thick = 2.5;       // thickness of the handlebar ring
width = 12;        // width of the handlebar ring
direction = -1;    // -1 puts the computer to the left of the mount arm; 1 would put the computer to the right, if it weren't broken
armThickness = width; // best to keep it the same

// 14-4-2026 center to handlebar needs to be 
// - minimal 45mm (this seems fine when turning to remove the computer)
// - current mount distance is 55mm 
// - gat=2 seems to be the minimal starting value
desiredGapBetwComputerAndHandlebar = 3;

//update for Garmin Edge 830 (85.5-62=23.5/2=11.75)
oldComputerDims = [12,62+2,42];
computerDims = [17.5, 85.5, 51.5]; 

offsetFromHandlebar = computerDims[1]/2 + desiredGapBetwComputerAndHandlebar;
// distance at wich the assembly will sit
mountY = offsetFromHandlebar + handleBarD/2;
shellD = 36;
stemW  = 37;  // checked and OK for Braun
gap = 1;      // gap in ring (allows ring to fasten tightly

 
big = 1000;
$fs = 1;
$fa = 6;

module screw(
        headD        = 9.3, 
        nutFlat      = 7.25, 
        throughHoleD = 5, 
        threadD      = 3, 
        throughLen   = 20, 
        threadLen    = 0, 
        headLen      = 25, 
        nutLen       = 15) {
    // head
    translate([0, 0, -headLen]) 
      cylinder(d=headD, h=headLen+0.01, center=false);
    // through hole
    cylinder(d=throughHoleD, h=throughLen+0.01, center=false);
    translate([0, 0, throughLen])
        if (nutFlat > 0) {
            // nut
            cylinder(d=nutFlat/cos(180/6), h=nutLen, center=false, $fn=6);
        } else {
            // thread
            cylinder(d=threadD, h=threadLen, center=false);
        }
}

module m4PanHeadScrew(length = 20) {
    translate([-length/2, 0, 0]) 
      rotate([0, 90, 0]) 
      screw(
        headD = 9.3,
        nutFlat = 7.25,
        throughHoleD = 5,
        nutLen = 15,
        throughLen = length
      );
}
module m4ButtonScrew(length = 6) {
    // translate([0, 0, direction == 1 ? 0 : 5])
    // rotate([0, direction == 1 ? 0 : 180, 0])
    screw(
        headD = 8,
        nutFlat = 7.25,
        throughHoleD = 5,
        nutLen = 15,
        throughLen = length
    );
}
module socket5_40(length = 9.5) {
    screw(
       headD = 6,
       headLen = 100,
       threadD = 3,
       throughHoleD = 3.75,
       throughLen = 2.5,
       threadLen = length -2.5
   );
}

module handlebar() {
    cylinder(d=handleBarD, h=width+37*2+2+5, center=true, $fn=60);
    // also construct the stem-handlebar-mount
    translate([0,0,width/2+1])
      cylinder(d=handleBarD+4, h=stemW, center=false, $fn=60);
      
    // optionally to debug
    // add block to double check distance between handlebar and centre of computer
    *translate([0,handleBarD/2,width/2+1])cube([15,45,stemW]);
}

module computerBody() {
    thick=computerDims[0];
    length=computerDims[1];
    width=computerDims[2];
    rotate([0,90,0]) hull() {
      translate([width/2-15,length/2-15,-thick/2]) 
        cylinder(h=thick,r=15);
      translate([width/2-15,-length/2+15,-thick/2]) 
        cylinder(h=thick,r=15);
      translate([-width/2+15,length/2-15,-thick/2]) 
        cylinder(h=thick,r=15);
      translate([-width/2+15,-length/2+15,-thick/2]) 
        cylinder(h=thick,r=15);
    }
    // cube(computerDims, center=true);  
}

module computer() {
    translate([direction * (-computerDims[0]/2), 0, 0]) 
      moveToCentralPoint() {
        rotate([25,0,0])
          computerBody();
        rotate([0,-90,0]) {
          translate([0,0,(2+computerDims[0])/2]) cylinder(h=2,d=24.9, center=true);
          translate([0,0,(4+computerDims[0])/2]) cylinder(h=2,d=28.8, center=true);
        }
        translate([computerDims[1],0,(4+computerDims[0])/2]) 
            #holderAssembly();
        // translate([-computerDims[0],0,0]) cube(oldComputerDims, center=true);

    }
}

module translateScrew(direction = 1) {
    translate([0,direction*(width/2 + handleBarD/2), 0]) children();
}

module moveYToMountPoint() {
    translate([0, mountY, 0]) children();
}

module screwHolder(direction = 1) {
    translateScrew(direction) 
      rotate([0,-90,0]) 
        rotate([0,0,180/8]) 
          cylinder(d=width/cos(180/8), $fn=8, h=20, center=true);
}
module rotateFastener() {
    rotate([0, 0, direction * 72]) children();
}
module fastenerAssembly() {
    screwHolder(1);
    rotateFastener() screwHolder(-1);
}
module screws() {
    // ring screw 1
    rotate([0, direction == 1 ? 0 : 180, 0]) 
      translateScrew(1) 
      m4PanHeadScrew(10);
    // ring screw 2
    rotateFastener() 
      rotate([0, 180, 0]) 
      translateScrew(-1) 
      m4PanHeadScrew(10);

    // mount arm assembly screw 1
    moveToIntermediate() 
      rotate([-30, 0, 0]) 
      rotate([0, 0, 180/6]) 
      translate([0, 0, 1]) 
      m4ButtonScrew(4.5);
    // mount arm assembly screw 2
    translate([0, 0, 0]) 
      moveToFar() 
      rotate([30, 0, 0]) 
      rotate([0, 0, 180/6]) 
      translate([0, 0, 1]) 
      m4ButtonScrew(4.5);
}

// handlebar ring including body for screws
module handlebarRing() {
    hull() {
        cylinder(r = handleBarD/2 + thick, h=width, center=true, $fn=60);
        fastenerAssembly();
    }
}
module cutoutHandlebarAndScrews() {
    difference() {
        children();
        handlebar();
        screws();
    }
}
module getBottom() {
    intersection() {
        children();
        //translate([-(big/2 + gap), (big/2 + gap), 0]) cube([big, big, big], center=true);
        hull() {
            rotate([0, 180, 0]) {
                moveToIntermediateX() translate([0, width/2, 0]) cylinder(d=width, h=100, center=true);
                moveToIntermediateX() translate([0, 100, 0]) cylinder(d=width, h=100, center=true);
                translate([100, 0, 0]) cylinder(d=width, h=100, center=true);
            }
            rotateFastener() translate([0, -1000, 0]) cylinder(d=0.1, h=100, center=true);
        }
    }
}
module getTop() {
    intersection() {
        children();
        difference() {
            cube([big, big, big], center=true);
            hull() {
                rotate([0, 180, 0]) translate([width/2 - gap, 0, 0]) {
                    translate([0, width/2, 0]) 
                      cylinder(d=width, h=100, center=true);
                    translate([0, 100, 0]) 
                      cylinder(d=width, h=100, center=true);
                    translate([100, 0, 0]) 
                      cylinder(d=width, h=100, center=true);
                }
                rotateFastener() 
                  translate([0, -75, 0]) 
                    cylinder(r=gap, h=100, center=true);
            }
        }
    }
}

module botMount() {
    getBottom() 
      cutoutHandlebarAndScrews() 
        handlebarRing();
}

// move to central point where to mount computer
module moveToCentralPoint() {
    // old
    // z = max(shellD/2, computerDims[2]/2 - width/2);
    // new: position computer directly in the middle
    // of the stem
    z = width/2+gap+stemW/2;
    echo ("z: ", z, shellD/2);
    translate([
        // moves shell up higher into the air
        // so gap means create space by adjusting height
        direction * (-armThickness-gap), 
        0, 
        z])
      moveYToMountPoint()
      children();
}
module moveToCentralPointAndRotate(scaleA=[1,1,1]) {
    moveToCentralPoint() 
      rotate([0, direction * 90, 0]) 
      rotate([0,0,90])
      scale(scaleA) 
      children();
}
module holderAssembly() {
    translate([direction * -1.0, 0, 0]) {
        difference() {
            outerShell();
            moveToCentralPointAndRotate() 
              bodyCutouts();
            translate([direction * 1.0, 0, 0])
              screws();
        }
        // two nodges (these help to lock computer)
        moveToCentralPointAndRotate() bodyAdditions();
    }
}
module outerHolder() {
    moveToCentralPointAndRotate() 
      holderBody();
}
module outerShell() {
    moveToCentralPointAndRotate() 
      rotate([0,0,90]) 
      shell(height = armThickness + 1.0);
}
module outerShellCutout() {
    moveToCentralPointAndRotate() 
      rotate([0,0,90]) 
      cylinder(
          d=shellD + 0.5, 
          h=100, 
          center=true);
}
module outerShellIntersection() {
    moveToCentralPointAndRotate() 
      rotate([0, 0, 180/8])
      cylinder(d=(shellD + width)/cos(180/8), 
          $fn=8, 
          h=100, 
          center=true);

}
module moveToIntermediateX() {
    translate([direction * (-armThickness/2 - gap), 0, 0]) children();
}
module moveToIntermediate() {
    oldZ = max(shellD/2, computerDims[2]/2 - width/2);
    // new: position computer directly in the middle
    // of the stem
    newZ = width/2+gap+stemW/2;
    z = newZ - oldZ;
    moveToIntermediateX() 
      translate([
          0, 
          handleBarD/2 + offsetFromHandlebar - 11, 
          z]) 
        children();
}

module moveToFar() {
    translate([0,22,0]) 
      moveToIntermediate() 
        children();
}
module intermediatePointCylinder(h=width) {
    intersection() {
      moveToIntermediate()
        cylinder(d=armThickness, h=h, center=true);
      outerShellIntersection();
    }
}
module farPointCylinder() {
    translate([0, 0, -width/2]) 
      moveToFar() 
        cylinder(d=armThickness, h=width, center=false);
}

// module to create most outer part of the arm
//   this connects with the holderAssembly
module mountArm() {
    difference() {
        intersection() {
            hull() {
              intermediatePointCylinder();
              farPointCylinder();
            }
            outerShellIntersection(); 
        }
        translate([0,0,0])
          screws();
        outerShellCutout();
    }
}
// module from handlebar upto mountArm which connects
//   with holderAssembly (computer holder)
//   excluding botMount
module topMount() {
    difference() {
        cutoutHandlebarAndScrews() 
          getTop() {
            handlebarRing();
            // bridge from the ring to 
            // the intermediatePoint
            hull() {
                moveToIntermediateX() 
                  translateScrew(1) 
                  rotate([0,-90,0]) 
                  cylinder(d=armThickness, h=armThickness, center=true);
;
                intermediatePointCylinder();
            }
          }
        outerShellCutout();

        // make sure we can rotate the rflkt in and out
        *translate([direction * -6, 0, 0]) 
          moveToCentralPointAndRotate() {
            cylinder(
                d = 1 + sqrt(computerDims[1] * computerDims[1] + computerDims[2] * computerDims[2]),
                h=12,
                center=true
            );
        }
        if (showComputer) {
            %computer(); // just for visualization
        }
    }

    mountArm();
}

// create bike arm
if (createArm) {
    rotate([0, 0, 0]) {
        botMount();
        topMount();
        // debug
        %holderAssembly();
    }
    %handlebar();
}

// quarter-turn-mount holder assembly
if (createHolderAssembly) {
    translate([0, direction * 25, armThickness/2 + 2]) rotate([0, direction * -90, 90])
        holderAssembly();
}
    
// quarter-turn-mount insert
if (createInsert) {
    translate([-42, 45, -4]) rotate([180, 0, 0]) insert();
}