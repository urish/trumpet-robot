include <MCAD/units.scad>
include <MCAD/nuts_and_bolts.scad>

$fn=60;

module Fingertip(
    fingertipHeight = 11,
    valveCapPocket = 3
) {
    nutHeight = 50;

    difference() {
        translate([-10,-10,0])
        cube([20, 20, fingertipHeight]);
        
        // Screw hole
        translate([0, 0, -epsilon])
        cylinder(h=fingertipHeight, r=M3/2 + 0.1);

        // Nut pocket
        translate([0, 0, fingertipHeight - valveCapPocket - METRIC_NUT_THICKNESS[M3 + 0.15]])
        nutHole(M3, tolerance=0.15);

        // Pocket
        translate([0, 0, fingertipHeight - valveCapPocket])
        cylinder(r=18/2, h=valveCapPocket + epsilon);
    }
}

Fingertip();
