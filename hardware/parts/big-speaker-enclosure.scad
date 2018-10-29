include <MCAD/units.scad>

speakerSize = 106;
speakerHole = 101 - 4;
shellSize = 5;
totalSize = speakerSize + shellSize;
speakerHoleDistance = 80;
enclosureHoleDistance = 100;
cornerRadius = 30;
coneHeight = 50;
shellThickness = 1.5;
rimRadius = 27.4 / 2;
rimHeight = 7;

$fn = 60;

module roundCube(width, length, height, cornerRadius) {
    hull() {
        for (x=[-1, 1], y=[-1, 1])
        translate([x * (width / 2 - cornerRadius), y * (length / 2 - cornerRadius), 0])
        cylinder(r=cornerRadius, h=height);
    }
}

module SpeakerEnclosure() {
    // Mouthpiece Hole
    difference() {
        cylinder(r=rimRadius+shellThickness, h=rimHeight);

        translate([0, 0, -epsilon])
        cylinder(r=rimRadius, h=rimHeight+epsilon*2);
    }
    
    translate([0, 0, rimHeight])
    difference() {
        cylinder(r1=rimRadius+shellThickness, r2=(speakerHole) / 2 + shellThickness, h=50);

        translate([0, 0, -epsilon])
        cylinder(r1=rimRadius, r2=speakerHole / 2, h=coneHeight+epsilon*2);
    }

    translate([0, 0, coneHeight + rimHeight])
    difference() {
        union() {
            color("silver")
            roundCube(totalSize, totalSize, shellSize, cornerRadius);

            roundCube(totalSize+14, totalSize+14, shellSize, cornerRadius);
        }
        
        translate([0, 0, -epsilon])
        cylinder(r=speakerHole/2, h=shellSize+epsilon*2);
        
        // Speaker holes
        for (x=[-1, 1], y=[-1, 1])
        translate([x * speakerHoleDistance / 2, y * speakerHoleDistance / 2, -epsilon])
        cylinder(h=shellSize + epsilon * 2, r=2.2);

        // Echo chamber holes
        for (x=[-1, 1], y=[-1, 1]) {
            translate([x * enclosureHoleDistance / 2, y * enclosureHoleDistance / 2, -epsilon])
            cylinder(h=shellSize + epsilon * 2, r=1.7);

            translate([0, y * ((totalSize + 14) / 2 - 4), -epsilon])
            cylinder(h=shellSize + epsilon * 2, r=1.7);

            translate([y * ((totalSize + 14) / 2 - 4), 0, -epsilon])
            cylinder(h=shellSize + epsilon * 2, r=1.7);
        }
    }
}

rotate([0, 180, 0])
SpeakerEnclosure();
