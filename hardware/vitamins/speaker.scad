include <MCAD/units.scad>

$fn = 60;
speakerSize = 106;

module roundCube(width, length, height, cornerRadius) {
    hull() {
        for (x=[-1, 1], y=[-1, 1])
        translate([x * (width / 2 - cornerRadius), y * (length / 2 - cornerRadius), 0])
        cylinder(r=cornerRadius, h=height);
    }
}

module Speaker() {
    difference() {
        union() {
            translate([0, 0, 31])
            cylinder(r=50 / 2., h=16.5);

            translate([0, 0, 23])
            cylinder(r=70 / 2., r2=60 / 2., h=8);

            translate([0, 0, 3])
            cylinder(r=95 / 2., r2=80 / 2., h=20);
            
            roundCube(speakerSize, speakerSize, 3, 20);
         }
         
         translate([0, 0, -epsilon])
         cylinder(r=4*inch/2, h=2);
    }
    
    translate([0, 0, -2])
    difference() {
        cylinder(r=80 / 2., h=4);

        translate([0, 0, -epsilon])
        cylinder(r=70 / 2., h=4);
    }
}


Speaker();