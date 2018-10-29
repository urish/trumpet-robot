include <MCAD/units.scad>

speakerSize = 106;
baseThickness = 15;
totalSize = speakerSize + 5;
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

module roundCubeConic(width, length, topWidth, topLength, height, cornerRadius) {
    hull() {
        for (x=[-1, 1], y=[-1, 1]) {
            translate([x * (width / 2 - cornerRadius), y * (length / 2 - cornerRadius), 0])
            cylinder(r=cornerRadius, h=epsilon);

            translate([x * (topWidth / 2 - cornerRadius), y * (topLength / 2 - cornerRadius), height - epsilon])
            cylinder(r=cornerRadius, h=0.1);
        }
    }
}

module SpeakerCover() {
    translate([0, 0, baseThickness])
    difference() {
        roundCubeConic(totalSize + shellThickness, totalSize + shellThickness, 75 + shellThickness, 75 + shellThickness, 80, cornerRadius);

        translate([0, 0, -epsilon])
        roundCubeConic(totalSize - 0.5, totalSize - 0.5, 70, 70, 80 - 4, cornerRadius);
    }
    
    difference() {
        roundCube(totalSize+14, totalSize+14, baseThickness, cornerRadius);

        translate([0, 0, -epsilon])
        roundCube(totalSize, totalSize, baseThickness+epsilon*2, cornerRadius);

        // Mounting holes
        for (x=[-1, 1], y=[-1, 1]) {
            translate([x * enclosureHoleDistance / 2, y * enclosureHoleDistance / 2, -epsilon])
            cylinder(h=baseThickness + epsilon * 2, r=1.7);

            translate([0, y * ((totalSize + 14) / 2 - 4), -epsilon])
            cylinder(h=baseThickness + epsilon * 2, r=1.7);

            translate([y * ((totalSize + 14) / 2 - 4), 0, -epsilon])
            cylinder(h=baseThickness + epsilon * 2, r=1.7);
        }
    }
}

SpeakerCover();
