include <MCAD/units.scad>

fingertipHeight = 18;
valveCapPocket = 3;

$fn=60;

module Fingertip() {
    difference() {
        translate([-10,-10,0])
        cube([20, 20, fingertipHeight]);

        translate([0, 0, fingertipHeight - valveCapPocket])
        cylinder(r=18/2, h=valveCapPocket + epsilon);
    }
}

Fingertip();
