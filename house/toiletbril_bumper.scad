// WC bril rubber mal
// v1 has too small cover (single wall) but printed and used anyway

ht=13.3;

l2=38.3;
d2=11;
h2=6.4;

l1=46.6;
d1=19;
h1=ht-h2;

// Some material definitions
// defaults in prusa slicer 0.15 height (0.2 first layer)
layer_1=0.2;
layer_n=0.15;
nozzle=0.4;
wall=nozzle*3;

$fn=60;

module bumper(l=l1,d=d1,h=h1) {
  difference() {
      scale([1,1,2*h/d]) 
      hull() {
        translate([(d-l)/2,0,0])
            sphere(d=d);
        translate([(l-d)/2,0,0])
            sphere(d=d);
      }
    translate([-l/2-0.1,-d/2-0.1])
        cube([l+0.2,d+0.2,d/2+0.1]);
  }
}

module mount(l=l2,d=d2,h=h2) {
  hull() {
    translate([(d-l)/2,0,0])
      cylinder(h=h,d=d);
    translate([(l-d)/2,0,0])
      cylinder(h=h,d=d);
  }
}

module rubber() {
  translate([0,0,h1+0.01]) 
    bumper();
  translate([0,0,h1])
    mount();
}

debug=0;

// base mold for bumper
l=l1+2;
d=d1+2;
h=h1+layer_1+4*layer_n;

difference() {
    mount(l=l,d=d,h=h);
    //translate([-l/2,-w/2,0])
    //    cube([l,w,h]);
    translate([0,0,h-h1])
        rubber();
    // debug
    if (debug)
      translate([0,0,-0.1])
        cube([l,d,h+0.2]);
}

// cover parameters
wall2=wall*2;
lci=l+0.4; lco=lci+wall2;
dci=d+0.4; dco=dci+wall2;
hc=h-4*layer_n;
lto=l2+wall2;
dto=d2+wall2;
htop=h2;

// make some nodges (to help disassemble)
mount(l=lco,d=dco,h=layer_1+3*layer_n);

module cover() {
    
        difference() {
        union() {
            mount(l=lco,d=dco,h=hc);
            translate([0,0,hc-4*layer_n])
                mount(l=lto,d=dto,h=htop);
        }
        translate([0,0,-0.01])
            mount(l=lci,d=dci,h=hc-4*layer_n);
        translate([0,0,hc-4*layer_n-0.1])
            mount(h=h2+8*layer_n+0.2);
        if (debug)
          translate([0,0,-0.1])
            cube([l,d,ht+1.2]);
    }
}

%translate([0,0,9*layer_n])
    cover();
    
translate([0,dco+5,hc-4*layer_n+htop])
    rotate([180,0,0])
        cover();

