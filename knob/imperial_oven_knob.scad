// Imperial Overknop fix

bid  = 30.0; // binnen diameter
zdlh =  5.0; // zadel hoogte (de basis is iets verhoogd tov de rand)

// hoek meten
x1d=46.2;
x2d=33.0;
xh=7.0;
angle=x2d/x1d/xh;

bid2 = bid * zdlh * 5;

translate([46,0,0]);
    cylinder(h=xh, d1=x1d, d2=x2d);
!cylinder(h=zdlh,d1=bid, d2=bid2);