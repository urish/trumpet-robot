include <MCAD/units.scad>

width = 50;
length = 200;
holeWidth = 23;
holeLength = 72;
cornerRadius = 20;
innerCornerRadius = 8;
$fn = 60;
thickness = 19;
feetPocket = 3;
feetRadius = 10;
feetInset = 20;
crossInset = 30;
crossWidth = 25;
crossCornerRadius = 8;
crossLength = 180;

module roundCube(width, length, height, cornerRadius) {
    hull() {
        for (x=[-1, 1], y=[-1, 1])
        translate([x * (width / 2 - cornerRadius), y * (length / 2 - cornerRadius), 0])
        cylinder(r=cornerRadius, h=height);
    }
}

module TrumpetStand() {
    difference() {
        union() {
            roundCube(width, length, thickness, cornerRadius);
            
            for (y=[0, 1])
            mirror([0, y, 0])
            translate([0, length / 2 - crossInset, 0])
            roundCube(crossLength, crossWidth, thickness, crossCornerRadius);
        }
        
        translate([0, 0, -epsilon])
        roundCube(holeWidth, holeLength, thickness + epsilon * 2, innerCornerRadius);
        
        // Feet pockets
        for (y=[0, 1])
        mirror([0, y, 0])
        translate([0, length / 2 - feetInset, thickness-feetPocket])
        cylinder(r=feetRadius, h=feetPocket + epsilon);

        // Cross feet pockets
        for (x=[-1, 1], y=[-1, 1])
        translate([x * (crossLength / 2 - feetInset), y * (length / 2 - crossInset), thickness-feetPocket])
        cylinder(r=feetRadius, h=feetPocket + epsilon);
    }
}

TrumpetStand();
