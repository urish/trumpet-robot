include <MCAD/units.scad>
use <../vitamins/valves.scad>
use <../parts/fingertip.scad>
use <../lib/rack.scad>

module Rack(
    fingerLength = 48,
    numTeeth = 8,
    teethInterval = 6.4,
    toothHeight = 4.5,
    width = 7.5,
    thickness = 7,
) {
    rackLength = teethInterval * numTeeth;
    fingerWidth = 8;
    fingerThickness = 7.5;
    $fn = 60;

    translate([-$t * valvePressAmount(), 0, 0])
    color("pink") {
        // End stop
        translate([-5, 0, 0])
        cube([5, width, thickness]);

        cube([rackLength, width - toothHeight, thickness]);

        for (toothIdx = [1 : numTeeth]) {
            translate([teethInterval * (toothIdx - 0.75), width - toothHeight, 0])
            linear_extrude(thickness)
            polygon([
                [0, 0], 
                [1.3, toothHeight], 
                [3.14, toothHeight],
                [4.44, 0]
            ]);
        }

        translate([rackLength - fingerWidth, 0, 0])
        difference() {
            cube([fingerWidth, fingerThickness, fingerLength]);

            translate([0, fingerThickness / 2, fingerLength - 8])
            rotate([0, 90, 0])
            cylinder(r=1.6, h=fingerWidth + 2 * epsilon);
        }

        translate([rackLength, thickness-9, fingerLength + 10])
        rotate([0, -90, 0])
        *Fingertip();
    }
}

Rack();