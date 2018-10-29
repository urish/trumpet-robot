include <MCAD/units.scad>

shellSize = 5;
speakerHoleDistance = 80;           
spacerHeight = 5;

$fn = 60;

module SpeakerSpacers() {
    for (x=[-1, 1], y=[-1, 1]) {
        translate([x * speakerHoleDistance / 2, y * speakerHoleDistance / 2])
        difference() {
            cylinder(h=shellSize + spacerHeight, r=4);
        
            translate([0, 0, -epsilon])
            cylinder(h=shellSize + spacerHeight + epsilon * 2, r=2.5);
        }
    }
}

SpeakerSpacers();