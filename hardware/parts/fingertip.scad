include <MCAD/units.scad>


$fn=60;

module Fingertip(
    fingertipHeight = 11,
    valveCapPocket = 3
) {
    difference() {
        translate([-10,-10,0])
        cube([20, 20, fingertipHeight]);
        
        translate([0, 0, -epsilon])
        cylinder(h=fingertipHeight, r=1.5);

        translate([0, 0, fingertipHeight - valveCapPocket])
        cylinder(r=18/2, h=valveCapPocket + epsilon);
    }
}

Fingertip();
